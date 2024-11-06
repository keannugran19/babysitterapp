import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String name;
  final String time;
  final String experience;
  final double rating;
  final int reviews;

  const NotificationCard({
    Key? key,
    required this.name,
    required this.time,
    required this.experience,
    required this.rating,
    required this.reviews,
  }) : super(key: key);

  String getProfileImage(String name) {
    switch (name.toLowerCase()) {
      case 'momo ayase':
        return 'assets/images/female4.jpg';
      case 'wayne hill':
        return 'assets/images/male5.jpg';
      case 'jennifer conn':
        return 'assets/images/female2.jpg';
      case 'evelyn larson':
        return 'assets/images/female1.jpg';
      default:
        return 'assets/images/default.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(getProfileImage(name)),
          radius: 25,
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Experience: $experience'),
            Text('Rating: $rating ★ ($reviews reviews)'),
            Text('Last active: $time'),
          ],
        ),
      ),
    );
  }
}
