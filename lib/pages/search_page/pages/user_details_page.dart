import 'package:babysitterapp/models/search_result.dart';
import 'package:babysitterapp/styles/responsive.dart';
import 'package:flutter/material.dart';
import 'package:babysitterapp/styles/colors.dart';

class UserDetailsPage extends StatelessWidget {
  final SearchResult babysitter;

  const UserDetailsPage({
    super.key,
    required this.babysitter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(babysitter.name),
        backgroundColor: colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: Responsive.getAvatarRadius(context),
                  backgroundImage: AssetImage(babysitter.profileImage),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        babysitter.name,
                        style: TextStyle(
                          fontSize: Responsive.getNameFontSize(context),
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.red, size: 16),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${babysitter.location} | ${babysitter.distance.toString()} km',
                              style: TextStyle(
                                fontSize: Responsive.getTextFontSize(context),
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${babysitter.rating} ★ (${babysitter.reviewsCount} reviews)',
                              style: TextStyle(
                                fontSize: Responsive.getTextFontSize(context),
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.call, color: colorScheme.onPrimary),
                  label: const Text("Call"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Experience',
              style: TextStyle(
                fontSize: Responsive.getTextFontSize(context),
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              babysitter.experience,
              style: TextStyle(
                fontSize: Responsive.getTextFontSize(context),
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Age: ${babysitter.age}',
              style: TextStyle(
                fontSize: Responsive.getTextFontSize(context),
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ABOUT',
              style: TextStyle(
                fontSize: Responsive.getTextFontSize(context),
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              babysitter.bio,
              style: TextStyle(
                fontSize: Responsive.getTextFontSize(context),
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: Text(
                'Read more...',
                style: TextStyle(color: colorScheme.secondary),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Availability',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(color: colorScheme.secondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildAvailabilityDate('26 Oct', true),
                      _buildAvailabilityDate('27 Oct', false),
                      _buildAvailabilityDate('28 Oct', false),
                      _buildAvailabilityDate('29 Oct', false),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Book Now action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('+ Book Now',
                  style: TextStyle(color: colorScheme.onPrimary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityDate(String date, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  colorScheme.surface.withOpacity(0.7),
                  colorScheme.surface
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isActive
            ? [
                BoxShadow(
                    color: colorScheme.secondary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ]
            : [],
      ),
      child: Text(
        date,
        style: TextStyle(
          color: isActive ? colorScheme.onPrimary : colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
