import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'verify.dart'; // Import the VerifyPage
import 'volunteers.dart'; // Import the VolunteersPage
import 'create_event.dart'; // Import the CreateEventPage
import 'manage_event.dart'; // Import the ManageEventPage

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4CAF50);
    const backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white), // Change font color to white
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout,
                color: Colors.white), // Change icon color to white
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildCard('Verify', Icons.verified, primaryColor, context),
            _buildCard('Manage Event', Icons.event, primaryColor, context),
            _buildCard('Volunteers', Icons.group, primaryColor, context),
            _buildCard('Create Event', Icons.add_circle, primaryColor, context),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      String title, IconData icon, Color color, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (title == 'Verify') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VerifyPage()),
            );
          } else if (title == 'Volunteers') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VolunteersPage()),
            );
          } else if (title == 'Create Event') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateEventPage()),
            );
          } else if (title == 'Manage Event') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ManageEventPage()),
            );
          }
          // Define other actions for other cards
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
