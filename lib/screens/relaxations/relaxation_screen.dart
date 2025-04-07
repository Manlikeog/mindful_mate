// lib/screens/relaxations/relaxation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation_card.dart';
import 'package:mindful_mate/providers/relaxation_provider.dart';
import 'package:mindful_mate/screens/relaxations/widgets/relaxation_card.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';

class RelaxationScreen extends ConsumerWidget {
  final String? suggestedExerciseId;

  const RelaxationScreen({this.suggestedExerciseId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = injector.palette;
    final data = ref.watch(relaxationScreenProvider(suggestedExerciseId));

    return Scaffold(
      appBar: _buildAppBar(data['currentLevel'] as int, palette),
      body: _buildBody(context, data, palette),
    );
  }

  AppBar _buildAppBar(int currentLevel, Palette palette) {
    return AppBar(
      title: Text(
        'Level $currentLevel Relaxation',
        style: TextStyle(color: palette.textColor),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildBody(BuildContext context, Map<String, dynamic> data, Palette palette) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE3F2FD), // Colors.blue.shade50
            Color(0xFFF3E5F5), // Colors.purple.shade50
          ],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          if (data['suggestedCard'] != null) ...[
            _buildSectionTitle(context, 'Suggested Relaxation (5-Point Booster)', palette.primaryColor),
            RelaxationCard(
              cardData: data['suggestedCard'] as RelaxationCardData,
              palette: palette,
            ),
            const SizedBox(height: 16),
          ],
          _buildSectionTitle(context, 'Explore More', palette.textColor),
          ...(data['otherCards'] as List<RelaxationCardData>).map(
            (cardData) => RelaxationCard(cardData: cardData, palette: palette),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}