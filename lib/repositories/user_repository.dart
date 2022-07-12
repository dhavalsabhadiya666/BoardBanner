import 'dart:io';

import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/repositories/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserRepository {
  final FirestoreCollections collections;
  final AuthenticationRepository auth;

  UserRepository({required this.collections, required this.auth});

  Future<void> createUser(UserData user) {
    return collections.userDoc(user.userId ?? '').set(user.toMap());
  }

  Stream<UserData> userStream() {
    User? user = auth.user;
    if (user != null) {
      return collections.userDoc(user.uid).snapshots().map((doc) {
        return UserData.fromMap(doc.data() as Map<String, dynamic>);
      });
    } else {
      return const Stream.empty();
    }
  }

  Stream<UserData> getUserById(String? userId) {
    return collections.userDoc(userId).snapshots().map((doc) {
      return UserData.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  Future<void> updateUser(UserData user) {
    return collections.userDoc(user.userId).update(user.toMap());
  }

  Future<void> deleteUser(String uid) {
    return collections.userDoc(uid).delete();
  }

  Future<void> updateUserField(String fieldName, dynamic value,
      {String? userId}) {
    if (userId != null) {
      return collections.userDoc(userId).update({
        fieldName: value,
        FirestoreFields.updatedAt:
            DateTime.now().millisecondsSinceEpoch.toString(),
      });
    } else {
      User? user = auth.user;
      return collections.userDoc(user?.uid).update({
        fieldName: value,
        FirestoreFields.updatedAt:
            DateTime.now().millisecondsSinceEpoch.toString(),
      });
    }
  }

  Future<bool> checkUserExisting(String? email) {
    return collections.usersRef
        .where(FirestoreFields.email, isEqualTo: email)
        .get()
        .then((snapshots) {
      return snapshots.docs.length == 1;
    });
  }

  Future<String?> uploadPhoto(File file) async {
    User? user = auth.user;

    Reference reference = FirebaseStorage.instance
        .ref()
        .child(collections.users)
        .child(user?.uid ?? DateTime.now().millisecondsSinceEpoch.toString())
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    return await reference.putFile(file).then((snapshot) async {
      return await snapshot.ref.getDownloadURL();
    });
  }
}
