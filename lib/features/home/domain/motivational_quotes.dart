class Quote {
  const Quote(this.text, this.author);
  final String text;
  final String author;
}

/// Static "Quotes for today" content (matches the sboxscreens mockup's
/// hero card). No backend dependency — purely local, rotates by day-of-year
/// so it's the same quote all day but changes daily without needing state.
const List<Quote> kMotivationalQuotes = [
  Quote('I have always imagined that paradise will be a kind of library.', 'Jorge Luis Borges'),
  Quote('The beautiful thing about learning is that no one can take it away from you.', 'B.B. King'),
  Quote('Success is the sum of small efforts, repeated day in and day out.', 'Robert Collier'),
  Quote("Education is the passport to the future, for tomorrow belongs to those who prepare for it today.",
      'Malcolm X'),
  Quote('It always seems impossible until it is done.', 'Nelson Mandela'),
  Quote('The expert in anything was once a beginner.', 'Helen Hayes'),
  Quote('Discipline is choosing between what you want now and what you want most.', 'Abraham Lincoln'),
];

Quote quoteForToday(DateTime now) {
  final dayOfYear = now.difference(DateTime(now.year)).inDays;
  return kMotivationalQuotes[dayOfYear % kMotivationalQuotes.length];
}
