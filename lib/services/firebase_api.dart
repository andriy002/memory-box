import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

import 'package:memory_box/model/firebase_file.dart';

class FirebaseApi {
  static Future<List<String>> _getDownloadLinks(List<Reference> ref) =>
      Future.wait(ref.map((ref) => ref.getDownloadURL()).toList());
  static Future<List<FirebaseFile>> listAll(String patch) async {
    final ref = FirebaseStorage.instance.ref(patch);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final refs = result.items[index];
          final name = refs.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);
          return MapEntry(index, file);
        })
        .values
        .toList();
  }
}
