// lib/models/relaxation.dart
class RelaxationExercise {
  final String id;
  final String title;
  final String description;
  final Duration duration;
  final String? audioUrl; // Optional for future audio integration

  RelaxationExercise({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    this.audioUrl,
  });
}