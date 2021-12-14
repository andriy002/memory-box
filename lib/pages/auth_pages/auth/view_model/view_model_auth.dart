import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memory_box/repositories/auth_repositories.dart';

class _ViewModelState {
  bool sendSms = false;
  String authError = '';
  String phone = '';
  String code = '';
}

class ViewModelAuth with ChangeNotifier {
  final _ViewModelState _state = _ViewModelState();
  _ViewModelState get state => _state;
  final AuthRepositories _authRepo = AuthRepositories.instance;

  Future<void> auth(String code, String phone, Function nav) async {
    if (_state.sendSms) {
      try {
        await _authRepo.auth(code);
        nav();
      } catch (e) {
        print(' Потрібний дизайн для : ${e.toString()}');
      }
      _state.sendSms = false;
      notifyListeners();
    } else {
      if (phone.length < 13) {
        _state.authError = 'В вашем номере телефона недостаточно символов';
        notifyListeners();
        return;
      }
      await _authRepo.authSendCode(phone);
      _state.phone = phone;
      _state.sendSms = true;
      notifyListeners();
    }
  }

  void signInAnon() {
    _authRepo.signInAnon();
  }
}




  // Future<void> onPrassedButtonSendSms(String phone) async {
  //   if (phone.length < 13) {
  //     _state.authError = 'В вашем номере телефона недостаточно символов';
  //     notifyListeners();
  //     return;
  //   }
  //   try {
  //     await _authRepo.authSendCode(phone);
  //     _state.sendSms = true;
  //     _state.authError = '';
  //     notifyListeners();
  //   } catch (e) {
  //     print('Потрібний дизайн для : ${e.toString()}');
  //   }
  // }

  // void onAuthButtonPressed(String code, Function() nav) {
  //   try {
  //     if (code.isEmpty) return;
  //     _authRepo.auth(code);
  //     _state.authError = '';
  //     nav();
  //   } catch (e) {
  //     print('Потрібний дизайн для ${e.toString()}');
  //   }
  // }