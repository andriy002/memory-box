import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as _firebase_storage;
import 'package:uuid/uuid.dart';

class AudioRepositories {
  static final AudioRepositories _repositories = AudioRepositories._instance();
  AudioRepositories._instance();
  static AudioRepositories get instance => _repositories;
  final Uuid _uuid = const Uuid();

  final CollectionReference _audio =
      FirebaseFirestore.instance.collection('audio');

  _firebase_storage.FirebaseStorage storage =
      _firebase_storage.FirebaseStorage.instanceFor(
          bucket: 'memory-box-9c2a3.appspot.com');

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

// add audio in firestore

  Future<void> _addAudioInFirestore(
      String audioName, String duration, String url) async {
    final String id = _uuid.v1();

    AudioBuilder audio = AudioBuilder(
      uid: id,
      audioName: audioName,
      audioUrl: url,
      duration: duration,
      searchKey: audioName.toLowerCase(),
      collections: [],
    );

    _audio
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('allAudio')
        .doc(id)
        .set(
          audio.toJson(),
        );
  }

// add audio in storage

  Future<void> addAudioInStorage(
      String path, String audioName, String duration) async {
    Reference storageRef =
        storage.ref('users/${_firebaseAuth.currentUser?.uid}/audio/$audioName');

    await storageRef.putFile(File(path));
    final String url = await storageRef.getDownloadURL();

    _addAudioInFirestore(audioName, duration, url);
  }

// send audio to deteled collection and remove in all audio

  Future<void> sendAudioToDeleteColection(String uid) async {
    if (uid.isEmpty) return;

    AudioBuilder audio = AudioBuilder();

    await _audio
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .doc(uid)
        .get()
        .then((value) {
      audio = AudioBuilder(
          uid: uid,
          audioName: value.get('audioName'),
          audioUrl: value.get('audioUrl'),
          duration: value.get('duration'),
          searchKey: value.get('audioName').toLowerCase(),
          collections: []);
    });

    await _audio
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('deleteAudio')
        .doc(uid)
        .set(
          audio.toJson(),
        );

    await _audio
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .doc(uid)
        .delete();
  }

// delete all audio

  void deleteAllAudio() {
    _audio.doc(_firebaseAuth.currentUser?.uid).delete();
  }

// update audio name

  Future<void> updateAudioName(String uid, String name) async {
    await _audio
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .doc(uid)
        .update(
      {'audioName': name},
    );
    await _audio
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .doc(uid)
        .update(
      {'searchKey': name.toLowerCase()},
    );
  }

  // maping data from stream firestore

  List<AudioBuilder> _audioFromSnap(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => AudioBuilder.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // stream audio in firestore

  Stream<List<AudioBuilder>> get audio {
    return _audio
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .snapshots()
        .map(_audioFromSnap);
  }

  // search audio stream

  Stream<List<AudioBuilder>> searchAudio(String searchKey) {
    return _audio
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .where('searchKey', isGreaterThanOrEqualTo: searchKey.toLowerCase())
        .where('searchKey', isLessThan: searchKey.toLowerCase() + '\uf8ff')
        .snapshots()
        .map(_audioFromSnap);
  }
}
