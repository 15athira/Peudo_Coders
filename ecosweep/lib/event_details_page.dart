import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetailsPage extends StatelessWidget {
  final Map<String, String> event;
  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

  void _showJoinEventDialog(BuildContext context) {
    const primaryColor = Color(0xFF4CAF50);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isChecked = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                children: [
                  Icon(
                    Icons.event_available,
                    color: primaryColor,
                    size: 48,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Join Event',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGuideline(
                            icon: Icons.access_time,
                            text: 'Please reach the location at least 1 hour before the event for registration.',
                          ),
                          SizedBox(height: 12),
                          _buildGuideline(
                            icon: Icons.people,
                            text: 'Respect others and follow the event guidelines.',
                          ),
                          SizedBox(height: 12),
                          _buildGuideline(
                            icon: Icons.inventory_2,
                            text: 'Ensure to carry necessary items as mentioned in the event details.',
                          ),
                          SizedBox(height: 12),
                          _buildGuideline(
                            icon: Icons.health_and_safety,
                            text: 'Follow all safety protocols and instructions provided by the event organizers.',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                          activeColor: primaryColor,
                        ),
                        Expanded(
                          child: Text(
                            'I have read and agree to the terms and conditions',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isChecked
                      ? () async {
                          final user = FirebaseAuth.instance.currentUser;
                          await FirebaseFirestore.instance
                              .collection('event_participants')
                              .doc('${event['id']}_${user!.uid}')
                              .set({
                            'eventId': event['id'],
                            'userId': user.uid,
                            'joinedAt': FieldValue.serverTimestamp(),
                          });
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Successfully joined the event!'),
                              backgroundColor: primaryColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text("I'm in"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildGuideline({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Color(0xFF4CAF50)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  void _handleJoinEvent(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _showJoinEventDialog(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Column(
              children: [
                Icon(
                  Icons.login,
                  color: Color(0xFF4CAF50),
                  size: 48,
                ),
                SizedBox(height: 16),
                Text('Login Required'),
              ],
            ),
            content: Text('Please login to join this event.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text('Login'),
              ),
            ],
          );
        },
      );
    }
  }

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
          "Event Details",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Icon(
                Icons.image,
                size: 100,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title']!,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: primaryColor),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date & Time',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              event['date']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: primaryColor),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  event['place']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          event['location']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  Text(
                    'About Event',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    event['description']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 30),

                  if (!event['title']!.toLowerCase().contains('beach cleanup'))
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('event_participants')
                          .doc('${event['id']}_${FirebaseAuth.instance.currentUser?.uid}')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.exists) {
                          return ElevatedButton.icon(
                            icon: Icon(Icons.visibility),
                            label: Text('View Updates'),
                            onPressed: () {
                              Navigator.pushNamed(
                                context, 
                                '/event-updates',
                                arguments: event,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                          );
                        }
                        return ElevatedButton(
                          onPressed: () => _handleJoinEvent(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text(
                            'Join Event',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}