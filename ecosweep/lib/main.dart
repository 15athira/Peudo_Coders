import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'home_page.dart'; // Import the HomePage widget
import 'login_page.dart'; // Import the LoginPage widget
import 'register_page.dart'; // Import the RegisterPage widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(), // Use LoginPage as the initial route
        '/home': (context) => HomePage(), // Define the HomePage route
        '/register': (context) => RegisterPage(), // Define the RegisterPage route
      },
    );
  }
}
