import 'package:babysitterapp/components/transaction_notif_card.dart';
import 'package:babysitterapp/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../models/user_model.dart';
import '../../services/current_user_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // call firestore services
  CurrentUserService firestoreService = CurrentUserService();
  final BookingService bookingService = BookingService();
  // get data from firestore using the model
  UserModel? currentUser;

  // load user data
  Future<void> loadUserData() async {
    final user = await firestoreService.loadUserData();
    setState(() {
      currentUser = user;
    });
  }

  // initiate load
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            currentUser != null && currentUser?.role.toLowerCase() != 'parent'
                ? bookingService.getBabysitterBookings()
                : bookingService.getUserBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notifications found.'));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index].data() as Map<String, dynamic>;

              return TransactionNotificationCard(
                bookingId: booking['bookingId'] ?? 'Booking ID Invalid',
                name: booking['babysitterName'] ?? 'Unknown User',
                time: booking['createdAt'] != null
                    ? timeago
                        .format((booking['createdAt'] as Timestamp).toDate())
                    : 'Unknown Time',
                duration: booking['duration'] ?? 'Not specified',
                parentName: booking['parentName'] ?? 'Unknown',
                totalPayment: booking['totalpayment'] ?? 'No amount',
                paymentStatus: booking['status'] ?? 'pending',
                paymentMode: booking['paymentMode'] ?? 'Unknown',
              );
            },
          );
        },
      ),
    );
  }
}
