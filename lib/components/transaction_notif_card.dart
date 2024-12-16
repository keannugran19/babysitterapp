import 'package:babysitterapp/pages/location/babysitter_view_location.dart';
import 'package:babysitterapp/styles/route_animation.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/booking_service.dart';
import '../services/current_user_service.dart';

class TransactionNotificationCard extends StatefulWidget {
  final String bookingId;
  final String name;
  final String time;
  final String duration;
  final String parentName;
  final String totalPayment;
  String paymentStatus;
  final String paymentMode;

  TransactionNotificationCard({
    super.key,
    required this.name,
    required this.time,
    required this.paymentStatus,
    required this.duration,
    required this.totalPayment,
    required this.paymentMode,
    required this.parentName,
    required this.bookingId,
  });

  @override
  State<TransactionNotificationCard> createState() =>
      _TransactionNotificationCardState();
}

class _TransactionNotificationCardState
    extends State<TransactionNotificationCard> {
  // Call firestore services
  CurrentUserService firestoreService = CurrentUserService();
  final BookingService _bookingService = BookingService();
  // Get data from firestore using the model
  UserModel? currentUser;

  // Load user data
  Future<void> loadUserData() async {
    final user = await firestoreService.loadUserData();
    setState(() {
      currentUser = user;
    });
  }

  // Initiate load
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  _handleAccept() async {
    setState(() {
      widget.paymentStatus = 'accepted';
    });
    try {
      await _bookingService.updatePaymentStatusByBookingId(
        bookingId: widget.bookingId, // Replace with the actual bookingId
        paymentStatus: 'accepted',
      );
      print('Transaction accepted');
    } catch (e) {
      print('Error handling accept: $e');
    }
  }

  _handleDecline() async {
    setState(() {
      widget.paymentStatus = 'declined';
    });
    try {
      await _bookingService.updatePaymentStatusByBookingId(
        bookingId: widget.bookingId, // Replace with the actual bookingId
        paymentStatus: 'declined',
      );
      print('Transaction declined');
    } catch (e) {
      print('Error handling decline: $e');
    }
  }

  void _viewStatus() {
    Navigator.push(
      context,
      RouteAnimate(0, -1.0,
          page: BabysitterViewLocation(
            parentName: widget.parentName,
            duration: widget.duration,
            selectedBabysitterName: widget.name,
            totalPayment: widget.totalPayment,
          )),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'declined':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return currentUser != null && currentUser?.role.toLowerCase() != 'parent'
        ?
        // if user is babysitter, it will display this notification card
        Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'A parent booked a transaction:',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.parentName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(widget.paymentStatus)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.paymentStatus,
                              style: TextStyle(
                                color: _getStatusColor(widget.paymentStatus),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.duration} hour/s",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          "Paid: P${widget.totalPayment} via ${widget.paymentMode}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              widget.time,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // show view status if babysitter accepted the booking
                widget.paymentStatus != 'accepted'
                    ? Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, left: 8.0, right: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _handleDecline,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade100,
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Decline'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _handleAccept,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade100,
                                  foregroundColor: Colors.green,
                                ),
                                child: const Text('Accept'),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, left: 8.0, right: 8.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _viewStatus,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade100,
                                  foregroundColor: Colors.green,
                                ),
                                child: const Text('View Status'),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          )
        :
        // if user is parent, it will display this notif card
        Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'You booked a transaction with:',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(widget.paymentStatus)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.paymentStatus,
                              style: TextStyle(
                                color: _getStatusColor(widget.paymentStatus),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.duration} hour/s",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          "Paid: P${widget.totalPayment} via ${widget.paymentMode}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              widget.time,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // show view status if babysitter accepted the booking
                widget.paymentStatus != 'accepted'
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, left: 8.0, right: 8.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _viewStatus,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade100,
                                  foregroundColor: Colors.green,
                                ),
                                child: const Text('View Status'),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          );
  }
}
