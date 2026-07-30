import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../shared/widgets/widgets.dart';

/// Temporary M0 review screen — shows the design system in one place.
/// Superseded by the real app shell in M1 and can be deleted then.
class DesignShowcaseScreen extends StatefulWidget {
  const DesignShowcaseScreen({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<DesignShowcaseScreen> createState() => _DesignShowcaseScreenState();
}

class _DesignShowcaseScreenState extends State<DesignShowcaseScreen> {
  double _ring = 0.54;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design system — M0'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const Center(child: AnimatedLogoIntro()),
          const SizedBox(height: AppSpacing.xxxl),

          const SectionHeader(title: 'Typography'),
          const SizedBox(height: AppSpacing.md),
          Text('Display / headline', style: textTheme.headlineLarge),
          Text('Title medium', style: textTheme.titleMedium),
          Text(
            'Body text in Inter, for long-form Study Center reading and everyday copy across the app.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xxxl),

          const SectionHeader(title: 'Buttons'),
          const SizedBox(height: AppSpacing.md),
          GradientButton(label: 'Get started', icon: Icons.arrow_forward_rounded, onPressed: () {}),
          const SizedBox(height: AppSpacing.md),
          const GradientButton(label: 'Loading…', loading: true, onPressed: null),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: FilledButton(onPressed: () {}, child: const Text('Log in'))),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Sign up'))),
            ],
          ),
          const SizedBox(height: AppSpacing.xxxl),

          const SectionHeader(title: 'Cards & glow'),
          const SizedBox(height: AppSpacing.md),
          GlowCard(
            glow: true,
            onTap: () {},
            child: Row(
              children: [
                AnimatedProgressRing(
                  progress: _ring,
                  child: Text('${(_ring * 100).round()}%', style: textTheme.labelMedium),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Continue studying', style: textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Biology for Senior Secondary School One', style: textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Slider(
            value: _ring,
            onChanged: (v) => setState(() => _ring = v),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          const SectionHeader(title: 'Pastel tiles'),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              PastelIconBadge(icon: Icons.menu_book_rounded, hue: AppColors.sky),
              PastelIconBadge(icon: Icons.quiz_rounded, hue: AppColors.coral),
              PastelIconBadge(icon: Icons.insights_rounded, hue: AppColors.sunflower),
              PastelIconBadge(icon: Icons.settings_rounded, hue: AppColors.lavender),
              PastelIconBadge(icon: Icons.chat_bubble_rounded, hue: AppColors.mint),
              PastelIconBadge(icon: Icons.calculate_rounded, hue: AppColors.rose),
            ],
          ),
          const SizedBox(height: AppSpacing.xxxl),

          const SectionHeader(title: 'Status & loading'),
          const SizedBox(height: AppSpacing.md),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              StatusPill(label: 'Synced just now', icon: Icons.check_circle, tone: StatusPillTone.success),
              StatusPill(label: 'Syncing…', tone: StatusPillTone.info, pulse: true),
              StatusPill(label: '3 results waiting', icon: Icons.cloud_off_rounded, tone: StatusPillTone.warning),
              StatusPill(label: 'Offline', icon: Icons.wifi_off_rounded),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const ShimmerCard(),
          const SizedBox(height: AppSpacing.xxxl),

          const SectionHeader(title: 'Empty state'),
          SizedBox(
            height: 320,
            child: EmptyState(
              icon: Icons.menu_book_outlined,
              title: 'No Study content yet',
              message: "You haven't downloaded any Study content yet — tap to add some.",
              actionLabel: 'Add content',
              onAction: () {},
            ),
          ),
        ],
      ),
    );
  }
}
