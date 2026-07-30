import 'package:flutter/material.dart';

/// Consistent "Title ... trailing action" row used above every list/grid
/// section (Home's "Resources", Study Center's "Topics", etc).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Expanded + ellipsis so a long title or a large system text scale
        // (spec Section 9) shrinks gracefully instead of pushing the
        // action button off the right edge.
        Expanded(
          child: Text(title, style: textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}
