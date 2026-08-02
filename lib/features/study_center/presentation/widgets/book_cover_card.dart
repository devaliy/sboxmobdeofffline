import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/utils/parse_hex_color.dart';
import '../../../../shared/widgets/widgets.dart';

/// A book's cover. `imagePath` (relative to the documents dir, written by
/// `PackImporter` from the pack's `image` field) is used when present —
/// server-authored cover art is real, just often absent (spec Section
/// 4.1's `image_path` is nullable) — falling back to a gradient tile in
/// the book's own authored color with its name, evoking the mockup's
/// bookshelf without needing artwork.
class BookCoverCard extends StatelessWidget {
  const BookCoverCard({
    super.key,
    required this.name,
    required this.colorHex,
    this.imagePath,
    this.onTap,
  });

  final String name;
  final String colorHex;
  final String? imagePath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final base = parseHexColor(colorHex, fallback: AppColors.brandBlue);
    final deep = Color.lerp(base, Colors.black, 0.35)!;

    final fallback = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [base, deep]),
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.menu_book_rounded, color: Colors.white, size: 18),
          const Spacer(),
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 0.66,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            boxShadow: [
              BoxShadow(color: base.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 6)),
            ],
          ),
          child: imagePath == null
              ? fallback
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    LocalContentImage(relativePath: imagePath, placeholder: fallback),
                    // A scrim + title even when a real cover image is
                    // present: unlike the mockup's stock art, real
                    // per-book covers aren't guaranteed to render their
                    // own title legibly, so this stays a safety net
                    // rather than assuming the image speaks for itself.
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.sm,
                          AppSpacing.lg,
                          AppSpacing.sm,
                          AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withValues(alpha: 0), Colors.black.withValues(alpha: 0.72)],
                          ),
                        ),
                        child: Text(
                          name,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
