import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../core/db/db_providers.dart';

/// Renders an image written by `PackImporter` under the documents dir at a
/// path relative to it (`imagePath`/`coverImagePath` throughout the local
/// content DBs, per `DbPaths`'s layout) — server-authored cover/question
/// art is real but often absent, so [placeholder] covers "no path yet",
/// "still resolving the documents dir", and "file missing/corrupt" alike,
/// keeping every call site a one-liner instead of re-deriving this.
class LocalContentImage extends ConsumerWidget {
  const LocalContentImage({
    super.key,
    required this.relativePath,
    required this.placeholder,
    this.fit = BoxFit.cover,
  });

  final String? relativePath;
  final Widget placeholder;
  final BoxFit fit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = relativePath;
    if (path == null) return placeholder;

    final docsAsync = ref.watch(documentsDirProvider);
    return docsAsync.when(
      loading: () => placeholder,
      error: (e, st) => placeholder,
      data: (docs) => Image.file(
        File(p.join(docs.path, path)),
        fit: fit,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }
}
