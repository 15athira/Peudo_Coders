import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile.dart'; // Import the EditProfilePage

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _deleteProfile(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Delete user data from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();
        // Delete user from Firebase Authentication
        await user.delete();
        // Sign out the user
        await FirebaseAuth.instance.signOut();
        // Navigate to home page
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    const primaryColor = Color(0xFF4CAF50);
    const backgroundColor = Color(0xFFF5F5F5);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor, // Set background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Delete Profile',
            style: TextStyle(color: primaryColor), // Set title color
          ),
          content: Text(
            'Are you sure you want to delete your profile? This action cannot be undone.',
            style: TextStyle(color: Colors.black87), // Set content color
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: primaryColor)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteProfile(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4CAF50);
    const backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(
            color: Colors.white), // Change arrow color to white
        titleTextStyle: const TextStyle(
          color: Colors.white, // Change font color to white
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: primaryColor),
              title: Text('Edit Profile'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.delete, color: primaryColor),
              title: Text('Delete Profile'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                _showDeleteConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
