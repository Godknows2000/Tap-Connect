import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tapconnect/models/upcoming_events_model.dart';
import 'package:tapconnect/models/venues.dart';
import 'package:tapconnect/models/user_model.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  GoogleMapController? mapController;
  Venue? venue;
  List<UserModel> friends = [];
  List<String> selectedFriendIds = [];

  @override
  void initState() {
    super.initState();
    _fetchVenue();
    _fetchFriends();
  }

  Future<void> _fetchVenue() async {
    if (widget.event.venueId == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('venues')
        .doc(widget.event.venueId)
        .get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      setState(() {
        venue = Venue.fromJson(data);
      });
    }
  }

  Future<void> _fetchFriends() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();
    if (userDoc.exists) {
      final user = UserModel.fromJson(userDoc.data()!);
      final friendIds = user.friends ?? [];
      final friendDocs = await Future.wait(
        friendIds.map((id) =>
            FirebaseFirestore.instance.collection('users').doc(id).get()),
      );
      setState(() {
        friends = friendDocs
            .where((doc) => doc.exists)
            .map((doc) => UserModel.fromJson(doc.data()!..['uid'] = doc.id))
            .toList();
      });
    }
  }

  Future<void> _shareEvent() async {
    if (friends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have no friends to share with.')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Event with Friends'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: friends.map((friend) {
                return CheckboxListTile(
                  title: Text(friend.email ?? 'Unknown',
                      style: const TextStyle(color: Colors.black)),
                  value: selectedFriendIds.contains(friend.uid),
                  onChanged: (bool? value) {
                    setDialogState(() {
                      if (value == true) {
                        selectedFriendIds.add(friend.uid!);
                      } else {
                        selectedFriendIds.remove(friend.uid);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (selectedFriendIds.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please select at least one friend.')),
                );
                return;
              }
              final currentUserId = FirebaseAuth.instance.currentUser?.uid;
              if (currentUserId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('You must be logged in to share.')),
                );
                return;
              }
              final messageContent =
                  'Check out this event: ${widget.event.title} on ${widget.event.date} at ${widget.event.time} at ${venue?.name ?? 'the venue'}';
              for (var friendId in selectedFriendIds) {
                final chatId = [currentUserId, friendId]..sort();
                final chatDocId = chatId.join('_');
                final chatRef = FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatDocId);
                final chatSnapshot = await chatRef.get();
                if (!chatSnapshot.exists) {
                  await chatRef.set({
                    'participants': [currentUserId, friendId],
                    'messages': [],
                  });
                }
                await chatRef.update({
                  'messages': FieldValue.arrayUnion([
                    {
                      'senderId': currentUserId,
                      'content': messageContent,
                      'timestamp': Timestamp.now(),
                      'eventId': widget.event.id,
                    }
                  ]),
                });
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Event shared with selected friends!')),
              );
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _toggleInterested() async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id)
        .update({
      'isInterested': !(widget.event.isInterested ?? false),
    });
    setState(() {});
  }

  void _toggleGoing() async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id)
        .update({
      'isGoing': !(widget.event.isGoing ?? false),
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Event',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event.title ?? 'Untitled Event',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.event.date} • ${widget.event.time}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            venue?.name ?? 'Loading venue...',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'ADD TO CALENDAR',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _toggleInterested,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            color: (widget.event.isInterested ?? false)
                                ? const Color(0xFFFFD700)
                                : Colors.white54,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Interested',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _toggleGoing,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: (widget.event.isGoing ?? false)
                                ? Colors.green
                                : Colors.white54,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Going',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _shareEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.share,
                            color: Colors.white54,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Share',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'WHERE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: venue != null &&
                        venue!.latitude != null &&
                        venue!.longitude != null
                    ? GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(venue!.latitude!, venue!.longitude!),
                          zoom: 15,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                        markers: {
                          Marker(
                            markerId: MarkerId(widget.event.venueId!),
                            position:
                                LatLng(venue!.latitude!, venue!.longitude!),
                            infoWindow:
                                InfoWindow(title: venue!.name ?? 'Venue'),
                          ),
                        },
                      )
                    : const Center(
                        child: Text(
                          'Loading map or venue location unavailable...',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'GOING',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${widget.event.isGoing == true ? 1 : 0}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'INTERESTED',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${widget.event.isInterested == true ? 1 : 0}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
