// babysitter.dart
class Babysitter {
  final String name;
  final String? profileImage; // Nullable in case the profile image is null
  final bool isVerified;

  Babysitter({
    required this.name,
    this.profileImage,
    required this.isVerified,
  });
}
