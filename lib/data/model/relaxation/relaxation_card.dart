import 'package:flutter/material.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';

/// Represents data for a relaxation card UI component.
class RelaxationCardData {
  final Relaxation exercise;
  final bool isSuggested;
   bool isExpanded;
  final bool isCompletedToday;
  final VoidCallback toggleExpansion;
  final Function(BuildContext) completeRelaxation;

  RelaxationCardData({
    required this.exercise,
    required this.isSuggested,
    required this.isExpanded,
    required this.isCompletedToday,
    required this.toggleExpansion,
    required this.completeRelaxation,
  });
}