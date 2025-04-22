import 'package:flutter_test/flutter_test.dart';
import 'package:mindful_mate/controller/insights_controller.dart';
import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/utils/date_utils.dart';

void main() {
  final ic = InsightsController();
  group('InsightsController trends', () {
    test('no data returns prompt', () {
      final msg = ic.getMoodInsight({}, DateTime.now(), CalendarViewMode.weekly);
      expect(msg, contains('Start tracking'));
    });

    test('weekly happy days branch', () {
      final base = DateTime(2025,4,21);
      final data = Map.fromEntries(
        List.generate(5, (i) {
          final d = base.add(Duration(days: i));
          return MapEntry(d, MoodEntry(date: d, moodRating: 3));
        })
      );
      final msg = ic.getMoodInsight(data, base, CalendarViewMode.weekly);
      expect(msg, contains('% happy days'));
    });
  });
}