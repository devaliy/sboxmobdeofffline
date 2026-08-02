import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../ai_chat_screen.dart';

/// The "chat with SuccessAI from anywhere" entry point — a floating button
/// present on every main shell page (wired in [AppShell], so it's absent
/// from the exam session, Setup, and auth screens, which are all outside
/// the shell) that opens a tall chat sheet over whatever the student was
/// doing, rather than navigating them away from it.
class AiChatFab extends StatelessWidget {
  const AiChatFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'successai-fab',
      tooltip: 'Ask SuccessAI',
      onPressed: () => _openChatSheet(context),
      child: const Icon(Icons.auto_awesome_rounded),
    );
  }

  void _openChatSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.92,
        child: const ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
          child: AiChatScreen(conversationId: null, embedded: true),
        ),
      ),
    );
  }
}
