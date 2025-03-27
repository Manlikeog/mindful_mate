import 'dart:convert';

class UserProgress {
  final int streakCount;
  final int totalPoints;
  final int level;
  final List<String> badges;
  final DateTime? lastMoodLogDate;
  final DateTime? lastRelaxationLogDate;
  final DateTime? lastLogDate;
  final Map<String, DateTime> completedRelaxations;
  final Map<String, int> challengeProgress;
  final List<String> completedChallenges;

  UserProgress({
    this.streakCount = 0,
    this.totalPoints = 0,
    this.level = 1,
    this.badges = const [],
    this.lastMoodLogDate,
    this.lastRelaxationLogDate,
    this.lastLogDate,
    this.completedRelaxations = const {},
    this.challengeProgress = const {},
    this.completedChallenges = const [],
  });

  UserProgress copyWith({
    int? streakCount,
    int? totalPoints,
    int? level,
    List<String>? badges,
    DateTime? lastMoodLogDate,
    DateTime? lastRelaxationLogDate,
    DateTime? lastLogDate,
    Map<String, DateTime>? completedRelaxations,
    Map<String, int>? challengeProgress,
    List<String>? completedChallenges,
  }) {
    return UserProgress(
      streakCount: streakCount ?? this.streakCount,
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      lastMoodLogDate: lastMoodLogDate ?? this.lastMoodLogDate,
      lastRelaxationLogDate: lastRelaxationLogDate ?? this.lastRelaxationLogDate,
      lastLogDate: lastLogDate ?? this.lastLogDate,
      completedRelaxations: completedRelaxations ?? this.completedRelaxations,
      challengeProgress: challengeProgress ?? this.challengeProgress,
      completedChallenges: completedChallenges ?? this.completedChallenges,
    );
  }

  Map<String, dynamic> toMap() => {
        'streakCount': streakCount,
        'totalPoints': totalPoints,
        'level': level,
        'badges': badges.join(','),
        'lastMoodLogDate': lastMoodLogDate?.toIso8601String(),
        'lastRelaxationLogDate': lastRelaxationLogDate?.toIso8601String(),
        'lastLogDate': lastLogDate?.toIso8601String(),
        'completedRelaxations': jsonEncode(
          completedRelaxations.map((key, value) => MapEntry(key, value.toIso8601String())),
        ),
        'challengeProgress': jsonEncode(challengeProgress),
        'completedChallenges': jsonEncode(completedChallenges),
      };

  factory UserProgress.fromMap(Map<String, dynamic> map) {
    final completedRelaxationsRaw = map['completedRelaxations'];
    Map<String, DateTime> completedRelaxations = {};
    if (completedRelaxationsRaw != null && completedRelaxationsRaw is String) {
      final decoded = jsonDecode(completedRelaxationsRaw) as Map<String, dynamic>;
      completedRelaxations = decoded.map(
        (key, value) => MapEntry(key, DateTime.parse(value as String)),
      );
    }
    final challengeProgressRaw = map['challengeProgress'];
    Map<String, int> challengeProgress = {};
    if (challengeProgressRaw != null && challengeProgressRaw is String) {
      final decoded = jsonDecode(challengeProgressRaw) as Map<String, dynamic>;
      challengeProgress = decoded.map((key, value) => MapEntry(key, value as int));
    }
    final completedChallengesRaw = map['completedChallenges'];
    List<String> completedChallenges = [];
    if (completedChallengesRaw != null && completedChallengesRaw is String) {
      completedChallenges = (jsonDecode(completedChallengesRaw) as List).cast<String>();
    }
    return UserProgress(
      streakCount: map['streakCount'] ?? 0,
      totalPoints: map['totalPoints'] ?? 0,
      level: map['level'] ?? 1,
      badges: (map['badges'] as String?)?.split(',').where((b) => b.isNotEmpty).toList() ?? [],
      lastMoodLogDate: map['lastMoodLogDate'] != null ? DateTime.parse(map['lastMoodLogDate']) : null,
      lastRelaxationLogDate: map['lastRelaxationLogDate'] != null ? DateTime.parse(map['lastRelaxationLogDate']) : null,
      lastLogDate: map['lastLogDate'] != null ? DateTime.parse(map['lastLogDate']) : null,
      completedRelaxations: completedRelaxations,
      challengeProgress: challengeProgress,
      completedChallenges: completedChallenges,
    );
  }
}