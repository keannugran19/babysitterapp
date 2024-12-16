import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to get bookings for the logged-in user
  Stream<QuerySnapshot> getUserBookings() {
    if (_auth.currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('bookings')
        .where('userEmail', isEqualTo: _auth.currentUser!.email)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Method to get bookings for the logged-in babysitter
  Stream<QuerySnapshot> getBabysitterBookings() {
    if (_auth.currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('bookings')
        .where('babysitterEmail', isEqualTo: _auth.currentUser!.email)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Method to save booking details in Firestore
  Future<void> saveBooking({
    required String babysitterName,
    required String babysitterEmail,
    required String specialRequirements,
    required String duration,
    required String parentName,
    required String paymentMode,
    required String totalpayment,
    required double babysitterRate,
    String? status,
  }) async {
    try {
      // Get the current user's email
      User? user = _auth.currentUser;
      if (user == null) {
        print("No user is logged in.");
        return;
      }
      String userEmail = user.email!;

      // Save booking details to Firestore, including the user's email
      await _firestore.collection('bookings').add({
        'bookingId': uuid.v4(),
        'babysitterName': babysitterName,
        'babysitterEmail': babysitterEmail,
        'specialRequirements': specialRequirements,
        'duration': duration,
        'parentName': parentName,
        'paymentMode': paymentMode,
        'totalpayment': totalpayment,
        'babysitterRate': babysitterRate,
        'status': 'pending',
        'createdAt': FieldValue
            .serverTimestamp(), // Timestamp of when the booking was created
        'userEmail': userEmail, // Store the user's email with the booking
      });

      print("Booking saved successfully.");
    } catch (e) {
      print("Failed to save booking: $e");
    }
  }

  // update current status
  Future<void> updatePaymentStatusByBookingId({
    required String bookingId,
    required String paymentStatus,
  }) async {
    try {
      // Query the document where bookingId matches
      QuerySnapshot querySnapshot = await _firestore
          .collection('bookings')
          .where('bookingId', isEqualTo: bookingId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (assuming bookingId is unique)
        DocumentReference bookingDoc = querySnapshot.docs.first.reference;

        // Update the paymentStatus field
        await bookingDoc.update({'status': paymentStatus});
        print('Payment status updated to: $paymentStatus');
      } else {
        print('No booking found with the given bookingId: $bookingId');
      }
    } catch (e) {
      print('Error updating payment status: $e');
      rethrow;
    }
  }
}
