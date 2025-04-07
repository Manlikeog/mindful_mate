// lib/screens/reward_popup.dart
import 'package:flutter/material.dart';

class RewardPopup extends StatelessWidget {
  final String badge;

  const RewardPopup({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Congratulations!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 50, color: Colors.yellow),
          const SizedBox(height: 10),
          Text('You earned a new badge: $badge'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }

  static void show(BuildContext context, String badge) {
    showDialog(context: context, builder: (_) => RewardPopup(badge: badge));
  }
}