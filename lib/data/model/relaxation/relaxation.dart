import 'package:hive/hive.dart';

part 'relaxation.g.dart'; // Will be generated

@HiveType(typeId: 4)
class Relaxation {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int level;

  const Relaxation({
    required this.id,
    required this.title,
    required this.level,
  });
}

final Map<int, List<Relaxation>> levelRelaxations = {
  1: [
    Relaxation(id: 'breath_l1', title: 'Deep Breathing', level: 1),
    Relaxation(id: 'stretch_l1', title: 'Gentle Stretching', level: 1),
  ],
  2: [
    Relaxation(id: 'meditate_l2', title: 'Guided Meditation', level: 2),
    Relaxation(id: 'yoga_l2', title: 'Yoga Flow', level: 2),
  ],
  3: [
    Relaxation(id: 'mindfulness_l3', title: 'Mindfulness Practice', level: 3),
    Relaxation(id: 'progressive_l3', title: 'Progressive Relaxation', level: 3),
  ],
};