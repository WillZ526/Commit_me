import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Entry.dart';

class AppState {
  /*AppState() {
    _entriesStreamController = StreamController.broadcast(onListen: () {
      _entriesStreamController.add([
        Entry(
          date: '10/09/2022',
          journal: lorem,
          title: '[Example] My Journal Entry',
        )
      ]);
    });
  }*/

  /*late StreamController<List<Entry>> _entriesStreamController;
  
  Stream<List<Entry>> get entries =>
      _entriesStreamController.stream.asBroadcastStream();*/

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    resetUser();
  }

  Future<String> signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.signOut();
      return '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'email is in use';
      }
    } catch (e) {
      return e.toString();
    }
    return 'Something went wrong in signin';
  }

  Future<String> logIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      setCurrentUser(credential.user);
      return '';
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'wrong-password') {
        return 'The email or password is incorrect.';
      } else if (e.code == 'user-not-found') {
        return 'The email or password is incorrect.';
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
    throw 'Login Error';
  }

  User? user = FirebaseAuth.instance.currentUser;
  User? getCurrentFirebaseUser() =>
      FirebaseAuth.instance.currentUser; //testing purpose
  User? getCurrentUser() => user; //testing purpose
  void setCurrentUser(User? user) => this.user = user; //testing purpose
  void resetUser() =>
      user = FirebaseAuth.instance.currentUser; //testing purpose
}
/*
await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'tokens': FieldValue.arrayUnion([token]),
      });*/
