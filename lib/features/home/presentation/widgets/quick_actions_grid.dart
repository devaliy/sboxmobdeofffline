import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';

class _QuickAction {
  const _QuickAction({
    required this.icon,
    required this.hue,
    required this.title,
    required this.subtitle,
    this.route,
  });

  final IconData icon;
  final PastelHue hue;
  final String title;
  final String subtitle;

  /// Null means "not built yet" — rendered locked with a Coming soon badge
  /// rather than a route (spec Section 0's non-goals: no chat/messaging in
  /// this offline build; kept visually per the mockups for completeness).
  final String? route;
}

const _actions = [
  _QuickAction(
    icon: Icons.menu_book_rounded,
    hue: AppColors.sky,
    title: 'Study Center',
    subtitle: 'Read your downloaded subjects',
    route: AppRoutes.study,
  ),
  _QuickAction(
    icon: Icons.assignment_rounded,
    hue: AppColors.coral,
    title: 'Practice / CBT',
    subtitle: 'Timed tests on what you\'ve read',
    route: AppRoutes.practice,
  ),
  _QuickAction(
    icon: Icons.insights_rounded,
    hue: AppColors.sunflower,
    title: 'Progress',
    subtitle: 'Streaks, scores and accuracy',
    route: AppRoutes.progress,
  ),
  _QuickAction(
    icon: Icons.settings_rounded,
    hue: AppColors.lavender,
    title: 'Settings',
    subtitle: 'Downloads, account, sync',
    route: AppRoutes.settings,
  ),
  _QuickAction(
    icon: Icons.chat_bubble_rounded,
    hue: AppColors.mint,
    title: 'Chat2Learn',
    subtitle: 'Ask an AI tutor anything',
  ),
  _QuickAction(
    icon: Icons.calculate_rounded,
    hue: AppColors.rose,
    title: 'Math Solver',
    subtitle: 'Step-by-step working',
  ),
];

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key, this.crossAxisCount = 2});

  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.05,
      children: [for (final action in _actions) _ActionTile(action: action)],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action});
  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    final locked = action.route == null;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlowCard(
      color: action.hue.tint(Theme.of(context).brightness),
      border: BorderSide.none,
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: locked
          ? () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${action.title} is coming in a future update.')),
              )
          : () => context.go(action.route!),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(action.icon, color: action.hue.foreground, size: 24),
              const SizedBox(height: AppSpacing.sm),
              Text(action.title, style: textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(
                action.subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          if (locked)
            const Positioned(top: 0, right: 0, child: ComingSoonBadge()),
        ],
      ),
    );
  }
}
