import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class EventUpdatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, String> event =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Updates'),
      ),
      body: Center(
        child: Text('Updates for event: ${event['title']}'),
      ),
    );
  }
}
