// firebase_service.dart 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to get the logged-in user's email
  Future<String?> getUserEmail() async {
    User? user = _auth.currentUser;
    return user?.email;
  }

  // Method to fetch transaction details by transaction ID and user's email
  Future<DocumentSnapshot> getTransactionDetails(String transactionId) async {
    String? userEmail = await getUserEmail();
    if (userEmail == null) {
      throw Exception("No user is logged in.");
    }

    try {
      // Query Firestore to get the transaction by userEmail and transactionId
      var snapshot = await _firestore
          .collection('bookings')
          .where('userEmail', isEqualTo: userEmail)
          .where('transactionId', isEqualTo: transactionId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first; // Return the first document that matches
      } else {
        throw Exception("Transaction not found.");
      }
    } catch (e) {
      // Handle errors such as missing composite index
      throw Exception("Error fetching transaction: $e");
    }
  }
}
