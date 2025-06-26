import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tapconnect/models/upcoming_events_model.dart';
import 'package:tapconnect/models/venues.dart';
import 'package:tapconnect/pages/nearby_venues/venues_list.dart';

class TrendingLocations extends StatefulWidget {
  const TrendingLocations({super.key});

  @override
  _TrendingLocationsState createState() => _TrendingLocationsState();
}

class _TrendingLocationsState extends State<TrendingLocations> {
  String _searchQuery = '';

  void _filterVenues(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Nearby',
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
                List<dynamic> filteredVenues = [];
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  final allVenues = snapshot.data!.docs;
                  filteredVenues = _searchQuery.isEmpty
                      ? allVenues
                      : allVenues.where((doc) {
                          final venue = doc.data() as Map<String, dynamic>;
                          return (venue['name']
                                      ?.toLowerCase()
                                      ?.contains(_searchQuery) ??
                                  false) ||
                              (venue['address']
                                      ?.toLowerCase()
                                      ?.contains(_searchQuery) ??
                                  false);
                        }).toList();
                } else {
                  filteredVenues = _searchQuery.isEmpty
                      ? Venue.dummyVenues
                      : Venue.dummyVenues.where((venue) {
                          return (venue.name
                                      ?.toLowerCase()
                                      .contains(_searchQuery) ??
                                  false) ||
                              (venue.address
                                      ?.toLowerCase()
                                      .contains(_searchQuery) ??
                                  false);
                        }).toList();
                }

                filteredVenues.sort((a, b) {
                  final aCheckInCount = (a is QueryDocumentSnapshot
                          ? (a.data() as Map<String, dynamic>)['checkInCount']
                          : a.checkInCount) as num? ??
                      0;
                  final bCheckInCount = (b is QueryDocumentSnapshot
                          ? (b.data() as Map<String, dynamic>)['checkInCount']
                          : b.checkInCount) as num? ??
                      0;
                  return bCheckInCount.compareTo(aCheckInCount);
                });

                return filteredVenues.isEmpty
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
                        itemCount: filteredVenues.length,
                        itemBuilder: (context, index) {
                          final venue =
                              filteredVenues[index] is QueryDocumentSnapshot
                                  ? Venue.fromJson(filteredVenues[index].data()
                                      as Map<String, dynamic>)
                                  : filteredVenues[index] as Venue;
                          return _buildVenueCard(
                            context,
                            venue,
                            rank: index + 1,
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
  }) {
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
                      image: AssetImage(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
