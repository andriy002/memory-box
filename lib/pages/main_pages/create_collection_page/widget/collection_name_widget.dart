import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/create_collection_page/view_model/view_model_create_collection.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:provider/provider.dart';

class SetCollectionNameWidget extends StatelessWidget {
  const SetCollectionNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _error =
        context.select((ViewModelCreateCoolection vm) => vm.state.error);
    final _nameCollection = context
        .select((ViewModelCreateCoolection vm) => vm.state.collectionName);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        maxLength: 20,
        onChanged: context.read<ViewModelCreateCoolection>().setCollectionName,
        style: const TextStyle(
            color: Colors.white,
            fontFamily: AppFonts.mainFont,
            fontSize: 24,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            hintStyle: TextStyle(
                color: _error ? Colors.red : Colors.white,
                fontFamily: AppFonts.mainFont,
                fontSize: 24,
                fontWeight: FontWeight.bold),
            hintText: _error
                ? 'Cначала введите название '
                : _nameCollection ?? 'Название',
            isCollapsed: true),
      ),
    );
  }
}
