// import 'package:flutter/material.dart';
// import 'package:tapconnect/models/beers_data.dart';
// import 'package:tapconnect/pages/beers/beer_details.dart';
// import 'package:tapconnect/pages/beers/beer_search_sreen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A1A), // Dark background
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1A1A1A), // Match background
//         elevation: 0, // Remove shadow
//         title: const Text(
//           'Discover',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.qr_code, color: Colors.white),
//             onPressed: () {
//               // Add QR code scanning functionality
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.filter_list, color: Colors.white),
//             onPressed: () {
//               // Add filter functionality
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Search Bar
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const BrewerySearchScreen()),
//                 );
//               },
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: TextField(
//                   enabled: false,
//                   decoration: InputDecoration(
//                     hintText: 'Beers, breweries, or venues',
//                     hintStyle: const TextStyle(color: Colors.white54),
//                     prefixIcon: const Icon(Icons.search, color: Colors.white54),
//                     filled: true,
//                     fillColor: Colors.grey[800],
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//             // View Map Section
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: Container(
//                 height: 100,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   image: const DecorationImage(
//                     image: AssetImage(
//                         'assets/3beers.jpg'), // Replace with your map image
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: const Stack(
//                   children: [
//                     Positioned(
//                       left: 16,
//                       top: 16,
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.map,
//                             color: Color(0xFFFFD700), // Golden icon
//                             size: 24,
//                           ),
//                           const SizedBox(width: 8),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: const [
//                               Text(
//                                 'View Map',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 'Find venues and breweries on the map',
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // New in Shop Section
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'New in Shop',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   SizedBox(
//                     height: 150,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: BeerData.beers.length,
//                       itemBuilder: (context, index) {
//                         final beer = BeerData.beers[index];
//                         return _buildShopCard(
//                           context,
//                           beer['imagePath'],
//                           beer['name'],
//                           beer['price'],
//                           beer['type'],
//                           beer['location'],
//                           beer['rating'].toDouble(),
//                           beer['ratingCount'],
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Ad Banner
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
//               child: Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   image: const DecorationImage(
//                     image: AssetImage(
//                         'assets/sponsor.jpg'), // Replace with your ad image
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       right: 8,
//                       top: 8,
//                       child: TextButton(
//                         onPressed: () {
//                           // Hide ad functionality
//                         },
//                         child: const Text(
//                           'HIDE ADS',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Upcoming Events Section
//             _buildSection(
//               icon: Icons.calendar_today,
//               title: 'Upcoming Events',
//               subtitle: "Check out what's happening",
//               iconColor: const Color(0xFFFFD700), // Golden icon
//             ),
//             // Nearby Venues Section
//             _buildSection(
//               icon: Icons.location_on,
//               title: 'Nearby Venues',
//               subtitle: 'Best places ',
//               iconColor: Colors.red,
//             ),
//             // Trending Beers Section
//             _buildSection(
//               icon: Icons.trending_up,
//               title: 'Trending Beers',
//               subtitle: '',
//               iconColor: Colors.orange,
//             ),
//             // Trending Locations Section
//             _buildSection(
//               icon: Icons.place,
//               title: 'Trending Locations',
//               subtitle: '',
//               iconColor: Colors.green,
//             ),
//             // Top Rated Beers Section
//             _buildSection(
//               icon: Icons.star,
//               title: 'Top Rated Beers',
//               subtitle: '',
//               iconColor: Colors.yellow,
//             ),
//             // Top Rated Breweries Section
//             _buildSection(
//               icon: Icons.local_drink,
//               title: 'Top Rated Breweries',
//               subtitle: '',
//               iconColor: Colors.green,
//             ),
//             // Recommended Section
//             _buildSection(
//               icon: Icons.thumb_up,
//               title: 'Recommended',
//               subtitle: '',
//               iconColor: const Color(0xFFFFD700), // Golden icon
//             ),
//             // Placeholder for Recommended Beers
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: Container(
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Column(
//                   children: [
//                     const Text(
//                       "We couldn't find any recommended beers in your local area.",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Check-in and rate beers to see your recommendations',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   const BrewerySearchScreen()),
//                         );
//                         // Add find a beer functionality
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text('FIND A BEER'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 'PLEASE DRINK RESPONSIBLY',
//                 style: TextStyle(
//                   color: Colors.white54,
//                   fontSize: 12,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildShopCard(
//     BuildContext context,
//     String imagePath,
//     String title,
//     String subtitle,
//     String type,
//     String location,
//     double rating,
//     int ratingCount,
//   ) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BeerDetailScreen(
//               imagePath: imagePath,
//               title: title,
//               subtitle: subtitle,
//               type: type,
//               location: location,
//               rating: rating,
//               ratingCount: ratingCount,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: 120,
//         margin: const EdgeInsets.only(right: 16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 80,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 image: DecorationImage(
//                   image: AssetImage(imagePath),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//             Text(
//               subtitle,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSection({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color iconColor,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 icon,
//                 color: iconColor,
//                 size: 24,
//               ),
//               const SizedBox(width: 16),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   if (subtitle.isNotEmpty)
//                     Text(
//                       subtitle,
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//           TextButton(
//             onPressed: () {
//               // Add see all functionality
//             },
//             child: const Text(
//               'SEE ALL',
//               style: TextStyle(
//                 color: Colors.blue,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tapconnect/contollers/firebase_controller.dart';
import 'package:tapconnect/pages/beers/beer_details.dart';
import 'package:tapconnect/pages/beers/beer_search_sreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tapconnect/pages/beers/trending_beer.dart'; // Import Firebase

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A), // Match background
        elevation: 0, // Remove shadow
        title: const Text(
          'Discover',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code, color: Colors.white),
            onPressed: () {
              // Add QR code scanning functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // Add filter functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BrewerySearchScreen()),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'Beers, breweries, or venues',
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
            ),
            // View Map Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/3beers.jpg'), // Replace with your map image
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Stack(
                  children: [
                    Positioned(
                      left: 16,
                      top: 16,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.map,
                            color: Color(0xFFFFD700), // Golden icon
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'View Map',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Find venues and breweries on the map',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
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
            ),
            // New in Shop Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'New in Shop',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 150,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: BeerData.streamBeers(), // Use the stream
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading beers'));
                        }
                        final beers = snapshot.data?.docs ?? [];
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: beers.length,
                          itemBuilder: (context, index) {
                            final beer =
                                beers[index].data() as Map<String, dynamic>;
                            return _buildShopCard(
                                context,
                                beer['imagePath'],
                                beer['name'],
                                beer['price'],
                                beer['type'],
                                beer['location'],
                                beer['rating'].toDouble(),
                                beer['ratingCount']);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Ad Banner
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/sponsor.jpg'), // Replace with your ad image
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 8,
                      top: 8,
                      child: TextButton(
                        onPressed: () {
                          // Hide ad functionality
                        },
                        child: const Text(
                          'HIDE ADS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Upcoming Events Section
            _buildSection(
              icon: Icons.calendar_today,
              title: 'Upcoming Events',
              subtitle: "Check out what's happening",
              iconColor: const Color(0xFFFFD700), // Golden icon
            ),
            // Nearby Venues Section
            _buildSection(
              icon: Icons.location_on,
              title: 'Nearby Venues',
              subtitle: 'Best places ',
              iconColor: Colors.red,
            ),
            // Trending Beers Section
            GestureDetector(
              onTap: () {
                Get.to(const TrendingBeer());
              },
              child: _buildSection(
                icon: Icons.trending_up,
                title: 'Trending Beers',
                subtitle: '',
                iconColor: Colors.orange,
              ),
            ),
            // Trending Locations Section
            _buildSection(
              icon: Icons.place,
              title: 'Trending Locations',
              subtitle: '',
              iconColor: Colors.green,
            ),
            // Top Rated Beers Section
            _buildSection(
              icon: Icons.star,
              title: 'Top Rated Beers',
              subtitle: '',
              iconColor: Colors.yellow,
            ),
            // Top Rated Breweries Section
            _buildSection(
              icon: Icons.local_drink,
              title: 'Top Rated Breweries',
              subtitle: '',
              iconColor: Colors.green,
            ),
            // Recommended Section
            _buildSection(
              icon: Icons.thumb_up,
              title: 'Recommended',
              subtitle: '',
              iconColor: const Color(0xFFFFD700), // Golden icon
            ),
            // Placeholder for Recommended Beers
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      "We couldn't find any recommended beers in your local area.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Check-in and rate beers to see your recommendations',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BrewerySearchScreen()),
                        );
                        // Add find a beer functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('FIND A BEER'),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'PLEASE DRINK RESPONSIBLY',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopCard(
    BuildContext context,
    String imagePath,
    String title,
    String subtitle,
    String type,
    String location,
    double rating,
    int ratingCount,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BeerDetailScreen(
              imagePath: imagePath,
              title: title,
              subtitle: subtitle,
              type: type,
              location: location,
              rating: rating,
              ratingCount: ratingCount,
            ),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              // Add see all functionality
            },
            child: const Text(
              'SEE ALL',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
