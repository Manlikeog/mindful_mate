// lib/models/challenge.dart
class Challenge {
  final String id;
  final String title;
  final String description;
  final int goal; // e.g., 5 mood logs
  final String type; // 'mood_log', 'relaxation'
  final int rewardPoints;
  final DateTime startDate;
  final DateTime endDate;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.goal,
    required this.type,
    required this.rewardPoints,
    required this.startDate,
    required this.endDate,
  });

  bool isActive(DateTime now) => now.isAfter(startDate) && now.isBefore(endDate);
}