import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/profile_page/view_model_profile/view_model_profile.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:provider/provider.dart';

class ButtonEditWidget extends StatelessWidget {
  const ButtonEditWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editToogleWatch = context.select(
      (ViewModelProfile vm) => vm.state.editToogle,
    );
    final editToogleRead = context.read<ViewModelProfile>();

    final textButton = editToogleWatch ? 'Сохранить' : 'Редактировать';
    return TextButton(
      onPressed: () {
        editToogleRead.editToogle();
      },
      child: Text(
        textButton,
        style: const TextStyle(
          fontFamily: AppFonts.mainFont,
          color: Colors.black,
        ),
      ),
    );
  }
}
