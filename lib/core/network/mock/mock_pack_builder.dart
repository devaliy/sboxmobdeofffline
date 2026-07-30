import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';

/// A built pack: the zip bytes plus the manifest metadata derived from
/// them (spec Section 4.4/4.5) — `checksum`/`size_bytes` are computed from
/// the actual bytes, not made up, so M4's checksum-verification step is
/// genuinely exercised against real data.
class BuiltPack {
  const BuiltPack({
    required this.zipBytes,
    required this.checksum,
    required this.version,
    required this.itemCount,
  });

  final Uint8List zipBytes;
  final String checksum;
  final String version;
  final int itemCount;

  int get sizeBytes => zipBytes.length;
}

/// Builds the fake-but-structurally-correct zip packs the spec calls for
/// (Section 14: "serving fake-but-structurally-correct zip packs so the
/// download/import/resume path in Phase 3 gets genuinely exercised, not
/// stubbed out"). Images are omitted from this mock dataset (image/
/// cover_image fields are left null) — the importer must treat them as
/// optional per the Section 4.1/4.2 schemas regardless.
abstract final class MockPackBuilder {
  static BuiltPack buildStudyPack({
    required int scopeId,
    required Map<String, dynamic> classJson,
    required Map<String, dynamic> bookJson,
    required List<Map<String, dynamic>> termsJson,
    required List<Map<String, dynamic>> subjectsJson,
    required String version,
  }) {
    final packJson = {
      'domain': 'study',
      'scope_type': 'book',
      'scope_id': scopeId,
      'version': version,
      'class': classJson,
      'book': bookJson,
      'terms': termsJson,
      'subjects': subjectsJson,
    };
    final itemCount = subjectsJson.fold<int>(
      0,
      (sum, s) =>
          sum +
          1 +
          (s['contents'] as List).length +
          (s['questions'] as List).length,
    );
    return _zip(packJson, version, itemCount);
  }

  static BuiltPack buildAssessmentPack({
    required int scopeId,
    required Map<String, dynamic> subjectJson,
    required List<Map<String, dynamic>> categoriesJson,
    required List<Map<String, dynamic>> yearsJson,
    required List<Map<String, dynamic>> testTypesJson,
    required List<Map<String, dynamic>> passagesJson,
    required List<Map<String, dynamic>> questionsJson,
    required String version,
  }) {
    final packJson = {
      'domain': 'assessment',
      'scope_type': 'subject',
      'scope_id': scopeId,
      'version': version,
      'subject': subjectJson,
      'categories': categoriesJson,
      'years': yearsJson,
      'test_types': testTypesJson,
      'passages': passagesJson,
      'questions': questionsJson,
    };
    return _zip(packJson, version, questionsJson.length);
  }

  static BuiltPack _zip(Map<String, dynamic> packJson, String version, int itemCount) {
    final archive = Archive();
    final jsonBytes = utf8.encode(jsonEncode(packJson));
    archive.addFile(ArchiveFile('pack.json', jsonBytes.length, jsonBytes));

    final encoded = ZipEncoder().encode(archive);
    if (encoded == null) throw StateError('Mock pack zip encoding failed');
    final zipBytes = Uint8List.fromList(encoded);
    final checksum = 'sha256:${sha256.convert(zipBytes)}';

    return BuiltPack(
      zipBytes: zipBytes,
      checksum: checksum,
      version: version,
      itemCount: itemCount,
    );
  }
}
