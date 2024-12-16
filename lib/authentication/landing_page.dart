import 'package:babysitterapp/components/button.dart';
import 'package:babysitterapp/styles/colors.dart';
import 'package:flutter/material.dart';

class BabySitterLandingPage extends StatefulWidget {
  const BabySitterLandingPage({super.key});

  @override
  State<BabySitterLandingPage> createState() => _BabySitterLandingPageState();
}

class _BabySitterLandingPageState extends State<BabySitterLandingPage> {
  bool isLoginButtonPressed = false;
  bool isRegisterButtonPressed = false;

  void _navigateAndResetButton(String route, VoidCallback resetButton) {
    Navigator.pushNamed(context, route).then((_) => setState(resetButton));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            const SizedBox(height: 20),
            _buildAppName(),
            const SizedBox(height: 40),
            _buildActionButton("Login", '/login', () {
              isLoginButtonPressed = true;
            }, () {
              isLoginButtonPressed = false;
            }),
            const SizedBox(height: 20),
            _buildActionButton("Register", '/register', () {
              isRegisterButtonPressed = true;
            }, () {
              isRegisterButtonPressed = false;
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return const CircleAvatar(
      radius: 80,
      backgroundImage: AssetImage('assets/images/app-logo.png'),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildAppName() {
    return const Text(
      'Babysitter Booking App',
      style: TextStyle(
        fontSize: 24,
        color: Colors.white,
      ),
    );
  }

  Widget _buildActionButton(String text, String route,
      VoidCallback onPressedStart, VoidCallback onPressedEnd) {
    return SizedBox(
      width: 250,
      child: AppButton(
        text: text,
        onPressed: () {
          setState(onPressedStart);
          _navigateAndResetButton(route, onPressedEnd);
        },
      ),
    );
  }
}
