import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart'; // Added for animations
import 'package:mindful_mate/providers/system_setup/theme_data_provider.dart';
import 'package:mindful_mate/screens/home/home_screen.dart';
import 'package:mindful_mate/screens/mood/mood_screen.dart';
import 'package:mindful_mate/screens/onboarding/model/onboarding_bottom_controls.dart';
import 'package:mindful_mate/screens/onboarding/model/onboarding_page.dart';
import 'package:mindful_mate/utils/app_settings/images_strings.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';
import 'package:mindful_mate/utils/local_keys.dart';

class OnboardingScreen extends StatefulHookConsumerWidget {
  const OnboardingScreen({super.key});
  static const String path = 'onboarding';
  static const String fullPath = '/onboarding';
  static const String pathName = '/onboarding';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late PageController pageController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = useState<int>(0);
    final palette = injector.palette;
    final themeMode = ref.watch(getTheThemeData);

    final onboardingList = [
      OnboardingPage(
        title: AppLocalizations.of(context)!.onboardingOneTitle,
        description: AppLocalizations.of(context)!.onboardingOneSubTitle,
        animation: Lottie.asset(
          onBoardingImageFirstPage,
          width: 300.ww(context),
          height: 300.hh(context),
        ),
      ),
      OnboardingPage(
        title: AppLocalizations.of(context)!.onboardingTwoTitle,
        description: AppLocalizations.of(context)!.onboardingTwoSubTitle,
        animation: Lottie.asset(
          onBoardingImageSecondPage,
          width: 300.ww(context),
          height: 300.hh(context),
        ),
      ),
      OnboardingPage(
        title: AppLocalizations.of(context)!.onboardingThreeTitle,
        description: AppLocalizations.of(context)!.onboardingThreeSubTitle,
        animation: Lottie.asset(
          onBoardingImageThirdPage,
          width: 300.ww(context),
          height: 300.hh(context),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: themeMode == ThemeMode.dark
          ? palette.darkModeBackground
          : palette.pureWhite,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: onboardingList.length,
              onPageChanged: (value) => currentPage.value = value,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animationController.value,
                      child: Transform.translate(
                        offset:
                            Offset(0, 20 * (1 - _animationController.value)),
                        child: onboardingList[index],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          BottomControls(
            currentPage: currentPage.value,
            totalPages: onboardingList.length,
            onContinue: () => _handleContinue(currentPage),
            onSkip: () => _handleSkip(),
            themeMode: themeMode,
          ),
        ],
      ),
    );
  }

  void _handleContinue(ValueNotifier<int> currentPage) {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      currentPage.value++;
    } else {
      _completeOnboarding();
    }
  }

  void _handleSkip() => _completeOnboarding();

  void _completeOnboarding() {
    print("ok");
    injector.quickStorage
        .storeBool(key: ObjectKeys.firstTimeLaunch, data: true);
    context.go(MoodTrackerScreen.fullPath);
    injector.quickStorage.storeString(
      key: ObjectKeys.path,
      data: MoodTrackerScreen.fullPath,
    );
  }
}
