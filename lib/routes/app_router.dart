import 'package:flutter/material.dart';
import 'package:memory_box/pages/auth_pages/auth/auth_page.dart';
import 'package:memory_box/pages/auth_pages/welcome_page.dart';
import 'package:memory_box/pages/loading_page.dart';
import 'package:memory_box/pages/main_pages/main.dart';

abstract class Routes {
  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    WelcomPage.routeName: (context) => const WelcomPage(),
    AuthPage.routeName: (context) => AuthPage.create(),
    LoadingPage.routeName: (context) => const LoadingPage(),
    Main.routeName: (context) => Main.create(),
  };
}

// class AppRouter {
//   const AppRouter._();

//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     final Object? arguments = settings.arguments;

//     WidgetBuilder builder;

//     switch (settings.name) {
//       case WelcomPage.routeName:
//         builder = (_) => const WelcomPage();
//         break;

//       case AuthPage.routeName:
//         builder = (_) => AuthPage.create();
//         break;

//       default:
//         throw Exception('Invalid route: ${settings.name}');
//     }

//     return MaterialPageRoute(
//       builder: builder,
//       settings: settings,
//     );
//   }
// }


