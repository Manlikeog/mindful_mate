// lib/screens/relaxations/relaxation_card.dart
import 'package:flutter/material.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation_card.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';

class RelaxationCard extends StatelessWidget {
  final RelaxationCardData cardData;
  final Palette palette;

  const RelaxationCard({
    required this.cardData,
    required this.palette,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: cardData.isSuggested ? 8 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: cardData.isSuggested
                  ? [Colors.purple.shade200, Colors.blue.shade200]
                  : [Colors.white, Colors.grey.shade100],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: cardData.isSuggested
                ? [BoxShadow(color: Colors.purple.shade100, blurRadius: 10, spreadRadius: 2)]
                : null,
          ),
          child: Column(
            children: [
              _buildListTile(),
              _buildExpandedContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile() {
    return ListTile(
      leading: Icon(Icons.self_improvement, color: palette.primaryColor, size: 32),
      title: Text(
        cardData.exercise.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: palette.textColor,
        ),
      ),
      subtitle: Text(
        'Level ${cardData.exercise.level}',
        style: TextStyle(color: palette.textColor.withOpacity(0.7)),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (cardData.isCompletedToday)
            const AnimatedScale(
              scale: 1.0,
              duration: Duration(milliseconds: 300),
              child: Icon(Icons.check_circle, color: Colors.green),
            ),
          IconButton(
            icon: Icon(
              cardData.isExpanded ? Icons.expand_less : Icons.expand_more,
              color: palette.textColor,
            ),
            onPressed: cardData.toggleExpansion,
          ),
        ],
      ),
      onTap: cardData.toggleExpansion,
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: const SizedBox.shrink(),
      secondChild: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complete this to progress your relaxation challenge${cardData.isSuggested ? " and earn a 5-point booster" : ""}!',
              style: TextStyle(color: palette.textColor.withOpacity(0.8)),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: cardData.isCompletedToday ? null : () => cardData.completeRelaxation(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cardData.isSuggested ? Colors.purple.shade600 : palette.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(cardData.isCompletedToday ? 'Done Today' : 'Start'),
                    if (cardData.isSuggested && !cardData.isCompletedToday) ...[
                      const SizedBox(width: 8),
                      const AnimatedScale(
                        scale: 1.1,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeInOut,
                        child: Icon(Icons.star, size: 16),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      crossFadeState: cardData.isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }
}