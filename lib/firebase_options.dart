import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDUMMY-web-key',
    appId: '1:123456789012:web:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'food-delivery-demo',
    authDomain: 'food-delivery-demo.firebaseapp.com',
    storageBucket: 'food-delivery-demo.firebasestorage.app',
    measurementId: 'G-XXXXXXXXXX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCD__7BnC5unzAMzjCLseHhPa400Z-ZEcs',
    appId: '1:662225690742:android:924ec3cde45c336a59bf57',
    messagingSenderId: '662225690742',
    projectId: 'ironpath-workout-simulator',
    storageBucket: 'ironpath-workout-simulator.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjeRiWesBwDtropn8uytjn9N8LQe_qvBw',
    appId: '1:662225690742:ios:b73c820e82c245ca59bf57',
    messagingSenderId: '662225690742',
    projectId: 'ironpath-workout-simulator',
    storageBucket: 'ironpath-workout-simulator.firebasestorage.app',
    iosBundleId: 'com.it304mad.foodDelivery',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBjeRiWesBwDtropn8uytjn9N8LQe_qvBw',
    appId: '1:662225690742:ios:b73c820e82c245ca59bf57',
    messagingSenderId: '662225690742',
    projectId: 'ironpath-workout-simulator',
    storageBucket: 'ironpath-workout-simulator.firebasestorage.app',
    iosBundleId: 'com.it304mad.foodDelivery',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCu5eUBWG578f-RnhdOOnY1MfsY3enyGec',
    appId: '1:662225690742:web:0b15f399332a63c759bf57',
    messagingSenderId: '662225690742',
    projectId: 'ironpath-workout-simulator',
    authDomain: 'ironpath-workout-simulator.firebaseapp.com',
    storageBucket: 'ironpath-workout-simulator.firebasestorage.app',
    measurementId: 'G-47X332DBWP',
  );
  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyDUMMY-linux-key',
    appId: '1:123456789012:web:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'food-delivery-demo',
    authDomain: 'food-delivery-demo.firebaseapp.com',
    storageBucket: 'food-delivery-demo.firebasestorage.app',
  );
}
