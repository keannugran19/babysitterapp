import 'package:babysitterapp/authentication/check_auth_page.dart';
import 'package:babysitterapp/authentication/login_page.dart';
import 'package:babysitterapp/authentication/register_page.dart';
import 'package:babysitterapp/styles/theme_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  //firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //supabase setup
  await Supabase.initialize(
      url: 'https://woftardesnpfazrmrqko.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndvZnRhcmRlc25wZmF6cm1ycWtvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQxNDc4OTQsImV4cCI6MjA0OTcyMzg5NH0.1y-0Y-ThOJYEqei4-JP96x6e4AgApEyUpepUF0wDdUM');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Baby Sitter App',
      theme: ThemeClass.theme,
      home: const CheckAuthPage(),
      routes: {
        '/login': (context) => const BabySitterLoginPage(),
        '/register': (context) => const BabySitterRegisterPage(),
      },
    );
  }
}
