import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/app_widget/custom_app_button.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';
import 'package:mindful_mate/utils/extension/widget_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  final ThemeMode themeMode;

  const BottomControls({super.key, 
    required this.currentPage,
    required this.totalPages,
    required this.onContinue,
    required this.onSkip,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    final palette = injector.palette;

    return Container(
      decoration: BoxDecoration(
        color: themeMode == ThemeMode.dark
            ? palette.darkModeSurface
            : palette.lightGray,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _ProgressDots(currentPage: currentPage, totalPages: totalPages),
          Gap(24.hh(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentPage != totalPages - 1)
                Flexible(
                  child: CustomAppButton(
                    label:   AppLocalizations.of(context)!.skip,
                    onPressed: onSkip,
                    variant: ButtonVariant.text, // Use text variant
                    foregroundColor: palette.primaryColor,
                  ),
                ),
              Expanded(
                // Give Continue button more space
                child: CustomAppButton(
                  label: currentPage == totalPages - 1
                      ?   AppLocalizations.of(context)!.getStarted
                      :   AppLocalizations.of(context)!.next,
                  onPressed: onContinue,
                  backgroundColor: palette.primaryColor,
                  foregroundColor: palette.pureWhite,
                ),
              ),
            ],
          )
        ],
      ).paddingSymmetric(h: 24.ww(context), v: 32.hh(context)),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _ProgressDots({required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    final palette = injector.palette;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.ww(context)),
          height: 8.hh(context),
          width: currentPage == index ? 24.ww(context) : 8.ww(context),
          decoration: BoxDecoration(
            color: currentPage == index
                ? palette.primaryColor
                : palette.inactiveDotLightMode,
            borderRadius: BorderRadius.circular(12.hh(context)),
          ),
        );
      }),
    );
  }
}
