import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'db_paths.dart';

part 'progress_db.g.dart';

/// Exact schema from spec Section 4.3. One physically separate file per
/// account (spec Section 3.2) — opened via [ProgressDb.forUser], never
/// shared across accounts. Client-generated UUID primary keys throughout,
/// since these are the rows a retryable sync needs to upsert idempotently.
class PracticeAttempts extends Table {
  TextColumn get id => text()();
  TextColumn get sourceType => text().named('source_type')(); // 'assessment' | 'library'
  IntColumn get subjectId => integer().named('subject_id').nullable()();
  IntColumn get librarySubjectId => integer().named('library_subject_id').nullable()();
  IntColumn get testTypeId => integer().named('test_type_id').nullable()();
  IntColumn get score => integer()();
  IntColumn get totalQuestions => integer().named('total_questions')();
  IntColumn get timeSpentSeconds => integer().named('time_spent_seconds')();
  TextColumn get startedAt => text().named('started_at')();
  TextColumn get completedAt => text().named('completed_at')();
  TextColumn get syncedAt => text().named('synced_at').nullable()();
  // Denormalized snapshot of the subject/format names at attempt time (added
  // schema v2) — the Analytics report needs these for its data table, and a
  // snapshot avoids "this attempt references content that's since been
  // removed" edge cases that a live join against the content DBs would hit.
  TextColumn get subjectName => text().named('subject_name').nullable()();
  TextColumn get testTypeLabel => text().named('test_type_label').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PracticeAnswers extends Table {
  TextColumn get id => text()();
  TextColumn get attemptId => text().named('attempt_id').references(PracticeAttempts, #id)();
  // References questions.id or library_questions.id in the relevant
  // content database, per questionSource — intentionally not an FK here,
  // since practice_answers lives in a different physical database file.
  IntColumn get questionId => integer().named('question_id')();
  TextColumn get questionSource => text().named('question_source')(); // 'assessment' | 'library'
  TextColumn get selectedOption => text().named('selected_option').nullable()();
  BoolColumn get isCorrect => boolean().named('is_correct')();
  IntColumn get timeSpentSeconds => integer().named('time_spent_seconds')();

  @override
  Set<Column> get primaryKey => {id};
}

class ReadingProgress extends Table {
  TextColumn get id => text()();
  IntColumn get librarySubjectId => integer().named('library_subject_id')();
  TextColumn get lastPosition => text().named('last_position').nullable()();
  IntColumn get percentComplete => integer().named('percent_complete')();
  TextColumn get lastOpenedAt => text().named('last_opened_at')();
  TextColumn get syncedAt => text().named('synced_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Single-row table (`id` is always 1).
class LocalStats extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get totalPoints => integer().named('total_points').withDefault(const Constant(0))();
  IntColumn get currentStreakDays =>
      integer().named('current_streak_days').withDefault(const Constant(0))();
  IntColumn get longestStreakDays =>
      integer().named('longest_streak_days').withDefault(const Constant(0))();
  TextColumn get lastActiveDate => text().named('last_active_date').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncOutbox extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text().named('entity_type')(); // 'practice_attempt' | 'reading_progress'
  TextColumn get entityId => text().named('entity_id')();
  TextColumn get payloadJson => text().named('payload_json')(); // pre-serialized at enqueue time
  TextColumn get createdAt => text().named('created_at')();
  IntColumn get attemptCount => integer().named('attempt_count').withDefault(const Constant(0))();
  TextColumn get lastAttemptedAt => text().named('last_attempted_at').nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending|synced|failed

  @override
  Set<Column> get primaryKey => {id};
}

/// Read-through cache of SuccessAI conversations (SUCCESSAI_BUILD_PROMPT.md
/// Section 3) — server is the source of truth; this table only exists so a
/// past conversation is still readable offline. Upserted (insert-or-replace
/// by `id`) every time `GET /ai/conversations` succeeds online, never
/// written to any other way — there is no outbox/sync for this table since
/// conversations only ever originate server-side.
class AiConversationsCache extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get updatedAt => text().named('updated_at')();
  TextColumn get lastMessage => text().named('last_message').nullable()();
  TextColumn get cachedAt => text().named('cached_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Read-through cache of one conversation's messages, same reasoning as
/// [AiConversationsCache] — upserted every time
/// `GET /ai/conversations/{id}/messages` succeeds online.
class AiMessagesCache extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text().named('conversation_id')();
  TextColumn get content => text()();
  BoolColumn get isAi => boolean().named('is_ai')();
  TextColumn get sender => text()();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get cachedAt => text().named('cached_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Local, client-generated activity notifications ("you scored 80% on
/// Physics", "Biology pack finished downloading") — there is no server
/// notifications endpoint (this app has no push infrastructure), so this
/// is purely a local activity log, written by the same controllers that
/// already call [ProgressDb.recordActivity] for streaks/points.
class LocalNotifications extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()(); // 'test_result' | 'download' | 'streak'
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get readAt => text().named('read_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  PracticeAttempts,
  PracticeAnswers,
  ReadingProgress,
  LocalStats,
  SyncOutbox,
  AiConversationsCache,
  AiMessagesCache,
  LocalNotifications,
])
class ProgressDb extends _$ProgressDb {
  ProgressDb.forUser(String userId) : super(_openConnection(userId));

  ProgressDb.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Seed the single local_stats row up front so watchLocalStats()
          // always has something to emit — a fresh account starts at 0
          // points / 0 streak, not "no row yet".
          await into(localStats).insert(LocalStatsCompanion.insert());
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(practiceAttempts, practiceAttempts.subjectName);
            await m.addColumn(practiceAttempts, practiceAttempts.testTypeLabel);
          }
          if (from < 3) {
            await m.createTable(aiConversationsCache);
            await m.createTable(aiMessagesCache);
            await m.createTable(localNotifications);
          }
        },
      );

  static QueryExecutor _openConnection(String userId) {
    return driftDatabase(
      name: 'progress_$userId',
      native: DriftNativeOptions(
        databasePath: () => DbPaths.progressDbPath(userId),
      ),
      // See the matching comment in study_content_db.dart: web support here
      // exists only so Chrome stays usable for local dev verification.
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  // --- Home / Progress (M5, M9) -------------------------------------------

  Future<LocalStat> readLocalStats() async {
    final existing = await (select(localStats)..where((t) => t.id.equals(1))).getSingleOrNull();
    if (existing != null) return existing;
    await into(localStats).insertOnConflictUpdate(const LocalStatsCompanion(id: Value(1)));
    return (select(localStats)..where((t) => t.id.equals(1))).getSingle();
  }

  /// Reactive counterpart to [readLocalStats] — safe to watch from first
  /// paint since [migration] guarantees row 1 always exists.
  Stream<LocalStat> watchLocalStats() =>
      (select(localStats)..where((t) => t.id.equals(1))).watchSingle();

  /// Awards points and bumps the daily streak for one completed activity —
  /// called by the Study Center quiz, Practice/CBT exam, and reading
  /// progress controllers right after they write their own rows. A
  /// calendar day only ever counts once: same-day calls just add points
  /// without re-bumping the streak, consecutive-day calls extend it, and
  /// a gap of more than a day resets it to 1. `local_stats` (spec Section
  /// 4.3) only tracks the running counters, not a per-day log, so
  /// Progress's "streak calendar" (M9) derives which days were active by
  /// counting `current_streak_days` back from `last_active_date` — the
  /// only history this schema actually holds.
  Future<void> recordActivity({int pointsEarned = 0}) async {
    final stats = await readLocalStats();
    final today = _dateOnly(DateTime.now().toUtc());
    final yesterday = _dateOnly(DateTime.now().toUtc().subtract(const Duration(days: 1)));

    int streak;
    if (stats.lastActiveDate == today) {
      streak = stats.currentStreakDays == 0 ? 1 : stats.currentStreakDays;
    } else if (stats.lastActiveDate == yesterday) {
      streak = stats.currentStreakDays + 1;
    } else {
      streak = 1;
    }
    final longest = streak > stats.longestStreakDays ? streak : stats.longestStreakDays;

    await (update(localStats)..where((t) => t.id.equals(1))).write(LocalStatsCompanion(
      totalPoints: Value(stats.totalPoints + pointsEarned),
      currentStreakDays: Value(streak),
      longestStreakDays: Value(longest),
      lastActiveDate: Value(today),
    ));

    // Only the transition onto a genuinely new active day, not every call
    // on an already-counted day — otherwise finishing three tests in one
    // sitting would fire three identical streak notifications.
    if (stats.lastActiveDate != today && streak > 1) {
      await addNotification(
        type: 'streak',
        title: '$streak-day streak!',
        body: 'You\'ve kept your streak going for $streak days in a row. Keep it up!',
      );
    }
  }

  static String _dateOnly(DateTime dt) => dt.toIso8601String().substring(0, 10);

  Stream<List<PracticeAttempt>> watchRecentAttempts({int limit = 20}) =>
      (select(practiceAttempts)
            ..orderBy([(t) => OrderingTerm.desc(t.completedAt)])
            ..limit(limit))
          .watch();

  /// Every completed attempt, oldest first — Progress's (M9) score-over-time
  /// chart and per-subject accuracy both need the full history, not just
  /// the most recent handful [watchRecentAttempts] returns.
  Stream<List<PracticeAttempt>> watchAllAttempts() =>
      (select(practiceAttempts)..orderBy([(t) => OrderingTerm.asc(t.completedAt)])).watch();

  Future<void> deleteAttempt(String id) async {
    await transaction(() async {
      await (delete(practiceAnswers)..where((t) => t.attemptId.equals(id))).go();
      await (delete(practiceAttempts)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<List<PracticeAnswer>> answersForAttempt(String attemptId) =>
      (select(practiceAnswers)..where((t) => t.attemptId.equals(attemptId))).get();

  Stream<ReadingProgressData?> watchReadingProgress(int librarySubjectId) =>
      (select(readingProgress)..where((t) => t.librarySubjectId.equals(librarySubjectId)))
          .watchSingleOrNull();

  /// Every subject in [librarySubjectIds] that has a progress row — used to
  /// compute a *book's* overall completion (spec: Reader's header progress
  /// bar), which needs every subject in the book, not just the one most
  /// recently opened.
  Stream<List<ReadingProgressData>> watchReadingProgressForSubjects(Set<int> librarySubjectIds) {
    if (librarySubjectIds.isEmpty) return Stream.value(const []);
    return (select(readingProgress)..where((t) => t.librarySubjectId.isIn(librarySubjectIds))).watch();
  }

  /// Most recently opened subjects, for Study Center's "Recently Read"
  /// shelf — a wider window than [watchMostRecentReading]'s single row,
  /// since the caller de-duplicates down to distinct *books*.
  Stream<List<ReadingProgressData>> watchRecentReadingProgress({int limit = 30}) {
    final query = select(readingProgress)
      ..orderBy([(t) => OrderingTerm.desc(t.lastOpenedAt)])
      ..limit(limit);
    return query.watch();
  }

  /// The single most recently-opened subject, for Home's "Continue
  /// studying" card — null once nothing has been read yet.
  Stream<ReadingProgressData?> watchMostRecentReading() {
    final query = select(readingProgress)
      ..orderBy([(t) => OrderingTerm.desc(t.lastOpenedAt)])
      ..limit(1);
    return query.watch().map((rows) => rows.isEmpty ? null : rows.first);
  }

  // --- Sync outbox (M8) ----------------------------------------------------

  Future<void> enqueueOutbox(SyncOutboxCompanion row) => into(syncOutbox).insertOnConflictUpdate(row);

  Future<List<SyncOutboxData>> pendingOutbox() =>
      (select(syncOutbox)..where((t) => t.status.equals('pending'))).get();

  /// Reactive pending count, for Home/Settings' ambient sync-status line.
  Stream<List<SyncOutboxData>> watchPendingOutbox() =>
      (select(syncOutbox)..where((t) => t.status.equals('pending'))).watch();

  Future<void> markOutboxSynced(String id) => (update(syncOutbox)..where((t) => t.id.equals(id)))
      .write(const SyncOutboxCompanion(status: Value('synced')));

  /// What the sync worker actually calls on a successful ack: flips the
  /// outbox row to `synced` *and* stamps `synced_at` on the source row it
  /// came from (`entityId` is that row's own primary key for both entity
  /// types — see `reading_progress_controller.dart` / the M6/M7 quiz
  /// controllers) so "last synced" is derivable from the content tables
  /// themselves, not just the outbox.
  Future<void> markOutboxRowSynced(SyncOutboxData row) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await transaction(() async {
      if (row.entityType == 'practice_attempt') {
        await (update(practiceAttempts)..where((t) => t.id.equals(row.entityId)))
            .write(PracticeAttemptsCompanion(syncedAt: Value(now)));
      } else if (row.entityType == 'reading_progress') {
        await (update(readingProgress)..where((t) => t.id.equals(row.entityId)))
            .write(ReadingProgressCompanion(syncedAt: Value(now)));
      }
      await markOutboxSynced(row.id);
    });
  }

  /// What the sync worker calls on a failed/unacknowledged item: bumps
  /// `attempt_count` and stamps `last_attempted_at` so backoff has
  /// something to key off, without touching `status` — the row stays
  /// `pending` and is never silently dropped (spec Section 8).
  Future<void> markOutboxAttempt(String id) async {
    final row = await (select(syncOutbox)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return;
    await (update(syncOutbox)..where((t) => t.id.equals(id))).write(SyncOutboxCompanion(
      attemptCount: Value(row.attemptCount + 1),
      lastAttemptedAt: Value(DateTime.now().toUtc().toIso8601String()),
    ));
  }

  /// Most recent successful sync across both entity types, for
  /// Settings' "last synced" line — null if nothing has ever synced yet.
  Future<DateTime?> lastSyncedAt() async {
    final attempt = await (select(practiceAttempts)
          ..where((t) => t.syncedAt.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.syncedAt)])
          ..limit(1))
        .getSingleOrNull();
    final progress = await (select(readingProgress)
          ..where((t) => t.syncedAt.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.syncedAt)])
          ..limit(1))
        .getSingleOrNull();

    DateTime? parse(String? iso) => iso == null ? null : DateTime.parse(iso);
    final a = parse(attempt?.syncedAt);
    final p = parse(progress?.syncedAt);
    if (a == null) return p;
    if (p == null) return a;
    return a.isAfter(p) ? a : p;
  }

  // --- SuccessAI read-through cache (SUCCESSAI_BUILD_PROMPT.md Section 3) --

  /// Insert-or-replace by id — called every time `GET /ai/conversations`
  /// succeeds online, never any other way (server is the only source of
  /// truth for what conversations exist).
  Future<void> upsertCachedConversations(List<AiConversationsCacheCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(aiConversationsCache, rows));
  }

  Stream<List<AiConversationsCacheData>> watchCachedConversations() =>
      (select(aiConversationsCache)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).watch();

  /// Insert-or-replace by id — called every time
  /// `GET /ai/conversations/{id}/messages` succeeds online.
  Future<void> upsertCachedMessages(List<AiMessagesCacheCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(aiMessagesCache, rows));
  }

  Stream<List<AiMessagesCacheData>> watchCachedMessages(String conversationId) =>
      (select(aiMessagesCache)
            ..where((t) => t.conversationId.equals(conversationId))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();

  // --- Local activity notifications -----------------------------------------

  Future<void> addNotification({
    required String type,
    required String title,
    required String body,
  }) async {
    await into(localNotifications).insert(LocalNotificationsCompanion.insert(
      id: DateTime.now().toUtc().microsecondsSinceEpoch.toString(),
      type: type,
      title: title,
      body: body,
      createdAt: DateTime.now().toUtc().toIso8601String(),
    ));
  }

  Stream<List<LocalNotification>> watchNotifications({int limit = 50}) =>
      (select(localNotifications)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit))
          .watch();

  Stream<int> watchUnreadNotificationCount() {
    final query = selectOnly(localNotifications)
      ..addColumns([localNotifications.id.count()])
      ..where(localNotifications.readAt.isNull());
    return query.watchSingle().map((row) => row.read(localNotifications.id.count()) ?? 0);
  }

  Future<void> markNotificationRead(String id) =>
      (update(localNotifications)..where((t) => t.id.equals(id)))
          .write(LocalNotificationsCompanion(readAt: Value(DateTime.now().toUtc().toIso8601String())));

  Future<void> markAllNotificationsRead() async {
    await (update(localNotifications)..where((t) => t.readAt.isNull()))
        .write(LocalNotificationsCompanion(readAt: Value(DateTime.now().toUtc().toIso8601String())));
  }
}
