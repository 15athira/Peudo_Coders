import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventPage extends StatelessWidget {
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
         "Events",
         style: TextStyle(
           fontSize: 24,
           fontWeight: FontWeight.bold,
           color: Colors.white,
         ),
       ),
     ),
     body: SingleChildScrollView(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           // Upcoming Events Section with Horizontal Scroll
           Container(
             padding: EdgeInsets.all(16.0),
             decoration: BoxDecoration(
               color: primaryColor,
               borderRadius: BorderRadius.only(
                 bottomLeft: Radius.circular(30),
                 bottomRight: Radius.circular(30),
               ),
             ),
             child: Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.calendar_today, color: Colors.white),
                     SizedBox(width: 8),
                     Text(
                       "Upcoming Events",
                       style: TextStyle(
                         fontSize: 24,
                         fontWeight: FontWeight.bold,
                         color: Colors.white,
                       ),
                     ),
                   ],
                 ),
                 SizedBox(height: 16),
                 Container(
                   height: 200,
                   child: ListView.builder(
                     scrollDirection: Axis.horizontal,
                     itemCount: 6,
                     itemBuilder: (context, index) {
                       return InkWell(
                         onTap: () {
                           Navigator.pushNamed(
                             context,
                             '/event-details',
                             arguments: {
                               'title': 'River Cleanup ${index + 1}',
                               'description': 'Join us for a community river cleanup event. Help us make our environment cleaner and better for everyone. We will provide all necessary equipment and refreshments. Let\'s work together to protect our rivers!',
                               'date': '30 Apr 2024 | 09:00 AM',
                               'place': 'City River Park',
                               'location': '123 River Street, Green City',
                             },
                           );
                         },
                         child: Container(
                           width: 200,
                           margin: EdgeInsets.only(right: 16),
                           child: Card(
                             elevation: 4,
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(15),
                             ),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Container(
                                   height: 80,
                                   width: 80,
                                   decoration: BoxDecoration(
                                     color: primaryColor.withOpacity(0.1),
                                     borderRadius: BorderRadius.circular(40),
                                   ),
                                   child: Icon(
                                     Icons.event,
                                     color: primaryColor,
                                     size: 30,
                                   ),
                                 ),
                                 SizedBox(height: 12),
                                 Text(
                                   "River Cleanup ${index + 1}",
                                   style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     color: Colors.black87,
                                     fontSize: 16,
                                   ),
                                 ),
                                 SizedBox(height: 4),
                                 Text(
                                   "30 Apr 2024",
                                   style: TextStyle(
                                     color: Colors.grey,
                                     fontSize: 14,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       );
                     },
                   ),
                 ),
               ],
             ),
           ),

           // Completed Events Section with Vertical Scroll
           Padding(
             padding: const EdgeInsets.all(16.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Icon(Icons.check_circle, color: primaryColor),
                 SizedBox(width: 8),
                 Text(
                   "Completed Events",
                   style: TextStyle(
                     fontSize: 24,
                     fontWeight: FontWeight.bold,
                     color: Colors.black87,
                   ),
                 ),
               ],
             ),
           ),
           ListView.builder(
             shrinkWrap: true,
             physics: NeverScrollableScrollPhysics(),
             itemCount: 6,
             itemBuilder: (context, index) {
               return InkWell(
                 onTap: () {
                   Navigator.pushNamed(
                     context,
                     '/event-details',
                     arguments: {
                       'title': 'Beach Cleanup ${index + 1}',
                       'description': 'Past cleanup event at the city beach. We collected over 100kg of waste and made our beach cleaner. Thanks to all volunteers who participated in this successful event!',
                       'date': '23 Apr 2024 | 10:00 AM',
                       'place': 'City Beach',
                       'location': '456 Beach Road, Green City',
                     },
                   );
                 },
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                   child: Card(
                     elevation: 4,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(15),
                     ),
                     child: Padding(
                       padding: const EdgeInsets.all(16.0),
                       child: Row(
                         children: [
                           Container(
                             height: 60,
                             width: 60,
                             decoration: BoxDecoration(
                               color: primaryColor.withOpacity(0.1),
                               borderRadius: BorderRadius.circular(30),
                             ),
                             child: Icon(
                               Icons.photo_camera,
                               color: primaryColor,
                               size: 24,
                             ),
                           ),
                           SizedBox(width: 16),
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   "Beach Cleanup ${index + 1}",
                                   style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     color: Colors.black87,
                                     fontSize: 16,
                                   ),
                                 ),
                                 SizedBox(height: 4),
                                 Text(
                                   "23 Apr 2024",
                                   style: TextStyle(
                                     color: Colors.grey,
                                     fontSize: 14,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           Icon(
                             Icons.arrow_forward_ios,
                             color: Colors.grey,
                             size: 16,
                           ),
                         ],
                       ),
                     ),
                   ),
                 ),
               );
             },
           ),
           SizedBox(height: 20),
         ],
       ),
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
             currentIndex: 1,
             selectedItemColor: primaryColor,
             unselectedItemColor: Colors.grey,
             backgroundColor: Colors.white,
             type: BottomNavigationBarType.fixed,
             elevation: 0,
             onTap: (index) {
               if (index == 0) {
                 Navigator.pushReplacementNamed(context, '/home');
               } else if (index == 2) {
                 if (isLoggedIn) {
                   Navigator.pushReplacementNamed(context, '/profile');
                 } else {
                   Navigator.pushNamed(context, '/login');
                 }
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