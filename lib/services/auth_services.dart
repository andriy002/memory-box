import 'dart:async';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/Model/user_model.dart';
import 'package:provider/src/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthServices with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get auth => _auth;

  bool _toogle = false;
  // bool? _record;

  bool get toogle => _toogle;
  // bool get record => _record!;

  // set recordToogle(bool tog) {
  //   _record = tog;
  //   notifyListeners();
  // }

  set changeToogle(bool tog) {
    _toogle = tog;
    notifyListeners();
  }

  bool _sendSms = false;
  bool get sendSms => _sendSms;

  set changeSendSms(bool sms) {
    _sendSms = sms;
    notifyListeners();
  }

  Future signOut() async {
    await _auth.signOut();
  }

  Future deleteAcc() async {
    await _auth.currentUser?.delete();
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instanceFor(
          bucket: 'gs://memorybox-d633c.appspot.com');

  String chechAuth() {
    if (_auth.currentUser != null) {
      return '/landing_page';
    } else {
      return '/';
    }
  }

  Future<void> uploadProfilePhoto(File file) async {
    try {
      var user = await getUser();
      var storageRef = storage
          .ref()
          .child('user/${user.uid}/profile/user-${user.uid}-avatar');
      storageRef.putFile(file);
      var complitedTask = (await storageRef.getDownloadURL()).toString();
      _auth.currentUser?.updatePhotoURL(complitedTask);
      UserModel(avatarUrl: complitedTask);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> pushAudio(String path, String audioName) async {
    try {
      if (audioName == 'Аудиозапись') {
        audioName += ' ' + await listAudio();
      }
      UserModel user = await getUser();
      Reference storageRef =
          storage.ref().child('user/${user.uid}/audio/${audioName}.aac');
      storageRef.putFile(File(path));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> listAudio() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref('user/${_auth.currentUser?.uid}/audio')
        .listAll();

    int length = result.items.length;
    return length.toString();
  }

  void updateDisplayName(String controller) {
    _auth.currentUser?.updateDisplayName(controller);
  }

  Future UpdateNumb(BuildContext context, String code) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: Provider.of<AuthServices>(context, listen: false)
              .myVerificationId,
          smsCode: code);

      await _auth.currentUser?.updatePhoneNumber(credential);
    } catch (e) {
      print(e.toString());
    }
  }

  Stream getCurrentUser() {
    return _auth.userChanges();
  }

  UserModel getUser() {
    var user = UserModel(
        uid: _auth.currentUser?.uid,
        phoneNumb: _auth.currentUser?.phoneNumber,
        displayName: _auth.currentUser?.displayName,
        avatarUrl: _auth.currentUser?.photoURL);
    return user;
  }

  // Stream<UserModel> user() {
  //   var stream = StreamController<UserModel>().onListen;
  //   return stream;
  // }

  String _myVerificationId = '';
  String get myVerificationId => _myVerificationId;

  void changeVerificationId(newVereficationId) {
    _myVerificationId = newVereficationId;
    notifyListeners();
  }

  Future verifyPhoneNumber(BuildContext context, String phone) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: const Duration(seconds: 120),
          verificationFailed: (FirebaseException error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.code)));
          },
          codeSent: (String vereficationId, int? forceResendingToken) {
            context.read<AuthServices>().changeVerificationId(vereficationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {});
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future verifyCode(BuildContext context, String code) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: Provider.of<AuthServices>(context, listen: false)
              .myVerificationId,
          smsCode: code);

      await _auth.signInWithCredential(credential);
      Navigator.of(context).pop('/auth');

      Navigator.of(context).pushReplacementNamed('/spash_screen');
    } catch (e) {
      print(e.toString());
      return Navigator.of(context).pushReplacementNamed('/auth');
    }
  }

  Future signInAnon(BuildContext context) async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      Navigator.of(context).pop('/auth');

      User? user = result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
