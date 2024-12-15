import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/messages.dart';

const String defaultImage = 'assets/images/default_user.png';

class ChatService {
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');

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

  Future<void> deleteChat(String currentUserID, String chatDocID) async {
    try {
      await users
          .doc(currentUserID)
          .collection('messages')
          .doc(chatDocID)
          .delete(); // Delete the specific document
      print("Chat document $chatDocID deleted successfully.");
    } catch (e) {
      print("Error deleting chat document: $e");
    }
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
}
