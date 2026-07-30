import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/utils/parse_hex_color.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/home_providers.dart';

/// "Continue studying" — the account's most recently opened subject, or an
/// inviting empty state pointing at Study Center/Setup when nothing's been
/// read yet (a student who only downloaded Assessment content, say).
class ContinueStudyingCard extends ConsumerWidget {
  const ContinueStudyingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(continueStudyingProvider);
    final textTheme = Theme.of(context).textTheme;

    return async.when(
      loading: () => const ShimmerCard(height: 96),
      error: (e, st) => const SizedBox.shrink(),
      data: (info) {
        if (info == null) {
          return GlowCard(
            onTap: () => context.go(AppRoutes.study),
            child: Row(
              children: [
                const PastelIconBadge(icon: Icons.menu_book_outlined, hue: AppColors.sky, size: 48),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start studying', style: textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        "Pick up a subject in Study Center — it'll show up here next time.",
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          );
        }

        final color = parseHexColor(info.bookColor, fallback: AppColors.brandBlue);
        return GlowCard(
          glow: true,
          onTap: () => context.go(AppRoutes.study),
          child: Row(
            children: [
              AnimatedProgressRing(
                progress: info.percentComplete / 100,
                gradientColors: [color.withValues(alpha: 0.7), color],
                child: Text('${info.percentComplete}%', style: textTheme.labelSmall),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Continue studying', style: textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      info.subjectTitle,
                      style: textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(info.bookName, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
