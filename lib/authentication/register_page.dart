import 'package:babysitterapp/components/button.dart';
import 'package:babysitterapp/services/current_user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:babysitterapp/utils/authentication.dart';
import 'package:flutter/gestures.dart';

import '../styles/colors.dart';
import 'terms_condition.dart';

class BabySitterRegisterPage extends StatefulWidget {
  const BabySitterRegisterPage({super.key});

  @override
  State<BabySitterRegisterPage> createState() => _BabySitterRegisterPageState();
}

class _BabySitterRegisterPageState extends State<BabySitterRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  // call database
  CurrentUserService firestoreService = CurrentUserService();

  // Form fields
  String? _email;
  String? _password;
  String? fullName;
  // ignore: unused_field
  String? _confirmPassword;
  String? _phoneNumber;
  String? _selectedRole;
  bool _isAgreed = false;

  // UI state
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Constants
  static const double _spacing = 20.0;
  static const double _largeSpacing = 30.0;
  static const double _welcomeTextSize = 24.0;

  // Input styling
  InputDecoration get _defaultInputDecoration => InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      );

  // Registration methods
  Future<void> signUserUp() async {
    if (!_formKey.currentState!.validate() || !_isAgreed) {
      _showErrorMessage('Please agree to the terms and conditions');
      return;
    }

    _formKey.currentState!.save();
    await _createFirebaseUser();
  }

  Future<void> _createFirebaseUser() async {
    _showLoadingDialog();
    try {
      await firestoreService.registerUser(
          email: _email!,
          password: _password!,
          name: fullName!,
          role: _selectedRole!,
          phone: _phoneNumber!);
      _onRegistrationSuccess();
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void _onRegistrationSuccess() {
    Navigator.pop(context); // Dismiss loading dialog
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _handleAuthError(FirebaseAuthException e) {
    Navigator.pop(context); // Dismiss loading dialog

    switch (e.code) {
      case 'invalid-email':
        _showErrorMessage('Invalid Email');
        break;
      case 'weak-password':
        _showErrorMessage('The password provided is too weak.');
        break;
      case 'email-already-in-use':
        _showErrorMessage('The account already exists for that email.');
        break;
      default:
        _showErrorMessage('Registration failed. Please try again.');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, letterSpacing: 0.5),
      ),
    ));
  }

  // Form validation
  String? _validatePassword(String? value) {
    if (value?.isEmpty == true) {
      return 'Please enter your password';
    }
    _password = value;
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value?.isEmpty == true) {
      return 'Please confirm your password';
    }
    if (value != _password) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
      return 'Phone number must be 11 digits';
    }
    return null;
  }

  // UI Components
  Widget _buildWelcomeText() {
    return const Text.rich(
      TextSpan(
        text: 'Create an Account,\n',
        style: TextStyle(
          fontSize: _welcomeTextSize,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'to get started now!',
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

  Widget _buildNameField() {
    return TextFormField(
      onSaved: (value) => fullName = value,
      decoration: _defaultInputDecoration.copyWith(
        hintText: "Full Name",
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      validator: (value) =>
          value?.isEmpty == true ? 'Please enter your email' : null,
      onSaved: (value) => _email = value,
      decoration: _defaultInputDecoration.copyWith(
        hintText: "Email",
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: !_isPasswordVisible,
      validator: _validatePassword,
      onSaved: (value) => _password = value,
      decoration: _defaultInputDecoration.copyWith(
        hintText: "Password",
        suffixIcon: _buildPasswordVisibilityToggle(
          isVisible: _isPasswordVisible,
          onToggle: () =>
              setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      obscureText: !_isConfirmPasswordVisible,
      validator: _validateConfirmPassword,
      onSaved: (value) => _confirmPassword = value,
      decoration: _defaultInputDecoration.copyWith(
        hintText: "Confirm Password",
        suffixIcon: _buildPasswordVisibilityToggle(
          isVisible: _isConfirmPasswordVisible,
          onToggle: () => setState(
              () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
        ),
      ),
    );
  }

  Widget _buildPasswordVisibilityToggle({
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return IconButton(
      icon: Icon(
        isVisible ? Icons.visibility : Icons.visibility_off,
        color: Colors.grey,
      ),
      onPressed: onToggle,
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      decoration: _defaultInputDecoration.copyWith(
        labelText: 'Select Role',
      ),
      value: _selectedRole,
      items: const [
        DropdownMenuItem(value: 'parent', child: Text('Parent')),
        DropdownMenuItem(value: 'babysitter', child: Text('Babysitter')),
      ],
      onChanged: (value) => setState(() => _selectedRole = value),
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      maxLength: 11,
      validator: _validatePhoneNumber,
      onSaved: (value) => _phoneNumber = value,
      decoration: _defaultInputDecoration.copyWith(
        hintText: "Phone Number",
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return CheckboxListTile(
      title: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: 'I understand and agree with the ',
              style: TextStyle(color: Colors.white),
            ),
            TextSpan(
              text: 'Terms and Conditions',
              style: const TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await showDialog(
                    context: context,
                    builder: (context) => const TermsConditionsDialog(),
                  );
                },
            ),
          ],
        ),
      ),
      value: _isAgreed,
      onChanged: (value) => setState(() => _isAgreed = value ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.white,
      checkColor: Colors.black,
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        text: "Register",
        onPressed: signUserUp,
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
          'Or Register with',
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
        _buildSocialButton(
          'https://developers.google.com/identity/images/g-logo.png',
          () async {
            await Authentication.signInWithGoogle(context: context);
            Navigator.pushReplacementNamed(context, '/welcome');
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton(String imageUrl, VoidCallback onPressed) {
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

  Widget _buildLoginPrompt() {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, '/login'),
      child: const Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "Already have an account? ",
              style: TextStyle(color: Colors.white),
            ),
            TextSpan(
              text: "Login now",
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
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                _buildWelcomeText(),
                const SizedBox(height: _largeSpacing),
                _buildNameField(),
                const SizedBox(height: _spacing),
                _buildEmailField(),
                const SizedBox(height: _spacing),
                _buildPasswordField(),
                const SizedBox(height: _spacing),
                _buildConfirmPasswordField(),
                const SizedBox(height: _spacing),
                _buildRoleDropdown(),
                const SizedBox(height: _spacing),
                _buildPhoneNumberField(),
                const SizedBox(height: _spacing),
                _buildTermsCheckbox(),
                const SizedBox(height: _largeSpacing),
                _buildRegisterButton(),
                const SizedBox(height: _largeSpacing),
                _buildDivider(),
                const SizedBox(height: _largeSpacing),
                _buildSocialLoginButtons(),
                const SizedBox(height: _largeSpacing),
                _buildLoginPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
