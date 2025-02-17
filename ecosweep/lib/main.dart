import 'package:ecosweep/event_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'profile_page.dart';
import 'event_details_page.dart';
import 'admin_dashboard.dart'; // Import the AdminDashboard page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        primarySwatch: Colors.green,
      ),
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        if (settings.name == '/event-details') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => EventDetailsPage(event: args),
          );
        }
        return null;
      },
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/events': (context) => EventPage(),
        '/register': (context) => RegisterPage(),
        '/profile': (context) => ProfilePage(), 
        '/admin-dashboard': (context) => AdminDashboard(), // Add the route
      },
    );
  }
}
