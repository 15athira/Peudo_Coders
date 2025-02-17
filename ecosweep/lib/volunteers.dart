import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_details_page.dart'; // Import the UserDetailsPage

class VolunteersPage extends StatefulWidget {
  const VolunteersPage({super.key});

  @override
  _VolunteersPageState createState() => _VolunteersPageState();
}

class _VolunteersPageState extends State<VolunteersPage> {
  String _sortBy = 'name';

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4CAF50);
    const backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Volunteers'),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(
            color: Colors.white), // Change arrow color to white
        titleTextStyle: const TextStyle(
          color: Colors.white, // Change font color to white
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          DropdownButton<String>(
            value: _sortBy,
            icon: const Icon(Icons.sort, color: Colors.white),
            dropdownColor: primaryColor,
            underline: Container(),
            onChanged: (String? newValue) {
              setState(() {
                _sortBy = newValue!;
              });
            },
            items: <String>['name', 'email', 'createdAt']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  'Sort by $value',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy(_sortBy)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching volunteers'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No volunteers found'));
          }

          final volunteers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: volunteers.length,
            itemBuilder: (context, index) {
              final volunteer =
                  volunteers[index].data() as Map<String, dynamic>;
              final name =
                  volunteer.containsKey('name') ? volunteer['name'] : 'No Name';
              final email = volunteer.containsKey('email')
                  ? volunteer['email']
                  : 'No Email';

              return ListTile(
                leading: Icon(Icons.person, color: primaryColor),
                title: Text(name),
                subtitle: Text(email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailsPage(user: volunteer),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
