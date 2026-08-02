import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/ai_chat_providers.dart';
import 'widgets/message_bubble.dart';

/// One SuccessAI thread. [conversationId] is null for a brand-new chat —
/// the first message sent creates the conversation server-side, and this
/// screen swaps its URL to the real id once that happens so re-opening it
/// later (or the browser/OS back button, on platforms where that applies)
/// lands on the same thread rather than another blank one.
class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key, required this.conversationId, this.embedded = false});

  final String? conversationId;

  /// True when hosted inside the floating chat sheet ([AiChatFab]) rather
  /// than as its own routed page — swaps the AppBar's back arrow for a
  /// drag handle + close button, since there's nowhere to "back" to.
  final bool embedded;

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  String? _replacedToId;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();
    await ref.read(aiChatControllerProvider(widget.conversationId).notifier).send(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(aiChatControllerProvider(widget.conversationId));
    final online = ref.watch(isOnlineProvider);

    ref.listen(aiChatControllerProvider(widget.conversationId), (previous, next) {
      final newId = next.valueOrNull?.conversationId;
      if (!widget.embedded && widget.conversationId == null && newId != null && _replacedToId != newId) {
        _replacedToId = newId;
        context.replace(AppRoutes.aiChatConversation(newId));
      }
      if (next.valueOrNull != null) _scrollToBottom();
    });

    return Scaffold(
      appBar: widget.embedded
          ? PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _EmbeddedChatHeader(onClose: () => Navigator.of(context).maybePop()),
            )
          : AppBar(title: const Text('SuccessAI')),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) =>
            EmptyState(icon: Icons.error_outline_rounded, title: 'Couldn\'t load', message: '$e'),
        data: (state) {
          if (state.unavailable) {
            return const EmptyState(
              icon: Icons.cloud_off_rounded,
              title: 'SuccessAI is unavailable right now',
              message: 'This isn\'t a connection problem — try again in a little while.',
            );
          }
          return Column(
            children: [
              if (state.isOfflineCache) const _OfflineBanner(),
              Expanded(
                child: state.messages.isEmpty
                    ? const EmptyState(
                        icon: Icons.auto_awesome_rounded,
                        title: 'Ask SuccessAI anything',
                        message: 'Homework help, explanations, exam prep — start typing below.',
                      )
                    : ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: state.messages.length,
                        separatorBuilder: (context, _) => const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, i) => MessageBubble(message: state.messages[i]),
                      ),
              ),
              if (state.sending) const _TypingIndicator(),
              if (state.error != null && state.error != 'no_connection')
                _RetryBanner(message: state.error!, conversationId: widget.conversationId),
              if (state.error == 'no_connection' || !online) const _NeedsInternetBanner(),
              _Composer(controller: _inputController, onSend: _send, enabled: online && !state.sending),
            ],
          );
        },
      ),
    );
  }
}

/// The floating chat sheet's own compact header — a drag handle, title,
/// and a close button, standing in for a normal AppBar's back arrow since
/// dismissing the sheet (not navigating back) is what "close" means here.
class _EmbeddedChatHeader extends StatelessWidget {
  const _EmbeddedChatHeader({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(bottom: BorderSide(color: isDark ? AppColors.outlineDark : AppColors.outlineLight)),
      ),
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.md),
          const Icon(Icons.auto_awesome_rounded, size: 18, color: AppColors.signalOrange),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(child: Text('SuccessAI', style: TextStyle(fontWeight: FontWeight.w700))),
          IconButton(onPressed: onClose, icon: const Icon(Icons.close_rounded)),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      color: AppColors.warning.withValues(alpha: 0.14),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 16, color: AppColors.warning),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Offline — showing saved messages',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeedsInternetBanner extends StatelessWidget {
  const _NeedsInternetBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      color: AppColors.danger.withValues(alpha: 0.12),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 16, color: AppColors.danger),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'No internet — SuccessAI needs a connection to reply',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}

class _RetryBanner extends ConsumerWidget {
  const _RetryBanner({required this.message, required this.conversationId});
  final String message;
  final String? conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      color: AppColors.danger.withValues(alpha: 0.12),
      child: Row(
        children: [
          Expanded(
            child: Text(message, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.danger)),
          ),
          TextButton(
            onPressed: () => ref.read(aiChatControllerProvider(conversationId).notifier).retry(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.signalOrange),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('SuccessAI is thinking…', style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSend, required this.enabled});
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: Border(top: BorderSide(color: isDark ? AppColors.outlineDark : AppColors.outlineLight)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.send,
                onSubmitted: enabled ? (_) => onSend() : null,
                decoration: InputDecoration(
                  hintText: enabled ? 'Type a question…' : 'Waiting for connection…',
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton.filled(
              onPressed: enabled ? onSend : null,
              icon: const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
