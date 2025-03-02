import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mindful_mate/providers/system_setup/theme_data_provider.dart';
import 'package:mindful_mate/screens/journal/journal_screen.dart';
import 'package:mindful_mate/screens/onboarding/onboarding_screen.dart';
import 'package:mindful_mate/utils/app_settings/images_strings.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';
import 'package:mindful_mate/utils/local_keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      const Duration(seconds: 3),
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
              JournalScreen.fullPath,
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
              splashImage, // Your Lottie file
              width: 200.ww(context),
              height: 200.hh(context),
              controller: _controller,
            ),
            Gap(24.hh(context)),
            // App name with subtle text animation
            AnimatedOpacity(
              duration: const Duration(milliseconds: 1000),
              opacity: 1.0,
              child: Text(
                AppLocalizations.of(context)!.mindfulMate,
                style: GoogleFonts.poppins(
                  color: injector.palette.pureWhite,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Gap(16.hh(context)),
            CircularProgressIndicator.adaptive(
              valueColor:
                  AlwaysStoppedAnimation<Color>(injector.palette.accentColor),
              strokeWidth: 2.ww(context),
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
