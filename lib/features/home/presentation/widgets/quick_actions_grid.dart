import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';

class _QuickAction {
  const _QuickAction({
    required this.imageAsset,
    required this.hue,
    required this.title,
    required this.subtitle,
    this.route,
    this.isTopLevelRoute = false,
  });

  final String imageAsset;
  final PastelHue hue;
  final String title;
  final String subtitle;

  /// Null means "not built yet" — rendered locked with a Coming soon badge
  /// rather than a route (spec Section 0's non-goals: no chat/messaging in
  /// this offline build; kept visually per the mockups for completeness).
  final String? route;

  /// True for destinations that aren't one of the shell's nav tabs (only
  /// SuccessAI today) — those need `push` so there's something to pop back
  /// to; the nav-tab destinations use `go` to switch the shell's active
  /// branch instead, which is correct there since the nav bar itself is
  /// always the way back.
  final bool isTopLevelRoute;
}

const _actions = [
  _QuickAction(
    imageAsset: 'assets/branding/resource_study.png',
    hue: AppColors.sky,
    title: 'Study Center',
    subtitle: 'Read your downloaded subjects',
    route: AppRoutes.study,
  ),
  _QuickAction(
    imageAsset: 'assets/branding/resource_test.png',
    hue: AppColors.coral,
    title: 'Test Center',
    subtitle: 'Get tested on the topics you\'ve read',
    route: AppRoutes.practice,
  ),
  _QuickAction(
    imageAsset: 'assets/branding/resource_report.png',
    hue: AppColors.sunflower,
    title: 'Report and Analytics',
    subtitle: 'Scores and test trends',
    route: AppRoutes.analytics,
  ),
  _QuickAction(
    imageAsset: 'assets/branding/resource_successai.png',
    hue: AppColors.lavender,
    title: 'SuccessAI',
    subtitle: 'Chat with your AI study buddy',
    route: AppRoutes.aiChat,
    isTopLevelRoute: true,
  ),
];

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Two rows of Expanded tiles rather than a fixed-aspect-ratio
    // GridView: each tile's own content (image + up to two lines of title
    // + up to two lines of subtitle) determines its height, so nothing
    // overflows at larger system text scales the way a locked aspect
    // ratio did (caught by accessibility_test.dart's 1.4x scale check).
    return Column(
      children: [
        Row(children: [
          Expanded(child: _ActionTile(action: _actions[0])),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _ActionTile(action: _actions[1])),
        ]),
        const SizedBox(height: AppSpacing.md),
        Row(children: [
          Expanded(child: _ActionTile(action: _actions[2])),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _ActionTile(action: _actions[3])),
        ]),
      ],
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
    final onTap = locked
        ? () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${action.title} is coming in a future update.')),
            )
        : action.isTopLevelRoute
            ? () => context.push(action.route!)
            : () => context.go(action.route!);

    final image = Image.asset(action.imageAsset, width: 76, height: 76, fit: BoxFit.contain);

    final subtitle = Text(
      action.subtitle,
      textAlign: TextAlign.center,
      style: textTheme.bodySmall?.copyWith(
        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
    final title = Text(
      action.title,
      textAlign: TextAlign.center,
      style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    return GlowCard(
      color: action.hue.tint(Theme.of(context).brightness),
      border: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
      onTap: onTap,
      child: Stack(
        children: [
          // A minimum height, not a fixed one: taller by default, but
          // still free to grow at larger system text scales instead of
          // overflowing (a fixed aspect ratio caused exactly that — see
          // accessibility_test.dart's 1.4x scale check).
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 176),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                image,
                const SizedBox(height: AppSpacing.md),
                title,
                const SizedBox(height: AppSpacing.xs),
                subtitle,
              ],
            ),
          ),
          if (locked)
            const Positioned(top: 0, right: 0, child: ComingSoonBadge()),
        ],
      ),
    );
  }
}
