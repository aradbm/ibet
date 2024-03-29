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
    apiKey: 'AIzaSyBPdw61Q8QVcr9qSv_misrr1Oeqf-YoOlo',
    appId: '1:168506232954:web:52a6753ce238452f17abc3',
    messagingSenderId: '168506232954',
    projectId: 'ibet-a0846',
    authDomain: 'ibet-a0846.firebaseapp.com',
    storageBucket: 'ibet-a0846.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBO6JrJ_rrxU_xkHUp7PcYOppRNbFZpKo0',
    appId: '1:168506232954:android:382e64a81fa9a6b717abc3',
    messagingSenderId: '168506232954',
    projectId: 'ibet-a0846',
    storageBucket: 'ibet-a0846.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyABtxKNakwOyE4trR7AVhy7CmlXGaCApqI',
    appId: '1:168506232954:ios:1a3d03ce9833c55617abc3',
    messagingSenderId: '168506232954',
    projectId: 'ibet-a0846',
    storageBucket: 'ibet-a0846.appspot.com',
    iosBundleId: 'com.example.ibet',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyABtxKNakwOyE4trR7AVhy7CmlXGaCApqI',
    appId: '1:168506232954:ios:14b8845c8f49992717abc3',
    messagingSenderId: '168506232954',
    projectId: 'ibet-a0846',
    storageBucket: 'ibet-a0846.appspot.com',
    iosBundleId: 'com.example.ibet.RunnerTests',
  );
}
