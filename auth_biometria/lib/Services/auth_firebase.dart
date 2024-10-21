import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthFirebase extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Métodos de Registro
  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e.toString());
    }
  }

  // Método de Login
  Future<User?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
          return _auth.currentUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}