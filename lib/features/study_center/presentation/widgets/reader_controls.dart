import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../application/reader_bookmarks.dart';
import '../../application/reader_prefs.dart';
import '../../application/reader_tts_controller.dart';

/// Speaks (or stops speaking) [html] aloud — the mic icon from the
/// desktop mockup's reader toolbar. Shared between the mobile AppBar and
/// the desktop reader pane rather than duplicated, since the behavior is
/// identical either way.
class ReadAloudButton extends ConsumerWidget {
  const ReadAloudButton({super.key, required this.html});

  final String html;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSpeaking = ref.watch(readerTtsControllerProvider);
    return IconButton(
      tooltip: isSpeaking ? 'Stop reading aloud' : 'Read aloud',
      icon: Icon(
        isSpeaking ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
        color: isSpeaking ? AppColors.signalOrange : null,
      ),
      onPressed: () {
        final controller = ref.read(readerTtsControllerProvider.notifier);
        if (isSpeaking) {
          controller.stop();
        } else {
          controller.speak(html);
        }
      },
    );
  }
}

class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({super.key, required this.subjectId});

  final int subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarked = ref.watch(bookmarkedSubjectsProvider).contains(subjectId);
    return IconButton(
      tooltip: bookmarked ? 'Remove bookmark' : 'Bookmark this reading',
      icon: Icon(
        bookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
        color: bookmarked ? AppColors.signalOrange : null,
      ),
      onPressed: () => ref.read(readerBookmarkControllerProvider).toggle(subjectId),
    );
  }
}

/// "Aa" — opens a small popup with live -/+ controls rather than two
/// separate always-visible AppBar buttons, matching the single-icon
/// treatment in the desktop mockup.
class FontSizeButton extends StatelessWidget {
  const FontSizeButton({super.key});

  void _adjust(WidgetRef ref, double delta) {
    final next = (ref.read(readerFontSizeProvider) + delta).clamp(kMinReaderFontSize, kMaxReaderFontSize);
    ref.read(readerFontSizeProvider.notifier).state = next;
    saveReaderFontSize(next);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Text size',
      icon: const Text('Aa', style: TextStyle(fontWeight: FontWeight.w800)),
      onPressed: () => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Text size'),
          content: Consumer(
            builder: (context, ref, _) {
              final size = ref.watch(readerFontSizeProvider);
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'Smaller text',
                    icon: const Icon(Icons.text_decrease_rounded),
                    onPressed: () => _adjust(ref, -1),
                  ),
                  SizedBox(
                    width: 56,
                    child: Text(
                      size.round().toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Larger text',
                    icon: const Icon(Icons.text_increase_rounded),
                    onPressed: () => _adjust(ref, 1),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Done')),
          ],
        ),
      ),
    );
  }
}
