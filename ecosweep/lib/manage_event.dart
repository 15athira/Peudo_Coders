import 'package:flutter/material.dart';

class ManageEventPage extends StatelessWidget {
  const ManageEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Event'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: const Center(
        child: Text(
          'Manage Event Page Content',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
