class Challenge {
  final String id;
  final String title;
  final String description;
  final int goal;
  final String type; // mood_log, relaxation, journal
  final int points;
  final DateTime startDate;
  final DateTime endDate;
  final int level;

  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.goal,
    required this.type,
    required this.points,
    required this.startDate,
    required this.endDate,
    required this.level,
  });

  bool isActive(DateTime now) {
    return now.isAfter(startDate) && now.isBefore(endDate.add(const Duration(days: 1)));
  }
}


// Define challenges and relaxations by level
final Map<int, List<Challenge>> levelChallenges = {
  1: [
    Challenge(
      id: 'mood_l1',
      title: 'Mood Tracker',
      description: 'Log your mood 3 days this week.',
      goal: 3,
      type: 'mood_log',
      points: 30,
      startDate: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
      level: 1,
    ),
    Challenge(
      id: 'relax_l1',
      title: 'Calm Mind',
      description: 'Complete 2 relaxation exercises this week.',
      goal: 2,
      type: 'relaxation',
      points: 30,
      startDate: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
      level: 1,
    ),
    Challenge(
      id: 'journal_l1',
      title: 'Reflective Writer',
      description: 'Write 3 journal entries this week.',
      goal: 3,
      type: 'journal',
      points: 40,
      startDate: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
      level: 1,
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
      startDate: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
      level: 2,
    ),
    Challenge(
      id: 'relax_l2',
      title: 'Inner Peace',
      description: 'Complete 3 relaxation exercises this week.',
      goal: 3,
      type: 'relaxation',
      points: 50,
      startDate: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
      level: 2,
    ),
    Challenge(
      id: 'journal_l2',
      title: 'Deep Thoughts',
      description: 'Write 4 journal entries this week.',
      goal: 4,
      type: 'journal',
      points: 0,
      startDate: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
      level: 2,
    ),
  ],
  3: [
    Challenge(
      id: 'mood_l3',
      title: 'Mood Mastery',
      description: 'Log your mood every day this week.',
      goal: 7,
      type: 'mood_log',
      points: 50,
      startDate: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
      level: 3,
    ),
    Challenge(
      id: 'relax_l3',
      title: 'Zen Master',
      description: 'Complete 4 relaxation exercises this week.',
      goal: 4,
      type: 'relaxation',
      points: 50,
      startDate: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
      level: 3,
    ),
    Challenge(
      id: 'journal_l3',
      title: 'Life Chronicler',
      description: 'Write 5 journal entries this week.',
      goal: 5,
      type: 'journal',
      points: 50,
      startDate: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)),
      level: 3,
    ),
  ],
};



final Map<int, int> levelPoints = {1: 100, 2: 250, 3: 400};
final Map<int, int> passMarks = {1: 90, 2: 225, 3: 360};