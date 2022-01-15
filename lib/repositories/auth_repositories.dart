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

  // send sms otp

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

  // add user in forestore

  void _addUserFireStore() {
    UserBuilder user = UserBuilder(
      phoneNumb: _auth.currentUser?.phoneNumber ?? 'Регистрация',
      displayName: _auth.currentUser?.displayName ?? 'Здесь будет твоё имя',
      avatarUrl: _auth.currentUser?.photoURL ?? '',
    );
    _users.doc(_auth.currentUser!.uid).set(user.toJson());
  }

  // check sms otp

  Future<void> auth(String code) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        smsCode: code, verificationId: _vereficationCode ?? '');
    await _auth.signInWithCredential(credential);
    _addUserFireStore();
  }

  // update phone numb

  Future<void> updateNumb(String code) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _vereficationCode ?? '', smsCode: code);
    await _auth.currentUser?.updatePhoneNumber(credential);
  }

  //sign out account

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // sign in anon

  Future<void> signInAnon() async {
    await _auth.signInAnonymously();
    _addUserFireStore();
  }
}
