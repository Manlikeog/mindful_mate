class UserProgress {
  final int streakCount;
  final int totalPoints;
  final int level;
  final List<String> badges;

  UserProgress({
    this.streakCount = 0,
    this.totalPoints = 0,
    this.level = 1,
    this.badges = const [],
  });

  Map<String, dynamic> toMap() => {
        'streakCount': streakCount,
        'totalPoints': totalPoints,
        'level': level,
        'badges': badges.join(','),
      };

  factory UserProgress.fromMap(Map<String, dynamic> map) => UserProgress(
        streakCount: map['streakCount'],
        totalPoints: map['totalPoints'],
        level: map['level'],
        badges: (map['badges'] as String).split(',').where((b) => b.isNotEmpty).toList(),
      );
}