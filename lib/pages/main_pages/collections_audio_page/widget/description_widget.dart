import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/collections_audio_page/view_model/view_model_audio_collection.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:provider/provider.dart';

class DescriptionWidget extends StatelessWidget {
  final String description;
  const DescriptionWidget({Key? key, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _editCollection = context
        .select((ViewModelCollectionAudio vm) => vm.state.editCollecrion);

    final bool _showMore =
        context.select((ViewModelCollectionAudio vm) => vm.state.detailsMore);

    final String? _editDescription =
        context.select((ViewModelCollectionAudio vm) => vm.state.description);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: SizedBox(
        width: double.infinity,
        height: _showMore ? 210 : 120,
        child: Column(
          children: [
            _showMore
                ? _editCollection
                    ? TextField(
                        onChanged: context
                            .read<ViewModelCollectionAudio>()
                            .editDescription,
                        maxLines: 5,
                        maxLength: 230,
                        decoration: InputDecoration(
                            hintText: _editDescription ?? description),
                      )
                    : Text(
                        description,
                        style: const TextStyle(
                          fontFamily: AppFonts.mainFont,
                        ),
                      )
                : description.length > MediaQuery.of(context).size.width / 2
                    ? Text(
                        description.substring(
                            0, MediaQuery.of(context).size.width ~/ 4.5),
                        style: const TextStyle(
                          fontFamily: AppFonts.mainFont,
                        ),
                      )
                    : Text(
                        description,
                        style: const TextStyle(
                          fontFamily: AppFonts.mainFont,
                        ),
                      ),
            if (description.length > MediaQuery.of(context).size.width / 2)
              if (!_editCollection)
                TextButton(
                  onPressed: () {
                    context.read<ViewModelCollectionAudio>().showMore();
                  },
                  child: Text(
                    _showMore ? 'Свернуть' : 'Подробнее',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontFamily: AppFonts.mainFont,
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }
}
