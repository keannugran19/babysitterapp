import 'package:babysitterapp/authentication/terms_condition.dart';
import 'package:babysitterapp/pages/homepage/home_page.dart';
import 'package:babysitterapp/components/button.dart';
import 'package:flutter/material.dart';
import '../../services/booking_service.dart';

class ConfirmationPage extends StatelessWidget {
  final String babysitterImage;
  final String babysitterName;
  final String babysitterEmail;
  final String parentName;
  final String specialRequirements;
  final String duration;
  final String paymentMode;
  final String totalpayment;
  final double babysitterRate;

  const ConfirmationPage({
    super.key,
    required this.babysitterImage,
    required this.babysitterName,
    required this.specialRequirements,
    required this.duration,
    required this.paymentMode,
    required this.totalpayment,
    required this.babysitterRate,
    required this.parentName,
    required this.babysitterEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              'Booking Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Table(
              border: TableBorder.all(
                color: Colors.black12,
                width: 1,
                borderRadius: BorderRadius.circular(8.0),
              ),
              children: [
                _buildTableRow('Babysitter Name:', babysitterName),
                _buildTableRow('Special Requirements:',
                    specialRequirements.isEmpty ? 'None' : specialRequirements),
                _buildTableRow('Duration:', _cleanDuration(duration)),
                _buildTableRow('Parent Name:', parentName),
                _buildTableRow('Payment Mode:', paymentMode),
                _buildTableRow('Babysitter Offer:',
                    'PHP ${babysitterRate.toStringAsFixed(2)}'),
                _buildTableRow('Total:', totalpayment),
              ],
            ),
            const SizedBox(height: 30),
            AppButton(
              text: 'Confirm',
              onPressed: () async {
                BuildContext currentContext = context;

                // Show Terms and Conditions dialog
                bool accepted = await showDialog(
                  context: currentContext,
                  builder: (BuildContext context) {
                    return const TermsConditionsDialog();
                  },
                );

                if (accepted) {
                  // Show booking confirmation dialog
                  showDialog(
                    context: currentContext,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Booking'),
                        content: const Text(
                            'Are you sure you want to confirm this booking?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();

                              // Call the saveBooking method to store the booking in Firestore
                              await BookingService().saveBooking(
                                babysitterName: babysitterName,
                                babysitterEmail: babysitterEmail,
                                specialRequirements: specialRequirements,
                                duration: duration,
                                parentName: parentName,
                                paymentMode: paymentMode,
                                totalpayment: totalpayment,
                                babysitterRate: babysitterRate,
                              );

                              // Show a success dialog to notify the user
                              showDialog(
                                context: currentContext,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Booking Confirmed'),
                                    content: const Text(
                                        'Your booking has been confirmed successfully!'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomePage()),
                                          );
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a table row with label and value
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _cleanDuration(String duration) {
    if (duration.endsWith('.0')) {
      return '${duration.substring(0, duration.indexOf('.'))} hour/s';
    }
    return '$duration Hours';
  }
}
