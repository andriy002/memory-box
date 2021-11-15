import 'package:flutter/material.dart';
import 'package:memory_box/screen/Auth/auth.dart';
import 'package:memory_box/screen/Auth/auth_confirm.dart';
import 'package:memory_box/screen/Auth/home_page_no_auth.dart';
import 'package:memory_box/screen/Auth/landingPage.dart';
import 'package:memory_box/screen/Auth/splash_screen.dart';
import 'package:memory_box/screen/Main/main_screen.dart';
import 'package:memory_box/screen/audio.dart';
import 'package:memory_box/screen/profile.dart';
import 'package:memory_box/screen/record/record.dart';
import 'package:memory_box/screen/selections.dart';
import 'package:memory_box/screen/test.dart';

abstract class Routes {
  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    '/': (context) => HomePageNoAuth(),
    '/auth': (context) => Auth(),
    '/auth_confirm': (context) => AuthConfirm(),
    '/test': (context) => AudioRecord(),
    '/landing_page': (context) => LandingPage(),
    '/spash_screen': (context) => SplashScreen(),
    '/main_screen': (context) => Main(),
    '/selections': (context) => Selectionts(),
    '/record': (context) => Record(),
    '/audio': (context) => Audio(),
    '/profile': (context) => Profile(),
  };
}
