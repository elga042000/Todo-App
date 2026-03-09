import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  Future login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);

    notifyListeners();
  }

  Future signup(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    notifyListeners();
  }

  Future logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}
