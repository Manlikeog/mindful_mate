import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindful_mate/providers/system_setup/theme_data_provider.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class CustomAppButton extends HookConsumerWidget {
  const CustomAppButton({
    super.key,
    this.variant = ButtonVariant.filled,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.width,
    this.height,
    this.icon,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  });

  final ButtonVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final double? width;
  final double? height;
  final Widget? icon;
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(getTheThemeData);
    final palette = injector.palette;
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 200));

    final colors = _getButtonColors(themeMode, palette);
    final borderRadiusValue = borderRadius ?? 12.0;

    return MouseRegion(
      onEnter: (_) => animationController.forward(),
      onExit: (_) => animationController.reverse(),
      child: GestureDetector(
        onTap: enabled && !isLoading ? onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width:
              width ?? (variant == ButtonVariant.text ? null : double.infinity),
          height: height ?? 56.hh(context),
          decoration: BoxDecoration(
            color: enabled
                ? colors.backgroundColor
                : colors.backgroundColor?.withOpacity(0.5),
            borderRadius: BorderRadius.circular(borderRadiusValue),
            border: variant == ButtonVariant.outlined
                ? Border.all(
                    color: colors.borderColor ??
                        colors.backgroundColor ??
                        palette.primaryColor)
                : null,
          ),
          child: ScaleTransition(
            scale: Tween(begin: 1.0, end: 0.95).animate(animationController),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isLoading
                    ? _LoadingIndicator(color: colors.foregroundColor)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icon != null) ...[
                            icon!,
                            const SizedBox(width: 12),
                          ],
                          Text(
                            label,
                            style: GoogleFonts.inter(
                              color: colors.foregroundColor,
                              fontSize: 16.ww(context),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _ButtonColors _getButtonColors(ThemeMode themeMode, Palette palette) {
    final isDark = themeMode == ThemeMode.dark;

    return switch (variant) {
      ButtonVariant.filled => _ButtonColors(
          backgroundColor: backgroundColor ?? palette.primaryColor,
          foregroundColor: foregroundColor ?? palette.pureWhite,
        ),
      ButtonVariant.outlined => _ButtonColors(
          backgroundColor: Colors.transparent,
          foregroundColor: foregroundColor ??
              (isDark ? palette.pureWhite : palette.primaryColor),
          borderColor: foregroundColor ??
              (isDark ? palette.pureWhite : palette.primaryColor),
        ),
      ButtonVariant.text => _ButtonColors(
          backgroundColor: Colors.transparent,
          foregroundColor: foregroundColor ??
              (isDark ? palette.pureWhite : palette.primaryColor),
        ),
    };
  }
}

class _LoadingIndicator extends StatelessWidget {
  final Color? color;

  const _LoadingIndicator({this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
      ),
    );
  }
}

class _ButtonColors {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  _ButtonColors({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });
}

enum ButtonVariant {
  filled,
  outlined,
  text,
}
