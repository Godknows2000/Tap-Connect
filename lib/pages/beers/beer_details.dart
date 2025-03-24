import 'package:flutter/material.dart';
import 'package:tapconnect/constants.dart';

class BeerDetailScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle; // e.g., price or status
  final String type;
  final String location;
  final double rating;
  final int ratingCount;

  const BeerDetailScreen({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.location,
    required this.rating,
    required this.ratingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Beer Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Beer Title
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Beer Subtitle (e.g., Price or Status)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Rating and Rating Count
                  Row(
                    children: [
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
                        '$rating AVG',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$ratingCount ratings',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Beer Description (Placeholder)
                  const Text(
                    'This is a premium beer with a rich, malty flavor and a smooth finish. Perfect for a relaxing evening or a social gathering with friends.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Additional Info (e.g., ABV, Type, etc.)
                  Text(
                    'ABV: 5.0%\nType: $type\nOrigin: $location',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // More Beers in Stock Section
                  const Text(
                    'More Beers in Stock',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildShopCard(
                          context,
                          'assets/clite.jpg',
                          'Castle Lite',
                          'PRE-ORDER',
                        ),
                        _buildShopCard(
                          context,
                          'assets/castle.jpg',
                          'Castle',
                          '1.50',
                        ),
                        _buildShopCard(
                          context,
                          'assets/super.jpg',
                          'Super',
                          '1.00',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopCard(
      BuildContext context, String imagePath, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BeerDetailScreen(
              imagePath: imagePath,
              title: title,
              subtitle: subtitle,
              type: 'Lager', // Placeholder, update with actual data if needed
              location: 'South Africa', // Placeholder
              rating: 3.5, // Placeholder
              ratingCount: 1200, // Placeholder
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
                  image: AssetImage(imagePath),
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
}
