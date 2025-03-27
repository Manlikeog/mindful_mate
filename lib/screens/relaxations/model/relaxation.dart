import 'package:flutter/material.dart';

class RelaxationExercise {
  final String id;
  final String title;
  final String description;
  final Duration duration;
  final IconData icon; // New field

  const RelaxationExercise({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.icon,
  });
}