import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/collections_page/collections_page.dart';
import 'package:memory_box/pages/main_pages/record_page/record_page.dart';
import 'package:memory_box/pages/main_pages/search_page/search_page.dart';
import 'package:memory_box/pages/main_pages/widget/bottom_navigation.dart';
import 'package:memory_box/pages/main_pages/widget/drawer.dart';
import 'package:memory_box/repositories/audio_repositories.dart';
import 'package:memory_box/routes/app_router.dart';

import 'package:memory_box/view_model/navigation.dart';
import 'package:provider/provider.dart';

import 'audio_page/audio_page.dart';
import 'main_page/main_page.dart';
import 'profile_page/profile_page.dart';

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);
  static const routeName = '/main';
  static final GlobalKey<NavigatorState> _globalKey =
      GlobalKey<NavigatorState>();

  static Widget create() {
    return MultiProvider(
      providers: [
        StreamProvider(
          create: (_) => AudioRepositories.instance.audio,
          initialData: null,
        ),
        ChangeNotifierProvider(
          create: (_) => Navigation(),
        )
      ],
      child: const Main(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int _currentIndex =
        context.select((Navigation nc) => nc.currentIndex);

    switch (_currentIndex) {
      case 0:
        _globalKey.currentState?.pushReplacementNamed(MainPage.routeName);

        break;
      case 1:
        _globalKey.currentState?.pushReplacementNamed(CollectionPage.routeName);

        break;
      case 2:
        _globalKey.currentState?.pushReplacementNamed(Record.routeName);

        break;
      case 3:
        _globalKey.currentState?.pushReplacementNamed(AudioPage.routeName);

        break;
      case 4:
        _globalKey.currentState?.pushReplacementNamed(Profile.routeName);

        break;
      case 5:
        _globalKey.currentState?.pushReplacementNamed(SearchPage.routeName);

        break;
      default:
        _globalKey.currentState?.pushReplacementNamed(MainPage.routeName);
        break;
    }

    return Scaffold(
      drawer: const Drawwer(),
      extendBody: true,
      body: Navigator(
        initialRoute: MainPage.routeName,
        key: _globalKey,
        onGenerateRoute: AppRouter.generateRoute,
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
