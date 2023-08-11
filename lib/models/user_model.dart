import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final DateTime? birthdate;
  final dynamic profilePicture;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final String name;
  final String medicinaEtapa;

  UserModel({
    required this.uid,
    required this.email,
    this.username = '',
    this.birthdate,
    this.profilePicture,
    required this.createdAt,
    required this.lastLoginAt,
    required this.name,
    required this.medicinaEtapa,
  });

  UserModel.fromDocumentSnapshot(DocumentSnapshot doc)
      : uid = doc['uid'],
        email = doc['email'],
        username = doc['username'] ?? '',
        birthdate = (doc['birthdate'] as Timestamp?)?.toDate(),
        profilePicture = doc['profilePicture'],
        createdAt = (doc['createdAt'] as Timestamp).toDate(),
        lastLoginAt = (doc['lastLoginAt'] as Timestamp).toDate(),
        name = doc['name'],
        medicinaEtapa = doc['medicinaEtapa'];

  UserModel.defaultUser()
      : uid = 'default',
        email = 'default@email.com',
        username = '',
        birthdate = null,
        profilePicture = null,
        createdAt = DateTime.now(),
        lastLoginAt = DateTime.now(),
        name = 'Default',
        medicinaEtapa = '';
}
