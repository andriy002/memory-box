import 'package:flutter/material.dart';
import 'package:memory_box/models/collections.model.dart';
import 'package:memory_box/pages/main_pages/add_audio_in_collection_page/view_model/view_model_add_audio_in_collection.dart';
import 'package:memory_box/repositories/coolections_repositories.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/no_collections_widget.dart';
import 'package:provider/provider.dart';
import 'widget/add_audio_in_card_collection_widget.dart';
import 'widget/sliver_app_bar_add_audio_in_collection_page.dart';

class AddAudioInCollectionPage extends StatelessWidget {
  static const routeName = '/add_audio_in_collection_page';
  final Map args;

  const AddAudioInCollectionPage({Key? key, required this.args})
      : super(key: key);

  static Widget create(Map args) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModelAddAudioInColection()),
        StreamProvider(
          create: (_) => CollectionsRepositories.instance.colllections,
          initialData: null,
        ),
      ],
      child: AddAudioInCollectionPage(
        args: args,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<CollectionsBuilder>? _dataCollections =
        context.watch<List<CollectionsBuilder>?>();

    if (_dataCollections == null) {
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
              SliverAppBarAddAudioInColectionPage(args: args),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return AddInCollectionsCardWidget(
                      displayName: _dataCollections[index].displayName,
                      img: _dataCollections[index].image,
                      name: _dataCollections[index].name,
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
          if (_dataCollections.isEmpty) const NoCollectionWidget()
        ],
      ),
    );
  }
}
