import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tapconnect/models/upcoming_events_model.dart';
import 'package:tapconnect/pages/upcoming_events/event_details_screen.dart';
import 'package:tapconnect/pages/upcoming_events/event_venue.dart';

class UpcomingEventsScreen extends StatefulWidget {
  const UpcomingEventsScreen({super.key});

  @override
  State<UpcomingEventsScreen> createState() => _UpcomingEventsScreenState();
}

class _UpcomingEventsScreenState extends State<UpcomingEventsScreen> {
  final DateTime now =
      DateTime(2025, 5, 31, 9, 30); // Current date: May 31, 2025, 09:30 AM BST

  Future<void> _addEvent(BuildContext context) async {
    DateTime? selectedDate = now;
    TimeOfDay? selectedTime = TimeOfDay.now();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController venueController = TextEditingController();
    final TextEditingController beersController = TextEditingController();
    final TextEditingController foodController = TextEditingController();
    final TextEditingController winesController = TextEditingController();
    final TextEditingController menuItemController = TextEditingController();

    List<Map<String, dynamic>> menuItems = [];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Select Date'),
                subtitle:
                    Text(DateFormat('EEE, MMM d, yyyy').format(selectedDate!)),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: now,
                    lastDate: DateTime(2026),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Select Time'),
                subtitle: Text(selectedTime!.format(context)),
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: selectedTime!,
                  );
                  if (pickedTime != null && pickedTime != selectedTime) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: venueController,
                decoration: const InputDecoration(labelText: 'Venue'),
              ),
              TextField(
                controller: beersController,
                decoration: const InputDecoration(labelText: 'Number of Beers'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: foodController,
                decoration:
                    const InputDecoration(labelText: 'Number of Food Items'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: winesController,
                decoration: const InputDecoration(labelText: 'Number of Wines'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: menuItemController,
                decoration: const InputDecoration(
                    labelText: 'Add Menu Item (e.g., Beer Name)'),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    menuItems
                        .add({'name': value, 'type': 'Beer', 'rating': 0.0});
                    menuItemController.clear();
                  }
                },
              ),
              const SizedBox(height: 8),
              Wrap(
                children: menuItems
                    .map((item) => Chip(
                          label: Text(item['name']),
                          onDeleted: () {
                            menuItems.remove(item);
                            setState(() {});
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final eventDateTime = DateTime(
                selectedDate!.year,
                selectedDate!.month,
                selectedDate!.day,
                selectedTime!.hour,
                selectedTime!.minute,
              );
              await FirebaseFirestore.instance.collection('events').add({
                'date': DateFormat('EEE, MMM d, yyyy').format(selectedDate!),
                'time': selectedTime?.format(context),
                'title': titleController.text,
                'venue': venueController.text,
                'timestamp': eventDateTime,
                'isInterested': false,
                'isGoing': false,
                'checkedIn': false,
                'beersCount': int.tryParse(beersController.text) ?? 0,
                'foodItemsCount': int.tryParse(foodController.text) ?? 0,
                'winesCount': int.tryParse(winesController.text) ?? 0,
                'menuItems': menuItems,
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _toggleInterested(Event event) async {
    await FirebaseFirestore.instance.collection('events').doc(event.id).update({
      'isInterested': !(event.isInterested ?? false),
    });
  }

  void _toggleGoing(Event event) async {
    await FirebaseFirestore.instance.collection('events').doc(event.id).update({
      'isGoing': !(event.isGoing ?? false),
    });
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

  void _shareEvent(Event event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${event.title}')),
    );
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
                        .where('timestamp', isGreaterThanOrEqualTo: now)
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
                        return Event.fromJson(data);
                      }).toList();
                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return EventCard(
                            event: event,
                            onInterested: () => _toggleInterested(event),
                            onGoing: () => _toggleGoing(event),
                            onCheckIn: () => _checkIn(event),
                            onShare: () => _shareEvent(event),
                          );
                        },
                      );
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('events')
                        .where('timestamp', isLessThan: now)
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
                        return Event.fromJson(data);
                      }).toList();
                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return EventCard(
                            event: event,
                            onInterested: () => _toggleInterested(event),
                            onGoing: () => _toggleGoing(event),
                            onCheckIn: () => _checkIn(event),
                            onShare: () => _shareEvent(event),
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
        onPressed: () => _addEvent(context),
        backgroundColor: const Color(0xFFFFD700),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onInterested;
  final VoidCallback onGoing;
  final VoidCallback onCheckIn;
  final VoidCallback onShare;

  const EventCard({
    super.key,
    required this.event,
    required this.onInterested,
    required this.onGoing,
    required this.onCheckIn,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Venue Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/venue_icon.png', // Ensure this asset is added
                color: Colors.black,
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Event Details
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
                    event.title!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.venue!,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Action Buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.bookmark_border,
                    color: Colors.white54,
                    size: 24,
                  ),
                  onPressed: onInterested,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white54,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsScreen(event: event),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
