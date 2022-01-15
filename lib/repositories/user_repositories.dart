import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memory_box/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as _firebase_storage;

class UsersRepositories {
  static final UsersRepositories _repositories = UsersRepositories._instance();
  UsersRepositories._instance();
  static UsersRepositories get instance => _repositories;

  _firebase_storage.FirebaseStorage storage =
      _firebase_storage.FirebaseStorage.instanceFor(
          bucket: 'memory-box-9c2a3.appspot.com');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // update avatar user

  Future<void> updatePhoto(File avatar) async {
    final String _uid = _firebaseAuth.currentUser!.uid;
    final String url = await uploadProfilePhoto(avatar);

    users.doc(_uid).update({'avatarUrl': url});
    _firebaseAuth.currentUser!.updatePhotoURL(url);
  }

  // check user phone numb

  bool checkAuthUser() {
    if (_firebaseAuth.currentUser?.phoneNumber == null) {
      return false;
    } else {
      return true;
    }
  }

  // update display name

  void updateDisplayName(String name) {
    final String _uid = _firebaseAuth.currentUser!.uid;
    users.doc(_uid).update({'displayName': name});
    _firebaseAuth.currentUser!.updateDisplayName(name);
  }

  // update phone numb

  void updatePhoneNumb(String phone) {
    final String _uid = _firebaseAuth.currentUser!.uid;
    users.doc(_uid).update({'phoneNumb': phone});
  }

  // deleted account

  void deleteAccount() {
    final String _uid = _firebaseAuth.currentUser!.uid;
    _firebaseAuth.currentUser!.updateDisplayName('');
    _firebaseAuth.currentUser!.updatePhotoURL(null);
    users.doc(_uid).delete();
    _firebaseAuth.signOut();
  }

  // upload user avatar in storage

  Future<String> uploadProfilePhoto(File file) async {
    final String _uid = _firebaseAuth.currentUser!.uid;
    Reference storageRef = storage.ref('users/$_uid/profile/user-$_uid-avatar');
    await storageRef.putFile(file);
    final String url = (await storageRef.getDownloadURL()).toString();

    return url;
  }

  // stream user

  Stream<UserBuilder> get user {
    final String _uid = _firebaseAuth.currentUser!.uid;
    final Stream<DocumentSnapshot> userStream =
        FirebaseFirestore.instance.collection('users').doc(_uid).snapshots();
    return userStream.map(
      (DocumentSnapshot snapshot) {
        return UserBuilder.fromJson(snapshot.data() as Map<String, dynamic>);
      },
    );
  }
}
