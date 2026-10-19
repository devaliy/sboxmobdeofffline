import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import 'widgets/continue_studying_card.dart';
import 'widgets/home_header.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/quote_carousel.dart';
import 'widgets/sync_status_line.dart';

/// Home — greeting/streak, quote of the day, continue-studying, quick
/// actions, ambient sync status (spec Section 7). One design system, two
/// densities: mobile stacks everything in a single column; desktop splits
/// into the mockups' two-pane layout.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: isDesktop ? _DesktopLayout() : const _MobileLayout(),
            );
          },
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeHeader(showBellAndProfile: true).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: AppSpacing.lg),
        const Align(alignment: Alignment.centerLeft, child: SyncStatusLine()),
        const SizedBox(height: AppSpacing.lg),
        const QuoteCarousel().animate().fadeIn(delay: 80.ms).moveY(begin: 12, end: 0),
        const SizedBox(height: AppSpacing.xl),
        const ContinueStudyingCard(),
        const SizedBox(height: AppSpacing.xxl),
        SectionHeader(title: 'Resources'),
        const SizedBox(height: AppSpacing.md),
        const QuickActionsGrid(),
        // Clears the shell's floating AiChatFab, which otherwise sits on
        // top of the grid's bottom-right tile when scrolled all the way down.
        const SizedBox(height: AppSpacing.huge * 2 + AppSpacing.lg),
      ],
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: HomeHeader()),
            const SizedBox(width: AppSpacing.lg),
            const SyncStatusLine(),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const QuoteCarousel(),
                  const SizedBox(height: AppSpacing.xl),
                  const ContinueStudyingCard(),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xxl),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: 'Resources'),
                  const SizedBox(height: AppSpacing.md),
                  const QuickActionsGrid(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
