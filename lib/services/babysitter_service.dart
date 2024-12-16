import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class BabysitterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // load all babysitters in a list
  Future<List<UserModel>> getBabysitters() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'babysitter')
          .get();

      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching babysitters: $e');
      return [];
    }
  }

  // load babysitter data using it's specific email
  Future<UserModel?> getBabysitterByEmail(String email) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return UserModel.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching babysitter by email: $e');
      return null;
    }
  }

  // load babysitters feedbacks
  Future<List<Map<String, dynamic>>> fetchFeedbacksByBabysitterName(
      String babysitterName) async {
    try {
      final querySnapshot = await _firestore
          .collection('feedbacks')
          .where('babysitterName', isEqualTo: babysitterName)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to fetch feedbacks: $e');
    }
  }
}
