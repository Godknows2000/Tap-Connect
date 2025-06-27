import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tapconnect/models/user_model.dart';
import 'package:tapconnect/models/venues.dart';
import 'package:tapconnect/pages/nearby_venues/venues_list.dart';
import 'package:tapconnect/models/upcoming_events_model.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  Future<Venue?> _fetchVenue(String? venueId) async {
    if (venueId == null || venueId.isEmpty) return null;
    final doc = await FirebaseFirestore.instance
        .collection('venues')
        .doc(venueId)
        .get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Venue.fromJson(data);
    }
    return null;
  }

  Future<void> _markAsRead(String messageId) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .update({'read': true});
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Please log in to view messages.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Messages', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .where('receiverId', isEqualTo: currentUserId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text(
                'Error loading messages',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }
          final messages = snapshot.data!.docs;
          if (messages.isEmpty) {
            return const Center(
              child: Text(
                'No messages yet',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index].data() as Map<String, dynamic>;
              final messageId = messages[index].id;
              final isRead = message['read'] ?? false;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(message['senderId'])
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(
                      title: Text(
                        'Loading...',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  final sender = UserModel.fromJson(
                      userSnapshot.data!.data() as Map<String, dynamic>);
                  return ListTile(
                    title: Text(
                      message['message'] ?? 'No message',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'From: ${sender.email ?? 'Unknown'}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: message['type'] == 'venue_share' &&
                            message['venueId'] != null
                        ? IconButton(
                            icon: const Icon(Icons.location_on,
                                color: Colors.white54),
                            onPressed: () async {
                              final venue =
                                  await _fetchVenue(message['venueId']);
                              if (venue != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VenueScreen(
                                      event: Event(venueId: venue.id),
                                    ),
                                  ),
                                );
                                await _markAsRead(messageId);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Venue not found.')),
                                );
                              }
                            },
                          )
                        : null,
                    onTap: () async {
                      if (!isRead) {
                        await _markAsRead(messageId);
                      }
                    },
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
