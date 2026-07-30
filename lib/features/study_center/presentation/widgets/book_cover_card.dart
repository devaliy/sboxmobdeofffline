import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/utils/parse_hex_color.dart';

/// A book's cover — server-authored `image` is almost always absent in
/// practice (spec Section 4.1's `image_path` is nullable), so this is the
/// *real* rendering path, not a placeholder-only fallback: a gradient tile
/// in the book's own authored color with its name, evoking the mockup's
/// bookshelf without needing artwork.
class BookCoverCard extends StatelessWidget {
  const BookCoverCard({super.key, required this.name, required this.colorHex, this.onTap});

  final String name;
  final String colorHex;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final base = parseHexColor(colorHex, fallback: AppColors.brandBlue);
    final deep = Color.lerp(base, Colors.black, 0.35)!;

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 0.72,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [base, deep],
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: [
              BoxShadow(color: base.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 8)),
            ],
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
              const Spacer(),
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
