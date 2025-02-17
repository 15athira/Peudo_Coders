import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'verify_details.dart'; // Import the VerifyDetailsPage

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4CAF50);
    const backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Verify Waste Reports'),
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
        stream:
            FirebaseFirestore.instance.collection('verification').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching reports'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reports found'));
          }

          final reports = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              final reportData = report.data() as Map<String, dynamic>;
              final description = reportData['name'] ?? 'No Description';
              final location = reportData['location'] ?? 'No Location';
              final submittedAt = reportData['submittedAt'] != null
                  ? (reportData['submittedAt'] as Timestamp).toDate()
                  : null;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(description),
                  subtitle: Text(location),
                  trailing: submittedAt != null
                      ? Text(
                          '${submittedAt.day}/${submittedAt.month}/${submittedAt.year}',
                          style: TextStyle(color: Colors.grey),
                        )
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyDetailsPage(report: report),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
