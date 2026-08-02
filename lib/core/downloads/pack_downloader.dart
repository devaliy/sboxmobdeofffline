import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/setup/domain/content_pack_manifest.dart';
import '../db/assessment_content_db.dart';
import '../db/study_content_db.dart';
import 'pack_importer.dart';

/// Manifest `download_url` values have been observed in two shapes from the
/// real backend: a path-only value (spec Section 4.4's example,
/// `/api/v1/content/study/12/pack`) and, currently, a full absolute URL
/// (`https://successbox.ng/api/v1/content/study/1/pack`). `Dio` joins
/// `baseUrl + path` via plain string concatenation, not URI resolution, so
/// a path-only value passed straight through double-prefixes it
/// (`.../api/v1/api/v1/...`) whenever `baseUrl` already ends in `/api/v1` —
/// and blindly forcing *any* value into `baseUrl`'s path component is worse:
/// feeding an already-absolute URL into `Uri.replace(path: ...)` stuffs the
/// whole `https://host/...` string into the path segment, producing
/// `https://successbox.ng/https://successbox.ng/api/v1/...`, a URL Laravel
/// can't route — it 302s to the homepage, and the app silently downloads
/// that HTML page instead of the pack (surfacing later as a checksum
/// failure with no clue why). Handling both shapes here, keyed on whether
/// the value already parses with a scheme, is what makes this correct
/// against either shape the backend sends.
Uri resolveApiUri(Dio dio, String pathFromApiRoot) {
  final asIs = Uri.parse(pathFromApiRoot);
  if (asIs.hasScheme) return asIs;
  return Uri.parse(dio.options.baseUrl).replace(path: pathFromApiRoot);
}

class PackDownloadException implements Exception {
  PackDownloadException(this.message, {this.recoverable = true});

  /// When false (checksum mismatch, corrupt zip), the partial file has
  /// already been discarded — a retry starts from zero, not resumed.
  final bool recoverable;
  final String message;

  @override
  String toString() => message;
}

/// Resumable pack download (spec Section 8): HTTP range requests so a
/// dropped connection resumes from the partial file already on disk
/// rather than from zero, checksum verification before import, and a
/// clean re-download (partial file discarded) on any corruption.
class PackDownloader {
  PackDownloader(this._dio, this._importer, {Future<Directory> Function()? tempDirProvider})
      : _tempDirProvider = tempDirProvider ?? getTemporaryDirectory;

  final Dio _dio;
  final PackImporter _importer;

  /// Overridable so tests can use [Directory.systemTemp] directly —
  /// `path_provider`'s real implementation needs a platform channel that
  /// doesn't exist under plain `test()`/`flutter test`.
  final Future<Directory> Function() _tempDirProvider;

  Future<File> _partialFile(ManifestPackEntry pack) async {
    final tempDir = await _tempDirProvider();
    final packsDir = Directory(p.join(tempDir.path, 'packs'));
    if (!await packsDir.exists()) {
      await packsDir.create(recursive: true);
    }
    // Keyed by version, not just domain/scopeId: if the server rebuilds
    // this pack between attempts (a new `content:build-pack` run changes
    // its checksum and size), a stale partial left over from the old
    // version must never be treated as resumable against the new one's
    // expected checksum — that's a guaranteed, silent corruption, not an
    // edge case worth risking.
    return File(p.join(packsDir.path, '${pack.domain}_${pack.scopeId}_${pack.version}.zip.part'));
  }

  /// Downloads (resuming from any existing partial bytes), verifies the
  /// checksum, and returns the full zip bytes ready for import. Progress
  /// is reported as (bytesReceived, totalBytes).
  ///
  /// Web has no path here: there's no real filesystem to hold a resumable
  /// partial file, and `path_provider`'s temp-directory lookup isn't even
  /// implemented in a browser (throws `MissingPluginException`). Flutter
  /// Web isn't a shipped target for this app (spec targets Android/iOS/
  /// Windows/macOS) — this branch exists purely so Chrome stays usable
  /// for interactive dev testing, downloading straight into memory with
  /// no resume support instead of silently hanging.
  Future<Uint8List> _downloadAndVerify(
    ManifestPackEntry pack, {
    void Function(int received, int total)? onProgress,
  }) {
    return kIsWeb
        ? _downloadAndVerifyInMemory(pack, onProgress: onProgress)
        : _downloadAndVerifyToFile(pack, onProgress: onProgress);
  }

