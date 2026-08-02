import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Strips tags/entities well enough for speech — content is CKEditor HTML,
/// not arbitrary markup, so a regex pass (rather than pulling in a full
/// HTML parser just to get plain text back out) is proportionate here:
/// minor artifacts in what gets spoken are acceptable, unlike in the
/// visual render where `flutter_html` is used properly.
String stripHtmlForSpeech(String html) {
  final withoutTags = html.replaceAll(RegExp(r'<[^>]*>'), ' ');
  final decoded = withoutTags
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'");
  return decoded.replaceAll(RegExp(r'\s+'), ' ').trim();
}

/// Read-aloud for the Reader's content — a thin wrapper over `flutter_tts`
/// exposing just "is it currently speaking" as state, since that's the
/// only thing the mic icon's appearance/behavior depends on.
class ReaderTtsController extends StateNotifier<bool> {
  ReaderTtsController() : super(false) {
    _tts.setCompletionHandler(() {
      if (mounted) state = false;
    });
    _tts.setCancelHandler(() {
      if (mounted) state = false;
    });
    _tts.setErrorHandler((message) {
      if (mounted) state = false;
    });
  }

  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String html) async {
    final text = stripHtmlForSpeech(html);
    if (text.isEmpty) return;
    await _tts.stop();
    state = true;
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
    state = false;
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}

/// `autoDispose`: stops speaking and releases the TTS engine the moment
/// nothing's reading anymore (leaving the Reader screen), rather than an
/// orphaned engine instance quietly outliving the page that created it.
final readerTtsControllerProvider =
    StateNotifierProvider.autoDispose<ReaderTtsController, bool>((ref) => ReaderTtsController());
