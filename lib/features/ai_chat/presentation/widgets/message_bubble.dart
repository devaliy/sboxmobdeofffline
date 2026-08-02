import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../domain/ai_message.dart';

/// AI replies styled distinctly from the student's own messages — dark
/// "SuccessAI" card on the left vs. a lighter bubble on the right, matching
/// `sboxscreens/successAI chat screen.png`'s chat treatment.
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final AiMessage message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    if (message.isAi) {
      return Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.signalOrange),
                  const SizedBox(width: AppSpacing.xs),
                  Text('SuccessAI', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.inkNavy,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: SelectableText(
                  message.content,
                  style: const TextStyle(color: Colors.white, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
            border: Border.all(color: isDark ? AppColors.outlineDark : AppColors.outlineLight),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: SelectableText(message.content, style: theme.textTheme.bodyMedium?.copyWith(height: 1.4)),
        ),
      ),
    );
  }
}
