import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Reference to the users collection
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // Fetch all babysitters
  Future<List<Map<String, dynamic>>> fetchBabysitters() async {
    try {
      final querySnapshot =
          await users.where('userType', isEqualTo: 'babysitter').get();

      // Convert query results into a list of maps
      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print('Error fetching babysitters: $e');
      return [];
    }
  }

  // Fetch babysitter details by Name
  Future<Map<String, dynamic>> fetchBabysitterByName(String name) async {
    try {
      final querySnapshot = await users.where('name', isEqualTo: name).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming only one babysitter will match the name
        final doc = querySnapshot.docs.first;
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      } else {
        throw Exception('Babysitter not found with name: $name');
      }
    } catch (e) {
      print('Error fetching babysitter by name: $e');
      rethrow;
    }
  }
}
