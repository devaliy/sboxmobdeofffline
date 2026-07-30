import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Resolves the on-device storage layout from spec Section 3:
/// ```
/// <app documents dir>/
///   study_content.sqlite
///   assessment_content.sqlite
///   users/{user_id}/progress.sqlite
///   content/
///     study/images/{books,subjects,questions}/
///     assessment/images/questions/
/// ```
/// The only file in the app that should know this shape — everything else
/// (databases, the pack importer, image widgets) asks [DbPaths].
abstract final class DbPaths {
  static Future<Directory> documentsDir() => getApplicationDocumentsDirectory();

  static Future<String> studyContentDbPath() async {
    final dir = await documentsDir();
    return p.join(dir.path, 'study_content.sqlite');
  }

  static Future<String> assessmentContentDbPath() async {
    final dir = await documentsDir();
    return p.join(dir.path, 'assessment_content.sqlite');
  }

  /// Per-account progress database (spec Section 3.2) — a physically
  /// separate file per `userId`, never a shared file with a filter column,
  /// so cross-account leakage is structurally impossible.
  static Future<String> progressDbPath(String userId) async {
    final dir = await documentsDir();
    final userDir = Directory(p.join(dir.path, 'users', userId));
    if (!await userDir.exists()) {
      await userDir.create(recursive: true);
    }
    return p.join(userDir.path, 'progress.sqlite');
  }

  /// Whether this account has used this device before (spec Section 3.3's
  /// login/account-switch check), without opening the database.
  static Future<bool> progressDbExists(String userId) async {
    final dir = await documentsDir();
    return File(p.join(dir.path, 'users', userId, 'progress.sqlite')).exists();
  }

  static const _studyImageKinds = {'books', 'subjects', 'questions'};

  /// `kind` is one of 'books' | 'subjects' | 'questions'.
  static Future<Directory> studyImagesDir(String kind) async {
    assert(_studyImageKinds.contains(kind), 'Unknown study image kind: $kind');
    final dir = await documentsDir();
    final target = Directory(p.join(dir.path, 'content', 'study', 'images', kind));
    if (!await target.exists()) {
      await target.create(recursive: true);
    }
    return target;
  }

  static Future<Directory> assessmentQuestionImagesDir() async {
    final dir = await documentsDir();
    final target = Directory(p.join(dir.path, 'content', 'assessment', 'images', 'questions'));
    if (!await target.exists()) {
      await target.create(recursive: true);
    }
    return target;
  }
}
