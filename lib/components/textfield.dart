import 'package:babysitterapp/styles/size.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  // store user input
  final TextEditingController controller;
  final String hintText;
  final Widget? suffix;
  const AppTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.suffix});

  @override
  Widget build(BuildContext context) {
    var decoration = InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
        hintText: hintText,
        suffixIcon: suffix);

    return SizedBox(
      width: sizeConfig.widthSize(context),
      child: TextField(
        controller: controller,
        decoration: decoration,
      ),
    );
  }
}
