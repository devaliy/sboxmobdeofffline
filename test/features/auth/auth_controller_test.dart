import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:success_offline/core/db/db_providers.dart';
import 'package:success_offline/core/db/progress_db.dart';
import 'package:success_offline/core/network/api_client.dart';
import 'package:success_offline/core/network/secure_session_store.dart';
import 'package:success_offline/core/router/router_state.dart';
import 'package:success_offline/features/auth/application/auth_controller.dart';

import '../../support/test_overrides.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(overrides: testProviderOverrides());
  });
  tearDown(() => container.dispose());

  test('logging in with the wrong password throws a 401 ApiException', () async {
    final controller = container.read(authControllerProvider);
    expect(
      () => controller.login(identifier: 'jane@demo.ng', password: 'wrong'),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401)),
    );
  });

  test('registering a new account signs them in and flips the auth gate', () async {
    final controller = container.read(authControllerProvider);
    await controller.register(
      firstName: 'Amaka',
      lastName: 'Okoro',
      email: 'amaka@demo.ng',
      phoneNumber: '+2348099990000',
      password: 'password123',
      currentClassId: 9,
    );

    expect(container.read(authStatusProvider), AuthStatus.loggedIn);
    expect(container.read(currentUserProvider)?.email, 'amaka@demo.ng');

    final session = await container.read(secureSessionStoreProvider).read();
    expect(session, isNotNull);
  });

  test(
      'two different demo accounts on the same device/session see fully isolated '
      '(initially empty) progress — no data crosses over', () async {
    final controller = container.read(authControllerProvider);

    // --- Jane logs in, we write a practice attempt to her progress db.
    await controller.login(identifier: 'jane@demo.ng', password: 'password123');
    final janeId = container.read(currentUserProvider)!.id;
    final janeDb = container.read(progressDbProvider(janeId.toString()));

    expect(await janeDb.watchRecentAttempts().first, isEmpty);
    await janeDb.into(janeDb.practiceAttempts).insert(PracticeAttemptsCompanion.insert(
          id: 'jane-attempt-1',
          sourceType: 'assessment',
          subjectId: const Value(7),
          score: 10,
          totalQuestions: 10,
          timeSpentSeconds: 60,
          startedAt: '2026-07-29T00:00:00Z',
          completedAt: '2026-07-29T00:01:00Z',
        ));
    expect(await janeDb.watchRecentAttempts().first, hasLength(1));

    await controller.logout();
    expect(container.read(authStatusProvider), AuthStatus.loggedOut);
    expect(container.read(currentUserProvider), isNull);

    // --- Musa logs in on the same device/session — must see an empty
    // progress db, never Jane's attempt.
    await controller.login(identifier: 'musa@demo.ng', password: 'password123');
    final musaId = container.read(currentUserProvider)!.id;
    expect(musaId, isNot(janeId));

    final musaDb = container.read(progressDbProvider(musaId.toString()));
    expect(await musaDb.watchRecentAttempts().first, isEmpty);

    // --- Switching back to Jane still sees her original attempt intact.
    await controller.logout();
    await controller.login(identifier: 'jane@demo.ng', password: 'password123');
    final janeDbAgain = container.read(progressDbProvider(janeId.toString()));
    expect(await janeDbAgain.watchRecentAttempts().first, hasLength(1));
  });

  test('logout surfaces the unsynced-data warning when the outbox has pending rows', () async {
    final controller = container.read(authControllerProvider);
    await controller.login(identifier: 'jane@demo.ng', password: 'password123');
    final userId = container.read(currentUserProvider)!.id;
    final db = container.read(progressDbProvider(userId.toString()));

    await db.enqueueOutbox(SyncOutboxCompanion.insert(
      id: 'outbox-unsynced',
      entityType: 'practice_attempt',
      entityId: 'jane-attempt-1',
      payloadJson: '{}',
      createdAt: '2026-07-29T00:01:01Z',
    ));

    final hadUnsynced = await controller.logout();
    expect(hadUnsynced, isTrue);
  });

  test('forgot/reset password round trip lets the account log in with the new password', () async {
    final controller = container.read(authControllerProvider);
    final otp = await controller.forgotPassword('musa@demo.ng');
    expect(otp, isNotNull);

    await controller.resetPassword(identifier: 'musa@demo.ng', otp: otp!, newPassword: 'newpass123');
    await controller.login(identifier: 'musa@demo.ng', password: 'newpass123');
    expect(container.read(authStatusProvider), AuthStatus.loggedIn);
  });
}
