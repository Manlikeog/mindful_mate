import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart'; // Added for animations
import 'package:mindful_mate/screens/home/home_screen.dart';
import 'package:mindful_mate/screens/onboarding/widgets/onboarding_bottom_controls.dart';
import 'package:mindful_mate/screens/onboarding/widgets/onboarding_page.dart';
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


    final onboardingList = [
      OnboardingPage(
        title: "Track Your Mood Effortlessly",
        description:  "Log daily emotions with simple emoji selections",
        animation: Lottie.asset(
          onBoardingImageFirstPage,
          width: 300.ww(context),
          height: 300.hh(context),
        ),
      ),
      OnboardingPage(
        title:  "Reflect with Guided Journaling",
        description: "Daily prompts to help you process thoughts",
        animation: Lottie.asset(
          onBoardingImageSecondPage,
          width: 300.ww(context),
          height: 300.hh(context),
        ),
      ),
      OnboardingPage(
        title: "Grow Your Self-Care Garden",
        description: "Earn badges by completing healthy habits",
        animation: Lottie.asset(
          onBoardingImageThirdPage,
          width: 300.ww(context),
          height: 300.hh(context),
        ),
      ),
    ];

    return Scaffold(
      
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
    context.go(HomeScreen.fullPath);
  }
}
