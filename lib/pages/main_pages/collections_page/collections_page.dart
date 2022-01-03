import 'package:flutter/material.dart';
import 'package:memory_box/models/collections.model.dart';
import 'package:memory_box/pages/main_pages/collections_page/pages/audio_collections.dart';
import 'package:memory_box/pages/main_pages/collections_page/pages/create_collection/create_collection_page.dart';
import 'package:memory_box/pages/main_pages/collections_page/view_model_collections/view_model_collections.dart';
import 'package:memory_box/repositories/coolections_repositories.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
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
      CreateNewCollection.create(),
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
    final List<CollectionsBuilder>? dataCollections =
        context.watch<List<CollectionsBuilder>?>();

    if (dataCollections == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: Stack(
        children: [
          const CircleAppBar(
            heightCircle: 0,
            colorCircle: AppColors.collectionsColor,
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
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
                backgroundColor: AppColors.collectionsColor,
                expandedHeight: MediaQuery.of(context).size.height / 10,
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
              ),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return SliverCollectionsWidget(
                      img: dataCollections[index].image,
                      name: dataCollections[index].name,
                      displayName: dataCollections[index].displayName,
                      length: dataCollections[index].length,
                      description: dataCollections[index].descriptions,
                    );
                  },
                  childCount: dataCollections.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 10,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class SliverCollectionsWidget extends StatelessWidget {
  final int? length;
  final String? img;
  final String? name;
  final String? displayName;
  final String? description;

  const SliverCollectionsWidget(
      {Key? key,
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
          context.read<ViewModelCoolections>().nameCollections(name!);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image:
                DecorationImage(image: NetworkImage(img!), fit: BoxFit.cover),
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
                  '$length',
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
