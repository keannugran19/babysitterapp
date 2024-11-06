import 'package:babysitterapp/pages/homepage/notification_card.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title:
            Text('Notification', style: Theme.of(context).textTheme.bodyLarge),
      ),
      body: ListView(
        children: const [
          NotificationCard(
              name: 'Emma Gill',
              time: '8 hours',
              experience: '6 years',
              rating: 0,
              reviews: 90),
          NotificationCard(
              name: 'Wayne Hill',
              time: '26 hours',
              experience: '6 years',
              rating: 0,
              reviews: 140),
          NotificationCard(
              name: 'Jennifer Conn',
              time: 'yesterday',
              experience: '6 years',
              rating: 0,
              reviews: 900),
          NotificationCard(
              name: 'Evelyn Larson',
              time: '6 seconds',
              experience: 'Recently joined',
              rating: 0,
              reviews: 0),
        ],
      ),
    );
  }
}
