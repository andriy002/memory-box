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
          bucket: 'gs://memory-box-9c2a3.appspot.com/');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void _addAudioInFirestore(
    String audioName,
    String audioUrl,
    String duration,
  ) {
    AudioBuilder audio = AudioBuilder(
      uid: _uuid.v1(),
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

  Future<void> addAudio(String name, String path, String duration) async {
    Reference storageRef =
        storage.ref('users/${_firebaseAuth.currentUser?.uid}/audio/$name');
    storageRef.putFile(File(path));

    String url = (await storageRef.getDownloadURL()).toString();

    _addAudioInFirestore(name, url, duration);
    //   document("fitness_teams/Team_1").
    // updateData(["step_counter" : FieldValue.increment(500)])
  }

  List<AudioBuilder> _audioFromSnap(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => AudioBuilder.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<AudioBuilder>> get audio {
    return _audio
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .snapshots()
        .map(_audioFromSnap);
  }
}

void a() async {
  // _audio
  //     .doc(_firebaseAuth.currentUser?.uid)
  //     .collection('allAudio')
  //     .where('audioName')
  //     .get()
  //     .then(
  //       (value) => value.docs[2].data().update('duration', (value) {
  //         value = 'ddddddddd';
  //         print(value);
  //       }, ifAbsent: () => true),
  //     );

  // var a = _audio
  //     .doc(_firebaseAuth.currentUser?.uid)
  //     .collection('allAudio')
  //     .get()
  //     .then((value) => value.docs.forEach((element) {
  //           print(element.data().remove('audioName'));
  //         }));

  // var a = await _audio
  //     .doc(_firebaseAuth.currentUser?.uid)
  //     .collection('allAudio')
  //     .doc('7d818fd0-5ce2-11ec-8e80-ff52c1f1b689')
  //     .snapshots()
  //     .length;
  // print(a);

  //  return _db
  //   .collection('jobs')
  //   .where("categoryId", isEqualTo: categoryId)
  //   .getDocuments()
  //   .then((v) {
  //     try{
  //       v.documents[0].data.update('isApproved', (bool) => true,ifAbsent: ()=>true);

  // _audio
  //     .doc(_firebaseAuth.currentUser?.uid)
  //     .collection('allAudio')
  //     .doc('b5035bb0-5ccd-11ec-9f8f-e585543a5183')
  //     .delete();
}
