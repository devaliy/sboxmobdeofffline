import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/progress_db.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/utils/relative_time.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/notifications_providers.dart';

/// Local activity feed ("you scored 80% on Physics", "Biology finished
/// downloading") — there's no server notifications endpoint for this app,
/// so this is entirely client-generated from real events the app already
/// knows about (see the `addNotification` call sites in the exam/quiz/
/// download controllers), not a placeholder.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          notificationsAsync.maybeWhen(
            data: (items) => items.any((n) => n.readAt == null)
                ? TextButton(
                    onPressed: () => ref.read(notificationsControllerProvider).markAllRead(),
                    child: const Text('Mark all read'),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) =>
            EmptyState(icon: Icons.error_outline_rounded, title: 'Couldn\'t load', message: '$e'),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'No notifications yet',
              message: 'Activity like test results and finished downloads will show up here.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: items.length,
            separatorBuilder: (context, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) => _NotificationTile(notification: items[i]),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.notification});
  final LocalNotification notification;

  IconData get _icon => switch (notification.type) {
        'test_result' => Icons.fact_check_rounded,
        'download' => Icons.download_done_rounded,
        'streak' => Icons.local_fire_department_rounded,
        _ => Icons.notifications_rounded,
      };

  PastelHue get _hue => switch (notification.type) {
        'test_result' => AppColors.sky,
        'download' => AppColors.mint,
        'streak' => AppColors.sunflower,
        _ => AppColors.lavender,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = notification.readAt == null;
    final theme = Theme.of(context);

    return GlowCard(
      onTap: unread ? () => ref.read(notificationsControllerProvider).markRead(notification.id) : null,
      border: unread ? const BorderSide(color: AppColors.signalOrange) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PastelIconBadge(icon: _icon, hue: _hue, size: 40),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(notification.body, style: theme.textTheme.bodySmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  relativeTime(DateTime.parse(notification.createdAt)),
                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (unread)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 4),
              decoration: const BoxDecoration(color: AppColors.signalOrange, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
