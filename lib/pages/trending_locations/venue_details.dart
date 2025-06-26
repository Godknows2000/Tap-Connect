import 'package:flutter/material.dart';
import 'package:tapconnect/models/venues.dart';

class VenueDetailScreen extends StatelessWidget {
  final String id;
  final String name;
  final String address;
  final String operatingHours;
  final String imagePath;
  final double rating;
  final int ratingCount;
  final int checkInCount;
  final int beersCount;
  final int foodItemsCount;
  final int winesCount;
  final List<Map<String, dynamic>>? menuItems;

  const VenueDetailScreen({
    super.key,
    required this.id,
    required this.name,
    required this.address,
    required this.operatingHours,
    required this.imagePath,
    required this.rating,
    required this.ratingCount,
    required this.checkInCount,
    required this.beersCount,
    required this.foodItemsCount,
    required this.winesCount,
    this.menuItems,
  });

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
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imagePath.isNotEmpty
                      ? imagePath
                      : 'https://via.placeholder.com/150'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Address: $address',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hours: $operatingHours',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color(0xFFFFD700),
                            size: 20,
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($ratingCount)',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check-ins: $checkInCount',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Beers: $beersCount | Food: $foodItemsCount | Wines: $winesCount',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Menu Items',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  menuItems == null || menuItems!.isEmpty
                      ? const Text(
                          'No menu items available',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: menuItems!.length,
                          itemBuilder: (context, index) {
                            final item = menuItems![index];
                            return ListTile(
                              title: Text(
                                item['name'] ?? 'Unknown Item',
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                item['price'] ?? 'N/A',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            );
                          },
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
