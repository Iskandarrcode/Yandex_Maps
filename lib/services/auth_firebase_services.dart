import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthFirebaseServices {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> register({
    required email,
    required password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseException catch (e) {
      debugPrint("Firebase SignIn Error: ${e.message}");
    } catch (e) {
      debugPrint("Genereal SigIn error: $e");
    }
  }

  Future<void> login({
    required email,
    required password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase SignIn Error: ${e.message}");
    } catch (e) {
      debugPrint("Firebase SignIn error: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase SignOut error: $e");
    }
  }
}