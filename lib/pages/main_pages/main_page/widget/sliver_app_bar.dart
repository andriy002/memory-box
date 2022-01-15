import 'package:flutter/material.dart';
import 'package:memory_box/models/collections.model.dart';
import 'package:memory_box/pages/main_pages/main_page/widget/app_bar_title.dart';
import 'package:memory_box/pages/main_pages/main_page/widget/small_card_widget.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:provider/provider.dart';
import 'big_card_widget.dart';

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
        background: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
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
                    appBarTitle(context),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 3.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BigCard(dataCollections: _dataCollections),
                          SmallCard(
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
        ),
      ),
    );
  }
}
