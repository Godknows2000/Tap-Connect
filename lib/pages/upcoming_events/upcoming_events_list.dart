import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tapconnect/models/upcoming_events_model.dart'
    as upcoming_events;
import 'package:tapconnect/pages/nearby_venues/venues_list.dart';
import 'package:tapconnect/pages/upcoming_events/add_event.dart';
import 'package:tapconnect/pages/upcoming_events/event_details_screen.dart';

class UpcomingEventsScreen extends StatefulWidget {
  const UpcomingEventsScreen({super.key});

  @override
  State<UpcomingEventsScreen> createState() => _UpcomingEventsScreenState();
}

class _UpcomingEventsScreenState extends State<UpcomingEventsScreen> {
  final DateTime now = DateTime.now(); // Use real current time

  void _toggleInterested(upcoming_events.Event event) async {
    await FirebaseFirestore.instance.collection('events').doc(event.id).update({
      'isInterested': !(event.isInterested ?? false),
    });
    setState(() {}); // Refresh UI
  }

  void _toggleGoing(upcoming_events.Event event) async {
    await FirebaseFirestore.instance.collection('events').doc(event.id).update({
      'isGoing': !(event.isGoing ?? false),
    });
    setState(() {}); // Refresh UI
  }

  void _checkIn(upcoming_events.Event event) async {
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

  Future<String?> _fetchVenueName(String? venueId) async {
    if (venueId == null || venueId.isEmpty) return 'Unknown Venue';
    final doc = await FirebaseFirestore.instance
        .collection('venues')
        .doc(venueId)
        .get();
    if (doc.exists) {
      return doc.data()!['name'] as String?;
    }
    return 'Unknown Venue';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Events',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              labelColor: Color(0xFFFFD700),
              unselectedLabelColor: Colors.white54,
              indicatorColor: Color(0xFFFFD700),
              tabs: [
                Tab(text: 'CURRENT'),
                Tab(text: 'PAST'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('events')
                        .where('timestamp',
                            isGreaterThanOrEqualTo: Timestamp.fromDate(now))
                        .orderBy('timestamp')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No upcoming events available.',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        );
                      }
                      final events = snapshot.data!.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        data['id'] = doc.id;
                        return upcoming_events.Event.fromJson(data);
                      }).toList();
                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return FutureBuilder<String?>(
                            future: _fetchVenueName(event.venueId),
                            builder: (context, venueSnapshot) {
                              return EventCard(
                                event: event,
                                venueName:
                                    venueSnapshot.data ?? 'Unknown Venue',
                                onInterested: () => _toggleInterested(event),
                                onGoing: () => _toggleGoing(event),
                                onCheckIn: () => _checkIn(event),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('events')
                        .where('timestamp', isLessThan: Timestamp.fromDate(now))
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No past events available.',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        );
                      }
                      final events = snapshot.data!.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        data['id'] = doc.id;
                        return upcoming_events.Event.fromJson(data);
                      }).toList();
                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return FutureBuilder<String?>(
                            future: _fetchVenueName(event.venueId),
                            builder: (context, venueSnapshot) {
                              return EventCard(
                                event: event,
                                venueName:
                                    venueSnapshot.data ?? 'Unknown Venue',
                                onInterested: () => _toggleInterested(event),
                                onGoing: () => _toggleGoing(event),
                                onCheckIn: () => _checkIn(event),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventScreen()),
          );
        },
        backgroundColor: const Color(0xFFFFD700),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final upcoming_events.Event event;
  final String venueName;
  final VoidCallback onInterested;
  final VoidCallback onGoing;
  final VoidCallback onCheckIn;

  const EventCard({
    super.key,
    required this.event,
    required this.venueName,
    required this.onInterested,
    required this.onGoing,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsScreen(event: event),
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
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.title ?? 'Untitled Event',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      venueName,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.bookmark_border,
                      color: (event.isInterested ?? false)
                          ? const Color(0xFFFFD700)
                          : Colors.white54,
                      size: 24,
                    ),
                    onPressed: onInterested,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: (event.isGoing ?? false)
                          ? Colors.green
                          : Colors.white54,
                      size: 24,
                    ),
                    onPressed: onGoing,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
