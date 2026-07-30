/// One entry from `GET /content/manifest` (spec Section 4.4) — the exact
/// shape drives the entire Setup screen, so this model mirrors it
/// field-for-field rather than approximating.
class ManifestPackEntry {
  const ManifestPackEntry({
    required this.domain,
    required this.scopeType,
    required this.scopeId,
    required this.parentScopeId,
    required this.title,
    required this.version,
    required this.checksum,
    required this.sizeBytes,
    required this.itemCount,
    required this.downloadUrl,
  });

  /// 'study' | 'assessment'
  final String domain;

  /// 'book' (study) | 'subject' (assessment)
  final String scopeType;
  final int scopeId;

  /// The book's `class_id`, used only to group books under a class heading
  /// in Setup's UI — not a separately downloadable scope. Null for
  /// assessment packs.
  final int? parentScopeId;

  final String title;
  final String version;
  final String checksum;
  final int sizeBytes;
  final int itemCount;
  final String downloadUrl;

  bool get isStudy => domain == 'study';
  bool get isAssessment => domain == 'assessment';

  factory ManifestPackEntry.fromJson(Map<String, dynamic> json) => ManifestPackEntry(
        domain: json['domain'] as String,
        scopeType: json['scope_type'] as String,
        scopeId: json['scope_id'] as int,
        parentScopeId: json['parent_scope_id'] as int?,
        title: json['title'] as String,
        version: json['version'] as String,
        checksum: json['checksum'] as String,
        sizeBytes: json['size_bytes'] as int,
        itemCount: json['item_count'] as int,
        downloadUrl: json['download_url'] as String,
      );
}

class ContentManifest {
  const ContentManifest({required this.generatedAt, required this.packs});

  final String generatedAt;
  final List<ManifestPackEntry> packs;

  factory ContentManifest.fromJson(Map<String, dynamic> json) => ContentManifest(
        generatedAt: json['generated_at'] as String,
        packs: (json['packs'] as List)
            .cast<Map<String, dynamic>>()
            .map(ManifestPackEntry.fromJson)
            .toList(),
      );

  List<ManifestPackEntry> get studyPacks => packs.where((p) => p.isStudy).toList();
  List<ManifestPackEntry> get assessmentPacks => packs.where((p) => p.isAssessment).toList();
}
