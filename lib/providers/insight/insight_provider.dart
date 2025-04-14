import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/controller/insights_controller.dart';
import 'package:mindful_mate/providers/mood_provider.dart';
import 'package:mindful_mate/utils/date_utils.dart';

/// Provides access to the insights controller.
final insightsControllerProvider = Provider((ref) => InsightsController());

/// Provides insights-related data and operations.
final insightsProvider = Provider<InsightsProvider>((ref) => InsightsProvider(ref));

/// Manages insights calculations for mood data.
class InsightsProvider {
  final Ref providerRef;

  InsightsProvider(this.providerRef);

  /// Retrieves a mood insight for the given date and view mode.
  String getMoodInsight(DateTime baseDate, CalendarViewMode viewMode) {
    final controller = providerRef.read(insightsControllerProvider);
    final moods = providerRef.read(moodProvider);
    return controller.getMoodInsight(moods, baseDate, viewMode);
  }

  /// Calculates the average mood across all entries.
  double? getAverageMood() {
    final controller = providerRef.read(insightsControllerProvider);
    final moods = providerRef.read(moodProvider);
    return controller.calculateAverageMood(moods);
  }
}