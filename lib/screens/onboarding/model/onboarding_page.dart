import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/constants.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';
import 'package:mindful_mate/utils/extension/widget_extension.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final Widget animation;
  final String description;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.animation,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final palette = injector.palette;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: animation),
        Gap(40.hh(context)),
        Text(
          title,
          style: kTextStyleFont600(context: context, size: 28.ww(context)),
          textAlign: TextAlign.center,
        ),
        Gap(16.hh(context)),
        Text(
          description,
          style: kTextStyleCustom(
              context: context,
              fontSize: 16.ww(context),
              color: palette.inactiveTextfieldIconColor),
          textAlign: TextAlign.center,
        ),
      ],
    ).paddingAll(24.ww(context));
  }
}
