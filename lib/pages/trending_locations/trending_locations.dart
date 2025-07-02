import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tapconnect/models/upcoming_events_model.dart';
import 'package:tapconnect/models/user_model.dart';
import 'package:tapconnect/models/venues.dart';
import 'package:tapconnect/pages/friend_management/friend_management.dart';
import 'package:tapconnect/pages/nearby_venues/venues_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrendingLocations extends StatefulWidget {
  const TrendingLocations({super.key});

  @override
  _TrendingLocationsState createState() => _TrendingLocationsState();
}

class _TrendingLocationsState extends State<TrendingLocations> {
  String _searchQuery = '';
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

  void _filterVenues(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  Future<void> _rateVenue(Venue venue, double rating, String review) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to rate venues.')),
      );
      return;
    }
    final reviewData = {
      'userId': currentUserId,
      'rating': rating,
      'review': review,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await FirebaseFirestore.instance
        .collection('venues')
        .doc(venue.id)
        .collection('reviews')
        .add(reviewData);

    final reviewsSnapshot = await FirebaseFirestore.instance
        .collection('venues')
        .doc(venue.id)
        .collection('reviews')
        .get();
    final ratings = reviewsSnapshot.docs
        .map((doc) => (doc.data()['rating'] as num).toDouble())
        .toList();
    final averageRating = ratings.isNotEmpty
        ? ratings.reduce((a, b) => a + b) / ratings.length
        : 0.0;
    await FirebaseFirestore.instance.collection('venues').doc(venue.id).update({
      'rating': averageRating,
      'ratingCount': ratings.length,
    });
  }

  Future<void> _shareVenue(Venue venue) async {
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
                              .collection('notifications')
                              .add({
                            'userId': friendId,
                            'type': 'venue_share',
                            'venueId': venue.id,
                            'message': 'Check out this venue: ${venue.name}',
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Venue shared!')),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Trending Locations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
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
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: _filterVenues,
              decoration: InputDecoration(
                hintText: 'Search venues by name or location',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.tune, color: Colors.white),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: _getUserLocation,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Refresh Location',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('venues')
                      .snapshots(),
                  builder: (context, snapshot) {
                    final totalVenues =
                        snapshot.hasData && snapshot.data!.docs.isNotEmpty
                            ? snapshot.data!.docs.length
                            : Venue.dummyVenues.length;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$totalVenues',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('venues').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                List<dynamic> venues = [];
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  venues = snapshot.data!.docs;
                } else {
                  venues = Venue.dummyVenues;
                }
                final filteredVenues = _searchQuery.isEmpty
                    ? venues
                    : venues.where((doc) {
                        final venue = doc is QueryDocumentSnapshot
                            ? Venue.fromJson(doc.data() as Map<String, dynamic>)
                            : doc as Venue;
                        return (venue.name
                                    ?.toLowerCase()
                                    .contains(_searchQuery) ??
                                false) ||
                            (venue.address
                                    ?.toLowerCase()
                                    .contains(_searchQuery) ??
                                false);
                      }).toList();

                final venueList = filteredVenues.map((doc) {
                  final venue = doc is QueryDocumentSnapshot
                      ? Venue.fromJson(doc.data() as Map<String, dynamic>)
                      : doc as Venue;
                  final distance = venue.latitude != null &&
                          venue.longitude != null
                      ? calculateDistance(
                          userLat!, userLon!, venue.latitude!, venue.longitude!)
                      : double.infinity;
                  return {'venue': venue, 'distance': distance};
                }).toList();

                venueList.sort((a, b) => (a['distance'] as double)
                    .compareTo(b['distance'] as double)); // Sort by distance

                return venueList.isEmpty
                    ? const Center(
                        child: Text(
                          'No trending venues found',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.75,
                        ),
                        padding: const EdgeInsets.all(16.0),
                        itemCount: venueList.length,
                        itemBuilder: (context, index) {
                          final venueData = venueList[index];
                          final venue = venueData['venue'] as Venue;
                          final distance = venueData['distance'] as double;
                          return _buildVenueCard(
                            context,
                            venue,
                            rank: index + 1,
                            distance: distance,
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenueCard(
    BuildContext context,
    Venue venue, {
    required int rank,
    required double distance,
  }) {
    final reviewController = TextEditingController();
    double selectedRating = 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VenueScreen(
              event: Event(venueId: venue.id),
            ),
          ),
        );
      },
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    image: DecorationImage(
                      image: NetworkImage(
                        venue.imagePath?.isNotEmpty == true
                            ? venue.imagePath!
                            : 'assets/placeholder.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        '$rank',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name ?? 'Unknown Venue',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    venue.address ?? 'Unknown Address',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    distance == double.infinity
                        ? 'Distance unknown'
                        : '${distance.toStringAsFixed(1)} km away',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < (venue.rating ?? 0.0).round()
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color(0xFFFFD700),
                            size: 16,
                          );
                        }),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        (venue.rating ?? 0.0).toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${venue.ratingCount ?? 0})',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white54),
                        onPressed: () => _shareVenue(venue),
                      ),
                      IconButton(
                        icon: const Icon(Icons.rate_review,
                            color: Colors.white54),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Rate & Review'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Slider(
                                    value: selectedRating,
                                    min: 0,
                                    max: 5,
                                    divisions: 5,
                                    label: selectedRating.toStringAsFixed(1),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedRating = value;
                                      });
                                    },
                                  ),
                                  TextField(
                                    controller: reviewController,
                                    decoration: const InputDecoration(
                                      labelText: 'Write a review',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await _rateVenue(venue, selectedRating,
                                        reviewController.text);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Review submitted!')),
                                    );
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
