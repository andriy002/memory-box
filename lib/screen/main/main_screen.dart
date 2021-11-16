import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:memory_box/components/bottom_nav.dart';
import 'package:memory_box/components/drawer.dart';
import 'package:memory_box/controlers/navigation.dart';
import 'package:memory_box/screen/audio.dart';
import 'package:memory_box/screen/profile.dart';
import 'package:memory_box/screen/record/record.dart';
import 'package:memory_box/screen/selections.dart';
import 'package:memory_box/widget/widget_auth/custom_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentIndex =
        context.select((NavigationController nc) => nc.currentIndex);
    List<Widget> screens = <Widget>[
      const MainScrean(),
      const Selectionts(),
      const RecordPage(),
      const Audio(),
      const Profile()
    ];

    return Scaffold(
        drawer: DrawerComponents(context),
        extendBody: true,
        body: screens[currentIndex],
        // IndexedStack(
        //   index: currentIndex,
        //   children: [
        //     const MainScrean(),
        //     const Selectionts(),
        //     const RecordPage(),
        //     const Audio(),
        //     const Profile()
        //   ],
        // ),
        bottomNavigationBar: BottomNav());
  }
}

class MainScrean extends StatefulWidget {
  const MainScrean({Key? key}) : super(key: key);

  @override
  State<MainScrean> createState() => _MainScreanState();
}

class _MainScreanState extends State<MainScrean> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<NavigationController>();

    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.menu,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            backgroundColor: Colors.white,
            expandedHeight: MediaQuery.of(context).size.height / 2,
            floating: false,
            pinned: false,
            snap: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  CustomAppBar(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 90,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Подборки',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'ttNormal',
                                  fontSize: 24),
                            ),
                            TextButton(
                                onPressed: () {
                                  model.setCurrentIndex = 1;
                                },
                                child: Text(
                                  'Открыть все',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'ttNormal',
                                      fontSize: 14),
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2.3,
                              height: MediaQuery.of(context).size.height / 3.5,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      'Здесь будет твой набор сказок',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'ttNormal',
                                          color: Colors.white,
                                          fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Добавить',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'ttNormal',
                                          fontSize: 14,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ))
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xE671A59F),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    height: MediaQuery.of(context).size.height /
                                        7.5,
                                    decoration: BoxDecoration(
                                      color: Color(0xE6F1B488),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            'Тут',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'ttNormal',
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    height: MediaQuery.of(context).size.height /
                                        7.5,
                                    decoration: BoxDecoration(
                                      color: Color(0xE6678BD2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            'И тут',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'ttNormal',
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        SliverToBoxAdapter(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Аудиозаписи',
                      style: TextStyle(fontFamily: 'ttNormal', fontSize: 24),
                    ),
                    TextButton(
                        onPressed: () {
                          model.setCurrentIndex = 3;
                        },
                        child: Text(
                          'Открыть все',
                          style: TextStyle(
                              fontFamily: 'ttNormal',
                              fontSize: 14,
                              color: Colors.black),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                color: index.isOdd ? Colors.white : Colors.black12,
                height: 50.0,
                child: Center(
                  child: Text('$index', textScaleFactor: 1),
                ),
              );
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }
}
