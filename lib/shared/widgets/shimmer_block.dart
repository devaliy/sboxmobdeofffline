import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/theme.dart';

/// Skeleton-loading placeholder — the one screen state per spec Section 9
/// where continuous ambient motion is expected while real data streams in
/// from drift (first paint) or a pack download is being read.
class ShimmerBlock extends StatelessWidget {
  const ShimmerBlock({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? AppColors.surfaceDark : AppColors.outlineLight;
    final highlight = isDark ? AppColors.outlineDark : Colors.white;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      period: const Duration(milliseconds: 1400),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: base,
          borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }
}

/// A ready-made shimmer skeleton for a card-shaped loading item (book
/// tiles, subject rows, list cells) so features don't hand-roll layout.
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key, this.height = 88});

  final double height;

  @override
  Widget build(BuildContext context) {
    // `height` isn't guaranteed to be finite or comfortably large (a caller
    // filling a flexible area may reasonably pass double.infinity) — the
    // leading icon square has to stay a sane, finite size regardless.
    final iconSize = height.isFinite ? (height - 32).clamp(24.0, 96.0) : 56.0;

    return Container(
      height: height,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.outlineDark
              : AppColors.outlineLight,
        ),
      ),
      child: Row(
        children: [
          ShimmerBlock(width: iconSize, height: iconSize, borderRadius: BorderRadius.circular(AppRadius.md)),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ShimmerBlock(width: double.infinity, height: 14),
                SizedBox(height: AppSpacing.sm),
                ShimmerBlock(width: 120, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
