import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_box/repositories/auth_repositories.dart';
import 'package:memory_box/repositories/user_repositories.dart';

class _ViewModelProfileState {
  bool editToogle = false;
  File? imageUrl;
  String displayName = '';
  bool sendSms = false;
  String phone = '';
}

class ViewModelProfile with ChangeNotifier {
  final _ViewModelProfileState _state = _ViewModelProfileState();
  _ViewModelProfileState get state => _state;
  final UsersRepositories _userRepo = UsersRepositories.instance;
  final AuthRepositories _authRepo = AuthRepositories.instance;

  void editToogle() {
    if (_state.editToogle) {
      _state.editToogle = false;
      if (_state.displayName.isNotEmpty) {
        _userRepo.updateDisplayName(_state.displayName);
      }
      if (_state.imageUrl != null) {
        _userRepo.updatePhoto();
      }
      notifyListeners();
    } else {
      _state.editToogle = true;
      _state.imageUrl = null;
      notifyListeners();
    }
  }

  Future<void> updatePhoneNumb(String code, String phone) async {
    if (_state.sendSms) {
      try {
        await _authRepo.updateNumb(code);
        _userRepo.updatePhoneNumb(code);
      } catch (e) {
        print(' Потрібний дизайн для : ${e.toString()}');
      }
      _state.sendSms = false;
      notifyListeners();
    } else {
      try {
        await _authRepo.authSendCode(phone);
        _state.phone = phone;
        _state.sendSms = true;
        notifyListeners();
      } catch (e) {
        print(' Потрібний дизайн для : ${e.toString()}');
      }
    }
  }

  Future<void> deleteAcc(Function nav) async {
    nav();
    try {
      await _userRepo.deleteUser();
    } catch (e) {
      print(e.toString());
    }
  }

  void displayNameController(String name) {
    if (name.isEmpty) return;
    _state.displayName = name;
    notifyListeners();
  }

  Future<void> signOut(Function nav) async {
    await _authRepo.signOut();
    nav();
  }

  Future<void> imagePicker() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 720,
        maxWidth: 720,
      );

      if (image == null) return;

      final _lmageTemporary = File(image.path);
      _state.imageUrl = _lmageTemporary;

      await _userRepo.uploadProfilePhoto(_state.imageUrl!);

      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
