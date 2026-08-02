/// Aggregate headline numbers for the Analytics report — everything here is
/// derived from the full local attempt history, no server round-trip.
class AnalyticsStats {
  const AnalyticsStats({
    required this.totalTests,
    required this.highestScorePercent,
    required this.totalPassed,
    required this.totalFailed,
    required this.averagePerformancePercent,
    required this.averageTimeSpentSeconds,
    required this.growthPercent,
    required this.performanceTrendPercent,
    required this.timeSpentTrendPercent,
    required this.growthSparkline,
    required this.performanceSparkline,
    required this.timeSpentSparkline,
  });

  static const empty = AnalyticsStats(
    totalTests: 0,
    highestScorePercent: 0,
    totalPassed: 0,
    totalFailed: 0,
    averagePerformancePercent: 0,
    averageTimeSpentSeconds: 0,
    growthPercent: 0,
    performanceTrendPercent: 0,
    timeSpentTrendPercent: 0,
    growthSparkline: [],
    performanceSparkline: [],
    timeSpentSparkline: [],
  );

  final int totalTests;
  final double highestScorePercent;
  final int totalPassed;
  final int totalFailed;
  final double averagePerformancePercent;
  final double averageTimeSpentSeconds;

  /// Period-over-period % change: second half of history vs first half,
  /// by score. Positive = improving.
  final double growthPercent;
  final double performanceTrendPercent;
  final double timeSpentTrendPercent;

  /// Up to the last 10 attempts, chronological — small trend lines behind
  /// each stat card.
  final List<double> growthSparkline;
  final List<double> performanceSparkline;
  final List<double> timeSpentSparkline;
}
