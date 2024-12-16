import 'package:flutter/material.dart';

class BabysitterCard extends StatelessWidget {
  final String name;
  final double rate;
  final double rating;
  final String gender;
  final DateTime birthdate;
  final String? profileImage;
  // final IconButton heartIcon;

  const BabysitterCard({
    super.key,
    required this.name,
    required this.rate,
    required this.rating,
    required this.gender,
    required this.birthdate,
    this.profileImage,
    // required this.heartIcon,
  });

// calculate age
  int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    // Adjust if the birthday hasn't occurred yet this year
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: profileImage != ""
              ? AssetImage(profileImage!)
              : const AssetImage('assets/images/default_user.png'),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
            Text(
              'P$rate/hr',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$gender, ',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
                Text(
                  calculateAge(birthdate).toString(),
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  rating.toStringAsFixed(1),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // const Spacer(),
            // IconButton(
            //   icon: const Icon(Icons.favorite_border),
            //   color: Theme.of(context).colorScheme.primary,
            //   onPressed: () {
            //     // Handle heart icon press
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
