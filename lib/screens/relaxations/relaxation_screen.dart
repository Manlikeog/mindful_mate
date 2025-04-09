// lib/screens/relaxations/relaxation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation_card.dart';
import 'package:mindful_mate/providers/relaxation_provider.dart';
import 'package:mindful_mate/screens/relaxations/widgets/relaxation_card.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class RelaxationScreen extends ConsumerWidget {
  final String? suggestedExerciseId;

  const RelaxationScreen({this.suggestedExerciseId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = injector.palette;
    final data = ref.watch(relaxationScreenProvider(suggestedExerciseId));
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _buildAppBar(data['currentLevel'] as int, palette, context),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5)],
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4.pw(context), vertical: 2.ph(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data['suggestedCard'] != null) ...[
                  _buildSectionTitle(context, 'Suggested Relaxation (5-Point Booster)', palette.primaryColor),
                  RelaxationCard(
                    cardData: data['suggestedCard'] as RelaxationCardData,
                    palette: palette,
                  ),
                  SizedBox(height: 2.ph(context)),
                ],
                _buildSectionTitle(context, 'Explore More', palette.textColor),
                ...(data['otherCards'] as List<RelaxationCardData>).map(
                  (cardData) => RelaxationCard(
                    cardData: cardData,
                    palette: palette,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(int currentLevel, Palette palette, BuildContext context) {
    return AppBar(
      title: Text(
        'Level $currentLevel Relaxation',
        style: TextStyle(color: palette.textColor, fontSize: 18.ww(context)),
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.ph(context)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.ww(context),
          color: color,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}