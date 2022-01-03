import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/record_page/view_model_record/view_mode_record.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:provider/provider.dart';

class AudioNameWidget extends StatefulWidget {
  const AudioNameWidget({Key? key}) : super(key: key);

  @override
  _AudioNameWidgetState createState() => _AudioNameWidgetState();
}

class _AudioNameWidgetState extends State<AudioNameWidget> {
  final TextEditingController? _audioNameController =
      TextEditingController(text: 'Аудиозапись');

  @override
  void dispose() {
    _audioNameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watchToogleRedactionAudioName =
        context.select((ViewModelRecord vm) => vm.state.editAudioName);
    return Center(
      child: GestureDetector(
        onTap: () {
          context
              .read<ViewModelRecord>()
              .editAudioNameToogle(_audioNameController!.text);
        },
        child: !watchToogleRedactionAudioName
            ? Text(
                _audioNameController!.text,
                style: const TextStyle(
                  fontFamily: AppFonts.mainFont,
                  fontSize: 24,
                ),
              )
            : SizedBox(
                width: 300,
                child: TextField(
                  controller: _audioNameController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: AppFonts.mainFont, fontSize: 24),
                  onEditingComplete: () {
                    context
                        .read<ViewModelRecord>()
                        .editAudioNameToogle(_audioNameController!.text);
                  },
                ),
              ),
      ),
    );
  }
}
