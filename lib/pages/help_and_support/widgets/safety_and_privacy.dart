import 'package:flutter/material.dart';

class SafetyAndPrivacy extends StatelessWidget {
  const SafetyAndPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety and Privacy',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          '• Safety Guidelines: Explain the app’s safety policies, including background checks and emergency protocols.\n• Privacy Policy: Detail how user information is protected and handled in compliance with relevant privacy laws.',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
