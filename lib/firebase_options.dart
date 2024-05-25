// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAK8h8rDj8u5T8F_nN2w_5_pJURqIAep9A',
    appId: '1:139517368895:web:6f1342a4499035b6bf368a',
    messagingSenderId: '139517368895',
    projectId: 'margin-point-firebase',
    authDomain: 'margin-point-firebase.firebaseapp.com',
    storageBucket: 'margin-point-firebase.appspot.com',
    measurementId: 'G-NGVTFGH4RR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAe5KvRX4Laj-iFgKxTzbZez08YYqFPVxs',
    appId: '1:139517368895:android:a51c3d671eaa775cbf368a',
    messagingSenderId: '139517368895',
    projectId: 'margin-point-firebase',
    storageBucket: 'margin-point-firebase.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-EU0fJT_8mYTT-UuT3BNRXRale2lafnI',
    appId: '1:139517368895:ios:6fab351859c6f42fbf368a',
    messagingSenderId: '139517368895',
    projectId: 'margin-point-firebase',
    storageBucket: 'margin-point-firebase.appspot.com',
    iosBundleId: 'com.evrz.marginpoint',
  );
}