import 'package:hive/hive.dart';

part 'mood_entry.g.dart'; // Will be generated

@HiveType(typeId: 3)
class MoodEntry {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int moodRating;

  MoodEntry({
    required this.date,
    required this.moodRating,
  });
}