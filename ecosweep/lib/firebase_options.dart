import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    appId: '1:197616550279:android:f618292d560c487fbc5322',
    apiKey: 'AIzaSyAXFCCn94cc7HSZfyI88Gi5EjvvceBQxbM',
    projectId: 'eco-sweep-6efef',
    storageBucket: 'eco-sweep-6efef.firebasestorage.app',
    messagingSenderId: '197616550279',
  );
}
