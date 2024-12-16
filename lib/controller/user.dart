//NOTE: This is temporary babysitter data fields

class User {
  final String id;
  final String name;
  final String email;
  final String img;
  final String address;
  final String phone;
  final DateTime birtdate;
  final String gender;
  final double rate;
  final String description;
  final List experience;
  final String userType;
  final String information;
  final int? childAge;

  bool? isClicked = false;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.img,
    required this.address,
    required this.phone,
    required this.birtdate,
    required this.gender,
    required this.rate,
    required this.description,
    required this.experience,
    required this.userType,
    required this.information,
    required this.childAge,
    this.isClicked,
  });
}
