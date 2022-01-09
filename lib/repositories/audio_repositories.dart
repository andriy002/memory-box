import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as _firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AudioRepositories {
  static final AudioRepositories _repositories = AudioRepositories._instance();
  AudioRepositories._instance();
  static AudioRepositories get instance => _repositories;
  final Uuid _uuid = const Uuid();

  // final _idAudio = DateTime.now().toString();

  final CollectionReference _audio =
      FirebaseFirestore.instance.collection('audio');

  _firebase_storage.FirebaseStorage storage =
      _firebase_storage.FirebaseStorage.instanceFor(
          bucket: 'memory-box-9c2a3.appspot.com');

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
        .set(audio.toJson())
        .catchError((e) => print(e.toString()));
  }

  Future<void> addAudio(String path, String audioName, String duration) async {
    try {
      Reference storageRef = storage
          .ref('users/${_firebaseAuth.currentUser?.uid}/audio/$audioName');

      await storageRef.putFile(File(path));
      final String url = (await storageRef.getDownloadURL()).toString();

      _addAudioInFirestore(audioName, duration, url);
    } catch (e) {
      print(e.toString());
    }
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

  Stream<List<AudioBuilder>> searchAudio(String searchKey) {
    return _audio
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .where('searchKey', isGreaterThanOrEqualTo: searchKey.toLowerCase())
        .where('searchKey', isLessThan: searchKey.toLowerCase() + '\uf8ff')
        .snapshots()
        .map(_audioFromSnap);
  }

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

  // List a = [
  //   '138ca9a0-63ec-11ec-954c-b9b24adfce86',
  //   '13d635c0-63ec-11ec-954c-b9b24adfce86',
  //   '13a7abb0-63ec-11ec-954c-b9b24adfce86',
  //   '1193e6e0-63ec-11ec-954c-b9b24adfce86',
  //   '13f02660-63ec-11ec-954c-b9b24adfce86'
  // ];
  // a.forEach((element) {
  //   b('test123', element);
  // });

  // void b(String col, String doc) async {
  //   List a = [col];
  //   await _audio
  //       .doc(_firebaseAuth.currentUser!.uid)
  //       .collection('allAudio')
  //       .doc(doc)
  //       .get()
  //       .then((value) {
  //     final i = value.get('collections');
  //     a.addAll(i);
  //     //   document("fitness_teams/Team_1").
  //     // updateData(["step_counter" : FieldValue.increment(500)])
  //   });
  //   _audio
  //       .doc(_firebaseAuth.currentUser!.uid)
  //       .collection('allAudio')
  //       .doc(doc)
  //       .update({'collections': a});
  //   //     .set({
  //   'nameCol': ['121113']
  // }, SetOptions(merge: true));

  // _audio
  //     .doc(_firebaseAuth.currentUser?.uid)
  //     .collection('allAudio')
  //     .where('nameCol', arrayContains: 'audioTest2')
  // .snapshots()
  // .map((event) => null);
  // .get()
  // .then((value) => value.docs.forEach((element) {
  //       print(element.data());
  //     }));
  //   document("fitness_teams/Team_1").
  // updateData(["step_counter" : FieldValue.increment(500)])
}
// }

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
