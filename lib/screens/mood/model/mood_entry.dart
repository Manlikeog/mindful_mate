class MoodEntry {
  final DateTime date;
  final int moodRating;

  MoodEntry({required this.date, required this.moodRating,});

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'moodRating': moodRating,

      };

  factory MoodEntry.fromMap(Map<String, dynamic> map) => MoodEntry(
        date: DateTime.parse(map['date']),
        moodRating: map['moodRating'],
      );
}