// transaction info page

import 'package:babysitterapp/components/button.dart';
import 'package:babysitterapp/pages/rate/rateandreviewpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../styles/colors.dart';

class TransactionInfoPage extends StatelessWidget {
  final String transactionId;
  final String babysitterName;
  final DateTime bookingDate;

  const TransactionInfoPage({
    super.key,
    required this.transactionId,
    required this.babysitterName,
    required this.bookingDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('bookings')
                .doc(transactionId) // Use the Firestore document ID here
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('No transaction found.'));
              }

              var transactionData =
                  snapshot.data!.data() as Map<String, dynamic>;

              String specialRequirements =
                  transactionData['specialRequirements'] ?? 'N/A';
              String duration = transactionData['duration'] ?? 'N/A';
              String paymentMode = transactionData['paymentMode'] ?? 'N/A';
              String totalPayment = transactionData['totalpayment'] ?? 'N/A';
              double babysitterRate =
                  transactionData['babysitterOffer']?.toDouble() ?? 0.0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle,
                          color: accentColor, size: 60),
                      const SizedBox(height: 10),
                      Text(
                        'Transaction Successful',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                      ),
                      const SizedBox(height: 20),
                      _detailRow('Babysitter:', babysitterName, context),
                      const SizedBox(height: 10),
                      _detailRow(
                          'Booking Date:',
                          DateFormat('yyyy-MM-dd').format(bookingDate),
                          context),
                      const SizedBox(height: 10),
                      _detailRow('Special Requirements:', specialRequirements,
                          context),
                      const SizedBox(height: 10),
                      _detailRow('Duration:',
                          '${_cleanDuration(duration)} hours', context),
                      const SizedBox(height: 10),
                      _detailRow('Payment Mode:', paymentMode, context),
                      const SizedBox(height: 10),
                      _detailRow('Total Payment:', 'P$totalPayment', context),
                      // const SizedBox(height: 10),
                      // _detailRow('Babysitter Offer:', babysitterRate.toString(), context),
                      const SizedBox(height: 30),
                      Divider(color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text(
                        'Reference No: ${transactionId.substring(0, 8)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: "Close",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }

  // Helper method to create a row of transaction details
  Widget _detailRow(String label, String value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  String _cleanDuration(String duration) {
    // Format duration if needed
    return duration;
  }
}
