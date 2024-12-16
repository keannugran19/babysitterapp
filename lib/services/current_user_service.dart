import 'package:babysitterapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CurrentUserService {
  // Initialize Firebase services
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // Register a new user with email and password
  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
    required String role,
    required String phone,
  }) async {
    try {
      // Create user in Firebase Auth
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final String uid = userCredential.user!.uid;

      // Create UserModel instance
      final UserModel newUser = UserModel(
        role: role,
        email: email,
        name: name,
        phone: phone,
      );

      // Save to Firestore
      await users.doc(uid).set(newUser.toMap());
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase
        final UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);

        final User? firebaseUser = userCredential.user;
        if (firebaseUser != null) {
          // Save user data to Firestore if it doesn't exist
          final doc = await users.doc(firebaseUser.uid).get();
          if (!doc.exists) {
            await users.doc(firebaseUser.uid).set({
              'uid': firebaseUser.uid,
              'name': firebaseUser.displayName ?? 'Guest',
              'email': firebaseUser.email ?? '',
              'photoURL': firebaseUser.photoURL,
              'role': 'parent',
              'phone': '',
            });
          }
        }
      }
    } catch (e) {
      throw Exception('Google sign-in failed: ${e.toString()}');
    }
  }

  // Load current user's data
  Future<UserModel?> loadUserData() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return null;

      final doc = await users.doc(user.uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
    return null;
  }

  // Save updated user data
  Future<void> saveUserData(UserModel userModel) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return;

      // Use set with merge: true to avoid overwriting other fields
      await users.doc(user.uid).set(userModel.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  // Sign out the user
  Future<void> signOutUser() async {
    try {
      await firebaseAuth.signOut();
      print("User signed out successfully.");
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  // add feedback to selected babysitter
  Future<void> addFeedback(
      {required String currentUserName,
      required String babysitterName,
      required String feedbackMessage,
      required int rating,
      required List<String> imageURL_}) async {
    try {
      await firestore.collection('feedbacks').add({
        'currentUserName': currentUserName,
        'babysitterName': babysitterName,
        'feedbackMessage': feedbackMessage,
        'rating': rating,
        'images': imageURL_,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add feedback: $e');
    }
  }
}
