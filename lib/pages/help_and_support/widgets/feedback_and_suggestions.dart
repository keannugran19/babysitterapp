import 'package:flutter/material.dart';

class FeedbackAndSuggestions extends StatelessWidget {
  const FeedbackAndSuggestions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How can I give feedback and suggestion?',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          'Steps where users can submit feedback or suggest improvements for the app.',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}