import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future<FirebaseOptions> get firebaseOptions async {
  if (kIsWeb) {
    return const FirebaseOptions(
      apiKey: "YOUR_API_KEY",
      appId: "YOUR_APP_ID",
      messagingSenderId: "YOUR_SENDER_ID",
      projectId: "YOUR_PROJECT_ID",
      authDomain: "YOUR_AUTH_DOMAIN",
      storageBucket: "YOUR_STORAGE_BUCKET",
    );
  } else {
    return await FirebaseOptions.fromResource(
      androidResource: 'google-services.json',
      iosResource: 'GoogleService-Info.plist',
    );
  }
}