// lib/screens/progress/widgets/insights_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/insight/insight_card_provider.dart';
import 'package:mindful_mate/screens/relaxations/relaxation_screen.dart';

class InsightsCard extends ConsumerWidget {
  const InsightsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
 final data = ref.watch(insightsCardProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade50, Colors.blue.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.insights, color: Colors.purple.shade600),
                  const SizedBox(width: 12),
                  Text(
                   data.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
               data.insightText,
                style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
               data.dateRange,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (data.suggestedExercise != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Suggested Relaxation: ${data.suggestedExercise}',
                      style: TextStyle(fontSize: 16, color: Colors.purple.shade600),
                    ),
                    const SizedBox(width: 8),
                    if (data.isExerciseCompleted)
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RelaxationScreen(suggestedExerciseId: data.suggestedExercise),
                        ),
                      );
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade600,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Try This Relaxation'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}