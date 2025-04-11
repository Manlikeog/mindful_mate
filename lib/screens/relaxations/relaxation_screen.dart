// lib/screens/relaxations/relaxation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation_card.dart';
import 'package:mindful_mate/providers/insight/insight_card_provider.dart';
import 'package:mindful_mate/providers/relaxation_provider.dart';
import 'package:mindful_mate/screens/relaxations/widgets/relaxation_card.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class RelaxationScreen extends ConsumerWidget {
      static const String path = 'relaxation';
  static const String pathName = 'relaxation';
  static const String fullPath = '/relaxation';

  final String? suggestedExerciseId;

  const RelaxationScreen({this.suggestedExerciseId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = injector.palette;
     final insight = ref.watch(insightsCardProvider);
    final data = ref.watch(relaxationScreenProvider(insight.suggestedExercise));
    
    final screenWidth = MediaQuery.of(context).size.width;
    final currentLevel = data['currentLevel'] as int;

    return Scaffold(
      appBar: _buildAppBar(currentLevel, palette, context),
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
                if (currentLevel <= 3) ...[
                  if (data['suggestedCard'] != null) ...[
                    _buildSectionTitle(context, 'Suggested Relaxation (5-Point Booster)', palette.primaryColor),
                    RelaxationCard(
                      cardData: data['suggestedCard'] as RelaxationCardData,
                      palette: palette,
                    ),
                    SizedBox(height: 2.ph(context)),
                  ],
                  _buildSectionTitle(context, 'Explore More', palette.textColor),
                  if ((data['otherCards'] as List<RelaxationCardData>).isNotEmpty)
                    ...(data['otherCards'] as List<RelaxationCardData>).map(
                      (cardData) => RelaxationCard(
                        cardData: cardData,
                        palette: palette,
                      ),
                    )
                  else
                    _buildNoRelaxationsMessage(context, palette),
                ] else ...[
                  _buildChampionMessage(context, palette, currentLevel),
                ],
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
        currentLevel <= 3 ? 'Level $currentLevel Relaxation' : 'Mindfulness Mastery',
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

  Widget _buildNoRelaxationsMessage(BuildContext context, Palette palette) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.ph(context)),
      child: Column(
        children: [
          Icon(Icons.self_improvement, size: 40.ww(context), color: palette.textColor.withOpacity(0.6)),
          SizedBox(height: 2.ph(context)),
          Text(
            'All Level Relaxations Completed!',
            style: TextStyle(
              fontSize: 16.ww(context),
              fontWeight: FontWeight.bold,
              color: palette.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.ph(context)),
          Text(
            'You’ve mastered this level’s exercises. Try repeating your favorites to maintain your calm! 🌿',
            style: TextStyle(
              fontSize: 14.ww(context),
              color: palette.textColor.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChampionMessage(BuildContext context, Palette palette, int level) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.ph(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.celebration, size: 50.ww(context), color: palette.accentColor),
          SizedBox(height: 2.ph(context)),
          Text(
            'Congratulations, Legend Level $level!',
            style: TextStyle(
              fontSize: 20.ww(context),
              fontWeight: FontWeight.bold,
              color: palette.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.ph(context)),
          Text(
            'You’ve conquered all levels! Keep your mindfulness journey alive with daily practice or create your own relaxation rituals. 🌟',
            style: TextStyle(
              fontSize: 16.ww(context),
              color: palette.textColor.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.ph(context)),
          ElevatedButton(
            onPressed: () {
              // Optionally navigate to a custom relaxation creator or reset levels
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: palette.primaryColor,
              foregroundColor: palette.pureWhite,
              padding: EdgeInsets.symmetric(horizontal: 4.pw(context), vertical: 2.ph(context)),
            ),
            child: Text(
              'Explore Custom Relaxation',
              style: TextStyle(fontSize: 14.ww(context)),
            ),
          ),
        ],
      ),
    );
  }
}