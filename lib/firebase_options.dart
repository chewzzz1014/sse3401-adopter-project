// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyB8tegv01GoEdHxXnKoMHIsuE-THaAw3eY',
    appId: '1:518554354592:web:cc6ccc6fbb0fe542b39ac5',
    messagingSenderId: '518554354592',
    projectId: 'sse3401-adopter-project',
    authDomain: 'sse3401-adopter-project.firebaseapp.com',
    storageBucket: 'sse3401-adopter-project.appspot.com',
    measurementId: 'G-TFD6M273RG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5r2QfzlRqpK47PLQikQt8kCB959v5y5g',
    appId: '1:518554354592:android:10635ae12109d779b39ac5',
    messagingSenderId: '518554354592',
    projectId: 'sse3401-adopter-project',
    storageBucket: 'sse3401-adopter-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZbf0U6u8LMA--3TQ4zTO-X0ciw6jikXM',
    appId: '1:518554354592:ios:ce3c1e0c4fd0fc1fb39ac5',
    messagingSenderId: '518554354592',
    projectId: 'sse3401-adopter-project',
    storageBucket: 'sse3401-adopter-project.appspot.com',
    iosBundleId: 'com.example.sse3401AdopterProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCZbf0U6u8LMA--3TQ4zTO-X0ciw6jikXM',
    appId: '1:518554354592:ios:ce3c1e0c4fd0fc1fb39ac5',
    messagingSenderId: '518554354592',
    projectId: 'sse3401-adopter-project',
    storageBucket: 'sse3401-adopter-project.appspot.com',
    iosBundleId: 'com.example.sse3401AdopterProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB8tegv01GoEdHxXnKoMHIsuE-THaAw3eY',
    appId: '1:518554354592:web:432284f6b69ba295b39ac5',
    messagingSenderId: '518554354592',
    projectId: 'sse3401-adopter-project',
    authDomain: 'sse3401-adopter-project.firebaseapp.com',
    storageBucket: 'sse3401-adopter-project.appspot.com',
    measurementId: 'G-05294584FV',
  );
}