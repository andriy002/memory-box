import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/models/collections.model.dart';
import 'package:memory_box/view_model/view_model_collections.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/navigation.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:provider/provider.dart';

class SliverAppBarWidget extends StatelessWidget {
  const SliverAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<CollectionsBuilder> _dataCollections =
        context.watch<List<CollectionsBuilder>?>() ?? [];
    return SliverAppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        backgroundColor: Colors.white,
        expandedHeight: MediaQuery.of(context).size.height / 2.3,
        floating: false,
        pinned: false,
        snap: false,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            alignment: Alignment.center,
            children: [
              CircleAppBar(
                  heightCircle: MediaQuery.of(context).size.height / 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 90,
                    ),
                    _appBarTitle(context),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 3.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _BigCard(dataCollections: _dataCollections),
                          _SmallCard(
                            dataCollections: _dataCollections,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Row _appBarTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Подборки',
          style: TextStyle(
            color: Colors.white,
            fontFamily: AppFonts.mainFont,
            fontSize: 24,
          ),
        ),
        TextButton(
            onPressed: () {
              context.read<Navigation>().setCurrentIndex = 1;
            },
            child: const Text(
              'Открыть все',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppFonts.mainFont,
                  fontSize: 14),
            ))
      ],
    );
  }
}

class _BigCard extends StatelessWidget {
  final List dataCollections;

  const _BigCard({Key? key, required this.dataCollections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.3,
      height: MediaQuery.of(context).size.height,
      child: dataCollections.length > 2
          ? _SliverCollectionsWidget(
              img: dataCollections[2].image,
              name: dataCollections[2].name,
              length: dataCollections[2].length,
              displayName: dataCollections[2].displayName,
              description: dataCollections[2].descriptions)
          : Card(
              color: const Color(0xE671A59F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text(
                      'Здесь будет твой набор сказок',
                      style: TextStyle(
                        fontFamily: AppFonts.mainFont,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                      onPressed: () {
                        context.read<Navigation>().setCurrentIndex = 1;
                        context.read<ViewModelCoolections>().setCurrentIndex =
                            2;
                      },
                      child: const Text(
                        'Добавить',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.mainFont,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ))
                ],
              ),
            ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  final List dataCollections;
  const _SmallCard({Key? key, required this.dataCollections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.3,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 7.2,
            width: double.infinity,
            child: dataCollections.isEmpty
                ? Card(
                    color: const Color(0xE6F1B488),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        'Тут',
                        style: TextStyle(
                            fontFamily: AppFonts.mainFont,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                    ),
                  )
                : _SliverCollectionsWidget(
                    img: dataCollections[0].image,
                    name: dataCollections[0].name,
                    length: dataCollections[0].length,
                    displayName: dataCollections[0].displayName,
                    description: dataCollections[0].descriptions),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 7.2,
            width: double.infinity,
            child: dataCollections.length > 1
                ? _SliverCollectionsWidget(
                    img: dataCollections[1].image,
                    name: dataCollections[1].name,
                    length: dataCollections[1].length,
                    displayName: dataCollections[1].displayName,
                    description: dataCollections[1].descriptions)
                : Card(
                    color: const Color(0xE6678BD2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        'И тут',
                        style: TextStyle(
                            fontFamily: AppFonts.mainFont,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SliverCollectionsWidget extends StatelessWidget {
  final int? length;
  final String? img;
  final String? name;
  final String? displayName;
  final String? description;

  const _SliverCollectionsWidget(
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
          context.read<Navigation>().setCurrentIndex = 1;

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
                  width: 50,
                  child: Text(
                    displayName!.length > 20
                        ? displayName!.substring(0, 20)
                        : displayName!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  '$length аудио',
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
