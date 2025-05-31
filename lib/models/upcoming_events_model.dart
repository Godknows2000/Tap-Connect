class Event {
  String? id;
  String? date;
  String? time;
  String? title;
  String? venue;
  DateTime? timestamp;
  bool? isInterested;
  bool? isGoing;
  bool? checkedIn;
  int? beersCount;
  int? foodItemsCount;
  int? winesCount;
  List<Map<String, dynamic>>? menuItems; // To store detailed menu items

  Event({
    this.id,
    this.date,
    this.time,
    this.title,
    this.venue,
    this.timestamp,
    this.isInterested,
    this.isGoing,
    this.checkedIn,
    this.beersCount,
    this.foodItemsCount,
    this.winesCount,
    this.menuItems,
  });

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    title = json['title'];
    venue = json['venue'];
    timestamp = json['timestamp']?.toDate();
    isInterested = json['isInterested'] ?? false;
    isGoing = json['isGoing'] ?? false;
    checkedIn = json['checkedIn'] ?? false;
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
    data['date'] = date;
    data['time'] = time;
    data['title'] = title;
    data['venue'] = venue;
    data['timestamp'] = timestamp;
    data['isInterested'] = isInterested ?? false;
    data['isGoing'] = isGoing ?? false;
    data['checkedIn'] = checkedIn ?? false;
    data['beersCount'] = beersCount;
    data['foodItemsCount'] = foodItemsCount;
    data['winesCount'] = winesCount;
    data['menuItems'] = menuItems;
    return data;
  }
}
