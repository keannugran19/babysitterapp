//NOTE: This is temporary messages data fields

import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final String id;
  final dynamic msg;
  final DateTime timestamp;
  bool isClicked;

  Messages({
    required this.id,
    required this.msg,
    required this.timestamp,
    required this.isClicked,
  });

  // Factory constructor to create Messages instance from Firestore map
  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(
      id: map['id'] as String,
      msg: map['msg'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      isClicked: false,
    );
  }
}
