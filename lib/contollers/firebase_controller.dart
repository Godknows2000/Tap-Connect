import 'package:cloud_firestore/cloud_firestore.dart';

class BeerData {
  static Stream<QuerySnapshot> streamBeers() {
    return FirebaseFirestore.instance.collection('beers').snapshots();
  }

  // Optional: Keep the getBeers() method if you still need it for one-time fetches
  static Future<List<Map<String, dynamic>>> getBeers() async {
    print('Started fetching beers');
    try {
      print('Finding beers');
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('beers').get();
      final data = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      print(data);
      return data;
    } catch (e) {
      print('Error fetching beers: $e');
      return [];
    }
  }
}
