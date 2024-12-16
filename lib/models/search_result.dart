import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchResult {
  final String id;
  final String name;
  final String profileImage;
  final double distance;
  final double rating;
  final int reviewsCount;
  final String bio;
  final int age;
  final List<String> skills;
  final String experience;
  final String location;
  final LatLng geocode;

  SearchResult({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.location,
    required this.distance,
    required this.rating,
    required this.reviewsCount,
    required this.bio,
    required this.age,
    required this.skills,
    required this.experience,
    required this.geocode,
  });

  static List<SearchResult> fetchBabysitters() {
    return [
      SearchResult(
        id: '1',
        name: 'Sarah Johnson',
        profileImage: 'assets/profile/sarah.jpg',
        geocode: const LatLng(37.7831, -122.4193),
        location: 'San Francisco',
        distance: 2.5,
        rating: 4.8,
        reviewsCount: 25,
        bio: 'Experienced babysitter with a love for children. CPR certified.',
        age: 25,
        skills: ['CPR certified', 'First Aid', 'Bilingual (English/Spanish)'],
        experience: '6 years with newborn and children up to 15 years',
      ),
      SearchResult(
        id: '2',
        name: 'Mike Thompson',
        profileImage: 'assets/profile/mike.jpg',
        geocode: const LatLng(37.7542, -122.4262),
        location: 'Daly City, CA',
        distance: 4.5,
        rating: 4.5,
        reviewsCount: 18,
        bio: 'Fun and energetic babysitter with 5 years of experience.',
        age: 26,
        skills: ['Creative play', 'Cooking', 'Organized activities'],
        experience: '2 years with newborn and children up to 12 years',
      ),
      SearchResult(
        id: '3',
        name: 'Emily Davis',
        profileImage: 'assets/profile/emily.jpg',
        geocode: const LatLng(37.8716, -122.2727),
        location: 'Berkeley, CA',
        distance: 7.5,
        rating: 4.7,
        reviewsCount: 32,
        bio:
            'Patient and caring babysitter with a passion for child development.',
        age: 23,
        skills: ['Child psychology', 'Homework help', 'First Aid'],
        experience: '1 year with newborn and children up to 16 years',
      ),
      SearchResult(
        id: '4',
        name: 'David Wilson',
        profileImage: 'assets/profile/david.jpg',
        geocode: const LatLng(37.7750, -122.4346),
        location: 'Western Addition, San Francisco, CA',
        distance: 6.5,
        rating: 4.6,
        reviewsCount: 28,
        bio:
            'Creative babysitter with a background in early childhood education.',
        age: 32,
        skills: ['Arts and crafts', 'Educational games', 'CPR certified'],
        experience: '4 years with newborn and children up to 15 years',
      ),
    ];
  }
}
