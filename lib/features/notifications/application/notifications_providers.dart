import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/progress_db.dart';
import '../../auth/application/auth_controller.dart';

final notificationsProvider = StreamProvider<List<LocalNotification>>((ref) {
  final db = ref.watch(currentProgressDbProvider);
  if (db == null) return Stream.value(const []);
  return db.watchNotifications();
});

final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(currentProgressDbProvider);
  if (db == null) return Stream.value(0);
  return db.watchUnreadNotificationCount();
});

class NotificationsController {
  NotificationsController(this._ref);
  final Ref _ref;

  Future<void> markRead(String id) async {
    final db = _ref.read(currentProgressDbProvider);
    if (db == null) return;
    await db.markNotificationRead(id);
  }

  Future<void> markAllRead() async {
    final db = _ref.read(currentProgressDbProvider);
    if (db == null) return;
    await db.markAllNotificationsRead();
  }
}

final notificationsControllerProvider =
    Provider<NotificationsController>((ref) => NotificationsController(ref));
