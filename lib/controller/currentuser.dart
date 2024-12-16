//NOTE: This is temporary current user data fields

import 'package:babysitterapp/views/customwidget.dart';

class CurrentUser {
  final String name;
  final String email;
  final String id;
  final String img;
  final List<ListWithID> messages;

  CurrentUser({
    required this.name,
    required this.email,
    required this.id,
    required this.img,
    required this.messages,
  });
}
