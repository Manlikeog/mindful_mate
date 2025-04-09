import 'package:flutter/material.dart';

extension AutoResize on num {
  double hh(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final scaledHeight = (this / 932) * screenHeight;
    // Clamp to prevent extreme scaling
    return scaledHeight.clamp(10.0, screenHeight * 0.9);
  }

  double ww(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaledWidth = (this / 430) * screenWidth;
    // Clamp to prevent extreme scaling
    return scaledWidth.clamp(10.0, screenWidth * 0.9);
  }

  // Percentage-based sizing for flexibility
  double ph(BuildContext context) => this * MediaQuery.of(context).size.height / 100;
  double pw(BuildContext context) => this * MediaQuery.of(context).size.width / 100;
}