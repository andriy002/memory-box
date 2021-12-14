import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:memory_box/models/user.dart';
import 'package:memory_box/pages/main_pages/profile_page/view_model_profile/view_model_profile.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:provider/provider.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _imageUrl = context.select(
      (UserBuilder? userFB) => userFB?.avatarUrl ?? '',
    );

    final _editToogleWatch = context.select(
      (ViewModelProfile vm) => vm.state.editToogle,
    );
    final Widget? _image = _imageUrl == ''
        ? const Image(image: AppIcons.iconAvatar, fit: BoxFit.cover)
        : Image.network(_imageUrl, fit: BoxFit.cover);

    final _fileImage =
        context.select((ViewModelProfile vm) => vm.state.imageUrl);

    Widget _fileAvatar() {
      return SizedBox(
        width: 228,
        height: 228,
        child: Image.file(
          _fileImage!,
          fit: BoxFit.cover,
        ),
      );
    }

    Widget _editingAvatar() {
      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 228,
            height: 228,
            child: _fileImage == null ? _image : _fileAvatar(),
          ),
          GestureDetector(
            onTap: () {
              context.read<ViewModelProfile>().imagePicker();
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 3,
                sigmaY: 3,
              ),
              child: const ImageIcon(
                AppIcons.photoEdit,
                size: 80,
                color: Colors.white,
              ),
            ),
          )
        ],
      );
    }

    Widget _avatar() {
      return SizedBox(
        width: 228,
        height: 228,
        child: _image,
      );
    }

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        CircleAppBar(
          heightCircle: MediaQuery.of(context).size.height / 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: !_editToogleWatch ? _avatar() : _editingAvatar(),
          ),
        )
      ],
    );
  }
}
