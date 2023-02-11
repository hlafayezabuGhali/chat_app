// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBgVi5mCSPSwRLzOBqu5i3pygTrWdFY-5o',
    appId: '1:636744597685:web:82476d5b05a0787d67fefc',
    messagingSenderId: '636744597685',
    projectId: 'chatapp-d6e0a',
    authDomain: 'chatapp-d6e0a.firebaseapp.com',
    storageBucket: 'chatapp-d6e0a.appspot.com',
    measurementId: 'G-WK2G9J0S97',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMNqPczLs7raSWUos046P7-QwEdU1uD_4',
    appId: '1:636744597685:android:f987624d230347d367fefc',
    messagingSenderId: '636744597685',
    projectId: 'chatapp-d6e0a',
    storageBucket: 'chatapp-d6e0a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDYpyR7rNAj2ilOcBhY5nHENrQIJMNSNRM',
    appId: '1:636744597685:ios:3ea24dacef7e630667fefc',
    messagingSenderId: '636744597685',
    projectId: 'chatapp-d6e0a',
    storageBucket: 'chatapp-d6e0a.appspot.com',
    iosClientId: '636744597685-44cnim91s0i3uc55aln46h0mu1gndhfm.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatAppProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDYpyR7rNAj2ilOcBhY5nHENrQIJMNSNRM',
    appId: '1:636744597685:ios:3ea24dacef7e630667fefc',
    messagingSenderId: '636744597685',
    projectId: 'chatapp-d6e0a',
    storageBucket: 'chatapp-d6e0a.appspot.com',
    iosClientId: '636744597685-44cnim91s0i3uc55aln46h0mu1gndhfm.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatAppProject',
  );
}
