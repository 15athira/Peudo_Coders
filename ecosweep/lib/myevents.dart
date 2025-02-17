import 'package:flutter/material.dart';

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        backgroundColor: const Color(0xFF4CAF50),
        iconTheme: const IconThemeData(
            color: Colors.white), // Change arrow color to white
        titleTextStyle: const TextStyle(
          color: Colors.white, // Change font color to white
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: const Center(
        child: Text(
          'My Events Page Content',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
