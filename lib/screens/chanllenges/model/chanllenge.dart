class Challenge {
  final String id;
  final String title;
  final String description;
  final int goal;
  final String type; // mood_log, relaxation, journal
  final int rewardPoints;
  final DateTime startDate;
  final DateTime endDate;

  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.goal,
    required this.type,
    required this.rewardPoints,
    required this.startDate,
    required this.endDate,
  });

  bool isActive(DateTime now) {
    return now.isAfter(startDate) && now.isBefore(endDate.add(const Duration(days: 1)));
  }
}