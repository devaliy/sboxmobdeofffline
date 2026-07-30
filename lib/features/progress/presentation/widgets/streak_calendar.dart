import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

/// This month's grid, with the active streak shaded (spec Section 7's
/// "streak calendar"). `local_stats` (spec Section 4.3) only stores a
/// running counter and `last_active_date`, not a per-day activity log, so
/// "which days were active" is derived the only honest way this schema
/// allows: the `current_streak_days` consecutive days ending at
/// `last_active_date`.
class StreakCalendar extends StatelessWidget {
  const StreakCalendar({super.key, required this.currentStreakDays, required this.lastActiveDate});

  final int currentStreakDays;
  final DateTime? lastActiveDate;

  static const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final leadingBlanks = firstOfMonth.weekday - 1; // Dart: Monday = 1

    final activeDays = <DateTime>{};
    if (lastActiveDate != null) {
      for (var k = 0; k < currentStreakDays; k++) {
        final d = lastActiveDate!.subtract(Duration(days: k));
        activeDays.add(DateTime(d.year, d.month, d.day));
      }
    }

    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final label in _weekdayLabels)
              Expanded(
                child: Center(
                  child: Text(label, style: textTheme.labelSmall?.copyWith(color: mutedColor)),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemCount: leadingBlanks + daysInMonth,
          itemBuilder: (context, index) {
            if (index < leadingBlanks) return const SizedBox.shrink();
            final day = index - leadingBlanks + 1;
            final date = DateTime(now.year, now.month, day);
            final isActive = activeDays.contains(date);
            final isToday = day == now.day;

            return Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isActive
                      ? const LinearGradient(colors: [AppColors.signalOrange, AppColors.signalOrangeLight])
                      : null,
                  border: isToday && !isActive ? Border.all(color: AppColors.signalOrange, width: 1.4) : null,
                ),
                child: Text(
                  '$day',
                  style: textTheme.labelSmall?.copyWith(
                    color: isActive ? Colors.white : null,
                    fontWeight: isToday ? FontWeight.w700 : null,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
