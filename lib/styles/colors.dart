import 'package:flutter/material.dart';

const textColor = Color(0xFF140f1a);
const backgroundColor = Color(0xFFfdfcfd);
const primaryColor = Color(0xFF7e51b8);
const primaryFgColor = Color(0xFFfdfcfd);
const secondaryColor = Color(0xFFb395da);
const secondaryFgColor = Color(0xFF140f1a);
const tertiaryColor = Color.fromARGB(255, 235, 225, 248);
const tertiaryFgColor = Color(0xFF140f1a);
const accentColor = Color(0xFF9d72d5);
const accentFgColor = Color(0xFF140f1a);
const dangerColor = Colors.red;

const colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryColor,
  onPrimary: primaryFgColor,
  secondary: secondaryColor,
  onSecondary: secondaryFgColor,
  tertiary: accentColor,
  onTertiary: accentFgColor,
  surface: backgroundColor,
  onSurface: textColor,
  error: Brightness.light == Brightness.light
      ? Color(0xffB3261E)
      : Color(0xffF2B8B5),
  onError: Brightness.light == Brightness.light
      ? Color(0xffFFFFFF)
      : Color(0xff601410),
);
