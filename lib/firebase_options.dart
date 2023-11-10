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
    apiKey: 'AIzaSyBY1hI2W9XPQ3JBn7y74CzS7PKDBmExysI',
    appId: '1:917976701250:web:728ac04255df6dc0d050db',
    messagingSenderId: '917976701250',
    projectId: 'apt1-1c2b2',
    authDomain: 'apt1-1c2b2.firebaseapp.com',
    storageBucket: 'apt1-1c2b2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDrxUTiULAOWTzdQC3x0Z_R_E9uKzqc2-4',
    appId: '1:917976701250:android:39c68e2310ca13d6d050db',
    messagingSenderId: '917976701250',
    projectId: 'apt1-1c2b2',
    storageBucket: 'apt1-1c2b2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAH2VgCLtH5mdwwGTefhHx0GOwL-zxTatk',
    appId: '1:917976701250:ios:fb659862cabac4b3d050db',
    messagingSenderId: '917976701250',
    projectId: 'apt1-1c2b2',
    storageBucket: 'apt1-1c2b2.appspot.com',
    iosBundleId: 'com.example.app1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAH2VgCLtH5mdwwGTefhHx0GOwL-zxTatk',
    appId: '1:917976701250:ios:e34d0df33ad7f073d050db',
    messagingSenderId: '917976701250',
    projectId: 'apt1-1c2b2',
    storageBucket: 'apt1-1c2b2.appspot.com',
    iosBundleId: 'com.example.app1.RunnerTests',
  );
}