// ignore_for_file: avoid_print, use_build_context_synchronously, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _fireStore = FirebaseFirestore.instance;

  static Future<bool> signUp(String name, String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? signedInUser = authResult.user;

      if (signedInUser != null) {
        _fireStore.collection('users').doc(signedInUser.uid).set({
          'name': name,
          'email': email,
          'profilePicture': '',
          'coverImage': '',
          'bio': ''
        });
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
   
  static Future<void> resetPassword(String email, BuildContext context) async {
    try {
      if (email.isEmpty) {
        showSnackBar(context, 'Enter Your Email');
      } else {
        await _auth.sendPasswordResetEmail(email: email);
        showSnackBar(context, 'Password reset email sent');
      }
    } catch (e) {
      showSnackBar(context, 'Invalid email');
    }
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
 
  static void logout() {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
