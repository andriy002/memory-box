import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/collections_audio_page/view_model/view_model_audio_collection.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:provider/provider.dart';

class DisplayNameWidget extends StatelessWidget {
  final String displayName;
  const DisplayNameWidget({Key? key, required this.displayName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _editCollection = context
        .select((ViewModelCollectionAudio vm) => vm.state.editCollecrion);
    final String? _displayNameEdit =
        context.select((ViewModelCollectionAudio vm) => vm.state.displayName);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: _editCollection
          ? TextField(
              onChanged:
                  context.read<ViewModelCollectionAudio>().editDisplayName,
              maxLength: 20,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.mainFont,
                fontSize: 24,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: _displayNameEdit ?? displayName,
                hintStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: AppFonts.mainFont,
                  fontSize: 24,
                ),
                isCollapsed: true,
              ),
            )
          : Text(
              _displayNameEdit ?? displayName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: AppFonts.mainFont),
            ),
    );
  }
}
