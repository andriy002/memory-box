import 'package:flutter/material.dart';
import 'package:memory_box/pages/auth_pages/auth/auth_page.dart';
import 'package:memory_box/pages/auth_pages/welcome_page.dart';
import 'package:memory_box/pages/loading_page.dart';
import 'package:memory_box/pages/main_pages/collections_page/pages/add_audio_in_collection/add_audio_in_collection_page.dart';
import 'package:memory_box/pages/main_pages/main.dart';

abstract class Routes {
  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    WelcomPage.routeName: (context) => const WelcomPage(),
    AuthPage.routeName: (context) => AuthPage.create(),
    LoadingPage.routeName: (context) => const LoadingPage(),
    Main.routeName: (context) => Main.create(),
    AddAudioInCollectionPage.routeName: (context) =>
        AddAudioInCollectionPage.create(),
  };
}
