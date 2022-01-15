import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/create_collection_page/view_model/view_model_create_collection.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:provider/provider.dart';

class SetDescriptionWidget extends StatelessWidget {
  const SetDescriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? _description = context.select(
        (ViewModelCreateCoolection vm) => vm.state.collectionDescription);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 10,
          child: TextField(
            maxLength: 230,
            maxLines: 3,
            onChanged: context
                .read<ViewModelCreateCoolection>()
                .setCollectionDescription,
            style: const TextStyle(fontFamily: AppFonts.mainFont),
            decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                hintStyle: const TextStyle(fontFamily: AppFonts.mainFont),
                hintText: _description ?? 'Введите описание...'),
          ),
        ),
      ),
    );
  }
}
