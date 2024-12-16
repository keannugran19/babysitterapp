import 'package:babysitterapp/authentication/forgot_password_page.dart';

import 'package:babysitterapp/authentication/check_auth_page.dart';

import 'package:babysitterapp/components/button.dart';
import 'package:babysitterapp/components/loading_screen.dart';
import 'package:babysitterapp/pages/homepage/home_page.dart';
import 'package:babysitterapp/services/current_user_service.dart';
import 'package:babysitterapp/styles/colors.dart';
import 'package:babysitterapp/styles/size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BabySitterLoginPage extends StatefulWidget {
  const BabySitterLoginPage({super.key});

  @override
  State<BabySitterLoginPage> createState() => _BabySitterLoginPageState();
}

class _BabySitterLoginPageState extends State<BabySitterLoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool _isPasswordVisible = false;

  // current user service
  CurrentUserService googleSignIn = CurrentUserService();

  // Constants
  static const double _spacing = 20.0;
  static const double _largeSpacing = 50.0;
  static const double _welcomeTextSize = 24.0;

  // Input decoration
  InputDecoration get _defaultInputDecoration => InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      );

  // Sign in methods
  Future<void> _signUserIn() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    await _authenticateUser();
  }

  Future<void> _authenticateUser() async {
    _showLoadingDialog();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email!,
        password: _password!,
      );
      _navigateToHomePage();
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) => const LoadingScreen(),
    );
  }

  void _navigateToHomePage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _handleAuthError(FirebaseAuthException e) {
    Navigator.pop(context);
    _showErrorSnackBar();
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        "Invalid Credentials",
        style: TextStyle(color: Colors.white, letterSpacing: 0.5),
      ),
    ));
  }

  // UI Components
  Widget _buildWelcomeText() {
    return const Text.rich(
      TextSpan(
        text: 'Welcome,\n',
        style: TextStyle(
          fontSize: _welcomeTextSize,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Glad to see you!',
            style: TextStyle(
              fontSize: _welcomeTextSize,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      validator: (value) =>
          value?.isEmpty == true ? 'Please enter your email' : null,
      onSaved: (value) => _email = value,
      decoration: _defaultInputDecoration.copyWith(
        hintText: "Email Address",
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: !_isPasswordVisible,
      validator: (value) =>
          value?.isEmpty == true ? 'Please enter your password' : null,
      onSaved: (value) => _password = value,
      decoration: _defaultInputDecoration.copyWith(
        hintText: "Password",
        suffixIcon: _buildPasswordVisibilityToggle(),
      ),
    );
  }

  Widget _buildPasswordVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        color: Colors.grey,
      ),
      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Forgot password logic
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ForgotPasswordScreen()),
          );
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        text: "Login",
        onPressed: _signUserIn,
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: Colors.white,
            thickness: 1,
            endIndent: 10,
          ),
        ),
        Text(
          'or login with',
          style: TextStyle(color: Colors.white),
        ),
        Expanded(
          child: Divider(
            color: Colors.white,
            thickness: 1,
            indent: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialLoginButton(
          'https://developers.google.com/identity/images/g-logo.png',
          () async {
            await googleSignIn.signInWithGoogle();
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CheckAuthPage()));
          },
        ),
      ],
    );
  }

  Widget _buildSocialLoginButton(String imageUrl, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Image.network(imageUrl, height: 24),
        iconSize: 50,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildRegisterPrompt() {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, '/register'),
      child: const Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "Don't have an account yet? ",
              style: TextStyle(color: Colors.white),
            ),
            TextSpan(
              text: "Register now",
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: sizeConfig.heightSize(context),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  _buildWelcomeText(),
                  const SizedBox(height: 30),
                  _buildEmailField(),
                  const SizedBox(height: _spacing),
                  _buildPasswordField(),
                  const SizedBox(height: 10),
                  _buildForgotPasswordButton(),
                  const SizedBox(height: 10),
                  _buildLoginButton(),
                  const SizedBox(height: _largeSpacing),
                  _buildDivider(),
                  const SizedBox(height: _largeSpacing),
                  _buildSocialLoginButtons(),
                  const Spacer(),
                  _buildRegisterPrompt(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
