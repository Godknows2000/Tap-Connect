class Brewery {
  String? id;
  String? name;
  String? location;
  String? imagePath;
  double? rating;
  int? ratingCount;
  int? checkInCount; // For trending logic
  String? description;

  Brewery({
    this.id,
    this.name,
    this.location,
    this.imagePath,
    this.rating,
    this.ratingCount,
    this.checkInCount,
    this.description,
  });

  Brewery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    imagePath = json['imagePath'];
    rating = json['rating']?.toDouble();
    ratingCount = json['ratingCount'];
    checkInCount = json['checkInCount'] ?? 0;
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['location'] = location;
    data['imagePath'] = imagePath;
    data['rating'] = rating;
    data['ratingCount'] = ratingCount;
    data['checkInCount'] = checkInCount;
    data['description'] = description;
    return data;
  }
}