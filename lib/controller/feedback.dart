import 'package:cloud_firestore/cloud_firestore.dart';

class FeedBack {
  final String id;
  final int rating;
  final DateTime timestamp;
  String? feedbackMsg;
  List<String>? images;

  FeedBack({
    required this.id,
    required this.rating,
    required this.timestamp,
    this.feedbackMsg,
    this.images,
  });
  // Convert Firestore data to FeedBack instance
  factory FeedBack.fromMap(Map<String, dynamic> data) {
    return FeedBack(
      id: data['id'] ?? '',
      rating: data['rating'] ?? 0,
      timestamp:
          (data['timestamp'] ?? Timestamp.fromDate(DateTime.now())).toDate(),
      feedbackMsg: data['msg'] ?? '',
      images: List<String>.from(data['images'] ?? []),
    );
  }
}
