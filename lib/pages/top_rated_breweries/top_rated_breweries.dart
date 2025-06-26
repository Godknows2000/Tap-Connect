import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tapconnect/models/beer_model.dart';

class TopRatedBreweriesScreen extends StatefulWidget {
  const TopRatedBreweriesScreen({super.key});

  @override
  _TopRatedBreweriesScreenState createState() =>
      _TopRatedBreweriesScreenState();
}

class _TopRatedBreweriesScreenState extends State<TopRatedBreweriesScreen> {
  String _searchQuery = '';

  void _filterBreweries(String query) {
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
          'Top Rated Breweries',
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
              onChanged: _filterBreweries,
              decoration: InputDecoration(
                hintText: 'Search breweries by name or location',
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
                  stream: BeerData.streamBreweries(),
                  builder: (context, snapshot) {
                    final totalBreweries =
                        snapshot.hasData && snapshot.data!.docs.isNotEmpty
                            ? snapshot.data!.docs.length
                            : BeerData.dummyBreweries.length;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$totalBreweries',
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
              stream: BeerData.streamBreweries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                List<dynamic> filteredBreweries = [];
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  final allBreweries = snapshot.data!.docs;
                  filteredBreweries = _searchQuery.isEmpty
                      ? allBreweries
                      : allBreweries.where((doc) {
                          final brewery = doc.data() as Map<String, dynamic>;
                          return (brewery['name']
                                      ?.toLowerCase()
                                      ?.contains(_searchQuery) ??
                                  false) ||
                              (brewery['location']
                                      ?.toLowerCase()
                                      ?.contains(_searchQuery) ??
                                  false);
                        }).toList();
                } else {
                  filteredBreweries = _searchQuery.isEmpty
                      ? BeerData.dummyBreweries
                      : BeerData.dummyBreweries.where((brewery) {
                          return (brewery.name
                                      ?.toLowerCase()
                                      .contains(_searchQuery) ??
                                  false) ||
                              (brewery.location
                                      ?.toLowerCase()
                                      .contains(_searchQuery) ??
                                  false);
                        }).toList();
                }

                return filteredBreweries.isEmpty
                    ? const Center(
                        child: Text(
                          'No breweries found',
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
                        itemCount: filteredBreweries.length,
                        itemBuilder: (context, index) {
                          final brewery = filteredBreweries[index]
                                  is QueryDocumentSnapshot
                              ? Brewery.fromJson(filteredBreweries[index].data()
                                  as Map<String, dynamic>)
                              : filteredBreweries[index] as Brewery;
                          return _buildBreweryCard(
                            context,
                            brewery,
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

  Widget _buildBreweryCard(
    BuildContext context,
    Brewery brewery, {
    required int rank,
  }) {
    return GestureDetector(
      onTap: () {
        // Placeholder for navigation to BreweryDetailScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text(brewery.name ?? 'Brewery Details')),
              body: Center(child: Text('Brewery: ${brewery.name}')),
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
                        brewery.imagePath?.isNotEmpty == true
                            ? brewery.imagePath!
                            : 'https://via.placeholder.com/150',
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
                    brewery.name ?? 'Unknown Brewery',
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
                    brewery.location ?? 'Unknown Location',
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
                            index < (brewery.averageRating ?? 0.0).round()
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color(0xFFFFD700),
                            size: 16,
                          );
                        }),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        (brewery.averageRating ?? 0.0).toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${brewery.ratingCount ?? 0})',
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
