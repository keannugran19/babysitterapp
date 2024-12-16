import 'package:babysitterapp/styles/colors.dart';
import 'package:flutter/material.dart';

class TermsAndConditionPage extends StatefulWidget {
  const TermsAndConditionPage({super.key});

  @override
  State<TermsAndConditionPage> createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  bool isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  'TERMS AND CONDITIONS',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome to the Babysitter Booking App. Please read the following terms and conditions carefully before using our services.',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildTermsItem('Agreement to Terms',
                  'By using the Babysitter Booking App, you agree to be bound by these terms and conditions.'),
              _buildTermsItem('Booking Responsibilities',
                  'As a user of this app, you are responsible for providing accurate information when booking a babysitter.'),
              _buildTermsItem('Payments',
                  'All payments for babysitting services must be made through the app.'),
              _buildTermsItem('Cancellations',
                  'You may cancel a booking up to 24 hours before the scheduled appointment.'),
              _buildTermsItem('Babysitter Responsibilities',
                  'Babysitters registered on our platform are independent contractors.'),
              _buildTermsItem('Liability',
                  'We are not liable for any damages, injuries, or losses arising from the use of this app.'), // Adjusted height
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
