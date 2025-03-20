class MoodEntry {
  final DateTime date;
  final int moodRating;
  final String? note;

  MoodEntry({required this.date, required this.moodRating, this.note});

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'moodRating': moodRating,
        'note': note,
      };

  factory MoodEntry.fromMap(Map<String, dynamic> map) => MoodEntry(
        date: DateTime.parse(map['date']),
        moodRating: map['moodRating'],
        note: map['note'],
      );
}