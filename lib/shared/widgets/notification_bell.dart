import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/theme.dart';
import '../../features/notifications/application/notifications_providers.dart';

/// The bell icon used in the desktop top nav and the mobile Home header —
/// a small red dot appears when there's at least one unread notification,
/// tapping always navigates to the Notifications list.
class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unread = ref.watch(unreadNotificationCountProvider).valueOrNull ?? 0;

    return IconButton(
      tooltip: 'Notifications',
      onPressed: () => context.push(AppRoutes.notifications),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(Icons.notifications_none_rounded, color: isDark ? Colors.white70 : AppColors.inkNavy),
          if (unread > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
