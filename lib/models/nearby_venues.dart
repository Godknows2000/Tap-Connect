// class Event {
//   String? id;
//   String? date;
//   String? time;
//   String? title;
//   String? venueId; // Reference to the Venue
//   DateTime? timestamp;
//   bool? isInterested;
//   bool? isGoing;
//   bool? checkedIn;

//   Event({
//     this.id,
//     this.date,
//     this.time,
//     this.title,
//     this.venueId,
//     this.timestamp,
//     this.isInterested,
//     this.isGoing,
//     this.checkedIn,
//   });

//   Event.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     date = json['date'];
//     time = json['time'];
//     title = json['title'];
//     venueId = json['venueId'];
//     timestamp = json['timestamp']?.toDate();
//     isInterested = json['isInterested'] ?? false;
//     isGoing = json['isGoing'] ?? false;
//     checkedIn = json['checkedIn'] ?? false;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['date'] = date;
//     data['time'] = time;
//     data['title'] = title;
//     data['venueId'] = venueId;
//     data['timestamp'] = timestamp;
//     data['isInterested'] = isInterested ?? false;
//     data['isGoing'] = isGoing ?? false;
//     data['checkedIn'] = checkedIn ?? false;
//     return data;
//   }
// }
