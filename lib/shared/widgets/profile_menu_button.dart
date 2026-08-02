import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/theme.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/application/logout_flow.dart';

/// The avatar+name chip used in the desktop top nav and (compact) the
/// mobile Home header — tapping it opens a small dropdown ("My Profile" /
/// "Log out"), reused in both places so the two densities never drift.
class ProfileMenuButton extends ConsumerWidget {
  const ProfileMenuButton({super.key, this.showChevron = true});

  /// Mobile's Home header shows just the avatar+name (no chevron) since
  /// it sits inline with a greeting rather than in a nav bar.
  final bool showChevron;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final textTheme = Theme.of(context).textTheme;
    final label = user?.fullName ?? 'Student';

    return PopupMenuButton<_ProfileMenuAction>(
      tooltip: 'Profile menu',
      offset: const Offset(0, 40),
      onSelected: (action) => _handle(action, context, ref),
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _ProfileMenuAction.profile,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.person_outline_rounded),
            title: Text('My Profile'),
          ),
        ),
        PopupMenuItem(
          value: _ProfileMenuAction.logout,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.logout_rounded),
            title: Text('Log out'),
          ),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.brandBlue,
            child: Text(
              (user?.firstName.isNotEmpty ?? false) ? user!.firstName[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(label, style: textTheme.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          if (showChevron) ...[
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          ],
        ],
      ),
    );
  }

  void _handle(_ProfileMenuAction action, BuildContext context, WidgetRef ref) {
    switch (action) {
      case _ProfileMenuAction.profile:
        context.push(AppRoutes.profile);
      case _ProfileMenuAction.logout:
        runLogoutFlow(context, ref);
    }
  }
}

enum _ProfileMenuAction { profile, logout }
