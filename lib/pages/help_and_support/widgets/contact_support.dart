import 'package:babysitterapp/styles/colors.dart';
import 'package:flutter/material.dart';

class ContactSupport extends StatelessWidget {
  const ContactSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Support',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          '• Phone: Customer support number',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 8.0),
        Text(
          "+123456789",
          style: TextStyle(fontSize: 16.0, color: primaryColor),
        ),
        SizedBox(height: 8.0),
        Text(
          '• Email: Support email for inquiries',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 8.0),
        Text(
          'babysitterapp@gmail.com',
          style: TextStyle(fontSize: 16.0, color: primaryColor),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
