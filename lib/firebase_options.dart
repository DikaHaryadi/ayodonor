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
    apiKey: 'AIzaSyD3m9t__P3KWi2Y7R25Z69Sx6G3h4sw9To',
    appId: '1:230252493960:web:0ea1622dc27ee3f830733d',
    messagingSenderId: '230252493960',
    projectId: 'donor-indonesia',
    authDomain: 'donor-indonesia.firebaseapp.com',
    storageBucket: 'donor-indonesia.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyApOlhyS6xsXRkqEnx64OlxPpDIfCOv_Fw',
    appId: '1:230252493960:android:8e9c22922305ab6830733d',
    messagingSenderId: '230252493960',
    projectId: 'donor-indonesia',
    storageBucket: 'donor-indonesia.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAt5rcECGQ9E_LVvE98TO5_kkbIvd6yMZI',
    appId: '1:230252493960:ios:592509af1e83dedd30733d',
    messagingSenderId: '230252493960',
    projectId: 'donor-indonesia',
    storageBucket: 'donor-indonesia.appspot.com',
    iosClientId: '230252493960-ov0856ctbjah1c0pp5cvub5ea2idffc8.apps.googleusercontent.com',
    iosBundleId: 'com.example.getdonor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAt5rcECGQ9E_LVvE98TO5_kkbIvd6yMZI',
    appId: '1:230252493960:ios:47c65ded303c9f2730733d',
    messagingSenderId: '230252493960',
    projectId: 'donor-indonesia',
    storageBucket: 'donor-indonesia.appspot.com',
    iosClientId: '230252493960-mssvgtc3earsf30nk21mpfn5b742v1i7.apps.googleusercontent.com',
    iosBundleId: 'com.example.getdonor.RunnerTests',
  );
}
