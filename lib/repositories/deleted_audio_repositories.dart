import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as _firebase_storage;
import 'package:memory_box/models/audio_model.dart';

class DeletedAudioRepositories {
  static final DeletedAudioRepositories _repositories =
      DeletedAudioRepositories._instance();
  DeletedAudioRepositories._instance();
  static DeletedAudioRepositories get instance => _repositories;
  final _firebaseAuthCurrentUser = FirebaseAuth.instance;

  final CollectionReference _audio =
      FirebaseFirestore.instance.collection('audio');

  _firebase_storage.FirebaseStorage storage =
      _firebase_storage.FirebaseStorage.instanceFor(
          bucket: 'memory-box-9c2a3.appspot.com');

  // delete audio in storage and firestore

  Future<void> deletedAudioInStorage(String doc) async {
    await _audio
        .doc(_firebaseAuthCurrentUser.currentUser?.uid)
        .collection('deleteAudio')
        .doc(doc)
        .get()
        .then((value) {
      final String url = value.get('audioUrl');
      storage.refFromURL(url).delete();
    });
    _audio
        .doc(_firebaseAuthCurrentUser.currentUser?.uid)
        .collection('deleteAudio')
        .doc(doc)
        .delete();
  }

  // restore audio in firestore

  Future<void> restoreAudio(String doc) async {
    if (doc.isEmpty) return;

    AudioBuilder audio = AudioBuilder();

    await _audio
        .doc(_firebaseAuthCurrentUser.currentUser?.uid)
        .collection('deleteAudio')
        .doc(doc)
        .get()
        .then(
      (value) {
        audio = AudioBuilder(
          uid: doc,
          audioName: value.get('audioName'),
          audioUrl: value.get('audioUrl'),
          duration: value.get('duration'),
          searchKey: value.get('audioName').toLowerCase(),
          collections: [],
        );
      },
    );
    await _audio
        .doc(_firebaseAuthCurrentUser.currentUser?.uid)
        .collection('allAudio')
        .doc(doc)
        .set(
          audio.toJson(),
        );
    _audio
        .doc(_firebaseAuthCurrentUser.currentUser?.uid)
        .collection('deleteAudio')
        .doc(doc)
        .delete();
  }

  // maping data fron stream

  List<AudioBuilder> _audioFromSnap(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => AudioBuilder.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // stream deleted audio

  Stream<List<AudioBuilder>> get audio {
    return _audio
        .doc(_firebaseAuthCurrentUser.currentUser?.uid)
        .collection('deleteAudio')
        .snapshots()
        .map(_audioFromSnap);
  }
}
