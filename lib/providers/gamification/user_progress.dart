class UserProgress {
  final int streakCount;
  final int totalPoints;
  final int level;
  final List<String> badges;
  final DateTime? lastMoodLogDate; // New: Last mood log date
  final DateTime? lastRelaxationLogDate; // New: Last relaxation date
  final DateTime? lastLogDate; // Keep for streak purposes

  UserProgress({
    this.streakCount = 0,
    this.totalPoints = 0,
    this.level = 1,
    this.badges = const [],
    this.lastMoodLogDate,
    this.lastRelaxationLogDate,
    this.lastLogDate,
  });

  Map<String, dynamic> toMap() => {
        'streakCount': streakCount,
        'totalPoints': totalPoints,
        'level': level,
        'badges': badges.join(','),
        'lastMoodLogDate': lastMoodLogDate?.toIso8601String(),
        'lastRelaxationLogDate': lastRelaxationLogDate?.toIso8601String(),
        'lastLogDate': lastLogDate?.toIso8601String(),
      };

  factory UserProgress.fromMap(Map<String, dynamic> map) => UserProgress(
        streakCount: map['streakCount'],
        totalPoints: map['totalPoints'],
        level: map['level'],
        badges: (map['badges'] as String).split(',').where((b) => b.isNotEmpty).toList(),
        lastMoodLogDate: map['lastMoodLogDate'] != null ? DateTime.parse(map['lastMoodLogDate']) : null,
        lastRelaxationLogDate: map['lastRelaxationLogDate'] != null ? DateTime.parse(map['lastRelaxationLogDate']) : null,
        lastLogDate: map['lastLogDate'] != null ? DateTime.parse(map['lastLogDate']) : null,
      );
}