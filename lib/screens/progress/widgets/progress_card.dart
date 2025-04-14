import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/data/model/progress_card/progress_card.dart';
import 'package:mindful_mate/providers/progress_card_provider.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class ProgressCard extends ConsumerWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressData = ref.watch(progressCardDataProvider);
    final palette = injector.palette;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 4.pw(context), vertical: 0.ph(context)),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                palette.primaryColor.withOpacity(0.15),
                palette.secondaryColor.withOpacity(0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: palette.primaryColor.withOpacity(0.1),
                blurRadius: 3.pw(context),
                offset: Offset(0, 1.pw(context)),
              ),
            ],
          ),
          padding: EdgeInsets.all(4.pw(context)),
          child: progressData.level <= 3
              ? _buildProgressContent(context, progressData, palette)
              : _buildChampionContent(context, progressData, palette),
        ),
      ),
    );
  }

  Widget _buildProgressContent(
      BuildContext context, ProgressCardData progressData, Palette palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Level ${progressData.levelName}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: palette.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.ww(context),
                      letterSpacing: 0.5,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: EdgeInsets.all(2.pw(context)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [palette.primaryColor, palette.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.star,
                color: Colors.white,
                size: 20.ww(context),
              ),
            ),
          ],
        ),
        Gap(2.ph(context)),
        Stack(
          children: [
            Container(
              height: 2.pw(context),
              decoration: BoxDecoration(
                color: palette.dividerColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(1.pw(context)),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: 2.pw(context),
              width: progressData.progressPercentage *
                  (MediaQuery.of(context).size.width - 8.pw(context)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [palette.primaryColor, palette.accentColor]),
                borderRadius: BorderRadius.circular(1.pw(context)),
              ),
            ),
          ],
        ),
        Gap(2.ph(context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level ${progressData.levelName}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: palette.textColor.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.ww(context),
                  ),
            ),
            Text(
              '${progressData.userProgress.totalPoints}/${progressData.levelTotalPoints}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: palette.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.ww(context),
                  ),
            ),
          ],
        ),
        Gap(1.ph(context)),
        Row(
          children: [
            Expanded(
              child: Text(
                'Pass Mark: ${progressData.passMark}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: palette.textColor.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                      fontSize: 12.ww(context),
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Gap(2.pw(context)),
            Container(
              padding: EdgeInsets.all(2.pw(context)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.accentColor.withOpacity(0.2),
                border: Border.all(
                    color: palette.accentColor, width: 0.5.pw(context)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${progressData.userProgress.streakCount}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: palette.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.ww(context),
                        ),
                  ),
                  Gap(1.pw(context)),
                  Text(
                    '🔥',
                    style: TextStyle(fontSize: 18.ww(context)),
                  ),
                ],
              ),
            ),
          ],
        ),
        Gap(2.ph(context)),
        if (progressData.userProgress.badges.isNotEmpty)
          SizedBox(
            height: 10.pw(context),
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: progressData.userProgress.badges
                    .map((badge) => Padding(
                          padding: EdgeInsets.only(right: 2.pw(context)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.pw(context),
                                vertical: 1.ph(context)),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  palette.secondaryColor,
                                  palette.secondaryColor.withOpacity(0.8),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(4.pw(context)),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      palette.secondaryColor.withOpacity(0.3),
                                  blurRadius: 1.pw(context),
                                  offset: Offset(0, 0.5.pw(context)),
                                ),
                              ],
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                color: palette.pureWhite,
                                fontSize: 12.ww(context),
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          )
        else
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: palette.textColor.withOpacity(0.6),
                size: 18.ww(context),
              ),
              Gap(2.pw(context)),
              Expanded(
                child: Text(
                  'No badges yet—keep going! 🌟',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: palette.textColor.withOpacity(0.6),
                        fontSize: 12.ww(context),
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildChampionContent(
      BuildContext context, ProgressCardData progressData, Palette palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Gap(2.ph(context)),
        Icon(Icons.celebration,
            size: 50.ww(context), color: palette.accentColor),
        Gap(2.ph(context)),
        Text(
          'Legend Level ${progressData.level - 3} Achieved!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: palette.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.ww(context),
              ),
          textAlign: TextAlign.center,
        ),
        Gap(1.ph(context)),
        Text(
          'You’ve mastered all levels! Keep shining with daily mindfulness and watch your streak grow. 🌟',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: palette.textColor.withOpacity(0.9),
                fontSize: 16.ww(context),
              ),
          textAlign: TextAlign.center,
        ),
        Gap(2.ph(context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(2.pw(context)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.accentColor.withOpacity(0.2),
                border: Border.all(
                    color: palette.accentColor, width: 0.5.pw(context)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${progressData.userProgress.streakCount}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: palette.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.ww(context),
                        ),
                  ),
                  Gap(1.pw(context)),
                  Text(
                    '🔥',
                    style: TextStyle(fontSize: 18.ww(context)),
                  ),
                ],
              ),
            ),
            Gap(4.pw(context)),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 3.pw(context), vertical: 1.ph(context)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [palette.primaryColor, palette.secondaryColor],
                ),
                borderRadius: BorderRadius.circular(4.pw(context)),
              ),
              child: Text(
                'Total Points: ${progressData.userProgress.totalPoints}',
                style: TextStyle(
                  color: palette.pureWhite,
                  fontSize: 14.ww(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Gap(2.ph(context)),
        if (progressData.userProgress.badges.isNotEmpty)
          SizedBox(
            height: 10.pw(context),
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: progressData.userProgress.badges
                    .map((badge) => Padding(
                          padding: EdgeInsets.only(right: 2.pw(context)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.pw(context),
                                vertical: 1.ph(context)),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  palette.secondaryColor,
                                  palette.secondaryColor.withOpacity(0.8),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(4.pw(context)),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      palette.secondaryColor.withOpacity(0.3),
                                  blurRadius: 1.pw(context),
                                  offset: Offset(0, 0.5.pw(context)),
                                ),
                              ],
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                color: palette.pureWhite,
                                fontSize: 12.ww(context),
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                color: palette.textColor.withOpacity(0.6),
                size: 18.ww(context),
              ),
              Gap(2.pw(context)),
              Text(
                'No badges yet—keep going! 🌟',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: palette.textColor.withOpacity(0.6),
                      fontSize: 12.ww(context),
                    ),
              ),
            ],
          ),
      ],
    );
  }
}
