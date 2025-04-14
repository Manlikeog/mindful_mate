import 'package:hive/hive.dart';

part 'mood_entry.g.dart';

/// Represents a single mood entry with a date and rating.
@HiveType(typeId: 3)
class MoodEntry {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int moodRating;

  @HiveField(2)
  final String key;

  MoodEntry({
    required this.date,
    required this.moodRating,
  }) : key = date.toIso8601String();

  /// Creates a copy with updated fields.
  MoodEntry copyWith({
    DateTime? date,
    int? moodRating,
  }) {
    return MoodEntry(
      date: date ?? this.date,
      moodRating: moodRating ?? this.moodRating,
    );
  }
}