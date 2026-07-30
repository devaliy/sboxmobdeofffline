import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:success_offline/core/db/assessment_content_db.dart';
import 'package:success_offline/core/db/db_providers.dart';
import 'package:success_offline/core/db/progress_db.dart';
import 'package:success_offline/core/db/study_content_db.dart';
import 'package:success_offline/core/downloads/pack_downloader.dart';
import 'package:success_offline/core/downloads/pack_importer.dart';
import 'package:success_offline/core/network/api_client.dart';
import 'package:success_offline/core/network/secure_session_store.dart';
import 'package:success_offline/core/sync/sync_triggers.dart';
import 'package:success_offline/features/setup/application/setup_controller.dart';

/// Provider overrides every test needs: `flutter_secure_storage`,
/// `path_provider`, `connectivity_plus` and `shared_preferences` all need
/// platform channels that don't exist under `flutter test` — several of
/// them (the DB providers, `PackDownloader`'s temp dir) would otherwise
/// hang indefinitely rather than fail fast, and the router's content gate
/// now reads the content databases on every boot, so this isn't optional
/// even for tests that never touch Setup directly.
List<Override> testProviderOverrides() {
  // Each test gets its own independent in-memory databases, so drift's
  // "opened the same database class twice" heuristic is a false positive
  // here — silence it instead of spamming every test run.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  // Registers the in-memory shared_preferences test implementation —
  // without this, SetupScreen's Wi-Fi-only preference load throws
  // MissingPluginException.
  SharedPreferences.setMockInitialValues({});

  return [
    secureSessionStoreProvider.overrideWithValue(InMemorySecureSessionStore()),
    progressDbProvider.overrideWith(
      (ref, userId) => ProgressDb.forTesting(NativeDatabase.memory()),
    ),
    studyContentDbProvider.overrideWith((ref) => StudyContentDb.forTesting(NativeDatabase.memory())),
    assessmentContentDbProvider
        .overrideWith((ref) => AssessmentContentDb.forTesting(NativeDatabase.memory())),
    // connectivity_plus also needs a platform channel that doesn't exist
    // under `flutter test` — assume "on Wi-Fi" so download tests don't
    // need to also stub connectivity.
    setupControllerProvider.overrideWith((ref) => SetupController(ref, isOnWifi: () async => true)),
    // PackDownloader's default temp-directory lookup is real
    // `path_provider` too — without this override, a download never
    // resolves under `flutter test` (it hangs on the platform channel,
    // silently, since nothing surfaces as a thrown exception).
    packDownloaderProvider.overrideWith(
      (ref) => PackDownloader(
        ref.watch(dioProvider),
        PackImporter(),
        tempDirProvider: () async => Directory.systemTemp.createTempSync('pack_dl_widget_test_'),
      ),
    ),
    // connectivity_plus's real stream needs a platform channel that
    // doesn't exist under `flutter test` — tests that need to simulate
    // "connectivity regained" override this again themselves.
    connectivityStreamProvider.overrideWith((ref) => const Stream.empty()),
  ];
}
