import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4CAF50);
    const backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    user.email ?? 'No email',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),
                  ListTile(
                    leading: Icon(Icons.person_outline, color: primaryColor),
                    title: Text('Account Settings'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.event_note, color: primaryColor),
                    title: Text('My Events'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.notifications_outlined, color: primaryColor),
                    title: Text('Notifications'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  Divider(),
                  SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text('Logout'),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please login to view profile',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final bool isLoggedIn = snapshot.hasData;
          
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: 2,
              selectedItemColor: primaryColor,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              onTap: (index) {
                if (index == 0) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else if (index == 1) {
                  Navigator.pushReplacementNamed(context, '/events');
                } else if (index == 2) {
                  // Already on profile page
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.event),
                  label: 'Events',
                ),
                BottomNavigationBarItem(
                  icon: Icon(isLoggedIn ? Icons.person : Icons.login),
                  label: isLoggedIn ? 'Profile' : 'Login',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}