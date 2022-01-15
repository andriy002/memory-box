import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/create_collection_page/view_model/view_model_create_collection.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:provider/provider.dart';

class OpenAudioSearchWidget extends StatelessWidget {
  const OpenAudioSearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: TextButton(
      child: const Text(
        'Добавить аудиофайл',
        style: TextStyle(
            color: Colors.black,
            fontFamily: AppFonts.mainFont,
            decoration: TextDecoration.underline),
      ),
      onPressed: () {
        context.read<ViewModelCreateCoolection>().openAddAudioPage();
        context.read<ViewModelCreateCoolection>().removeSelected();
      },
    ));
  }
}
