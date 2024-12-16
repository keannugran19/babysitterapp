import 'package:babysitterapp/authentication/landing_page.dart';
import 'package:babysitterapp/pages/homepage/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckAuthPage extends StatefulWidget {
  const CheckAuthPage({super.key});

  @override
  State<CheckAuthPage> createState() => _CheckAuthPageState();
}

class _CheckAuthPageState extends State<CheckAuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //   user no logged in
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const BabySitterLandingPage();
          }
        },
      ),
    );
  }
}
