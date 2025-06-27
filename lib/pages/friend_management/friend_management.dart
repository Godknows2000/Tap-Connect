import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tapconnect/models/user_model.dart';

class FriendManagementScreen extends StatefulWidget {
  final String currentUserId;

  const FriendManagementScreen({super.key, required this.currentUserId});

  @override
  State<FriendManagementScreen> createState() => _FriendManagementScreenState();
}

class _FriendManagementScreenState extends State<FriendManagementScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<UserModel?> _findUserByEmail(String email) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (query.docs.isNotEmpty) {
      final userData = query.docs.first.data();
      userData['uid'] = query.docs.first.id;
      return UserModel.fromJson(userData);
    }
    return null;
  }

  Future<void> _sendFriendRequest(String targetUserId) async {
    if (targetUserId == widget.currentUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Cannot send friend request to yourself.')),
      );
      return;
    }
    try {
      print('Sending friend request to $targetUserId'); // Debug log
      final targetDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .get();
      if (!targetDoc.exists) {
        throw Exception('Target user does not exist: $targetUserId');
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .update({
        'friendRequests': FieldValue.arrayUnion([widget.currentUserId]),
      }).catchError((e) {
        throw Exception(
            'Failed to update friendRequests for $targetUserId: $e');
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserId)
          .update({
        'sentRequests': FieldValue.arrayUnion([targetUserId]),
      }).catchError((e) {
        throw Exception(
            'Failed to update sentRequests for ${widget.currentUserId}: $e');
      });
      print('Friend request sent to $targetUserId'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend request sent successfully!')),
      );
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {});
    } catch (e) {
      print('Error sending friend request: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending friend request: $e')),
      );
    }
  }

  Future<void> _cancelFriendRequest(String targetUserId) async {
    try {
      print('Cancelling friend request to $targetUserId'); // Debug log
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserId)
          .update({
        'sentRequests': FieldValue.arrayRemove([targetUserId]),
      }).catchError((e) {
        throw Exception(
            'Failed to remove sentRequests for ${widget.currentUserId}: $e');
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .update({
        'friendRequests': FieldValue.arrayRemove([widget.currentUserId]),
      }).catchError((e) {
        throw Exception(
            'Failed to remove friendRequests for $targetUserId: $e');
      });
      print('Friend request to $targetUserId cancelled'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend request cancelled.')),
      );
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {});
    } catch (e) {
      print('Error cancelling friend request: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling friend request: $e')),
      );
    }
  }

  Future<void> _acceptFriendRequest(String requesterId) async {
    try {
      print('Accepting friend request from $requesterId'); // Debug log
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserId)
          .update({
        'friends': FieldValue.arrayUnion([requesterId]),
        'friendRequests': FieldValue.arrayRemove([requesterId]),
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(requesterId)
          .update({
        'friends': FieldValue.arrayUnion([widget.currentUserId]),
        'sentRequests': FieldValue.arrayRemove([widget.currentUserId]),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Friend request accepted! You are now friends.')),
      );
      setState(() {});
    } catch (e) {
      print('Error accepting friend request: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accepting friend request: $e')),
      );
    }
  }

  Future<void> _rejectFriendRequest(String requesterId) async {
    try {
      print('Rejecting friend request from $requesterId'); // Debug log
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserId)
          .update({
        'friendRequests': FieldValue.arrayRemove([requesterId]),
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(requesterId)
          .update({
        'sentRequests': FieldValue.arrayRemove([widget.currentUserId]),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend request rejected.')),
      );
      setState(() {});
    } catch (e) {
      print('Error rejecting friend request: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting friend request: $e')),
      );
    }
  }

  Future<void> _removeFriend(String friendId) async {
    try {
      print('Removing friend $friendId'); // Debug log
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserId)
          .update({
        'friends': FieldValue.arrayRemove([friendId]),
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .update({
        'friends': FieldValue.arrayRemove([widget.currentUserId]),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend removed.')),
      );
      setState(() {});
    } catch (e) {
      print('Error removing friend: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing friend: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: const Key('FriendManagementScreen'),
        backgroundColor: const Color(0xFF1A1A1A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text('Manage Friends',
              style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            labelColor: Color(0xFFFFD700),
            unselectedLabelColor: Colors.white54,
            indicatorColor: Color(0xFFFFD700),
            tabs: [
              Tab(text: 'DISCOVER'),
              Tab(text: 'SENT'),
              Tab(text: 'FRIENDS'),
              Tab(text: 'PENDING'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {}); // Refresh entire screen
            print('Floating refresh triggered'); // Debug log
          },
          backgroundColor: const Color(0xFFFFD700),
          foregroundColor: Colors.black,
          child: const Icon(Icons.refresh),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Friend by Email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter friend\'s email',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final user = await _findUserByEmail(_emailController.text);
                  if (user != null) {
                    await _sendFriendRequest(user.uid!);
                    _emailController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User not found.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Send Friend Request'),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: TabBarView(
                  children: [
                    // Discover Users Tab
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.currentUserId)
                          .snapshots(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (userSnapshot.hasError || !userSnapshot.hasData) {
                          return const Center(
                              child: Text('Error loading user data',
                                  style: TextStyle(color: Colors.white70)));
                        }
                        final currentUser = UserModel.fromJson(
                            userSnapshot.data!.data() as Map<String, dynamic>);
                        final currentFriends = currentUser.friends ?? [];
                        final currentRequests =
                            currentUser.friendRequests ?? [];
                        final sentRequests = currentUser.sentRequests ?? [];

                        print('Current friends: $currentFriends'); // Debug log
                        print(
                            'Current requests: $currentRequests'); // Debug log
                        print('Sent requests: $sentRequests'); // Debug log

                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError || !snapshot.hasData) {
                              return const Center(
                                  child: Text('Error loading users',
                                      style: TextStyle(color: Colors.white70)));
                            }
                            final users = snapshot.data!.docs
                                .map((doc) => UserModel.fromJson(
                                    doc.data() as Map<String, dynamic>
                                      ..['uid'] = doc.id))
                                .where(
                                    (user) => user.uid != widget.currentUserId)
                                .where((user) =>
                                    !currentFriends.contains(user.uid))
                                .where((user) =>
                                    !currentRequests.contains(user.uid))
                                .where(
                                    (user) => !sentRequests.contains(user.uid))
                                .toList();
                            print(
                                'Filtered users: ${users.map((u) => u.email).toList()}'); // Debug log
                            if (users.isEmpty) {
                              return const Center(
                                  child: Text('No new users to add',
                                      style: TextStyle(color: Colors.white70)));
                            }
                            return ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFD700),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                      ),
                                      title: Text(user.email ?? 'Unknown',
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      trailing: ElevatedButton(
                                        onPressed: () async {
                                          await _sendFriendRequest(user.uid!);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue),
                                        child: const Text('Add'),
                                      ),
                                    ),
                                    const Divider(
                                        color: Colors.white54, thickness: 0.5),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    // Sent Friend Requests Tab
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.currentUserId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Center(
                              child: Text('Error loading sent requests',
                                  style: TextStyle(color: Colors.white70)));
                        }
                        final user = UserModel.fromJson(
                            snapshot.data!.data() as Map<String, dynamic>);
                        final sentRequests = user.sentRequests ?? [];
                        print(
                            'Sent friend requests: $sentRequests'); // Debug log
                        if (sentRequests.isEmpty) {
                          return const Center(
                              child: Text('No sent requests',
                                  style: TextStyle(color: Colors.white70)));
                        }
                        return ListView.builder(
                          itemCount: sentRequests.length,
                          itemBuilder: (context, index) {
                            final targetId = sentRequests[index];
                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(targetId)
                                  .get(),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const ListTile(
                                      title: Text('Loading...',
                                          style: TextStyle(
                                              color: Colors.white70)));
                                }
                                if (!userSnapshot.hasData ||
                                    userSnapshot.hasError) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFD700),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.black,
                                            size: 24,
                                          ),
                                        ),
                                        title: const Text('User not found',
                                            style: TextStyle(
                                                color: Colors.white70)),
                                        trailing: ElevatedButton(
                                          onPressed: () =>
                                              _cancelFriendRequest(targetId),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          child: const Text('Cancel'),
                                        ),
                                      ),
                                      const Divider(
                                          color: Colors.white54,
                                          thickness: 0.5),
                                    ],
                                  );
                                }
                                final targetUser = UserModel.fromJson(
                                    userSnapshot.data!.data()
                                        as Map<String, dynamic>);
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFD700),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                      ),
                                      title: Text(targetUser.email ?? 'Unknown',
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      trailing: ElevatedButton(
                                        onPressed: () =>
                                            _cancelFriendRequest(targetId),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        child: const Text('Cancel'),
                                      ),
                                    ),
                                    const Divider(
                                        color: Colors.white54, thickness: 0.5),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    // Your Friends Tab
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.currentUserId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Center(
                              child: Text('Error loading friends',
                                  style: TextStyle(color: Colors.white70)));
                        }
                        final user = UserModel.fromJson(
                            snapshot.data!.data() as Map<String, dynamic>);
                        final friends = user.friends ?? [];
                        if (friends.isEmpty) {
                          return const Center(
                              child: Text('No friends yet',
                                  style: TextStyle(color: Colors.white70)));
                        }
                        return ListView.builder(
                          itemCount: friends.length,
                          itemBuilder: (context, index) {
                            final friendId = friends[index];
                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(friendId)
                                  .get(),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const ListTile(
                                      title: Text('Loading...',
                                          style: TextStyle(
                                              color: Colors.white70)));
                                }
                                if (!userSnapshot.hasData ||
                                    userSnapshot.hasError) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFD700),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.black,
                                            size: 24,
                                          ),
                                        ),
                                        title: const Text('User not found',
                                            style: TextStyle(
                                                color: Colors.white70)),
                                      ),
                                      const Divider(
                                          color: Colors.white54,
                                          thickness: 0.5),
                                    ],
                                  );
                                }
                                final friend = UserModel.fromJson(
                                    userSnapshot.data!.data()
                                        as Map<String, dynamic>);
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFD700),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                      ),
                                      title: Text(friend.email ?? 'Unknown',
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.person_remove,
                                            color: Colors.red),
                                        onPressed: () =>
                                            _removeFriend(friendId),
                                      ),
                                    ),
                                    const Divider(
                                        color: Colors.white54, thickness: 0.5),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    // Pending Friend Requests Tab
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.currentUserId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Center(
                              child: Text('Error loading requests',
                                  style: TextStyle(color: Colors.white70)));
                        }
                        final user = UserModel.fromJson(
                            snapshot.data!.data() as Map<String, dynamic>);
                        final friendRequests = user.friendRequests ?? [];
                        print(
                            'Pending friend requests: $friendRequests'); // Debug log
                        if (friendRequests.isEmpty) {
                          return const Center(
                              child: Text('No pending requests',
                                  style: TextStyle(color: Colors.white70)));
                        }
                        return ListView.builder(
                          itemCount: friendRequests.length,
                          itemBuilder: (context, index) {
                            final requesterId = friendRequests[index];
                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(requesterId)
                                  .get(),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const ListTile(
                                      title: Text('Loading...',
                                          style: TextStyle(
                                              color: Colors.white70)));
                                }
                                if (!userSnapshot.hasData ||
                                    userSnapshot.hasError) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFD700),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.black,
                                            size: 24,
                                          ),
                                        ),
                                        title: const Text('User not found',
                                            style: TextStyle(
                                                color: Colors.white70)),
                                      ),
                                      const Divider(
                                          color: Colors.white54,
                                          thickness: 0.5),
                                    ],
                                  );
                                }
                                final requester = UserModel.fromJson(
                                    userSnapshot.data!.data()
                                        as Map<String, dynamic>);
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFD700),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                      ),
                                      title: Text(requester.email ?? 'Unknown',
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () =>
                                                _acceptFriendRequest(
                                                    requesterId),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green),
                                            child: const Text('Accept'),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: () =>
                                                _rejectFriendRequest(
                                                    requesterId),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red),
                                            child: const Text('Reject'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                        color: Colors.white54, thickness: 0.5),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
