// import 'package:flutter/material.dart';
// import 'package:tapconnect/constants.dart';
// import 'package:tapconnect/models/beers_data.dart';
// import 'package:tapconnect/pages/beers/beer_details.dart';
// // Import the shared beer data

// class BrewerySearchScreen extends StatefulWidget {
//   const BrewerySearchScreen({super.key});

//   @override
//   _BrewerySearchScreenState createState() => _BrewerySearchScreenState();
// }

// class _BrewerySearchScreenState extends State<BrewerySearchScreen> {
//   String _searchQuery = '';
//   List<Map<String, dynamic>> _filteredBeers = BeerData.beers;

//   void _filterBeers(String query) {
//     setState(() {
//       _searchQuery = query;
//       if (query.isEmpty) {
//         _filteredBeers = BeerData.beers;
//       } else {
//         _filteredBeers = BeerData.beers
//             .where((beer) =>
//                 beer['name'].toLowerCase().contains(query.toLowerCase()) ||
//                 beer['type'].toLowerCase().contains(query.toLowerCase()) ||
//                 beer['location'].toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A1A), // Dark background
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1A1A1A),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           'Search Beers',
//           style: TextStyle(
//             color: Colors.white54,
//             fontSize: 18,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Search Bar
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: TextField(
//               onChanged: _filterBeers,
//               decoration: InputDecoration(
//                 hintText: 'Search beers by name, type, or location',
//                 hintStyle: const TextStyle(color: Colors.white54),
//                 prefixIcon: const Icon(Icons.search, color: Colors.white54),
//                 filled: true,
//                 fillColor: Colors.grey[800],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//           // Filter Buttons
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.tune, color: Colors.white),
//                       onPressed: () {
//                         // Add filter functionality
//                       },
//                     ),
//                     const SizedBox(width: 8),
//                     OutlinedButton(
//                       onPressed: () {
//                         // Add nearby functionality
//                       },
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         side: const BorderSide(color: Colors.white),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       child: const Text(
//                         'Nearby',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     OutlinedButton(
//                       onPressed: () {
//                         // Add beer type functionality
//                       },
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         side: const BorderSide(color: Colors.white),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       child: const Text(
//                         'Beer Type',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[800],
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     '${_filteredBeers.length}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Beer List or Not Found Message
//           Expanded(
//             child: _filteredBeers.isEmpty
//                 ? const Center(
//                     child: Text(
//                       'Not found',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 18,
//                       ),
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: _filteredBeers.length,
//                     itemBuilder: (context, index) {
//                       final beer = _filteredBeers[index];
//                       return _buildBeerCard(
//                         context,
//                         beer['imagePath'],
//                         beer['name'],
//                         beer['type'],
//                         beer['location'],
//                         beer['rating'].toDouble(),
//                         beer['ratingCount'],
//                         beer['price'],
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBeerCard(
//     BuildContext context,
//     String imagePath,
//     String name,
//     String type,
//     String location,
//     double rating,
//     int ratingCount,
//     String price,
//   ) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BeerDetailScreen(
//               imagePath: imagePath,
//               title: name,
//               subtitle: price,
//               type: type,
//               location: location,
//               rating: rating,
//               ratingCount: ratingCount,
//             ),
//           ),
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: Card(
//           color: Colors.grey[900],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 // Beer Image
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       image: AssetImage(imagePath),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 // Beer Info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         name,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         type,
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ),
//                       Text(
//                         location,
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           // Rating Stars
//                           Row(
//                             children: List.generate(5, (index) {
//                               return Icon(
//                                 index < (rating / 5 * 5).round()
//                                     ? Icons.star
//                                     : Icons.star_border,
//                                 color: const Color(0xFFFFD700), // Golden stars
//                                 size: 20,
//                               );
//                             }),
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             rating.toStringAsFixed(2) + ' AVG',
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '$ratingCount ratings',
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // More Options
//                 IconButton(
//                   icon: const Icon(Icons.more_vert, color: Colors.white),
//                   onPressed: () {
//                     // Add more options functionality
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tapconnect/constants.dart';
import 'package:tapconnect/contollers/firebase_controller.dart'; // Updated import to match your BeerData file
import 'package:tapconnect/pages/beers/beer_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase

class BrewerySearchScreen extends StatefulWidget {
  const BrewerySearchScreen({super.key});

  @override
  _BrewerySearchScreenState createState() => _BrewerySearchScreenState();
}

class _BrewerySearchScreenState extends State<BrewerySearchScreen> {
  String _searchQuery = '';

  // No need for _filteredBeers as a state variable since we'll filter directly from the stream
  // We'll handle filtering inside the StreamBuilder

  void _filterBeers(String query) {
    setState(() {
      _searchQuery = query
          .toLowerCase(); // Convert to lowercase for case-insensitive search
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
                StreamBuilder<QuerySnapshot>(
                  stream: BeerData
                      .streamBeers(), // Get real-time count from Firebase
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
          // Beer List or Not Found Message
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  BeerData.streamBeers(), // Use the stream for real-time data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading beers'));
                }
                final allBeers = snapshot.data?.docs ?? [];
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
                    : ListView.builder(
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
                      image: NetworkImage(imagePath),
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
