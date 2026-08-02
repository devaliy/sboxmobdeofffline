import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/ai_chat/presentation/widgets/ai_chat_fab.dart';
import '../theme/app_spacing.dart';
import 'widgets/app_bottom_nav.dart';
import 'widgets/app_top_nav.dart';

/// The single responsive shell wrapping every main-tab destination.
/// Branches by width via [LayoutBuilder] at [AppBreakpoints.desktop], not
/// by platform check, per spec Section 1.8 — the same [navigationShell]
/// (and therefore the same per-tab navigation stacks/state) powers both
/// densities.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;

        if (isDesktop) {
          return Scaffold(
            appBar: AppTopNav(currentIndex: navigationShell.currentIndex, onTap: _onTap),
            body: navigationShell,
            floatingActionButton: const AiChatFab(),
          );
        }

        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: AppBottomNav(
            currentIndex: navigationShell.currentIndex,
            onTap: _onTap,
          ),
          floatingActionButton: const AiChatFab(),
        );
      },
    );
  }
}
