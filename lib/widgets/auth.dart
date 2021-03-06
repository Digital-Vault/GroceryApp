import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> SignInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  void resetPassword(String email);
  Future<void> signOut();
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

  void resetPassword(String email) {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      // ignoring the errors in this case for security purposes
    }
  }

  Future<String> currentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user != null ? user.uid : null;
  }

  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }
}
