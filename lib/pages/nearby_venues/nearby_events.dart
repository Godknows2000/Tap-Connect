import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tapconnect/models/upcoming_events_model.dart';
import 'package:tapconnect/models/user_model.dart';
import 'package:tapconnect/models/venues.dart';
import 'package:tapconnect/pages/friend_management/friend_management.dart';
import 'package:tapconnect/pages/nearby_venues/add_venue.dart';
import 'package:tapconnect/pages/nearby_venues/venues_list.dart';
import 'package:tapconnect/pages/upcoming_events/add_event.dart';
import 'package:tapconnect/pages/upcoming_events/event_details_screen.dart';

class NearbyEventsScreen extends StatefulWidget {
  const NearbyEventsScreen({super.key});

  @override
  State<NearbyEventsScreen> createState() => _NearbyEventsScreenState();
}

class _NearbyEventsScreenState extends State<NearbyEventsScreen> {
  double? userLat;
  double? userLon;
  bool isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() {
      isLoadingLocation = true;
    });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied.';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        userLat = position.latitude;
        userLon = position.longitude;
        isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        isLoadingLocation = false;
        userLat = 51.5074; // Fallback to London
        userLon = -0.1278;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius of the Earth in km
    double dLat = (lat2 - lat1) * (pi / 180.0);
    double dLon = (lon2 - lon1) * (pi / 180.0);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180.0)) *
            cos(lat2 * (pi / 180.0)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distance in km
  }

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

  void _checkIn(Event event) async {
    if (event.isGoing ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VenueScreen(event: event),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please mark as Going first.')),
      );
    }
  }

  Future<void> _shareEvent(Event event, Venue? venue) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to share.')),
      );
      return;
    }
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();
    final user = UserModel.fromJson(userDoc.data()!);
    final friends = user.friends ?? [];
    if (friends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No friends to share with.')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: friends
              .map((friendId) => FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(friendId)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();
                      final friend = UserModel.fromJson(
                          snapshot.data!.data() as Map<String, dynamic>);
                      return ListTile(
                        title: Text(friend.email ?? 'Unknown'),
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection('messages')
                              .add({
                            'senderId': currentUserId,
                            'receiverId': friendId,
                            'type': 'event_share',
                            'eventId': event.id,
                            'venueId': venue?.id,
                            'message': 'Check out this event: ${event.title}',
                            'timestamp': FieldValue.serverTimestamp(),
                            'read': false,
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Event shared via message!')),
                          );
                        },
                      );
                    },
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingLocation) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Nearby Events',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: () {
              final currentUserId = FirebaseAuth.instance.currentUser?.uid;
              if (currentUserId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('You must be logged in to manage friends.')),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendManagementScreen(
                    currentUserId: currentUserId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where('timestamp', isGreaterThanOrEqualTo: DateTime.now())
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error fetching events.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No upcoming events available.\nTry adding a new event or venue!',
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          }

          final events = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return Event.fromJson(data);
          }).toList();

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: Future.wait(events.map((event) async {
              final venue = await _fetchVenue(event.venueId);
              double distance = venue != null &&
                      venue.latitude != null &&
                      venue.longitude != null
                  ? calculateDistance(
                      userLat!, userLon!, venue.latitude!, venue.longitude!)
                  : double.infinity;
              return {
                'event': event,
                'venue': venue,
                'distance': distance,
              };
            })),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Error calculating distances.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                );
              }

              final eventList = snapshot.data ?? [];
              if (eventList.isEmpty) {
                return const Center(
                  child: Text(
                    'No events found.\nTry adding a new venue and event!',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              eventList.sort((a, b) =>
                  a['distance'].compareTo(b['distance'])); // Sort by distance

              return ListView.builder(
                itemCount: eventList.length,
                itemBuilder: (context, index) {
                  final eventData = eventList[index];
                  final event = eventData['event'] as Event;
                  final venue = eventData['venue'] as Venue?;
                  final distance = eventData['distance'] as double;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventDetailsScreen(event: event),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD700),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                'assets/club-2.jpg',
                                color: Colors.black,
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${event.date} • ${event.time}',
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    event.title!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    venue?.name ?? 'No Venue Specified',
                                    style: const TextStyle(
                                        color: Colors.white54, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    distance == double.infinity
                                        ? 'Distance unknown'
                                        : '${distance.toStringAsFixed(1)} km away',
                                    style: const TextStyle(
                                        color: Colors.white54, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.check_circle_outline,
                                    color: (event.isGoing ?? false)
                                        ? Colors.green
                                        : Colors.white54,
                                    size: 24,
                                  ),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('events')
                                        .doc(event.id)
                                        .update({
                                      'isGoing': !(event.isGoing ?? false),
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.directions,
                                    color: Colors.white54,
                                    size: 24,
                                  ),
                                  onPressed: () => _checkIn(event),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.white54,
                                    size: 24,
                                  ),
                                  onPressed: () => _shareEvent(event, venue),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFFFD700),
        child: PopupMenuButton<String>(
          icon: const Icon(Icons.add, color: Colors.black),
          onSelected: (value) {
            if (value == 'event') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddEventScreen()),
              );
            } else if (value == 'venue') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddVenueScreen()),
              );
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'event',
              child: Text('Add Event'),
            ),
            const PopupMenuItem<String>(
              value: 'venue',
              child: Text('Add Venue'),
            ),
          ],
        ),
      ),
    );
  }
}
