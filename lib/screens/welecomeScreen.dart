import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app_project/screens/registrationScreen.dart';
import 'package:chat_app_project/screens/signinScreen.dart';
import 'package:flutter/material.dart';
import '../wedjets/my_buttons.dart';

class WelecomScreen extends StatefulWidget {
  static const String id = "welcomescreen";
  const WelecomScreen({Key? key}) : super(key: key);

  @override
  State<WelecomScreen> createState() => _WelecomScreenState();
}

class _WelecomScreenState extends State<WelecomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  height: 200,
                  child: Image.asset('images/logo.png'),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Chat App',
                      textStyle: const TextStyle(
                        fontSize: 45.0,
                        color: Color(0xFF0D47A1),
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            MyButton(
              color: Colors.pink.shade200,
              title: 'Sign in',
              onPressed: () {
                Navigator.pushNamed(context, SignInScreen.id);
              },
            ),
            SizedBox(height: 10),
            MyButton(
              color: Colors.blue[800]!,
              title: 'register',
              onPressed: () {
                Navigator.pushReplacementNamed(context, RegistrationScreen.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
