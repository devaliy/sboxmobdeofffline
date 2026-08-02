import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/utils/relative_time.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/ai_chat_providers.dart';
import '../domain/ai_conversation.dart';

/// SuccessAI's entry point (SUCCESSAI_BUILD_PROMPT.md Section 4) — list of
/// past conversations plus "New chat". Three distinct empty states: no
/// conversations yet, offline with nothing cached, and the server
/// reporting SuccessAI unavailable.
class AiConversationListScreen extends ConsumerWidget {
  const AiConversationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(aiConversationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SuccessAI')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.aiChatNew),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New chat'),
      ),
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
          if (state.conversations.isEmpty && state.isOfflineCache) {
            return const EmptyState(
              icon: Icons.wifi_off_rounded,
              title: 'You\'re offline',
              message: 'Connect to the internet to start chatting with SuccessAI.',
            );
          }
          if (state.conversations.isEmpty) {
            return const EmptyState(
              icon: Icons.auto_awesome_rounded,
              title: 'Ask SuccessAI anything',
              message: 'Your academic AI assistant is ready — start a new chat to get going.',
            );
          }
          return Column(
            children: [
              if (state.isOfflineCache) const _OfflineBanner(),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: state.conversations.length,
                  separatorBuilder: (context, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) => _ConversationTile(conversation: state.conversations[i]),
                ),
              ),
            ],
          );
        },
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
              'Offline — showing saved conversations',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation});
  final AiConversation conversation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlowCard(
      onTap: () => context.push(AppRoutes.aiChatConversation(conversation.id)),
      child: Row(
        children: [
          const PastelIconBadge(icon: Icons.auto_awesome_rounded, hue: AppColors.lavender, size: 40),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(conversation.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                if (conversation.lastMessage != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    conversation.lastMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            relativeTime(conversation.updatedAt),
            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
