import 'package:hive/hive.dart';

part 'relaxation.g.dart';

/// Represents a relaxation exercise with details.
@HiveType(typeId: 4)
class Relaxation {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int level;

  @HiveField(3)
  final int duration;

  @HiveField(4)
  final String description;

  Relaxation({
    required this.id,
    required this.title,
    required this.level,
    required this.duration,
    required this.description,
  });

  /// Creates a copy with updated fields.
  Relaxation copyWith({
    String? id,
    String? title,
    int? level,
    int? duration,
    String? description,
  }) {
    return Relaxation(
      id: id ?? this.id,
      title: title ?? this.title,
      level: level ?? this.level,
      duration: duration ?? this.duration,
      description: description ?? this.description,
    );
  }
}

final Map<int, List<Relaxation>> levelRelaxations = {
  1: [
    Relaxation(
      id: 'breath_l1',
      title: 'Deep Breathing',
      level: 1,
      duration: 10,
      description:
          'Sit comfortably, close your eyes, and take slow, deep breaths. Inhale through your nose for 4 seconds, hold for 4 seconds, and exhale through your mouth for 6 seconds. Repeat to calm your mind.',
    ),
    Relaxation(
      id: 'stretch_l1',
      title: 'Gentle Stretching',
      level: 1,
      duration: 0,
      description:
          'Stand up and gently stretch your arms overhead, then side to side. Move slowly, focusing on your breath and the sensation in your muscles. Release tension with each stretch.',
    ),
    Relaxation(
      id: 'body_scan_l1',
      title: 'Body Scan',
      level: 1,
      duration: 10,
      description:
          'Lie down or sit still. Close your eyes and mentally scan your body from head to toe, noticing any tension or sensations. Breathe into each area to relax it.',
    ),
    Relaxation(
      id: 'calm_walk_l1',
      title: 'Calm Walking',
      level: 1,
      duration: 15,
      description:
          'Take a slow walk outdoors or in a quiet space. Focus on each step, the feel of the ground, and your breathing. Let your mind settle as you move.',
    ),
    Relaxation(
      id: 'five_senses_l1',
      title: 'Five Senses Exercise',
      level: 1,
      duration: 0,
      description:
          'Pause and notice 5 things you see, 4 you can touch, 3 you hear, 2 you smell, and 1 you taste. This grounds you in the present moment.',
    ),
  ],
  2: [
    Relaxation(
      id: 'meditate_l2',
      title: 'Guided Meditation',
      level: 2,
      duration: 10,
      description:
          'Sit quietly and follow a simple guided meditation in your mind. Imagine a peaceful place, focusing on the sights, sounds, and feelings to deepen relaxation.',
    ),
    Relaxation(
      id: 'yoga_l2',
      title: 'Yoga Flow',
      level: 2,
      duration: 15,
      description:
          'Perform a gentle yoga sequence: start with a downward dog, move to a plank, then a child’s pose. Flow smoothly, syncing breath with movement.',
    ),
    Relaxation(
      id: 'visualize_l2',
      title: 'Visualization',
      level: 2,
      duration: 8,
      description:
          'Close your eyes and picture a serene scene—like a beach or forest. Imagine every detail: the colors, sounds, and smells. Let it soothe your mind.',
    ),
    Relaxation(
      id: 'breath_count_l2',
      title: 'Counting Breaths',
      level: 2,
      duration: 5,
      description:
          'Sit still and count each breath up to 10, then start over. If your mind wanders, gently return to 1. This builds focus and calm.',
    ),
    Relaxation(
      id: 'tense_release_l2',
      title: 'Tense and Release',
      level: 2,
      duration: 10,
      description:
          'Sit or lie down. Tense each muscle group (e.g., fists, shoulders) for 5 seconds, then release slowly while breathing out. Work from feet to head.',
    ),
  ],
  3: [
    Relaxation(
      id: 'mindfulness_l3',
      title: 'Mindfulness Practice',
      level: 3,
      duration: 15,
      description:
          'Sit in a quiet space. Focus on your breath and observe your thoughts without judgment. Let them pass like clouds, staying present.',
    ),
    Relaxation(
      id: 'progressive_l3',
      title: 'Progressive Relaxation',
      level: 3,
      duration: 12,
      description:
          'Lie down and progressively relax each muscle group from toes to head. Tense briefly, then release, imagining tension melting away.',
    ),
    Relaxation(
      id: 'nature_sound_l3',
      title: 'Nature Sound Meditation',
      level: 3,
      duration: 10,
      description:
          'Sit or lie down, close your eyes, and imagine forest or ocean sounds. Let the natural rhythm guide your breathing and calm your mind.',
    ),
    Relaxation(
      id: 'gratitude_l3',
      title: 'Gratitude Reflection',
      level: 3,
      duration: 8,
      description:
          'Sit quietly and think of 3 things you’re grateful for. Reflect on why they matter, feeling the warmth of appreciation grow within you.',
    ),
    Relaxation(
      id: 'loving_kindness_l3',
      title: 'Loving-Kindness Meditation',
      level: 3,
      duration: 10,
      description:
          'Sit comfortably and silently repeat: "May I be happy, may I be healthy, may I be at peace." Extend this to others, spreading compassion.',
    ),
    Relaxation(
      id: 'sound_bath_l3',
      title: 'Sound Bath',
      level: 3,
      duration: 15,
      description:
          'Lie down and imagine soothing sounds (e.g., bells, chimes). Let the vibrations wash over you, releasing stress from your body and mind.',
    ),
  ],
};