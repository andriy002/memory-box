import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/collections_page/view_model_collections/view_model_collections.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/left_arrow_button.dart';
import 'package:provider/provider.dart';

class AppBarCollectionCreate extends StatelessWidget {
  const AppBarCollectionCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final File? _image =
        context.select((ViewModelCoolections vm) => vm.state.imageUrl);
    final _nameCollection =
        context.select((ViewModelCoolections vm) => vm.state.newCollectionName);
    final String? _nameDescription = context
        .select((ViewModelCoolections vm) => vm.state.newCollectionDescription);
    final bool _error =
        context.select((ViewModelCoolections vm) => vm.state.error);

    return SliverAppBar(
      leading: leftArrowButton(
        () {
          context.read<ViewModelCoolections>().setCurrentIndex = 0;
          context.read<ViewModelCoolections>().deleteFields();
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.read<ViewModelCoolections>().createCollection();
            if (!_error) {
              context.read<ViewModelAudio>().addAudioToCollection(
                    _nameCollection ?? '',
                  );
            }
          },
          child: const Text(
            'Готово',
            style: TextStyle(
                fontFamily: AppFonts.mainFont,
                color: Colors.white,
                fontSize: 16),
          ),
        ),
      ],
      expandedHeight: MediaQuery.of(context).size.height / 2,
      floating: false,
      pinned: false,
      snap: false,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text(
        'Создание',
        style: TextStyle(
          fontFamily: AppFonts.mainFont,
          fontWeight: FontWeight.bold,
          fontSize: 36,
        ),
      ),
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            CircleAppBar(
              heightCircle: MediaQuery.of(context).size.height / 8,
              colorCircle: AppColors.collectionsColor,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 75),
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: TextField(
                  onChanged:
                      context.read<ViewModelCoolections>().setCollectionName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: AppFonts.mainFont,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: _error ? Colors.red : Colors.white,
                          fontFamily: AppFonts.mainFont,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                      hintText: _nameCollection ?? 'Название',
                      isCollapsed: true),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.width / 2,
                child: GestureDetector(
                  onTap: () {
                    context.read<ViewModelCoolections>().imagePicker();
                  },
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    heightFactor: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: _error ? Colors.red : Colors.grey,
                            blurRadius: 10,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                        image: _image != null
                            ? DecorationImage(
                                image: FileImage(_image), fit: BoxFit.cover)
                            : null,
                        color: Colors.white,
                      ),
                      child: Center(
                          child: _image == null
                              ? const ImageIcon(
                                  AppIcons.photoEdit,
                                  size: 80,
                                )
                              : null),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 10,
                  child: TextField(
                    maxLines: 3,
                    onChanged: context
                        .read<ViewModelCoolections>()
                        .setCollectionDescription,
                    style: const TextStyle(fontFamily: AppFonts.mainFont),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle:
                            const TextStyle(fontFamily: AppFonts.mainFont),
                        hintText: _nameDescription ?? 'Введите описание...'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
