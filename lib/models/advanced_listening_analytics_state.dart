import 'package:yaabsa/models/advanced_loading_progress_info.dart';
import 'package:yaabsa/models/advanced_listening_stats.dart';

class AdvancedListeningAnalyticsState {
  const AdvancedListeningAnalyticsState({this.isLoading = false, this.stats, this.progress, this.errorMessage});

  final bool isLoading;
  final AdvancedListeningStats? stats;
  final AdvancedLoadingProgressInfo? progress;
  final String? errorMessage;
}
