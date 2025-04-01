import 'package:flutter/material.dart';
import 'package:tapconnect/contollers/firebase_controller.dart'; // Updated import
import 'package:tapconnect/pages/beers/beer_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase

class TrendingBeer extends StatefulWidget {
  const TrendingBeer({super.key});

  @override
  _TrendingBeerState createState() => _TrendingBeerState();
}

class _TrendingBeerState extends State<TrendingBeer> {
  String _searchQuery = '';

  void _filterBeers(String query) {
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Trending Beers',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: _filterBeers,
              decoration: InputDecoration(
                hintText: 'Search beers by name, type, or location',
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
          // Filter Buttons
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
                        'Beer Type',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: BeerData.streamBeers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }
                    final totalBeers = snapshot.data?.docs.length ?? 0;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$totalBeers',
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
          // Beer Grid or Not Found Message
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: BeerData.streamBeers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading beers'));
                }
                final allBeers = snapshot.data?.docs ?? [];

                // Filter beers based on search query
                final filteredBeers = _searchQuery.isEmpty
                    ? allBeers
                    : allBeers.where((doc) {
                        final beer = doc.data() as Map<String, dynamic>;
                        return beer['name']
                                    ?.toLowerCase()
                                    .contains(_searchQuery) ==
                                true ||
                            beer['type']
                                    ?.toLowerCase()
                                    .contains(_searchQuery) ==
                                true ||
                            beer['location']
                                    ?.toLowerCase()
                                    .contains(_searchQuery) ==
                                true;
                      }).toList();

                // Sort beers by rating in descending order
                filteredBeers.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;
                  final aRating = (aData['rating'] as num?)?.toDouble() ?? 0.0;
                  final bRating = (bData['rating'] as num?)?.toDouble() ?? 0.0;
                  return bRating.compareTo(aRating); // Descending order
                });

                return filteredBeers.isEmpty
                    ? const Center(
                        child: Text(
                          'Not found',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 columns
                          crossAxisSpacing: 16.0, // Horizontal spacing
                          mainAxisSpacing: 16.0, // Vertical spacing
                          childAspectRatio:
                              0.9, // Increased to prevent overflow
                        ),
                        padding: const EdgeInsets.all(16.0),
                        itemCount: filteredBeers.length,
                        itemBuilder: (context, index) {
                          final doc = filteredBeers[index];
                          final beer = doc.data() as Map<String, dynamic>;
                          return _buildBeerCard(
                            context,
                            beer['imagePath'] ?? '',
                            beer['name'] ?? 'Unknown Beer',
                            beer['type'] ?? 'Unknown Type',
                            beer['location'] ?? 'Unknown Location',
                            (beer['rating'] as num?)?.toDouble() ?? 0.0,
                            (beer['ratingCount'] as num?)?.toInt() ?? 0,
                            beer['price'] ?? 'N/A',
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

  Widget _buildBeerCard(
    BuildContext context,
    String imagePath,
    String name,
    String type,
    String location,
    double rating,
    int ratingCount,
    String price, {
    required int rank,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BeerDetailScreen(
              imagePath: imagePath,
              title: name,
              subtitle: price,
              type: type,
              location: location,
              rating: rating,
              ratingCount: ratingCount,
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
            // Beer Image with Rank Overlay
            Stack(
              children: [
                Container(
                  height: 100, // Reduced height to fit within grid cell
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    image: DecorationImage(
                      image: NetworkImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 24, // Reduced size for better fit
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
                          fontSize: 14, // Reduced font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Beer Info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14, // Reduced font size
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2), // Reduced spacing

                  Text(
                    location,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10, // Reduced font size
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4), // Reduced spacing
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < (rating / 5 * 5).round()
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color(0xFFFFD700),
                            size: 14, // Reduced star size
                          );
                        }),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10, // Reduced font size
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2), // Reduced spacing
                  Text(
                    '$ratingCount ratings',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10, // Reduced font size
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
