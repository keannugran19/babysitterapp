import 'package:flutter/material.dart';

class Responsive {
  //method to get responsive font sizes based on screen width
  static double getNameFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 400 ? 20 : 24;
  }

  static double getTextFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 400 ? 12 : 14;
  }

  //method to get responsive CircleAvatar radius based on screen width
  static double getAvatarRadius(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 400 ? 40 : 50;
  }

  //method to get responsive border radius for text fields and containers
  static double getBorderRadius(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 400 ? 8 : 12;
  }

  //method to get responsive border width
  static double getBorderWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 400 ? 1 : 2;
  }

  //method to get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 400
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  }
}