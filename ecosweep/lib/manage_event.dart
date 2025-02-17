import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event_details_admin.dart'; // Import the EventDetailsAdminPage

class ManageEventPage extends StatelessWidget {
  const ManageEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4CAF50);
    const backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Manage Event'),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(
            color: Colors.white), // Change arrow color to white
        titleTextStyle: const TextStyle(
          color: Colors.white, // Change font color to white
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching events'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No events found'));
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final eventData = event.data() as Map<String, dynamic>;
              final name = eventData['name'] ?? 'No Name';
              final description = eventData['description'] ?? 'No Description';
              final date = eventData['date'] != null
                  ? (eventData['date'] as Timestamp).toDate()
                  : null;

              return ListTile(
                leading: Icon(Icons.event, color: primaryColor),
                title: Text(name),
                subtitle: Text(description),
                trailing: date != null
                    ? Text(
                        '${date.day}/${date.month}/${date.year}',
                        style: TextStyle(color: Colors.grey),
                      )
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailsAdminPage(event: event),
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
