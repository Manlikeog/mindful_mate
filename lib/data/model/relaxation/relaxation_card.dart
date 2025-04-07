// lib/data/relaxation_card_data.dart
import 'package:flutter/material.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';

class RelaxationCardData {
  final Relaxation exercise;
  final bool isSuggested;
  final bool isCompletedToday;
  final bool isExpanded;
  final VoidCallback toggleExpansion;
  final void Function(BuildContext) completeRelaxation;

  const RelaxationCardData({
    required this.exercise,
    required this.isSuggested,
    required this.isCompletedToday,
    required this.isExpanded,
    required this.toggleExpansion,
    required this.completeRelaxation,
  });
}