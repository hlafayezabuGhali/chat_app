import 'package:chat_app_project/screens/chatScreen.dart';
import 'package:chat_app_project/screens/registrationScreen.dart';
import 'package:chat_app_project/screens/signinScreen.dart';
import 'package:chat_app_project/screens/welecomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Message App',
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: ChatScreen(),
      initialRoute:
          _auth.currentUser != null ? ChatScreen.id : WelecomScreen.id,
      routes: {
        WelecomScreen.id: (context) => WelecomScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        SignInScreen.id: (context) => SignInScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
