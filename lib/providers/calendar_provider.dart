import 'package:hooks_riverpod/hooks_riverpod.dart';

final calendarViewProvider =
    StateProvider<CalendarViewMode>((ref) => CalendarViewMode.weekly);
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final currentDisplayedWeekProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return now.subtract(Duration(days: now.weekday % 7));
});

enum CalendarViewMode { weekly, monthly }