  Future<Uint8List> _downloadAndVerifyInMemory(
    ManifestPackEntry pack, {
    void Function(int received, int total)? onProgress,
  }) async {
    onProgress?.call(0, pack.sizeBytes);
    final builder = BytesBuilder(copy: false);
    var received = 0;
    try {
      final response = await _dio.getUri<ResponseBody>(
        resolveApiUri(_dio, pack.downloadUrl),
        options: Options(responseType: ResponseType.stream),
      );
      await for (final chunk in response.data!.stream) {
        builder.add(chunk);
        received += chunk.length;
        onProgress?.call(received, pack.sizeBytes);
      }
    } catch (e) {
      throw PackDownloadException('Download failed: $e');
    }

    // A stream can end (no exception thrown) without delivering every byte
    // the manifest promised — e.g. a connection reset mid-transfer. Left
    // unchecked, that silently truncated body falls straight through to
    // checksum verification below, where it fails as an *unrecoverable*
    // "corrupted" error with no automatic retry — masking what's actually
    // just a dropped connection.
    if (pack.sizeBytes > 0 && received != pack.sizeBytes) {
      throw PackDownloadException(
        'Download failed: connection closed early (got $received of ${pack.sizeBytes} bytes).',
      );
    }

    final bytes = builder.takeBytes();
    final actualChecksum = 'sha256:${sha256.convert(bytes)}';
    if (actualChecksum != pack.checksum) {
      throw PackDownloadException(
        'Checksum mismatch — the download was corrupted. Please retry.',
        recoverable: false,
      );
    }
    return bytes;
  }

  Future<Uint8List> _downloadAndVerifyToFile(
    ManifestPackEntry pack, {
    void Function(int received, int total)? onProgress,
  }) async {
    final partial = await _partialFile(pack);
    var existingBytes = await partial.exists() ? await partial.length() : 0;

    // A stale partial *larger* than the pack itself can't be resumed and
    // is discarded. Exactly-the-right-size is left alone on purpose — that
    // means "fully downloaded but never got past checksum verification /
    // import (e.g. a crash right after)", so it falls through to
    // verification below instead of re-downloading from scratch.
    if (pack.sizeBytes > 0 && existingBytes > pack.sizeBytes) {
      await partial.delete();
      existingBytes = 0;
    }

    onProgress?.call(existingBytes, pack.sizeBytes);

    if (existingBytes < pack.sizeBytes) {
      final sink = partial.openWrite(mode: FileMode.append);
      var received = existingBytes;
      try {
        final response = await _dio.getUri<ResponseBody>(
          resolveApiUri(_dio, pack.downloadUrl),
          options: Options(
            responseType: ResponseType.stream,
            headers: existingBytes > 0 ? {'Range': 'bytes=$existingBytes-'} : null,
          ),
        );
        await for (final chunk in response.data!.stream) {
          sink.add(chunk);
          received += chunk.length;
          onProgress?.call(received, pack.sizeBytes);
        }
        await sink.flush();
        // As in the web/in-memory path: a stream can end clean (no thrown
        // exception) without actually delivering the full byte count — the
        // partial file on disk is genuinely incomplete, not corrupt. Keep
        // it and surface this as a *recoverable* failure so the caller's
        // retry-with-backoff resumes via Range from here, instead of
        // falling through to checksum verification, failing as
        // unrecoverable, and throwing away a perfectly good partial.
        if (pack.sizeBytes > 0 && received != pack.sizeBytes) {
          throw StateError('connection closed early (got $received of ${pack.sizeBytes} bytes)');
        }
      } catch (e) {
        await sink.close();
        // Network failure: keep the partial file so the next attempt
        // resumes instead of restarting.
        throw PackDownloadException('Download failed: $e');
      }
      await sink.close();
    }

    final bytes = await partial.readAsBytes();
    final actualChecksum = 'sha256:${sha256.convert(bytes)}';
    if (actualChecksum != pack.checksum) {
      // Corrupt: never leave a bad file around to "resume" from.
      await partial.delete();
      throw PackDownloadException(
        'Checksum mismatch — the download was corrupted. Please retry.',
        recoverable: false,
      );
    }

    return bytes;
  }

  Future<void> _cleanup(ManifestPackEntry pack) async {
    if (kIsWeb) return; // nothing was ever written to disk
    final partial = await _partialFile(pack);
    if (await partial.exists()) await partial.delete();
  }

  /// Full pipeline for one Study pack: download+verify, then import.
  Future<void> downloadAndImportStudyPack(
    ManifestPackEntry pack, {
    required StudyContentDb db,
    void Function(int received, int total)? onProgress,
  }) async {
    assert(pack.isStudy);
    final bytes = await _downloadAndVerify(pack, onProgress: onProgress);
    await _importer.importStudyPack(
      db: db,
      zipBytes: bytes,
      checksum: pack.checksum,
      sizeBytes: pack.sizeBytes,
    );
    await _cleanup(pack);
  }

  /// Full pipeline for one Assessment pack: download+verify, then import.
  Future<void> downloadAndImportAssessmentPack(
    ManifestPackEntry pack, {
    required AssessmentContentDb db,
    void Function(int received, int total)? onProgress,
  }) async {
    assert(pack.isAssessment);
    final bytes = await _downloadAndVerify(pack, onProgress: onProgress);
    await _importer.importAssessmentPack(
      db: db,
      zipBytes: bytes,
      checksum: pack.checksum,
      sizeBytes: pack.sizeBytes,
    );
    await _cleanup(pack);
  }
}
