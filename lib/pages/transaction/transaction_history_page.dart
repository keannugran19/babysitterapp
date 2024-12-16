// transaction history page

import 'package:babysitterapp/services/booking_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transactioninfopage.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // call bookings service
    final BookingService bookingService = BookingService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bookingService.getUserBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final booking =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final String status = booking['status'];
              final String babysitterName = booking['babysitterName'];
              final String transactionId =
                  snapshot.data!.docs[index].id; // Get the document ID
              final DateTime createdAt =
                  (booking['createdAt'] as Timestamp).toDate();

              return GestureDetector(
                onTap: () => _navigateToBabysitterDetails(
                    context, transactionId, babysitterName, createdAt),
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: ListTile(
                    leading: statusIcon(status),
                    title: Text(
                      'Babysitter: $babysitterName',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Date: ${DateFormat('yyyy-MM-dd').format(createdAt)}\nStatus: $status',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToBabysitterDetails(BuildContext context, String transactionId,
      String babysitterName, DateTime createdAt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionInfoPage(
          transactionId: transactionId,
          babysitterName: babysitterName,
          bookingDate: createdAt,
        ),
      ),
    );
  }

  Widget statusIcon(String status) {
    if (status == 'confirmed') {
      return const Icon(Icons.check_circle, color: Colors.purple);
    } else if (status == 'cancelled') {
      return const Icon(Icons.cancel, color: Colors.grey);
    } else {
      return const Icon(Icons.help_outline, color: Colors.grey);
    }
  }
}
