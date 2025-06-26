// class BeerData {
//   static final List<Map<String, dynamic>> beers = [
//     {
//       'name': 'Castle Lite',
//       'type': 'Lager',
//       'location': 'South Africa',
//       'rating': 3.5,
//       'ratingCount': 1200,
//       'imagePath': 'assets/clite.jpg',
//       'price': 'PRE-ORDER',
//     },
//     {
//       'name': 'Castle',
//       'type': 'Lager',
//       'location': 'South Africa',
//       'rating': 3.2,
//       'ratingCount': 950,
//       'imagePath': 'assets/castle.jpg',
//       'price': '1.50',
//     },
//     {
//       'name': 'Super',
//       'type': 'Ale',
//       'location': 'South Africa',
//       'rating': 4.0,
//       'ratingCount': 800,
//       'imagePath': 'assets/super.jpg',
//       'price': '1.00',
//     },
//     {
//       'name': 'Zambezi',
//       'type': 'Lager',
//       'location': 'Zimbabwe',
//       'rating': 3.8,
//       'ratingCount': 600,
//       'imagePath': 'assets/zambezi.jpg',
//       'price': '1.20',
//     },
//     {
//       'name': 'Savanah',
//       'type': 'Lager',
//       'location': 'Netherlands',
//       'rating': 4.2,
//       'ratingCount': 2000,
//       'imagePath': 'assets/savana.jpg',
//       'price': '2.00',
//     },
//     {
//       'name': 'Nyathi',
//       'type': 'Stout',
//       'location': 'Zimbabwe',
//       'rating': 1.0,
//       'ratingCount': 1500,
//       'imagePath': 'assets/nyathi.jpg',
//       'price': '0.80',
//     },
//   ];
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class BeerData {
  static Stream<QuerySnapshot> streamBeers() {
    return FirebaseFirestore.instance
        .collection('beers')
        .orderBy('rating', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> streamTopRatedBeers() {
    return FirebaseFirestore.instance
        .collection('beers')
        .orderBy('rating', descending: true)
        .limit(20)
        .snapshots();
  }

  static Stream<QuerySnapshot> streamBreweries() {
    return FirebaseFirestore.instance
        .collection('breweries')
        .orderBy('averageRating', descending: true)
        .snapshots();
  }

  static Future<List<Map<String, dynamic>>> streamRecommendedBeers(
      String userId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    final userData = userDoc.data();
    final interestedEvents = userData?['interestedEvents'] ?? [];

    final beers = await FirebaseFirestore.instance
        .collection('beers')
        .where('eventId', whereIn: interestedEvents)
        .get();
    return beers.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }
}