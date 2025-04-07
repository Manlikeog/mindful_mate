// lib/providers/insights_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/controller/insights_controller.dart';
import 'package:mindful_mate/providers/calendar_provider.dart';
import 'package:mindful_mate/providers/mood_provider.dart';

// Controller provider
final insightsControllerProvider = Provider((ref) => InsightsController());

// Insight-specific providers
final insightsProvider = Provider<InsightsProvider>((ref) => InsightsProvider(ref));

class InsightsProvider {
  final Ref ref;

  InsightsProvider(this.ref);

  String getMoodInsight(DateTime baseDate, CalendarViewMode viewMode) {
    final controller = ref.read(insightsControllerProvider);
    final moods = ref.read(moodProvider);
    return controller.getMoodInsight(moods, baseDate, viewMode);
  }

  double getAverageMood() {
    final controller = ref.read(insightsControllerProvider);
    final moods = ref.read(moodProvider);
    return controller.calculateAverageMood(moods);
  }


}
