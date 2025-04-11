import 'package:flutter/material.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';

class RelaxationCardData {
  final Relaxation exercise; // Assuming this is your Relaxation object
  final bool isSuggested;
  bool isExpanded;
  final bool isCompletedToday;
  final Function toggleExpansion;
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