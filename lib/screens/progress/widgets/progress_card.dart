import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/providers/progress_provider.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';

class ProgressCard extends ConsumerWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressData = ref.watch(progressCardDataProvider);
    final palette = injector.palette;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: MediaQuery.of(context).size.width - 32,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                palette.primaryColor.withOpacity(0.15),
                palette.secondaryColor.withOpacity(0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: palette.primaryColor.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
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
                            letterSpacing: 0.5,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [palette.primaryColor, palette.secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Stack(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: palette.dividerColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    height: 10,
                    width: progressData.progressPercentage *
                        (MediaQuery.of(context).size.width - 80),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [palette.primaryColor, palette.accentColor],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level ${progressData.levelName}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: palette.textColor.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '${progressData.userProgress.totalPoints}/${progressData.levelTotalPoints}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: palette.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const Gap(12),
              Row(
                children: [
                  Text(
                    'Pass Mark: ${progressData.passMark}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: palette.textColor.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: palette.accentColor.withOpacity(0.2),
                      border: Border.all(color: palette.accentColor, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${progressData.userProgress.streakCount}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: palette.accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Gap(4),
                        const Text(
                          '🔥',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(20),
              if (progressData.userProgress.badges.isNotEmpty)
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: progressData.userProgress.badges
                          .map((badge) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        palette.secondaryColor,
                                        palette.secondaryColor.withOpacity(0.8)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: palette.secondaryColor
                                            .withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    badge,
                                    style: TextStyle(
                                      color: palette.pureWhite,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
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
                      size: 20,
                    ),
                    const Gap(8),
                    Text(
                      'No badges yet—keep going! 🌟',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: palette.textColor.withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
