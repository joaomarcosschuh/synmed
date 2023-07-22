import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createUserRecord(String email, String name, String medicinaEtapa) async {
    User? user = _auth.currentUser;
    if (user == null) {
      debugPrint("No current user found");
      return;
    }

    debugPrint("New user, creating user data");
    await _db.collection('users').doc(user.uid).set({
      'email': email,
      'uid': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
      'username': '',
      'birthdate': null,
      'profilePicture': null,
      'name': name,
      'medicinaEtapa': medicinaEtapa,
    });
    debugPrint("User data created for user with uid: ${user.uid}");
  }

  Future<void> updateUserInfo(String username, DateTime birthdate, dynamic profilePicture, String name, String medicinaEtapa) async {
    User? user = _auth.currentUser;
    if (user == null) {
      debugPrint("No current user found");
      return;
    }

    debugPrint("User already exists, updating user data");
    await _db.collection('users').doc(user.uid).update({
      'username': username,
      'birthdate': birthdate,
      'profilePicture': profilePicture,
      'name': name,
      'medicinaEtapa': medicinaEtapa,
    });
    debugPrint("User data updated for user with uid: ${user.uid}");
  }

  Future<void> updateLastLoginAt(String uid, DateTime lastLoginAt) async {
    await _db.collection('users').doc(uid).update({
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
    });
    debugPrint("Last login updated for user with uid $uid");
  }

  Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
    debugPrint("User deleted with uid $uid");
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
    await _db.collection('users').doc(uid).get();
    if (!docSnapshot.exists) {
      debugPrint("No user found with uid $uid");
      throw Exception('User not found');
    } else {
      debugPrint("User found with uid $uid");
      return docSnapshot;
    }
  }
}
