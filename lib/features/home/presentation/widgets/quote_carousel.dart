import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/motivational_quotes.dart';

/// "Quotes for today" hero card (matches the sboxscreens mockup): a
/// glowing gradient carousel, swipeable, defaulting to today's pick so it
/// feels fresh without needing any state.
class QuoteCarousel extends StatefulWidget {
  const QuoteCarousel({super.key});

  @override
  State<QuoteCarousel> createState() => _QuoteCarouselState();
}

class _QuoteCarouselState extends State<QuoteCarousel> {
  late final int _initialPage = kMotivationalQuotes.indexOf(quoteForToday(DateTime.now()));
  late final PageController _controller = PageController(initialPage: _initialPage);
  late int _page = _initialPage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(int delta) {
    _controller.animateToPage(
      (_page + delta).clamp(0, kMotivationalQuotes.length - 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      decoration: BoxDecoration(
        gradient: context.glow.heroGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: context.glow.cardShadow,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _controller,
              itemCount: kMotivationalQuotes.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) {
                final quote = kMotivationalQuotes[i];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.xl, AppSpacing.xxl, 36),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'QUOTE FOR TODAY',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.6),
                              letterSpacing: 1.2,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          '"${quote.text}"',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      Text(
                        '— ${quote.author}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white.withValues(alpha: 0.75)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            bottom: AppSpacing.md,
            child: _NavButton(icon: Icons.chevron_left_rounded, onTap: () => _go(-1)),
          ),
          Positioned(
            left: AppSpacing.xxxl,
            bottom: AppSpacing.md,
            child: _NavButton(icon: Icons.chevron_right_rounded, onTap: () => _go(1)),
          ),
          Positioned(
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: Row(
              children: [
                for (var i = 0; i < kMotivationalQuotes.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(left: 4),
                    width: i == _page ? 14 : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: i == _page ? 0.9 : 0.4),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.14), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
