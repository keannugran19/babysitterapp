import 'package:babysitterapp/pages/help_and_support/widgets/faq_tile.dart';
import 'package:babysitterapp/styles/colors.dart';
import 'package:flutter/material.dart';

import 'widgets/contact_support.dart';
import 'widgets/safety_and_privacy.dart';
import 'widgets/feedback_and_suggestions.dart';
import '../../models/faq_model.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  const Text(
                    '(FAQs)',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ...faqData.map((faq) {
                    return FAQTile(
                      question: faq.question,
                      answer: faq.answer,
                    );
                  }),
                  const SizedBox(height: 16.0),
                  const ContactSupport(),
                  const SafetyAndPrivacy(),
                  const FeedbackAndSuggestions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
