import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tapconnect/models/venues.dart';
import 'package:tapconnect/models/user_model.dart';

class VenueMapShareScreen extends StatefulWidget {
  final Venue venue;

  const VenueMapShareScreen({super.key, required this.venue});

  @override
  State<VenueMapShareScreen> createState() => _VenueMapShareScreenState();
}

class _VenueMapShareScreenState extends State<VenueMapShareScreen> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          widget.venue.name ?? 'Venue Location',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () async {
              final currentUserId = FirebaseAuth.instance.currentUser?.uid;
              if (currentUserId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You must be logged in to share.')),
                );
                return;
              }
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserId)
                  .get();
              final user = UserModel.fromJson(userDoc.data()!);
              final friends = user.friends ?? [];
              if (friends.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No friends to share with.')),
                );
                return;
              }
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Share Venue'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: friends.map((friendId) => FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const SizedBox.shrink();
                            final friend = UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                            return ListTile(
                              title: Text(friend.email ?? 'Unknown'),
                              onTap: () async {
                                await FirebaseFirestore.instance.collection('notifications').add({
                                  'userId': friendId,
                                  'type': 'venue_share',
                                  'venueId': widget.venue.id,
                                  'message': 'Check out this venue: ${widget.venue.name}',
                                  'timestamp': FieldValue.serverTimestamp(),
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Venue shared!')),
                                );
                              },
                            );
                          },
                        )).toList(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: widget.venue.latitude != null && widget.venue.longitude != null
          ? GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.venue.latitude!, widget.venue.longitude!),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: {
                Marker(
                  markerId: MarkerId(widget.venue.id!),
                  position: LatLng(widget.venue.latitude!, widget.venue.longitude!),
                  infoWindow: InfoWindow(
                    title: widget.venue.name,
                    snippet: widget.venue.address,
                  ),
                ),
              },
            )
          : const Center(
              child: Text(
                'No location data available',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
    );
  }
}