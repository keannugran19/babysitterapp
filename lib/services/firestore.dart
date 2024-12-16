import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/messages.dart';
import '../controller/user.dart';

class FirestoreService {
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');

  //fetch user data based on id
  Future<User?> getUserData(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await users.doc(id).get();

      if (snapshot.exists) {
        final data = snapshot.data();
        return User(
          id: data?['id'] ?? '',
          name: data?['name'] ?? 'User not exist',
          email: data?['email'] ?? '',
          img: (data?['img'] == null || data?['img'] == '')
              ? 'assets/images/default_user.png'
              : data?['img'],
          address: data?['address'] ?? '',
          phone: data?['phone'] ?? '',
          birtdate: (data?['birthdate'] ?? Timestamp.fromDate(DateTime.now()))
              .toDate(),
          gender: data?['gender'] ?? '',
          rate: data?['rate'] ?? 0,
          description: data?['description'] ?? '',
          experience: List<String>.from(data?['experience'] ?? []),
          userType: data?['userType'] ?? '',
          information: data?['information'] ?? '',
          childAge: data?['childAge'] ?? 0,
        );
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      throw Exception(
          "User not found"); // Re-throw if max retries reached or if it's not a retryable error
    }
  }

  // Fetch chat list of the current user
  Future<List> getChatListID(String currentUserID) async {
    List<String> chatListID = [];

    QuerySnapshot querySnapshot = await users
        .doc(currentUserID)
        .collection('messages')
        .get(); // This retrieves all documents in the messages collection

    for (var doc in querySnapshot.docs) {
      chatListID.add(doc.id); // Add document ID to the list
    }

    return chatListID;
  }

  //fetch messages of the selected chat
  Future<List<Messages>> getMessages(
      String currentUserID, String recipientID) async {
    List<Messages> messagesList = [];

    // Reference to the babysitter's messages document
    DocumentSnapshot<Map<String, dynamic>> doc = await users
        .doc(currentUserID)
        .collection('messages')
        .doc(recipientID) // Adjust if using a different ID for the document
        .get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() ?? {};

      data.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          messagesList.add(Messages.fromMap(value));
        }
      });

      // Sort messages by timestamp in ascending order
      messagesList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }

    return messagesList;
  }

  //add new message to firestore
  Future<void> addMessageToFirestore(
      String currentUserID, String recipientID, Messages message) async {
    try {
      // Reference to the messages document of the current user
      DocumentReference<Map<String, dynamic>> messageDoc =
          users.doc(currentUserID).collection('messages').doc(recipientID);

      // Convert the message to a map
      Map<String, dynamic> messageData = {
        'id': message.id,
        'msg': message.msg,
        'timestamp': message.timestamp,
        'isClicked': message.isClicked,
      };

      // Save the message to Firestore with a unique ID (e.g., by using the timestamp as a key)
      await messageDoc.set(
        {DateTime.now().toString(): messageData},
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      print("Error adding message: $e");
    }
  }

  //add new feedback to firestore
  // Future<void> addFeedback(
  //     String currentUserID, String recipientID, FeedBack feedback) async {
  //   try {
  //     // Reference to the messages document of the current user
  //     DocumentReference<Map<String, dynamic>> feedbackDoc =
  //         users.doc(recipientID).collection('feedbacks').doc(currentUserID);

  //     // Convert the message to a map
  //     Map<String, dynamic> feedbackData = {
  //       'rating': feedback.rating,
  //       'msg': feedback.feedbackMsg,
  //       'images': feedback.images,
  //       'timestamp': feedback.timestamp,
  //     };

  //     // Save the message to Firestore with a unique ID (e.g., by using the timestamp as a key)
  //     await feedbackDoc.set(
  //       feedbackData,
  //       SetOptions(merge: false),
  //     );
  //   } on FirebaseException catch (e) {
  //     print("Error adding message: $e");
  //   }
  // }

  //fetch feedback list for babysitter
  // Future<List<FeedBack>> getFeedbackList(String babysitterId) async {
  //   List<FeedBack> feedbackList = [];

  //   QuerySnapshot querySnapshot =
  //       await users.doc(babysitterId).collection('feedbacks').get();

  //   for (var doc in querySnapshot.docs) {
  //     // Convert each document data into a FeedBack instance
  //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //     FeedBack feedback = FeedBack.fromMap(
  //         data..['id'] = doc.id); // Use document ID as feedback ID
  //     feedbackList.add(feedback);
  //   }

  //   return feedbackList;
  // }
}
