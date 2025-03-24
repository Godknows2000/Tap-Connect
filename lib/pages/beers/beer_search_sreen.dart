import 'package:flutter/material.dart';
import 'package:tapconnect/constants.dart';
import 'package:tapconnect/models/beers_data.dart';
import 'package:tapconnect/pages/beers/beer_details.dart';
// Import the shared beer data

class BrewerySearchScreen extends StatefulWidget {
  const BrewerySearchScreen({super.key});

  @override
  _BrewerySearchScreenState createState() => _BrewerySearchScreenState();
}

class _BrewerySearchScreenState extends State<BrewerySearchScreen> {
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredBeers = BeerData.beers;

  void _filterBeers(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredBeers = BeerData.beers;
      } else {
        _filteredBeers = BeerData.beers
            .where((beer) =>
                beer['name'].toLowerCase().contains(query.toLowerCase()) ||
                beer['type'].toLowerCase().contains(query.toLowerCase()) ||
                beer['location'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark background
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
          'Search Beers',
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
                      onPressed: () {
                        // Add filter functionality
                      },
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        // Add nearby functionality
                      },
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
                      onPressed: () {
                        // Add beer type functionality
                      },
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_filteredBeers.length} Results',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Beer List or Not Found Message
          Expanded(
            child: _filteredBeers.isEmpty
                ? const Center(
                    child: Text(
                      'Beer not found',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredBeers.length,
                    itemBuilder: (context, index) {
                      final beer = _filteredBeers[index];
                      return _buildBeerCard(
                        context,
                        beer['imagePath'],
                        beer['name'],
                        beer['type'],
                        beer['location'],
                        beer['rating'].toDouble(),
                        beer['ratingCount'],
                        beer['price'],
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1A1A),
        selectedItemColor: const Color(0xFFFFD700), // Golden for selected
        unselectedItemColor: Colors.black,
        currentIndex: 2, // Discover tab is selected
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Add navigation logic for each tab
        },
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
    String price,
  ) {
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Beer Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Beer Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        location,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Rating Stars
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < (rating / 5 * 5).round()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: const Color(0xFFFFD700), // Golden stars
                                size: 20,
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            rating.toStringAsFixed(2) + ' AVG',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$ratingCount ratings',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // More Options
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {
                    // Add more options functionality
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
