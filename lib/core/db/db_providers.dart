import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'assessment_content_db.dart';
import 'db_paths.dart';
import 'progress_db.dart';
import 'study_content_db.dart';

/// Resolved once and cached for the app's lifetime (no `.autoDispose`) —
/// every local content image (`imagePath`/`coverImagePath`, stored relative
/// to this dir per [DbPaths]) needs it, and it's a platform-channel call
/// not worth repeating per widget build.
final documentsDirProvider = FutureProvider<Directory>((ref) => DbPaths.documentsDir());

/// Long-lived: one instance for the app's lifetime, shared across whichever
/// accounts use this device (spec Section 3.1 — content is device-scoped,
/// not account-scoped).
final studyContentDbProvider = Provider<StudyContentDb>((ref) {
  final db = StudyContentDb();
  ref.onDispose(db.close);
  return db;
});

final assessmentContentDbProvider = Provider<AssessmentContentDb>((ref) {
  final db = AssessmentContentDb();
  ref.onDispose(db.close);
  return db;
});

/// Shared by the router's content gate ([contentInstalledProvider]) and
/// the Setup screen's per-pack "already installed?" checks — one live
/// subscription per stream, not one per consumer.
final installedStudyPacksProvider = StreamProvider<List<InstalledStudyPack>>((ref) {
  return ref.watch(studyContentDbProvider).watchInstalledPacks();
});

final installedAssessmentPacksProvider = StreamProvider<List<InstalledAssessmentPack>>((ref) {
  return ref.watch(assessmentContentDbProvider).watchInstalledPacks();
});

/// Per-account (spec Section 3.2) — one instance per `userId`, disposed
/// when no longer watched. M3 (auth) is what actually decides *which*
/// `userId` is active; this family just knows how to open/close the file
/// for whichever id it's asked for, keyed so switching accounts on the
/// same device never mixes progress data.
final progressDbProvider = Provider.family<ProgressDb, String>((ref, userId) {
  final db = ProgressDb.forUser(userId);
  ref.onDispose(db.close);
  return db;
});
