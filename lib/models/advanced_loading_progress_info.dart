class AdvancedLoadingProgressInfo {
  const AdvancedLoadingProgressInfo({
    required this.loadedPages,
    required this.loadedSessions,
    this.totalPages,
    this.totalSessions,
  });

  final int loadedPages;
  final int loadedSessions;
  final int? totalPages;
  final int? totalSessions;

  double? get progress {
    if (totalPages != null && totalPages! > 0) {
      return (loadedPages / totalPages!).clamp(0, 1);
    }

    if (totalSessions != null && totalSessions! > 0) {
      return (loadedSessions / totalSessions!).clamp(0, 1);
    }

    return null;
  }
}
