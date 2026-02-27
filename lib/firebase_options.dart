import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no están configuradas para esta plataforma. '
          'Ejecuta: flutterfire configure',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOyzxrLFH6E2D9S1a__rdZEenbgdvYank',
    appId: '1:838529841091:android:4a56c5c96c0aef20b8af76',
    messagingSenderId: '838529841091',
    projectId: 'falcon-byte',
    databaseURL: 'https://falcon-byte-default-rtdb.firebaseio.com',
    storageBucket: 'falcon-byte.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNyzoTPRzITnYLmJ9pCk_MAue6dSjU_VM',
    appId: '1:838529841091:ios:933220722138181bb8af76',
    messagingSenderId: '838529841091',
    projectId: 'falcon-byte',
    databaseURL: 'https://falcon-byte-default-rtdb.firebaseio.com',
    storageBucket: 'falcon-byte.firebasestorage.app',
    androidClientId:
        '838529841091-8hictql9e1taj7pq0s04tddb3pnqkr86.apps.googleusercontent.com',
    iosClientId:
        '838529841091-3tmvglqncgouku4pvar8dpf1d8fvtbhm.apps.googleusercontent.com',
    iosBundleId: 'com.example.falconByte',
  );
}
