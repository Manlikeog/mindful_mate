import 'package:hive/hive.dart';

part 'user_progress.g.dart';

/// Stores user progress for gamification features.
@HiveType(typeId: 1)
class UserProgress {
  @HiveField(0)
  final int level;

  @HiveField(1)
  final int totalPoints;

  @HiveField(2)
  final int streakCount;

  @HiveField(3)
  final DateTime? lastLogDate;

  @HiveField(4)
  final DateTime? lastMoodLogDate;

  @HiveField(5)
  final DateTime? lastRelaxationLogDate;

  @HiveField(6)
  final Map<String, int> challengeProgress;

  @HiveField(7)
  final List<String> completedChallenges;

  @HiveField(8)
  final List<String> badges;

  @HiveField(9)
  final Map<String, DateTime> completedRelaxations;

  @HiveField(10)
  final List<DateTime> moodLogDates;

  @HiveField(11)
  final List<DateTime> journalLogDates;

  @HiveField(12)
  final List<DateTime> relaxationLogDates;

  UserProgress({
    this.level = 1,
    this.totalPoints = 0,
    this.streakCount = 0,
    this.lastLogDate,
    this.lastMoodLogDate,
    this.lastRelaxationLogDate,
    this.challengeProgress = const {},
    this.completedChallenges = const [],
    this.badges = const [],
    this.completedRelaxations = const {},
    this.moodLogDates = const [],
    this.journalLogDates = const [],
    this.relaxationLogDates = const [],
  });

  /// Creates a copy with updated fields.
  UserProgress copyWith({
    int? level,
    int? totalPoints,
    int? streakCount,
    DateTime? lastLogDate,
    DateTime? lastMoodLogDate,
    DateTime? lastRelaxationLogDate,
    Map<String, int>? challengeProgress,
    List<String>? completedChallenges,
    List<String>? badges,
    Map<String, DateTime>? completedRelaxations,
    List<DateTime>? moodLogDates,
    List<DateTime>? journalLogDates,
    List<DateTime>? relaxationLogDates,
  }) {
    return UserProgress(
      level: level ?? this.level,
      totalPoints: totalPoints ?? this.totalPoints,
      streakCount: streakCount ?? this.streakCount,
      lastLogDate: lastLogDate ?? this.lastLogDate,
      lastMoodLogDate: lastMoodLogDate ?? this.lastMoodLogDate,
      lastRelaxationLogDate: lastRelaxationLogDate ?? this.lastRelaxationLogDate,
      challengeProgress: challengeProgress ?? Map.from(this.challengeProgress),
      completedChallenges: completedChallenges ?? List.from(this.completedChallenges),
      badges: badges ?? List.from(this.badges),
      completedRelaxations: completedRelaxations ?? Map.from(this.completedRelaxations),
      moodLogDates: moodLogDates ?? List.from(this.moodLogDates),
      journalLogDates: journalLogDates ?? List.from(this.journalLogDates),
      relaxationLogDates: relaxationLogDates ?? List.from(this.relaxationLogDates),
    );
  }
}