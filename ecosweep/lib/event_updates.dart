import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class EventUpdatesPage extends StatefulWidget {
  final Map<String, String> event;

  const EventUpdatesPage({Key? key, required this.event}) : super(key: key);

  @override
  _EventUpdatesPageState createState() => _EventUpdatesPageState();
}

class _EventUpdatesPageState extends State<EventUpdatesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingImage = false;

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';

    DateTime dateTime = timestamp.toDate();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();

    return '$day/$month/$year, $hour:$minute';
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _feedbackController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _uploadImage() async {
    if (_isLoadingImage) return;

    setState(() {
      _isLoadingImage = true;
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        imageQuality: 80,
      );

      if (image == null) {
        setState(() {
          _isLoadingImage = false;
        });
        return;
      }

      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String storagePath =
          'event_photos/${widget.event['id']}/$timestamp';

      final Reference storageRef =
          FirebaseStorage.instance.ref().child(storagePath);
      await storageRef.putFile(File(image.path));
      final String downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('event_photos').add({
        'eventId': widget.event['id'],
        'userId': user.uid,
        'userName': user.displayName ?? 'Anonymous',
        'imageUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Photo uploaded successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload photo: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoadingImage = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('event_chats').add({
        'eventId': widget.event['id'],
        'userId': user.uid,
        'userName': user.displayName ?? 'Anonymous',
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message')),
      );
    }
  }

  Future<void> _submitFeedback() async {
    final feedbackText = _feedbackController.text.trim();
    if (feedbackText.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('event_feedback').add({
        'eventId': widget.event['id'],
        'userId': user.uid,
        'userName': user.displayName ?? 'Anonymous',
        'text': feedbackText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _feedbackController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank you for your feedback!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit feedback'),
          backgroundColor: Colors.red,
        ),
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
          widget.event['title']!,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(icon: Icon(Icons.info_outline), text: 'Guidelines'),
            Tab(icon: Icon(Icons.chat), text: 'Chat'),
            Tab(icon: Icon(Icons.photo_library), text: 'Gallery'),
            Tab(icon: Icon(Icons.feedback), text: 'Feedback'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGuidelines(),
          _buildChat(),
          _buildGallery(),
          _buildFeedback(),
        ],
      ),
    );
  }

  Widget _buildGuidelines() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildGuidelineCard(
            icon: Icons.access_time,
            title: 'Event Schedule',
            content:
                'Event Time: ${widget.event['date']}\nDuration: 3 hours\nRegistration: 30 minutes before start',
          ),
          _buildGuidelineCard(
            icon: Icons.inventory_2,
            title: 'What to Bring',
            content:
                '• Comfortable clothes\n• Water bottle\n• Hat & sunscreen\n• Work gloves\n• Face mask',
          ),
          _buildGuidelineCard(
            icon: Icons.medical_services,
            title: 'Safety Guidelines',
            content:
                '• Follow safety instructions\n• Stay hydrated\n• Use provided equipment properly\n• Report any incidents',
          ),
          _buildGuidelineCard(
            icon: Icons.people,
            title: 'Team Protocol',
            content:
                '• Work in assigned groups\n• Maintain communication\n• Support team members\n• Follow leader instructions',
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Color(0xFF4CAF50)),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChat() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('event_chats')
                .where('eventId', isEqualTo: widget.event['id'])
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: EdgeInsets.all(16),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  return _buildMessageBubble(
                      doc.data() as Map<String, dynamic>);
                },
              );
            },
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isCurrentUser =
        message['userId'] == FirebaseAuth.instance.currentUser?.uid;
    final timestamp = message['timestamp'] as Timestamp?;
    final timeString = timestamp != null
        ? '${timestamp.toDate().hour.toString().padLeft(2, '0')}:${timestamp.toDate().minute.toString().padLeft(2, '0')}'
        : '';

    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              backgroundColor: Color(0xFF4CAF50),
              child: Text(
                message['userName'][0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isCurrentUser ? Color(0xFF4CAF50) : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isCurrentUser)
                    Text(
                      message['userName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  Text(
                    message['text'],
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    timeString,
                    style: TextStyle(
                      fontSize: 10,
                      color: isCurrentUser ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              minLines: 1,
              maxLines: 5,
            ),
          ),
          SizedBox(width: 8),
          MaterialButton(
            onPressed: _sendMessage,
            color: Color(0xFF4CAF50),
            minWidth: 0,
            padding: EdgeInsets.all(12),
            shape: CircleBorder(),
            child: Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildGallery() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _isLoadingImage ? null : _uploadImage,
            icon: _isLoadingImage
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Icon(Icons.add_photo_alternate),
            label: Text(_isLoadingImage ? 'Uploading...' : 'Add Photo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4CAF50),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('event_photos')
                .where('eventId', isEqualTo: widget.event['id'])
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No photos yet.\nBe the first to share!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var photo =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return _buildPhotoItem(photo);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoItem(Map<String, dynamic> photo) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            insetPadding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.network(
                      photo['imageUrl'],
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        photo['userName'] ?? 'Anonymous',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (photo['timestamp'] != null)
                        Text(
                          formatTimestamp(photo['timestamp'] as Timestamp),
                          style: TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              photo['imageUrl'],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  photo['userName'] ?? 'Anonymous',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedback() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitFeedback,
                child: Text('Submit Feedback'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF50),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('event_feedback')
                .where('eventId', isEqualTo: widget.event['id'])
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No feedback yet.\nBe the first to share!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var feedback =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return _buildFeedbackItem(feedback);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackItem(Map<String, dynamic> feedback) {
    final timestamp = feedback['timestamp'] as Timestamp?;
    final timeString = timestamp != null
        ? '${timestamp.toDate().day.toString().padLeft(2, '0')}/${timestamp.toDate().month.toString().padLeft(2, '0')}/${timestamp.toDate().year.toString()}'
        : '';

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feedback['userName'] ?? 'Anonymous',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              feedback['text'],
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              timeString,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
