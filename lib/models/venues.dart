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
    return data;
  }
}
