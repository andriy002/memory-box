import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memory_box/models/collections.model.dart';

class CollectionsRepositories {
  static final CollectionsRepositories _repositories =
      CollectionsRepositories._instance();
  CollectionsRepositories._instance();
  static CollectionsRepositories get instance => _repositories;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _collections =
      FirebaseFirestore.instance.collection('audio');

  List<CollectionsBuilder> _audioFromSnap(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) =>
            CollectionsBuilder.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<CollectionsBuilder>> get colllections {
    return _collections
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('collections')
        .snapshots()
        .map(_audioFromSnap);
  }
}
