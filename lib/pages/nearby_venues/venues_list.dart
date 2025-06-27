import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:tapconnect/models/upcoming_events_model.dart';
import 'package:tapconnect/models/venues.dart';
import 'package:tapconnect/models/user_model.dart';
import 'package:tapconnect/pages/venue_map_share/venue_map_share.dart';

class VenueScreen extends StatelessWidget {
  final Event event;

  const VenueScreen({super.key, required this.event});

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

  Future<void> _checkIn(BuildContext context) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to check in.')),
      );
      return;
    }
    if (event.isGoing ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checked in successfully!')),
      );
      await FirebaseFirestore.instance
          .collection('events')
          .doc(event.id)
          .update({
        'checkedIn': true,
        'checkedInBy': FieldValue.arrayUnion([currentUserId]),
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please mark as Going first.')),
      );
    }
  }

  Future<void> _shareVenue(BuildContext context, Venue venue) async {
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
        title: const Text('Share Venue'),
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
                            'type': 'venue_share',
                            'venueId': venue.id,
                            'message': 'Check out this venue: ${venue.name}',
                            'timestamp': FieldValue.serverTimestamp(),
                            'read': false,
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Venue shared via message!')),
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
    return FutureBuilder<Venue?>(
      future: _fetchVenue(event.venueId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final venue = snapshot.data;

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: const Color(0xFF1A1A1A),
            appBar: AppBar(
              backgroundColor: const Color(0xFF1A1A1A),
              elevation: 0,
              title: Row(
                children: [
                  Image.asset(
                    'assets/club-2.jpg',
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    venue?.name ?? 'No Venue Specified',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                if (venue != null)
                  IconButton(
                    icon: const Icon(Icons.map, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VenueMapShareScreen(venue: venue),
                        ),
                      );
                    },
                  ),
                if (venue != null)
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      _shareVenue(context, venue);
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
                    Tab(icon: Icon(Icons.rate_review), text: 'REVIEWS'),
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
                                venue?.operatingHours ?? 'N/A',
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
                                          '${venue?.beersCount ?? 0} Beers',
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
                                          '${venue?.foodItemsCount ?? 0} Food Items',
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
                                          '${venue?.winesCount ?? 0} Wines',
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (venue?.menuItems != null &&
                                        venue!.menuItems!.isNotEmpty)
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
                      // EVENTS Tab
                      const Center(
                        child: Text(
                          'Events content here',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                      // REVIEWS Tab
                      venue != null
                          ? StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('venues')
                                  .doc(venue.id)
                                  .collection('reviews')
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError || !snapshot.hasData) {
                                  return const Center(
                                      child: Text('No reviews available',
                                          style: TextStyle(
                                              color: Colors.white70)));
                                }
                                final reviews = snapshot.data!.docs;
                                return ListView.builder(
                                  itemCount: reviews.length,
                                  itemBuilder: (context, index) {
                                    final review = reviews[index].data()
                                        as Map<String, dynamic>;
                                    return ListTile(
                                      title: Text(
                                        'Rating: ${review['rating'].toStringAsFixed(1)}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        review['review'] ?? 'No review text',
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                      trailing: FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(review['userId'])
                                            .get(),
                                        builder: (context, userSnapshot) {
                                          if (!userSnapshot.hasData)
                                            return const SizedBox.shrink();
                                          final user = UserModel.fromJson(
                                              userSnapshot.data!.data()
                                                  as Map<String, dynamic>);
                                          return Text(
                                            user.email ?? 'Anonymous',
                                            style: const TextStyle(
                                                color: Colors.white54),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                'No venue available',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16),
                              ),
                            ),
                      // SHARE Tab
                      venue != null
                          ? VenueMapShareScreen(venue: venue)
                          : const Center(
                              child: Text(
                                'No venue to share',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16),
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
