import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/utils/date_utils.dart';

/// Manages the calendar view mode (weekly or monthly).
final calendarViewProvider =
    StateProvider<CalendarViewMode>((ref) => CalendarViewMode.weekly);

/// Tracks the selected date for calendar interactions.
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// Tracks the start of the currently displayed week.
final currentDisplayedWeekProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return now.subtract(Duration(days: now.weekday % 7));
});