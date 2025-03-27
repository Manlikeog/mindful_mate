import 'package:flutter/material.dart';


class Relaxation {
  final String id;
  final String title;
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