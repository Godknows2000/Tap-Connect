import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? email;
  String? uid;
  List<String>? friends; // List of friend UIDs
  List<String>? friendRequests; // List of pending friend request UIDs
  List<String>? sentRequests; // List of UIDs for sent friend requests

  UserModel({
    this.email,
    this.uid,
    this.friends,
    this.friendRequests,
    this.sentRequests,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    uid = json['uid'];
    friends = json['friends'] != null ? List<String>.from(json['friends']) : [];
    friendRequests = json['friendRequests'] != null
        ? List<String>.from(json['friendRequests'])
        : [];
    sentRequests = json['sentRequests'] != null
        ? List<String>.from(json['sentRequests'])
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['uid'] = uid;
    data['friends'] = friends ?? [];
    data['friendRequests'] = friendRequests ?? [];
    data['sentRequests'] = sentRequests ?? [];
    return data;
  }
}
