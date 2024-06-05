import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/user_list_controller.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

final _fireStore = FirebaseFirestore.instance;
late User loggedInUser;

class UserListScreen extends StatefulWidget {
  static const String id = "User_List_Screen";


  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _auth = FirebaseAuth.instance;

  final UserListController _controller = Get.put(UserListController());

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Talk Mate'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_active),
            onPressed: () async {
              _controller.listenForNewMessages();
            },
          ),
        ],
      ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.white,
                    ),
                    Text(
                      loggedInUser.email ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () async {
                  await _auth.signOut();
                  Get.offAll(LoginScreen()); // Navigate to the LoginScreen after signing out

                },
              ),
            ],
          ),
        ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final messages = snapshot.data!.docs;
          Set<String> usersSet = Set<String>();
          for (var message in messages) {
            final sender = message['sender'];
            usersSet.add(sender);
          }
          final List<String> users = usersSet.toList();
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userEmail = users[index];
              return UserTile(
                userEmail: userEmail,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chatSender: userEmail),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final String userEmail;
  final VoidCallback onTap;

  UserTile({required this.userEmail, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedColor: Colors.purple[100],
      leading: Icon(Icons.person), // Human icon
      title: Text(userEmail.split('@').first),
      onTap: onTap,
    );
  }
}

