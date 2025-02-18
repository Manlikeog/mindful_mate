import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mindful_mate/providers/system_setup/theme_data_provider.dart';
import 'package:mindful_mate/screens/onboarding/onboarding_screen.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/local_keys.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.repeat(reverse: true);

    initialAction();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Timer> initialAction() async {
    // ref.read(apiKey.notifier).getApiKey();
    return Timer(
      const Duration(seconds: 5),
      () async {
        bool isItAFirstTimeLaunch = await injector.quickStorage.returnBool(
          key: ObjectKeys.firstTimeLaunch,
        );

        String getLastRoute = await injector.quickStorage.returnString(
          key: ObjectKeys.path,
        );

        if (kDebugMode) {
          print(getLastRoute);
        }

        if (mounted) {
          if (isItAFirstTimeLaunch == false) {
            context.go(
              OnboardingScreen.fullPath,
            );
          } else {
            if (kDebugMode) {
              print('its here');
            }
            context.go(
              getLastRoute,
            );
          }
        }

        if (kDebugMode) {
          print('Done');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ref.watch(getTheThemeData);
    return Scaffold(
      backgroundColor: injector.palette.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated plant growth (Lottie animation)
            Lottie.asset(
              'assets/animation/plant_growth.json', // Your Lottie file
              width: 200,
              height: 200,
              controller: _controller,
            ),

            const SizedBox(height: 24),

            // App name with subtle text animation
            AnimatedOpacity(
              duration: const Duration(milliseconds: 1000),
              opacity: 1.0,
              child: Text(
                'MindfulMate',
                style: GoogleFonts.poppins(
                  color: injector.palette.pureWhite,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            CircularProgressIndicator.adaptive(
              valueColor:
                  AlwaysStoppedAnimation<Color>(injector.palette.accentColor),
              strokeWidth: 2,
              backgroundColor: (themeMode == ThemeMode.dark)
                  ? injector.palette.pureWhite
                  : injector.palette.accentColor,
            ),
          ],
        ),
      ),
    );
  }
}
