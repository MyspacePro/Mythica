import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "AIzaSyD_zSV6NixpO-2amn7rEmchVLtKBLfgu-4",
        authDomain: "readora-e331b.firebaseapp.com",
        projectId: "readora-e331b",
        storageBucket: "readora-e331b.appspot.com",
        messagingSenderId: "742798402849",
        appId: "1:742798402849:web:7828ce437693cd4f0fca60",
        measurementId: "G-34XVB6QDPE",
      );
    }

    // Android ke liye
    return const FirebaseOptions(
      apiKey: "AIzaSyC27FUr92rA1v-NVfjryYCFb9p_2zxQ48Y",
      appId: "1:742798402849:android:5275a346b28b6ace0fca60",
      messagingSenderId: "742798402849",
      projectId: "readora-e331b",
      storageBucket: "readora-e331b.appspot.com",
    );
  }
}