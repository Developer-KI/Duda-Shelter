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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCaGk0TaYu0SDfxlzJVRNj7ZDzww4dD4DQ',
    appId: '1:155287368114:web:6cfe56968e55ba206eb4ab',
    messagingSenderId: '155287368114',
    projectId: 'dudashelterdeniorg',
    authDomain: 'dudashelterdeniorg.firebaseapp.com',
    storageBucket: 'dudashelterdeniorg.appspot.com',
    measurementId: 'G-9S2LYDX9NT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBgGyrN8uFd_DWt5DRqWt_lD6pcWmfERIo',
    appId: '1:155287368114:android:352e1f14722bf2676eb4ab',
    messagingSenderId: '155287368114',
    projectId: 'dudashelterdeniorg',
    storageBucket: 'dudashelterdeniorg.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFU4zAc58UXqEz_py_oHgbWyvBxkMzSCI',
    appId: '1:155287368114:ios:19312bc070c3c4326eb4ab',
    messagingSenderId: '155287368114',
    projectId: 'dudashelterdeniorg',
    storageBucket: 'dudashelterdeniorg.appspot.com',
    iosClientId: '155287368114-i9l95prlhtra1s44ru8qnipf86pic7vf.apps.googleusercontent.com',
    iosBundleId: 'com.agiledevelopment.deni.dudaShelter',
  );
}