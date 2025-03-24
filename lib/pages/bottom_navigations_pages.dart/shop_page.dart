import 'package:flutter/material.dart';
import 'package:tapconnect/models/beers_data.dart';
import 'package:tapconnect/pages/beers/beer_details.dart';
// Import the shared beer data

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Shop',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              // Add cart functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              // Add menu functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Beers, breweries, styles',
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
            // Shipping Location
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white54,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Shipping to New York',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.white54),
                    onPressed: () {
                      // Add location change functionality
                    },
                  ),
                ],
              ),
            ),
            // Personalized Box Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Personalized Box',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.yellow[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _buildStyleChip(
                                        'IPA', '59%', Colors.purple),
                                    const SizedBox(width: 8),
                                    _buildStyleChip('Sour', '25%', Colors.teal),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Made for',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.grey,
                                      child: Icon(Icons.person,
                                          size: 16, color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'A box for you',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'BEERS YOU LOVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'EXCLUSIVE STYLES',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  "ONLY BEERS YOU HAVEN'T HAD",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Add build your 12-pack functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('BUILD YOUR 12-PACK'),
                    ),
                  ],
                ),
              ),
            ),
            // Award Winners Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Award Winners',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                  const SizedBox(height: 8),
                  // Horizontal ListView for the first two beers
                  SizedBox(
                    height: 290,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: BeerData
                          .beers.length, // Show only the first two beers
                      itemBuilder: (context, index) {
                        final beer = BeerData.beers[index];
                        return _buildBeerCard(
                          context,
                          beer['imagePath'],
                          beer['name'],
                          beer['location'],
                          beer['rating'].toDouble(),
                          beer['price'],
                          beer['type'],
                          beer['location'],
                          beer['rating'].toDouble(),
                          beer['ratingCount'],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Vertical GridView for the remaining beers
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.6,
                    ),
                    itemCount:
                        BeerData.beers.length - 2, // Show the remaining beers
                    itemBuilder: (context, index) {
                      final beer = BeerData
                          .beers[index + 2]; // Start from the third beer
                      return _buildBeerCard(
                        context,
                        beer['imagePath'],
                        beer['name'],
                        beer['location'],
                        beer['rating'].toDouble(),
                        beer['price'],
                        beer['type'],
                        beer['location'],
                        beer['rating'].toDouble(),
                        beer['ratingCount'],
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

  Widget _buildStyleChip(String label, String percentage, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            percentage,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
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
    String brewery,
    double rating,
    String price,
    String type,
    String location,
    double ratingValue,
    int ratingCount,
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
              rating: ratingValue,
              ratingCount: ratingCount,
            ),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
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
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              brewery,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Color(0xFFFFD700),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  rating.toStringAsFixed(2),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '16oz Can',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '\$$price',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Add to cart functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
