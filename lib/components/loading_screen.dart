import 'package:flutter/material.dart';

import '../styles/colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String logoPath = 'assets/images/app-logo.png';
    return const Scaffold(
      backgroundColor: secondaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 75,
              backgroundImage: AssetImage(logoPath),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
