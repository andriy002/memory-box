import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/models/collections.model.dart';
import 'package:firebase_storage/firebase_storage.dart' as _firebase_storage;

class CollectionsRepositories {
  static final CollectionsRepositories _repositories =
      CollectionsRepositories._instance();
  CollectionsRepositories._instance();
  static CollectionsRepositories get instance => _repositories;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _collections =
      FirebaseFirestore.instance.collection('audio');

  _firebase_storage.FirebaseStorage storage =
      _firebase_storage.FirebaseStorage.instanceFor(
          bucket: 'gs://memory-box-9c2a3.appspot.com/');

  List<CollectionsBuilder> _collectionFromSnap(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) =>
            CollectionsBuilder.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<String> updatePhoto(String name) async {
    final String _uid = _firebaseAuth.currentUser!.uid;
    Reference storageRef = storage.ref('users/$_uid/collections-photo/$name');
    String url = (await storageRef.getDownloadURL()).toString();
    return url;
  }

  Future<void> uploadProfilePhoto(File file, String name) async {
    final String _uid = _firebaseAuth.currentUser!.uid;
    Reference storageRef = storage.ref('users/$_uid/collections-photo/$name');
    storageRef.putFile(file);
  }

  Future<void> _deleteAudioInCollections(
      String doc, List collectionName) async {
    List listCollectionName = [];
    await _collections
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .doc(doc)
        .get()
        .then((value) {
      final List listNameCol = value.get('collections');
      for (String element in collectionName) {
        listNameCol.remove(element);
      }

      listCollectionName.addAll(listNameCol);
    });

    _collections
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .doc(doc)
        .update({'collections': listCollectionName});
  }

  void deleteCollection(String name) {
    if (name.isEmpty) return;
    _collections
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('collections')
        .doc(name)
        .delete();
  }

  void deletedAudioInCollection(List colectionName) {
    _collections
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .where('collections', arrayContainsAny: colectionName)
        .get()
        .then(
      (value) {
        for (var element in value.docs) {
          _deleteAudioInCollections(element.data()['uid'], colectionName);
        }
      },
    );
  }

  Future<void> addAudioInCollection(String col, String doc) async {
    List colectionName = [col];
    await _collections
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .doc(doc)
        .get()
        .then((value) {
      final List collections = value.get('collections');

      colectionName.addAll(collections);
    });
    _collections
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .doc(doc)
        .update({'collections': colectionName});
  }

  Future<void> addAudioInCollectionList(List col, String doc) async {
    await _collections
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .doc(doc)
        .get()
        .then((value) {
      final List collections = value.get('collections');
      col.addAll(collections);
    });
    _collections
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .doc(doc)
        .update({'collections': col.toSet().toList()});
  }

  void createNewCollection(
      String name, String description, String image, int length) {
    CollectionsBuilder collections = CollectionsBuilder(
        descriptions: description,
        name: name,
        length: length,
        image: image,
        displayName: name);
    _collections
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('collections')
        .doc(name)
        .set(collections.toJson());
  }

  List<AudioBuilder> _audioFromSnap(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => AudioBuilder.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<CollectionsBuilder>> get colllections {
    return _collections
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('collections')
        .snapshots()
        .map(_collectionFromSnap);
  }

  Stream<List<AudioBuilder>> audioFromCollection(String collectionName) {
    return _collections
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('allAudio')
        .where('collections', arrayContains: collectionName)
        .snapshots()
        .map(_audioFromSnap);
  }
}
