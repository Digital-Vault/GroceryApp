import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> SignInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
}

class Auth implements BaseAuth {
  Future<String> SignInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;
    if (user.isEmailVerified) return user.uid;
    return null;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password))
        .user;

    try {
      await user.sendEmailVerification();
      return user.uid;
    } catch (e) {
      print(e.message);
    } finally {
      return null;
    }
  }

  Future<String> currentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user != null ? user.uid : null;
  }

  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
      return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
