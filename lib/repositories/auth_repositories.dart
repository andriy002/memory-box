import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memory_box/models/user_model.dart';

class AuthRepositories {
  static final AuthRepositories _repositories = AuthRepositories._instance();
  AuthRepositories._instance();
  static AuthRepositories get instance => _repositories;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  String? _vereficationCode;
  bool eventAuth = false;

  Future<void> authSendCode(String phone) async {
    await _auth.verifyPhoneNumber(
      verificationFailed: (FirebaseAuthException error) {},
      phoneNumber: phone,
      timeout: const Duration(seconds: 120),
      codeSent: (String vereficationId, int? forceResendingToken) {
        _vereficationCode = vereficationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
    );
  }

  void _addUserFireStore() {
    UserBuilder user = UserBuilder(
      phoneNumb:
          _auth.currentUser?.phoneNumber ?? 'Здесь можно зарегистрироваться',
      displayName: _auth.currentUser?.displayName ?? 'Здесь будет твоё имя',
      avatarUrl: _auth.currentUser?.photoURL ?? '',
    );
    _users.doc(_auth.currentUser!.uid).set(user.toJson());
  }

  Future<void> auth(String code) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        smsCode: code, verificationId: _vereficationCode ?? '');
    await _auth.signInWithCredential(credential);
    _addUserFireStore();
  }

  Future<void> updateNumb(String code) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _vereficationCode ?? '', smsCode: code);
    await _auth.currentUser?.updatePhoneNumber(credential);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> signInAnon() async {
    await _auth.signInAnonymously();
    _addUserFireStore();
  }
}
