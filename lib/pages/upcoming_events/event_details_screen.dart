// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:tapconnect/models/upcoming_events_model.dart';
// import 'package:tapconnect/pages/upcoming_events/event_venue.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EventDetailsScreen extends StatelessWidget {
//   final Event event;

//   const EventDetailsScreen({super.key, required this.event});

//   void _toggleInterested(BuildContext context) async {
//     await FirebaseFirestore.instance.collection('events').doc(event.id).update({
//       'isInterested': !(event.isInterested ?? false),
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A1A),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1A1A1A),
//         elevation: 0,
//         title: Text(
//           event.title!,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '${event.date} • ${event.time}',
//                 style: const TextStyle(
//                   color: Colors.white70,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 event.venue!,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 height: 200,
//                 width: double.infinity,
//                 child: ClipRRect(
//                     borderRadius:
//                         BorderRadius.circular(5), // Match the container
//                     child: Image.asset(
//                       'assets/default-marker.jpg',
//                       fit: BoxFit.cover,
//                     ),
//                   )
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Menus',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 padding: const EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Text(
//                   'Menu Item 1\nMenu Item 2\nMenu Item 3',
//                   style: TextStyle(color: Colors.white70, fontSize: 14),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () => _toggleInterested(context),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                         foregroundColor: Colors.white,
//                         side: const BorderSide(color: Colors.white54),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.bookmark_border,
//                             color: (event.isInterested ?? false)
//                                 ? const Color(0xFFFFD700)
//                                 : Colors.white54,
//                             size: 20,
//                           ),
//                           const SizedBox(width: 8),
//                           const Text(
//                             'Interested',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Event shared!')),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                         foregroundColor: Colors.white,
//                         side: const BorderSide(color: Colors.white54),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                       ),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.share,
//                             color: Colors.white54,
//                             size: 20,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             'Share',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tapconnect/models/upcoming_events_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  void _toggleInterested(BuildContext context) async {
    await FirebaseFirestore.instance.collection('events').doc(event.id).update({
      'isInterested': !(event.isInterested ?? false),
    });
  }

  void _toggleGoing(BuildContext context) async {
    await FirebaseFirestore.instance.collection('events').doc(event.id).update({
      'isGoing': !(event.isGoing ?? false),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Event',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Check It Out, Check It In!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${event.date} • ${event.time}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'ADD TO CALENDAR',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _toggleInterested(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            color: (event.isInterested ?? false)
                                ? const Color(0xFFFFD700)
                                : Colors.white54,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Interested',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _toggleGoing(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: (event.isGoing ?? false)
                                ? Colors.green
                                : Colors.white54,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Going',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Event shared!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.share,
                            color: Colors.white54,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Share',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Map Section
              const Text(
                'WHERE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(5), // Match the container
                    child: Image.asset(
                      'assets/default-marker.jpg',
                      fit: BoxFit.cover,
                    ),
                  )),
              const SizedBox(height: 16),
              // Status Bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'GOING',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${event.isGoing == true ? 1 : 0}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'INTERESTED',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${event.isInterested == true ? 1 : 0}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
