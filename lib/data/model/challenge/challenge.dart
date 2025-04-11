import 'package:hive/hive.dart';

part 'challenge.g.dart';

@HiveType(typeId: 2)
class Challenge {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final int goal;

  @HiveField(5)
  final int points;

  @HiveField(6)
  final DateTime startDate;

  @HiveField(7)
  final DateTime endDate;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.goal,
    required this.points,
    required this.startDate,
    required this.endDate,
  });

  bool isActive(DateTime now) {
    return now.isAfter(startDate) &&
        now.isBefore(endDate.add(Duration(days: 1)));
  }
}

final Map<int, List<Challenge>> levelChallenges = {
  1: [
    Challenge(
      id: 'mood_l1',
      title: 'Mood Tracker',
      description: 'Log your mood 3 days this week.',
      goal: 3,
      type: 'mood_log',
      points: 30,
      startDate:
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
    ),
    Challenge(
      id: 'relax_l1',
      title: 'Calm Mind',
      description: 'Complete 2 relaxation exercises this week.',
      goal: 2,
      type: 'relaxation',
      points: 30,
      startDate:
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
    ),
    Challenge(
      id: 'journal_l1',
      title: 'Reflective Writer',
      description: 'Write 3 journal entries this week.',
      goal: 3,
      type: 'journal',
      points: 40,
      startDate:
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
    ),
    Challenge(
      id: 'breath_l1',
      title: 'Breath Starter',
      description: 'Try Deep Breathing 3 times this week.',
      goal: 3,
      type: 'relaxation',
      points: 20,
      startDate:
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
    ),
  ],
  2: [
    Challenge(
      id: 'mood_l2',
      title: 'Mood Consistency',
      description: 'Log your mood 5 days this week.',
      goal: 5,
      type: 'mood_log',
      points: 50,
      startDate:
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
    ),
    Challenge(
      id: 'relax_l2',
      title: 'Inner Peace',
      description: 'Complete 3 relaxation exercises this week.',
      goal: 3,
      type: 'relaxation',
      points: 50,
      startDate:
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
    ),
    Challenge(
      id: 'journal_l2',
      title: 'Deep Thoughts',
      description: 'Write 4 journal entries this week.',
      goal: 4,
      type: 'journal',
      points: 60,
      startDate:
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
    ),
    Challenge(
      id: 'yoga_l2',
      title: 'Yoga Flow Fan',
      description: 'Complete Yoga Flow 3 times this week.',
      goal: 3,
      type: 'relaxation',
      points: 30,
      startDate:
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
    ),
  ],
  3: [
    Challenge(
      id: 'mood_l3',
      title: 'Mood Mastery',
      description: 'Log your mood every day this week.',
      goal: 7,
      type: 'mood_log',
      points: 70,
      startDate:
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
    ),
    Challenge(
      id: 'relax_l3',
      title: 'Zen Master',
      description: 'Complete 4 relaxation exercises this week.',
      goal: 4,
      type: 'relaxation',
      points: 70,
      startDate:
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
    ),
    Challenge(
      id: 'journal_l3',
      title: 'Life Chronicler',
      description: 'Write 5 journal entries this week.',
      goal: 5,
      type: 'journal',
      points: 70,
      startDate:
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
    ),
    Challenge(
      id: 'mindful_l3',
      title: 'Mindfulness Pro',
      description: 'Practice Mindfulness 4 times this week.',
      goal: 4,
      type: 'relaxation',
      points: 50,
      startDate:
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
    ),
  ],
};

final Map<int, int> passMarks = {1: 90, 2: 180, 3: 240};
final Map<int, int> levelPoints = {1: 145, 2: 227, 3: 309};
