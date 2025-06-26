class Venue {
  String? id;
  String? name;
  double? latitude;
  double? longitude;
  String? address;
  String? operatingHours;
  int? beersCount;
  int? foodItemsCount;
  int? winesCount;
  List<Map<String, dynamic>>? menuItems;
  double? rating;
  int? ratingCount;
  int? checkInCount;
  String? imagePath;

  Venue({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.address,
    this.operatingHours,
    this.beersCount,
    this.foodItemsCount,
    this.winesCount,
    this.menuItems,
    this.rating,
    this.ratingCount,
    this.checkInCount,
    this.imagePath,
  });

  Venue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude']?.toDouble();
    longitude = json['longitude']?.toDouble();
    address = json['address'];
    operatingHours = json['operatingHours'];
    beersCount = json['beersCount'];
    foodItemsCount = json['foodItemsCount'];
    winesCount = json['winesCount'];
    menuItems = json['menuItems'] != null
        ? List<Map<String, dynamic>>.from(json['menuItems'])
        : null;
    rating = json['rating']?.toDouble();
    ratingCount = json['ratingCount'];
    checkInCount = json['checkInCount'] ?? 0;
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['operatingHours'] = operatingHours;
    data['beersCount'] = beersCount;
    data['foodItemsCount'] = foodItemsCount;
    data['winesCount'] = winesCount;
    data['menuItems'] = menuItems;
    data['rating'] = rating;
    data['ratingCount'] = ratingCount;
    data['checkInCount'] = checkInCount;
    data['imagePath'] = imagePath;
    return data;
  }

  static final List<Venue> dummyVenues = [
    Venue(
      id: 'venue_1',
      name: 'The Tap Room',
      latitude: 37.7749,
      longitude: -122.4194,
      address: '123 Main St, San Francisco, CA',
      operatingHours: 'Mon-Sun 12PM-12AM',
      beersCount: 50,
      foodItemsCount: 20,
      winesCount: 10,
      menuItems: [],
      rating: 4.5,
      ratingCount: 200,
      checkInCount: 150,
      imagePath: 'https://via.placeholder.com/150',
    ),
    Venue(
      id: 'venue_2',
      name: 'Dreams Night Club',
      latitude: 40.7128,
      longitude: -74.0060,
      address: '456 Oak Ave, New York, NY',
      operatingHours: 'Mon-Fri 3PM-11PM',
      beersCount: 30,
      foodItemsCount: 15,
      winesCount: 5,
      menuItems: [],
      rating: 4.0,
      ratingCount: 150,
      checkInCount: 100,
      imagePath: 'https://via.placeholder.com/150',
    ),
    Venue(
      id: 'venue_3',
      name: 'Club Vibes Night Club',
      latitude: 34.0522,
      longitude: -118.2437,
      address: '789 Pine St, Los Angeles, CA',
      operatingHours: 'Tue-Sun 1PM-1AM',
      beersCount: 40,
      foodItemsCount: 25,
      winesCount: 8,
      menuItems: [],
      rating: 4.2,
      ratingCount: 180,
      checkInCount: 120,
      imagePath: 'https://via.placeholder.com/150',
    ),
  ];
}
