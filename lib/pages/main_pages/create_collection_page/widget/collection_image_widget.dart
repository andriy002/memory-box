import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/create_collection_page/view_model/view_model_create_collection.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:provider/provider.dart';

class SetCollectionImageWidget extends StatelessWidget {
  const SetCollectionImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _error =
        context.select((ViewModelCreateCoolection vm) => vm.state.error);
    final File? _image =
        context.select((ViewModelCreateCoolection vm) => vm.state.imageUrl);
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.width / 2,
      child: GestureDetector(
        onTap: () {
          context.read<ViewModelCreateCoolection>().imagePicker();
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
                  ? DecorationImage(image: FileImage(_image), fit: BoxFit.cover)
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
    );
  }
}
