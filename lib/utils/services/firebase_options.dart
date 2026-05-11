import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

//FIREBASE- IMPORTED FILE              //FIREBASE- IMPORTED FILE            //FIREBASE- IMPORTED FILE
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
    apiKey: 'AIzaSyD0RZiug_48X5SZslJPMxzuwXu4GzgFDsg',
    appId: '1:419048434130:android:56e1407113744bd72e400b',
    messagingSenderId: '419048434130',
    projectId: 'civicfind-4d1ec',
    storageBucket: 'civicfind-4d1ec.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYeSwg8DkCfxbbw5AFwX275l1jqZkSWgU',
    appId: '1:419048434130:ios:300809882a58df9e2e400b',
    messagingSenderId: '419048434130',
    projectId: 'civicfind-4d1ec',
    storageBucket: 'civicfind-4d1ec.firebasestorage.app',
    androidClientId:
        '419048434130-6ajb63j52607d5h0l40s0vm4iq60bua3.apps.googleusercontent.com',
    iosClientId:
        '419048434130-i7kb3bu77g8q0bm7gn414na17fuiloqp.apps.googleusercontent.com',
    iosBundleId: 'com.civicfind.blinx.blinxMobile',
  );
}
