import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../screens/chat_screen.dart';

class UserListController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Rx<User?> loggedInUser = Rx<User?>(null);
  RxList<String> users = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
    fetchUsers();
    listenForNewMessages();
    initializeNotifications();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      loggedInUser.value = user;
    } catch (e) {
      print(e);
    }
  }

  void fetchUsers() {
    _fireStore.collection('messages').snapshots().listen((snapshot) {
      Set<String> usersSet = Set<String>();
      for (var message in snapshot.docs) {
        final sender = message['sender'] as String?;
        if (sender != loggedInUser.value?.email) {
          usersSet.add(sender!);
        }
      }
      users.value = usersSet.toList();
    });
  }

  void listenForNewMessages() {
    _fireStore.collection('messages').snapshots().listen((snapshot) {
      for (var message in snapshot.docChanges) {
        if (message.type == DocumentChangeType.added) {
          final sender = message.doc['sender'] as String?;
          final receiver = message.doc['receiver'] as String?;
          if (sender != loggedInUser.value?.email &&
              receiver == loggedInUser.value?.email) {
            showNotification(sender!);
          }
        }
      }
    });
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotification);
  }

  Future<void> onSelectNotification(NotificationResponse? notification) async {
    if (notification != null && notification.payload != null) {
      String? payload = notification.payload;
      if (payload != null) {
        // Handle notification tap here, navigate to appropriate screen
        Get.to(ChatScreen(
            chatSender: payload)); // Example navigation to ChatScreen
      }

      Future<void> signOut() async {

        await _auth.signOut();
      }

    }
  }
  Future<void> showNotification(String chatSender) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your channel id', // Replace 'your channel id' with your desired channel ID
      'your channel name', // Replace 'your channel name' with your desired channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New Message',
      'You have a new message from $chatSender', // Use the chat sender's email in the notification message
      platformChannelSpecifics,
      payload: chatSender, // Pass the chat sender's email as the payload
    );
  }
}