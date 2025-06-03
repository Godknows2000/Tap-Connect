import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tapconnect/models/upcoming_events_model.dart';
import 'package:tapconnect/models/venues.dart';
import 'package:tapconnect/pages/nearby_venues/venues_list.dart';
import 'package:tapconnect/pages/upcoming_events/event_details_screen.dart';
import 'add_venue.dart';
import 'package:tapconnect/pages/upcoming_events/upcoming_events_list.dart';

class NearbyEventsScreen extends StatefulWidget {
  const NearbyEventsScreen({super.key});

  @override
  State<NearbyEventsScreen> createState() => _NearbyEventsScreenState();
}

class _NearbyEventsScreenState extends State<NearbyEventsScreen> {
  final DateTime now =
      DateTime(2025, 5, 31, 13, 0); // Current date: May 31, 2025, 01:00 PM BST
  final double userLat = 51.5074; // User's latitude (London, UK)
  final double userLon = -0.1278; // User's longitude (London, UK)

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

  Future<Venue?> _fetchVenue(String venueId) async {
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

  @override
  Widget build(BuildContext context) {
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where('timestamp', isGreaterThanOrEqualTo: now)
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
              final venue = await _fetchVenue(event.venueId!);
              double distance = venue != null &&
                      venue.latitude != null &&
                      venue.longitude != null
                  ? calculateDistance(
                      userLat, userLon, venue.latitude!, venue.longitude!)
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
                    'No events with valid venues found.\nTry adding a new venue and event!',
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
                                'assets/venue_icon.png',
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
                                    venue?.name ?? 'Unknown Venue',
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
                MaterialPageRoute(
                    builder: (context) => const UpcomingEventsScreen()),
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
