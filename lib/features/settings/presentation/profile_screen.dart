import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/reference/ng_classes.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/application/logout_flow.dart';

/// My Profile — the top nav/Home-header profile dropdown's destination.
/// Avatar-initial + name + class, then account actions (per
/// `sboxscreens/profile page and edit profile.png`): edit profile info,
/// performance history (-> Analytics), language, log out.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.brandBlue,
                  child: Text(
                    user == null ? '?' : user.firstName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(user?.fullName ?? 'Loading…', style: theme.textTheme.titleLarge),
                const SizedBox(height: 2),
                Text(
                  user == null
                      ? ''
                      : [
                          if (classOptionByIdOrNull(user.currentClassId) case final c?) c.name,
                          user.email,
                        ].join(' · '),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          GlowCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Edit profile information'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push(AppRoutes.editProfile),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: const Text('Language'),
                  trailing: Text('English', style: theme.textTheme.bodyMedium),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.insights_rounded),
                  title: const Text('My performance history'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push(AppRoutes.analytics),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          GradientButton(
            label: 'Log Out',
            onPressed: () => runLogoutFlow(context, ref),
          ),
        ],
      ),
    );
  }
}
