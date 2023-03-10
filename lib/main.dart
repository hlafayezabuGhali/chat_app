import 'package:chat_app_project/screens/chatScreen.dart';
import 'package:chat_app_project/screens/notificationsScreen.dart';
import 'package:chat_app_project/screens/registrationScreen.dart';
import 'package:chat_app_project/screens/signinScreen.dart';
import 'package:chat_app_project/screens/welecomeScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

String? fcmToken;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.subscribeToTopic("breaking_news");
  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  void getFcm() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    print('fcm token: $fcmToken');
  }

  @override
  Widget build(BuildContext context) {
    getFcm();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Message App',
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: ChatScreen(),
      initialRoute: WelecomScreen.id,
      routes: {
        WelecomScreen.id: (context) => WelecomScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        SignInScreen.id: (context) => SignInScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        NotificationsScreen.id: (context) => NotificationsScreen(),
      },
    );
  }
}
