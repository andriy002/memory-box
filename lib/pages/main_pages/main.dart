import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/audio_page/audio_page.dart';
import 'package:memory_box/pages/main_pages/record_page/record_page.dart';
import 'package:memory_box/pages/main_pages/search_page/search_page.dart';
import 'package:memory_box/pages/main_pages/widget/bottom_navigation.dart';
import 'package:memory_box/pages/main_pages/widget/drawer.dart';
import 'package:memory_box/repositories/audio_repositories.dart';

import 'package:memory_box/view_model/navigation.dart';
import 'package:provider/provider.dart';

import 'collections_page/collections_page.dart';

import 'main_page/main_page.dart';
import 'profile_page/profile_page.dart';

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);
  static const routeName = '/main';

  static Widget create() {
    return MultiProvider(
      providers: [
        StreamProvider(
          create: (_) => AudioRepositories.instance.audio,
          initialData: null,
        )
      ],
      child: const Main(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _currentIndex = context.select((Navigation nc) => nc.currentIndex);
    List<Widget> _pages = <Widget>[
      MainPage.create(),
      CollectionPage.create(),
      Record.create(),
      const AudioPage(),
      Profile.create(),
      const SearchPage()
    ];

    return Scaffold(
      drawer: const Drawwer(),
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
