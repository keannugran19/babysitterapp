import 'package:babysitterapp/authentication/terms_condition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:babysitterapp/utils/authentication.dart';
import 'package:flutter/gestures.dart';

class BabySitterRegisterPage extends StatefulWidget {
  const BabySitterRegisterPage({super.key});

  @override
  State<BabySitterRegisterPage> createState() => _BabySitterRegisterPageState();
}

class _BabySitterRegisterPageState extends State<BabySitterRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String? fullName;
  String? _email;
  String? _password;
  String? _role;
  String? _confirmPassword;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _phoneNumber;
  bool _isAgreed = false;

  // Function to add user data to the Firestore 'users' collection
  Future<void> addUserData(String userId, String fullName, String email,
      String role, String phoneNumber) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Firestore will create 'users' collection and 'userId' document if they don't exist
      await firestore.collection('users').doc(userId).set({
        'full_name': fullName,
        'email': email,
        'role': role,
        'phone_number': phoneNumber,
      });

      print("User data added successfully!");
    } catch (e) {
      print("Failed to add user data: $e");
    }
  }

  void signUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email!, password: _password!);
      // Assuming you already have a logged-in user
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        addUserData(userId, fullName!, _email!, _role!, _phoneNumber!);
      }

      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/welcome');
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print(e.code);
      if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "Invalid Email",
            style: TextStyle(color: Colors.white, letterSpacing: 0.5),
          ),
        ));
      }

      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "The password provided is too weak.",
            style: TextStyle(color: Colors.white, letterSpacing: 0.5),
          ),
        ));
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "The account already exists for that email.",
            style: TextStyle(color: Colors.white, letterSpacing: 0.5),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFB39DDB), Color(0xFF9575CD)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  const Text.rich(
                    TextSpan(
                      text: 'Create an Account,\n',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'to get started now!',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  // name
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      fullName = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // email
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // password
                  TextFormField(
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      _password = value;
                      return null;
                    },
                    onSaved: (value) {
                      _password = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // confirm password
                  TextFormField(
                    obscureText: !_isConfirmPasswordVisible,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _password) {
                        return 'Passwords do not match';
                      }
                      _confirmPassword = value;
                      return null;
                    },
                    onSaved: (value) {
                      _confirmPassword = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // dropdown : select role whether employer or babysitter
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Role',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(child: Text('Parent'), value: 'parent'),
                      DropdownMenuItem(
                          child: Text('Babysitter'), value: 'babysitter'),
                    ],
                    onChanged: (value) {
                      _role = value;
                      // Handle role selection
                    },
                  ),
                  const SizedBox(height: 20),
                  // phone number for otp
                  TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
                        return 'Phone number must be 11 digits';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _phoneNumber = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // checkbox for terms and conditions
                  CheckboxListTile(
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
                                  builder: (context) =>
                                      const TermsConditionsDialog(),
                                );
                                // Navigator.pushNamed(context, '/terms');
                              },
                          ),
                        ],
                      ),
                    ),
                    value: _isAgreed,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAgreed = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                  ),
                  const SizedBox(height: 30),
                  // register button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add register logic
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Implement your sign-up logic here
                          signUserUp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Row(
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
                  ),
                  const SizedBox(height: 30),
                  // register with google and facebook
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Image.network(
                              'https://developers.google.com/identity/images/g-logo.png',
                              height: 24),
                          iconSize: 50,
                          onPressed: () async {
                            await Authentication.signInWithGoogle(
                                context: context);
                            Navigator.pushReplacementNamed(context, '/welcome');
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/c/cd/Facebook_logo_%28square%29.png',
                              height: 24),
                          iconSize: 50,
                          onPressed: () {
                            // Facebook login logic
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
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
                                decorationColor: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
