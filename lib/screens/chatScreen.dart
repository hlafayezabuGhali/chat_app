import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'notificationsScreen.dart';
import 'package:http/http.dart' as http;

final _firestore = FirebaseFirestore.instance;
late User signedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = "chatscreen";
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messagesTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messages;
  //dynmic
  List<RemoteNotification?> notifications = [];
  String token = '';

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void getNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          notifications.add(message.notification);
        });
        print(
            'Message also contained a notification: ${message.notification!.title}');
      }
    });
  }

  Future<AccessToken> getAccessToken() async {
    final serviceAccount = await rootBundle.loadString(
        'assets/chatapp-d6e0a-firebase-adminsdk-s56kw-cc4401b83c.json');
    final data = await json.decode(serviceAccount);
    print(data);
    final accountCredentials = ServiceAccountCredentials.fromJson({
      "private_key_id": data['private_key_id'],
      "private_key": data['private_key'],
      "client_email": data['client_email'],
      "client_id": data['client_id'],
      "type": data['type'],
    });
    final scopes = ["https://www.googleapis.com/auth/firebase.messaging"];
    final AuthClient authclient = await clientViaServiceAccount(
      accountCredentials,
      scopes,
    )
      ..close(); // Remember to close the client when you are finished with it.

    print(authclient.credentials.accessToken);

    return authclient.credentials.accessToken;
  }

  void sendNotification(String title, String body) async {
    http.Response response = await http.post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/chatapp-d6e0a/messages:send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "message": {
          "topic": "breaking_news",
          "notification": {"body": body, "title": title}
        }
      }),
    );
    print('response.body: ${response.body}');
  }

  @override
  void initState() {
    getCurrentUser();
    getNotifications();
    getAccessToken().then((value) => token = value.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        title: Row(
          children: [
            Container(
              child: Image.asset('images/logo.png', height: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Chat App',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.pushNamed(context, NotificationsScreen.id,
                          arguments: notifications)
                      .then(
                    (value) => setState(() {
                      notifications.clear();
                    }),
                  );
                },
              ),
              notifications.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: Text(
                        '${notifications.length}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageSreamBuilder(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.pinkAccent[100]!,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messagesTextController,
                      onChanged: (value) {
                        messages = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messagesTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messages,
                        'sender': signedInUser.email,
                        'time': FieldValue.serverTimestamp(),
                      });
                      sendNotification(
                          'message from ${signedInUser.email}', messages!);
                      notifications.clear();
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageSreamBuilder extends StatelessWidget {
  const MessageSreamBuilder({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').orderBy('time').snapshots(),
        builder: (context, snapshot) {
          List<MessageBubble> messagesWidgets = [];
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ));
          }
          final message = snapshot.data!.docs.reversed;
          for (var item in message) {
            final messsageText = item.get('text');
            final messsageSender = item.get('sender');
            final currentUser = signedInUser.email;
            final messsageWidget = MessageBubble(
              sender: messsageSender,
              text: messsageText,
              isMe: currentUser == messsageSender,
            );
            messagesWidgets.add(messsageWidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messagesWidgets,
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {required this.text, required this.sender, required this.isMe, Key? key})
      : super(key: key);
  final String? text;
  final String? sender;
  final bool? isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe! ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            '$sender',
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
          Material(
            elevation: 5,
            color: isMe! ? Colors.blueAccent : Colors.white,
            borderRadius: isMe!
                ? BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                    fontSize: 15,
                    color: isMe! ? Colors.white : Colors.blueAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
