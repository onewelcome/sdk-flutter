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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAF8WFnHz1HSw7v1uULIEomBEw2-YP6Gq8',
    appId: '1:586427927998:android:f1f11af9897a98c9bfbdef',
    messagingSenderId: '586427927998',
    projectId: 'onegini-sdk-android-401',
    databaseURL: 'https://onegini-sdk-android-401.firebaseio.com',
    storageBucket: 'onegini-sdk-android-401.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAGluW_cyQGdw9vEhXDZ1cuxskqCAF6l6A',
    appId: '1:586427927998:ios:69a0c41bd06d0bf5bfbdef',
    messagingSenderId: '586427927998',
    projectId: 'onegini-sdk-android-401',
    databaseURL: 'https://onegini-sdk-android-401.firebaseio.com',
    storageBucket: 'onegini-sdk-android-401.appspot.com',
    iosClientId: '586427927998-m8rhq7est4ons7v77skvucefj2scbcnj.apps.googleusercontent.com',
    iosBundleId: 'com.onegini.mobile.flutterExample',
  );
}
