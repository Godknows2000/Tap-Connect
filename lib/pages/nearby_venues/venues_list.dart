import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tapconnect/models/nearby_venues.dart';
import 'package:tapconnect/models/upcoming_events_model.dart';
import 'package:tapconnect/models/venues.dart';

class VenueScreen extends StatelessWidget {
  final Event event;

  const VenueScreen({super.key, required this.event});

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

  Future<void> _checkIn(BuildContext context) async {
    if (event.isGoing ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checked in successfully!')),
      );
      await FirebaseFirestore.instance
          .collection('events')
          .doc(event.id)
          .update({
        'checkedIn': true,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please mark as Going first.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Venue?>(
      future: _fetchVenue(event.venueId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('Venue not found')),
          );
        }

        final venue = snapshot.data!;

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: const Color(0xFF1A1A1A),
            appBar: AppBar(
              backgroundColor: const Color(0xFF1A1A1A),
              elevation: 0,
              title: Row(
                children: [
                  Image.asset(
                    'assets/venue_icon.png',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    venue.name!,
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sharing venue')),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                TabBar(
                  labelColor: const Color(0xFFFFD700),
                  unselectedLabelColor: Colors.white54,
                  indicatorColor: const Color(0xFFFFD700),
                  tabs: const [
                    Tab(icon: Icon(Icons.menu_book), text: 'MENUS'),
                    Tab(icon: Icon(Icons.event), text: 'EVENTS'),
                    Tab(icon: Icon(Icons.share), text: 'SHARE'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // MENUS Tab
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${venue.operatingHours ?? 'Open Today • 8AM - 6PM'}',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => _checkIn(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: const Text('CHECK-IN HERE'),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'MENUS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Updated ${DateFormat('MMM d, yyyy').format(DateTime.now())} at 9:44 AM',
                                      style: const TextStyle(
                                          color: Colors.white54, fontSize: 12),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.local_drink,
                                            color: Colors.white70, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${venue.beersCount ?? 0} Beers',
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.fastfood,
                                            color: Colors.white70, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${venue.foodItemsCount ?? 0} Food Items',
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.wine_bar,
                                            color: Colors.white70, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${venue.winesCount ?? 0} Wines',
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (venue.menuItems != null &&
                                        venue.menuItems!.isNotEmpty)
                                      ...venue.menuItems!.map((item) => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['name'],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                              const SizedBox(height: 4),
                                            ],
                                          )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // EVENTS Tab (Placeholder)
                      const Center(
                        child: Text(
                          'Events content here',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                      // SHARE Tab (Placeholder)
                      const Center(
                        child: Text(
                          'Share content here',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
