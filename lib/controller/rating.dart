//NOTE: This is temporary rating data fields

class Rating {
  final String userID;
  final String babysitterID;
  final int rating;
  final String review;
  List? images;
  final DateTime timestamp;

  Rating({
    required this.userID,
    required this.babysitterID,
    required this.rating,
    required this.review,
    required this.timestamp,
    this.images,
  });
}
