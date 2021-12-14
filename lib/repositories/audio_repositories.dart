import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memory_box/models/audio.dart';
import 'package:firebase_storage/firebase_storage.dart' as _firebase_storage;
import 'package:uuid/uuid.dart';

class AudioRepositories {
  static final AudioRepositories _repositories = AudioRepositories._instance();
  AudioRepositories._instance();
  static AudioRepositories get instance => _repositories;
  Uuid _uuid = const Uuid();

  final CollectionReference _audio =
      FirebaseFirestore.instance.collection('audio');
  _firebase_storage.FirebaseStorage storage =
      _firebase_storage.FirebaseStorage.instanceFor(
          bucket: 'gs://memory-box-9c2a3.appspot.com/');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void _addAudioFirestore(
    String audioName,
    String audioUrl,
    String duration,
  ) {
    AudioBuilder audio = AudioBuilder(
      audioName: audioName,
      audioUrl: audioUrl,
      duration: duration,
    );

    _audio
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('allAudio')
        .doc(_uuid.v1())
        .set(audio.toJson())
        .catchError((e) => print(e.toString()));
  }

  void a() async {
    // _audio
    //     .doc(_firebaseAuth.currentUser?.uid)
    //     .collection('allAudio')
    //     .where('audioName', isEqualTo: 'Аудиозапrtyurtyurtyuись')
    //     .get()
    //     .then(
    //       (value) => print(value.docs.length),
    //     );

    storage
        .refFromURL(
            'https://firebasestorage.googleapis.com/v0/b/memory-box-9c2a3.appspot.com/o/users%2FwSJ44GJwdJU1KVGeYKE0CjBQ9bn1%2Faudio%2F%D0%90%D1%83%D0%B4%D0%B8%D0%BE%D0%B7%D0%B0%D0%BFhhh%D0%B8%D1%81%D1%8C?alt=media&token=4c700dfc-2446-4cda-b6b4-c4a9b4636b06')
        .delete();

    // _audio
    //     .doc(_firebaseAuth.currentUser?.uid)
    //     .collection('allAudio')
    //     .doc('b5035bb0-5ccd-11ec-9f8f-e585543a5183')
    //     .delete();
  }

  Future<void> addAudio(String name, String path, String duration) async {
    Reference storageRef =
        storage.ref('users/${_firebaseAuth.currentUser?.uid}/audio/$name');
    storageRef.putFile(File(path));
    String url = (await storageRef.getDownloadURL()).toString();
    _addAudioFirestore(name, url, duration);
  }

  //   Future<void> uploadProfilePhoto(File file) async {
  //   final String _uid = _firebaseAuth.currentUser!.uid;
  //   Reference storageRef = storage.ref('users/$_uid/profile/user-$_uid-avatar');
  //   storageRef.putFile(file);
  // }

  //   Future<void> updatePhoto() async {
  //   final String _uid = _firebaseAuth.currentUser!.uid;
  //   Reference storageRef = storage.ref('user/$_uid/profile/user-$_uid-avatar');
  //   String url = (await storageRef.getDownloadURL()).toString();
  //   users.doc(_uid).update({'avatarUrl': url});
  //   _firebaseAuth.currentUser!.updatePhotoURL(url);
  // }

  // void _addAudioFireStore() {
  // AudioBuilder user = AudioBuilder(
  //   phoneNumb:
  //       _auth.currentUser?.phoneNumber ?? 'Здесь можно зарегистрироваться',
  //   displayName: _auth.currentUser?.displayName ?? 'Здесь будет твоё имя',
  //   avatarUrl: _auth.currentUser?.photoURL ?? '',
  // );
  // _users
  //     .doc(_auth.currentUser!.uid)
  //     .set(user.toJson())
  //     .catchError((e) => print(e.toString()));
  // }

  //   Future<void> updatePhoto() async {
  //   final String _uid = _firebaseAuth.currentUser!.uid;
  //   Reference storageRef = storage.ref('user/$_uid/profile/user-$_uid-avatar');
  //   String url = (await storageRef.getDownloadURL()).toString();
  //   users.doc(_uid).update({'avatarUrl': url});
  //   _firebaseAuth.currentUser!.updatePhotoURL(url);
  // }
}
