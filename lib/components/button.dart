import 'package:babysitterapp/styles/size.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;

  const AppButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)));
    var textStyle = const TextStyle(fontWeight: FontWeight.w500);
    return SizedBox(
      width: sizeConfig.widthSize(context),
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
