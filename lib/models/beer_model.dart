import 'package:cloud_firestore/cloud_firestore.dart';

class Beer {
  String? id;
  String? name;
  String? type;
  String? location;
  String? imagePath;
  double? rating;
  int? ratingCount;
  String? price;
  String? breweryId;
  int? checkInCount;

  Beer({
    this.id,
    this.name,
    this.type,
    this.location,
    this.imagePath,
    this.rating,
    this.ratingCount,
    this.price,
    this.breweryId,
    this.checkInCount,
  });

  Beer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    location = json['location'];
    imagePath = json['imagePath'];
    rating = json['rating']?.toDouble();
    ratingCount = json['ratingCount'];
    price = json['price'];
    breweryId = json['breweryId'];
    checkInCount = json['checkInCount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['location'] = location;
    data['imagePath'] = imagePath;
    data['rating'] = rating;
    data['ratingCount'] = ratingCount;
    data['price'] = price;
    data['breweryId'] = breweryId;
    data['checkInCount'] = checkInCount;
    return data;
  }
}

class Brewery {
  String? id;
  String? name;
  String? location;
  String? imagePath;
  double? averageRating;
  int? ratingCount;

  Brewery({
    this.id,
    this.name,
    this.location,
    this.imagePath,
    this.averageRating,
    this.ratingCount,
  });

  Brewery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    imagePath = json['imagePath'];
    averageRating = json['averageRating']?.toDouble();
    ratingCount = json['ratingCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['location'] = location;
    data['imagePath'] = imagePath;
    data['averageRating'] = averageRating;
    data['ratingCount'] = ratingCount;
    return data;
  }
}

class BeerData {
  static Stream<QuerySnapshot> streamBeers() {
    return FirebaseFirestore.instance.collection('beers').snapshots();
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
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final userData = userDoc.data();
    final interestedEvents = userData?['interestedEvents'] ?? [];

    final beers = await FirebaseFirestore.instance
        .collection('beers')
        .where('eventId',
            whereIn: interestedEvents.isNotEmpty ? interestedEvents : [''])
        .get();
    return beers.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  static final List<Beer> dummyBeers = [
    Beer(
      id: 'beer_1',
      name: 'Castle Lite',
      type: 'Lager',
      location: 'Zimbabwe',
      imagePath: 'https://via.placeholder.com/150',
      rating: 3.5,
      ratingCount: 1200,
      price: 'PRE-ORDER',
      breweryId: 'brewery_1',
      checkInCount: 300,
    ),
    Beer(
      id: 'beer_2',
      name: 'Castle',
      type: 'Lager',
      location: 'South Africa',
      imagePath: 'https://via.placeholder.com/150',
      rating: 3.2,
      ratingCount: 950,
      price: '1.50',
      breweryId: 'brewery_1',
      checkInCount: 250,
    ),
    Beer(
      id: 'beer_3',
      name: 'Super',
      type: 'Ale',
      location: 'South Africa',
      imagePath: 'https://via.placeholder.com/150',
      rating: 4.0,
      ratingCount: 800,
      price: '1.00',
      breweryId: 'brewery_2',
      checkInCount: 200,
    ),
    Beer(
      id: 'beer_4',
      name: 'Zambezi',
      type: 'Lager',
      location: 'Zimbabwe',
      imagePath: 'https://via.placeholder.com/150',
      rating: 3.8,
      ratingCount: 600,
      price: '1.20',
      breweryId: 'brewery_3',
      checkInCount: 180,
    ),
    Beer(
      id: 'beer_5',
      name: 'Savanah',
      type: 'Lager',
      location: 'Zimbabwe',
      imagePath: 'https://via.placeholder.com/150',
      rating: 4.2,
      ratingCount: 2000,
      price: '2.00',
      breweryId: 'brewery_4',
      checkInCount: 400,
    ),
    Beer(
      id: 'beer_6',
      name: 'Nyathi',
      type: 'Stout',
      location: 'Zimbabwe',
      imagePath: 'https://via.placeholder.com/150',
      rating: 1.0,
      ratingCount: 1500,
      price: '0.80',
      breweryId: 'brewery_3',
      checkInCount: 350,
    ),
  ];

  static final List<Brewery> dummyBreweries = [
    Brewery(
      id: 'brewery_1',
      name: 'Coast Breweries',
      location: 'Southerton, Zimbabwe',
      imagePath: 'https://via.placeholder.com/150',
      averageRating: 4.0,
      ratingCount: 1500,
    ),
    Brewery(
      id: 'brewery_2',
      name: 'Golden Valley Breweries',
      location: 'Marondera, Zimbabwe',
      imagePath: 'https://via.placeholder.com/150',
      averageRating: 4.3,
      ratingCount: 800,
    ),
    Brewery(
      id: 'brewery_3',
      name: 'Delta Beverages',
      location: 'Chitungwiza, Zimbabwe',
      imagePath: 'https://via.placeholder.com/150',
      averageRating: 3.8,
      ratingCount: 600,
    ),
    Brewery(
      id: 'brewery_4',
      name: 'Nyathi Breweries',
      location: 'Harare, Zimbabwe',
      imagePath: 'https://via.placeholder.com/150',
      averageRating: 4.5,
      ratingCount: 2000,
    ),
  ];
}
