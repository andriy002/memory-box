import 'package:flutter/material.dart';
import 'package:memory_box/pages/auth_pages/auth/auth_page.dart';
import 'package:memory_box/pages/auth_pages/welcome_page.dart';
import 'package:memory_box/pages/loading_page.dart';
import 'package:memory_box/pages/main_pages/add_audio_in_collection_page/add_audio_in_collection_page.dart';
import 'package:memory_box/pages/main_pages/audio_page/audio_page.dart';
import 'package:memory_box/pages/main_pages/collections_audio_page/audio_collections_page.dart';
import 'package:memory_box/pages/main_pages/collections_page/collections_page.dart';
import 'package:memory_box/pages/main_pages/create_collection_page/create_collection_page.dart';
import 'package:memory_box/pages/main_pages/deleted_audio_page/deleted_audio_page.dart';
import 'package:memory_box/pages/main_pages/main.dart';
import 'package:memory_box/pages/main_pages/main_page/main_page.dart';
import 'package:memory_box/pages/main_pages/profile_page/profile_page.dart';
import 'package:memory_box/pages/main_pages/record_page/record_page.dart';
import 'package:memory_box/pages/main_pages/search_page/search_page.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? arguments = settings.arguments;

    PageRouteBuilder builder;

    switch (settings.name) {
      case Profile.routeName:
        builder = PageRouteBuilder(
          pageBuilder: (_, __, ___) => Profile.create(),
          transitionDuration: const Duration(seconds: 0),
        );

        break;

      case MainPage.routeName:
        builder = PageRouteBuilder(
          pageBuilder: (_, __, ___) => MainPage.create(),
          transitionDuration: const Duration(seconds: 0),
        );
        break;

      case WelcomPage.routeName:
        builder = PageRouteBuilder(
          pageBuilder: (_, __, ___) => const WelcomPage(),
          transitionDuration: const Duration(seconds: 0),
        );
        break;

      case AuthPage.routeName:
        builder = PageRouteBuilder(
          pageBuilder: (_, __, ___) => AuthPage.create(),
          transitionDuration: const Duration(seconds: 0),
        );
        break;

      case LoadingPage.routeName:
        builder = PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoadingPage(),
          transitionDuration: const Duration(seconds: 0),
        );
        break;

      case Main.routeName:
        builder = PageRouteBuilder(
          pageBuilder: (_, __, ___) => Main.create(),
          transitionDuration: const Duration(seconds: 0),
        );
        break;
      case Record.routeName:
        builder = PageRouteBuilder(
          pageBuilder: (_, __, ___) => Record.create(),
          transitionDuration: const Duration(seconds: 0),
        );
        break;
      case AudioPage.routeName:
        builder = PageRouteBuilder(
          pageBuilder: (_, __, ___) => AudioPage.create(),
          transitionDuration: const Duration(seconds: 0),
        );
        break;
      case SearchPage.routeName:
        builder = PageRouteBuilder(
          pageBuilder: (_, __, ___) => SearchPage.create(),
          transitionDuration: const Duration(seconds: 0),
        );
        break;
      case AddAudioInCollectionPage.routeName:
        final args = arguments as Map;
        builder = PageRouteBuilder(
          pageBuilder: (_, __, ___) => AddAudioInCollectionPage.create(args),
          transitionDuration: const Duration(seconds: 0),
        );
        break;
      case CollectionPage.routeName:
        builder = PageRouteBuilder(
          pageBuilder: (_, __, ___) => CollectionPage.create(),
          transitionDuration: const Duration(seconds: 0),
        );
        break;
      case DeletedAudioPage.routeName:
        builder = PageRouteBuilder(
          pageBuilder: (_, __, ___) => DeletedAudioPage.create(),
          transitionDuration: const Duration(seconds: 0),
        );
        break;
      case CreateNewCollection.routeName:
        builder = PageRouteBuilder(
          pageBuilder: (c, a1, a2) => CreateNewCollection.create(),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 10),
        );
        break;
      case CollectionsAudioPage.routeName:
        final args = arguments as Map;

        builder = PageRouteBuilder(
          pageBuilder: (c, a1, a2) => CollectionsAudioPage.create(
              img: args['img'],
              displayName: args['displayName'],
              description: args['description'],
              nameCollections: args['nameCollections']),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 10),
        );
        break;

      default:
        throw Exception('Invalid route: ${settings.name}');
    }

    return builder;
  }
}
