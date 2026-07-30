import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

/// Small ribbon used on locked/preview tiles (Chat2Learn, Math Solver on
/// Home) that are shown for visual completeness per the mockups but are
/// out of scope for this offline build — see MOBILE_APP_BUILD_PROMPT.md
/// Section 0's non-goals.
class ComingSoonBadge extends StatelessWidget {
  const ComingSoonBadge({super.key, this.label = 'Coming soon'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.inkNavy,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontSize: 9,
              letterSpacing: 0.4,
            ),
      ),
    );
  }
}
