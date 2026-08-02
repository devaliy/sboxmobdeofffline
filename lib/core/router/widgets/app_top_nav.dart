import 'package:flutter/material.dart';
import '../../../shared/widgets/widgets.dart';
import '../../theme/theme.dart';
import '../nav_items.dart';

/// Desktop top nav bar — the wide-density counterpart to [AppBottomNav],
/// matching the desktopscreens mockups' tab row (active tab gets a tinted
/// rounded-rect background) plus a notification/profile cluster on the
/// right. Sits below the native OS title bar (per the "keep native window
/// chrome" decision) rather than replacing it.
class AppTopNav extends StatelessWidget implements PreferredSizeWidget {
  const AppTopNav({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(bottom: BorderSide(color: isDark ? AppColors.outlineDark : AppColors.outlineLight)),
      ),
      child: SizedBox(
        height: preferredSize.height,
        child: Row(
          children: [
            const SizedBox(width: AppSpacing.xxl),
            const AppLogoMark(),
            const SizedBox(width: AppSpacing.xxxl),
            // LayoutBuilder + a min-width-pinned-to-viewport wrapper: nav
            // items are centered in the bar when they fit, but at a large
            // system text scale (spec Section 9) five stacked icon+label
            // items can still outgrow even the 900px desktop breakpoint's
            // width — this degrades to a left-anchored horizontal scroll
            // instead of overflowing off-screen, rather than losing that
            // safety net for the sake of centering.
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < kMainNavItems.length; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                              child: _TopNavTab(
                                item: kMainNavItems[i],
                                selected: i == currentIndex,
                                onTap: () => onTap(i),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const NotificationBell(),
            const SizedBox(width: AppSpacing.lg),
            const ProfileMenuButton(),
            const SizedBox(width: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _TopNavTab extends StatelessWidget {
  const _TopNavTab({required this.item, required this.selected, required this.onTap});

  final NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = selected
        ? AppColors.signalOrange
        : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      // 44x44 minimum touch target (spec Section 9) — this bar's own 68px
      // height doesn't help since InkWell only hit-tests its own child,
      // not the row's full height.
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44, minWidth: 64),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.signalOrange.withValues(alpha: isDark ? 0.18 : 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 26, color: fg),
              const SizedBox(height: 4),
              Text(item.label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}

/// The real logo, sized for the top nav's leading brand slot.
class AppLogoMark extends StatelessWidget {
  const AppLogoMark({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLogo(width: 120);
  }
}
