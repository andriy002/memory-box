import 'package:flutter/material.dart';
import 'package:memory_box/models/collections.model.dart';
import 'package:memory_box/pages/main_pages/collections_page/view_model/view_model_collections.dart';
import 'package:memory_box/pages/main_pages/collections_page/widget/collection_card_widget.dart';
import 'package:memory_box/pages/main_pages/collections_page/widget/sliver_app_bar_collection_page.dart';
import 'package:memory_box/repositories/coolections_repositories.dart';
import 'package:memory_box/resources/app_colors.dart';

import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/no_auth_user.dart';
import 'package:memory_box/widget/no_collections_widget.dart';
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
    if (!context.read<ViewModelCoolections>().checkAuthUser()) {
      return const NoAuthUser();
    }

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
              const SliverAppBarCollectionPage(),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return CollectionsCardWidget(
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
