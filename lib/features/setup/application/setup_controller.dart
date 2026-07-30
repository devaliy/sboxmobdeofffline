import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/db/db_providers.dart';
import '../../../core/downloads/pack_downloader.dart';
import '../../../core/downloads/pack_importer.dart';
import '../../../core/downloads/pack_remover.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/endpoints.dart';
import '../domain/content_pack_manifest.dart';

enum PackPhase { idle, downloading, importing, installed, failed }

class PackDownloadState {
  const PackDownloadState({this.phase = PackPhase.idle, this.received = 0, this.total = 0, this.error});

  final PackPhase phase;
  final int received;
  final int total;
  final String? error;

  double get progress => total > 0 ? received / total : 0;

  PackDownloadState copyWith({PackPhase? phase, int? received, int? total, String? error}) =>
      PackDownloadState(
        phase: phase ?? this.phase,
        received: received ?? this.received,
        total: total ?? this.total,
        error: error,
      );
}

String packStateKey(ManifestPackEntry pack) => '${pack.domain}:${pack.scopeId}';

final packDownloadStatesProvider =
    StateProvider<Map<String, PackDownloadState>>((ref) => const {});

/// Default ON per spec Section 3/7 — a metered-connection-safe default for
/// a first content download.
final wifiOnlyDownloadsProvider = StateProvider<bool>((ref) => true);

const _wifiOnlyPrefsKey = 'setup_wifi_only_downloads';

Future<bool> loadWifiOnlyPreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_wifiOnlyPrefsKey) ?? true;
}

Future<void> saveWifiOnlyPreference(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_wifiOnlyPrefsKey, value);
}

final contentManifestProvider = FutureProvider<ContentManifest>((ref) async {
  final json = await ref.watch(contentEndpointsProvider).manifest();
  return ContentManifest.fromJson(json);
});

final packDownloaderProvider = Provider<PackDownloader>((ref) {
  return PackDownloader(ref.watch(dioProvider), PackImporter());
});

final packRemoverProvider = Provider<PackRemover>((ref) => PackRemover());

/// Storage used per domain (spec Section 7: "Manage downloaded content...
/// shows storage used per domain separately since they're physically
/// separate folders") — summed straight from each `installed_*_packs`
/// table, so removing a pack updates this the instant its bookkeeping row
/// is gone, with no separate recomputation step.
final studyStorageUsedProvider = StreamProvider<int>((ref) {
  return ref
      .watch(studyContentDbProvider)
      .watchInstalledPacks()
      .map((rows) => rows.fold<int>(0, (sum, r) => sum + r.sizeBytes));
});

final assessmentStorageUsedProvider = StreamProvider<int>((ref) {
  return ref
      .watch(assessmentContentDbProvider)
      .watchInstalledPacks()
      .map((rows) => rows.fold<int>(0, (sum, r) => sum + r.sizeBytes));
});

/// Orchestrates one pack's download: Wi-Fi-only gating, resumable
/// download + checksum verify + transactional import (via
/// [PackDownloader]), automatic retry with linear backoff on transient
/// failure, and a terminal failed state with a manual retry action
/// otherwise (spec Section 7).
class SetupController {
  SetupController(this._ref, {Future<bool> Function()? isOnWifi})
      : _isOnWifi = isOnWifi ?? _defaultIsOnWifi;

  final Ref _ref;

  /// Overridable so tests can bypass `connectivity_plus`, which — like
  /// `path_provider` and `flutter_secure_storage` — needs a platform
  /// channel that doesn't exist under `flutter test`.
  final Future<bool> Function() _isOnWifi;

  static const _maxAutoAttempts = 3;

  static Future<bool> _defaultIsOnWifi() async {
    final results = await Connectivity().checkConnectivity();
    return results.contains(ConnectivityResult.wifi);
  }

  void _setState(ManifestPackEntry pack, PackDownloadState state) {
    final map = Map<String, PackDownloadState>.from(_ref.read(packDownloadStatesProvider));
    map[packStateKey(pack)] = state;
    _ref.read(packDownloadStatesProvider.notifier).state = map;
  }

  Future<bool> _canUseNetwork() async {
    if (!_ref.read(wifiOnlyDownloadsProvider)) return true;
    return _isOnWifi();
  }

  Future<void> download(ManifestPackEntry pack) async {
    if (!await _canUseNetwork()) {
      _setState(
        pack,
        const PackDownloadState(
          phase: PackPhase.failed,
          error: 'Wi-Fi only is on. Connect to Wi-Fi, or allow mobile data in Settings.',
        ),
      );
      return;
    }

    final downloader = _ref.read(packDownloaderProvider);

    for (var attempt = 1; attempt <= _maxAutoAttempts; attempt++) {
      _setState(pack, const PackDownloadState(phase: PackPhase.downloading));
      try {
        if (pack.isStudy) {
          await downloader.downloadAndImportStudyPack(
            pack,
            db: _ref.read(studyContentDbProvider),
            onProgress: (received, total) => _setState(
              pack,
              PackDownloadState(phase: PackPhase.downloading, received: received, total: total),
            ),
          );
        } else {
          await downloader.downloadAndImportAssessmentPack(
            pack,
            db: _ref.read(assessmentContentDbProvider),
            onProgress: (received, total) => _setState(
              pack,
              PackDownloadState(phase: PackPhase.downloading, received: received, total: total),
            ),
          );
        }
        _setState(pack, const PackDownloadState(phase: PackPhase.installed));
        return;
      } on PackDownloadException catch (e) {
        final isLastAttempt = attempt == _maxAutoAttempts;
        if (!e.recoverable || isLastAttempt) {
          _setState(pack, PackDownloadState(phase: PackPhase.failed, error: e.message));
          return;
        }
        await Future<void>.delayed(Duration(seconds: attempt)); // 1s, then 2s
      }
    }
  }

  /// Settings -> "Manage downloaded content" (spec Section 4.7): frees the
  /// scope's rows/images and its `installed_*_packs` bookkeeping row. The
  /// installed-packs streams both screens watch pick this up on their own —
  /// no manual refresh needed.
  Future<void> remove(ManifestPackEntry pack) async {
    final remover = _ref.read(packRemoverProvider);
    if (pack.isStudy) {
      await remover.removeStudyPack(db: _ref.read(studyContentDbProvider), libraryBookId: pack.scopeId);
    } else {
      await remover.removeAssessmentPack(
        db: _ref.read(assessmentContentDbProvider),
        subjectId: pack.scopeId,
      );
    }
  }
}

final setupControllerProvider = Provider<SetupController>((ref) => SetupController(ref));
