import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/models/collections.model.dart';
import 'package:memory_box/pages/main_pages/collections_page/pages/audio_collections.dart';
import 'package:memory_box/pages/main_pages/collections_page/view_model_collections/view_model_collections.dart';
import 'package:memory_box/repositories/audio_repositories.dart';
import 'package:memory_box/repositories/coolections_repositories.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';

import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/left_arrow_button.dart';
import 'package:provider/provider.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({Key? key}) : super(key: key);

  static Widget create() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModelCoolections()),
        StreamProvider(
          create: (_) => CollectionsRepositories.instance.colllections,
          initialData: null,
        ),
        StreamProvider(
            create: (_) =>
                AudioRepositories.instance.audioFromCollection('test'),
            initialData: null)
      ],
      child: const CollectionPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _currentIndex =
        context.select((ViewModelCoolections vm) => vm.state.currentIndex);
    final _nameCollections =
        context.select((ViewModelCoolections vm) => vm.state.nameCollections);

    List<Widget> _pages = <Widget>[
      const CollectionsPageContainer(),
      CollectionsAudioContainer.create(_nameCollections ?? ''),
      CreateNewCollection.create()
    ];

    return Scaffold(
      body: _pages[_currentIndex],
    );
  }
}

class CollectionsPageContainer extends StatelessWidget {
  const CollectionsPageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<CollectionsBuilder> dataCollections =
        context.watch<List<CollectionsBuilder>?>() ?? [];
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: IconButton(
            onPressed: () {
              context.read<ViewModelCoolections>().setCurrentIndex = 2;
            },
            icon: const Icon(Icons.add),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.more_horiz,
                size: 40,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            const SizedBox(
              width: 10,
            )
          ],
          backgroundColor: Colors.white,
          expandedHeight: MediaQuery.of(context).size.height / 4,
          floating: false,
          pinned: false,
          snap: false,
          title: Column(
            children: const [
              Text(
                'Подборки',
                style: TextStyle(
                    fontFamily: AppFonts.mainFont,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Все в одном месте',
                style: TextStyle(
                  fontFamily: AppFonts.mainFont,
                  fontSize: 16,
                ),
              )
            ],
          ),
          centerTitle: true,
          flexibleSpace: CircleAppBar(
            heightCircle: MediaQuery.of(context).size.height / 6,
            colorCircle: AppColors.collectionsColor,
          ),
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return SliverCollectionsWidget(
                index: index,
                img: dataCollections[index].image,
                name: dataCollections[index].name,
                displayName: dataCollections[index].displayName,
                length: dataCollections[index].length,
                description: dataCollections[index].length,
              );
            },
            childCount: dataCollections.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 4,
          ),
        )
      ],
    );
  }
}

class SliverCollectionsWidget extends StatelessWidget {
  final int index;
  final String? length;
  final String? img;
  final String? name;
  final String? displayName;
  final String? description;

  const SliverCollectionsWidget(
      {Key? key,
      required this.index,
      required this.img,
      required this.name,
      required this.length,
      required this.displayName,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: () {
          context.read<ViewModelCoolections>().sendInfoCollecion(
                descriptionCollections: description,
                displayNameCollections: displayName,
                lengthCollections: length,
                imgCollections: img,
              );

          context.read<ViewModelCoolections>().setCurrentIndex = 1;
          context.read<ViewModelCoolections>().nameCollections(name ?? '');
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                image: NetworkImage(img ?? ''), fit: BoxFit.cover),
            color: Colors.amber,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    displayName ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  length ?? '',
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateNewCollection extends StatelessWidget {
  const CreateNewCollection({Key? key}) : super(key: key);

  static Widget create() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModelAudioPlayer()),
      ],
      child: const CreateNewCollection(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: leftArrowButton(() {
          context.read<ViewModelCoolections>().setCurrentIndex = 0;
        }),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Готово',
              style: TextStyle(
                  fontFamily: AppFonts.mainFont,
                  color: Colors.white,
                  fontSize: 16),
            ),
          )
        ],
        title: const Text(
          'Создание',
          style: TextStyle(
            fontFamily: AppFonts.mainFont,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.collectionsColor,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height - 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  CircleAppBar(
                    heightCircle: MediaQuery.of(context).size.height / 4,
                    colorCircle: AppColors.collectionsColor,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: const EdgeInsets.only(left: 30, top: 10),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextField(
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppFonts.mainFont,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: AppFonts.mainFont,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                                hintText: 'Название',
                                isCollapsed: true),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width / 2,
                          child: GestureDetector(
                            onTap: () {},
                            child: FractionallySizedBox(
                              widthFactor: 0.9,
                              heightFactor: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 10,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  // image: DecorationImage(
                                  //     image: NetworkImage(''), fit: BoxFit.cover),
                                  color: Colors.white,
                                ),
                                child: const Center(
                                  child: ImageIcon(
                                    AppIcons.photoEdit,
                                    size: 80,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 10,
                child: const TextField(
                  style: TextStyle(fontFamily: AppFonts.mainFont),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontFamily: AppFonts.mainFont),
                      hintText: 'Введите описание...'),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width - 10,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Center(
                      child: TextButton(
                        child: const Text(
                          'Добавить аудиофайл',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: AppFonts.mainFont,
                              decoration: TextDecoration.underline),
                        ),
                        onPressed: () {},
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//  ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     return Text('10');
//                   },