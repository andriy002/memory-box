import 'package:flutter/material.dart';
import 'package:memory_box/models/collections.model.dart';
import 'package:memory_box/pages/main_pages/collections_audio_page/audio_collections_page.dart';
import 'package:memory_box/pages/main_pages/create_collection_page/create_collection_page.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/view_model_collections.dart';
import 'package:memory_box/repositories/coolections_repositories.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/no_collections_widget.dart';
import 'package:memory_box/widget/popup_item.dart';
import 'package:provider/provider.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({Key? key}) : super(key: key);

  static const String routeName = '/collection_page';

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
    final List<CollectionsBuilder>? _dataCollections =
        context.watch<List<CollectionsBuilder>?>();

    if (_dataCollections == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        const CircleAppBar(
          heightCircle: 0,
          colorCircle: AppColors.collectionsColor,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(CreateNewCollection.routeName);
                  },
                  icon: const Icon(Icons.add),
                ),
                actions: const [
                  PopupMenuAudioWidget(),
                  SizedBox(
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
                      img: _dataCollections[index].image,
                      name: _dataCollections[index].name,
                      displayName: _dataCollections[index].displayName,
                      description: _dataCollections[index].descriptions,
                    );
                  },
                  childCount: _dataCollections.length,
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
        ),
        if (_dataCollections.isEmpty) const NoCollectionWidget()
      ],
    );
  }
}

class SliverCollectionsWidget extends StatefulWidget {
  final String? img;
  final String? name;
  final String? displayName;
  final String? description;

  const SliverCollectionsWidget(
      {Key? key,
      required this.img,
      required this.name,
      required this.displayName,
      required this.description})
      : super(key: key);

  @override
  State<SliverCollectionsWidget> createState() =>
      _SliverCollectionsWidgetState();
}

class _SliverCollectionsWidgetState extends State<SliverCollectionsWidget> {
  @override
  Widget build(BuildContext context) {
    final bool _selected =
        context.select((ViewModelCoolections vm) => vm.state.selected);
    bool isCheck = false;
    final chekUid =
        context.select((ViewModelCoolections vm) => vm.state.collectionMap);
    if (chekUid[widget.name] == true) {
      isCheck = true;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: _selected
            ? () {
                if (isCheck) {
                  context
                      .read<ViewModelCoolections>()
                      .removeCollectionInMap(widget.name ?? '');
                } else {
                  isCheck = false;
                  context
                      .read<ViewModelCoolections>()
                      .addCollectionToMap(widget.name ?? '');
                }
                setState(() {});
              }
            : () {
                Navigator.pushNamed(
                  context,
                  CollectionsAudioPage.routeName,
                  arguments: {
                    'img': widget.img,
                    'displayName': widget.displayName,
                    'nameCollections': widget.name,
                    'description': widget.description
                  },
                );
              },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: NetworkImage(widget.img!),
                    fit: BoxFit.cover,
                    colorFilter: _selected
                        ? !isCheck
                            ? const ColorFilter.mode(
                                Color(0x73000000), BlendMode.multiply)
                            : null
                        : null),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      widget.displayName ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            if (_selected)
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            if (isCheck)
              const ImageIcon(
                AppIcons.done,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}

class PopupMenuAudioWidget extends StatelessWidget {
  const PopupMenuAudioWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool selected =
        context.select((ViewModelCoolections vm) => vm.state.selected);
    final _viewModel = context.read<ViewModelCoolections>();

    return PopupMenuButton(
      icon: const Icon(Icons.more_horiz),
      iconSize: 40,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      itemBuilder: !selected
          ? (context) => [
                popupMenuItem('Выбрать несколько', () {
                  _viewModel.selected();
                }, 0),
              ]
          : (context) => [
                popupMenuItem('Отменить выбор', () {
                  _viewModel.selected();
                }, 1),
                popupMenuItem('Удалить все', () {
                  context.read<ViewModelCoolections>().deletedCollection();
                  _viewModel.selected();
                }, 2),
              ],
    );
  }
}
