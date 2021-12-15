import 'package:flutter/material.dart';
import 'package:memory_box/models/user_model.dart';
import 'package:memory_box/pages/main_pages/profile_page/view_model_profile/view_model_profile.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:provider/provider.dart';

class DisplayNameWidget extends StatelessWidget {
  const DisplayNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _displayNameWatch = context.select(
      (UserBuilder? userFB) => userFB?.displayName,
    );
    final _editToogleWatch = context.select(
      (ViewModelProfile vm) => vm.state.editToogle,
    );

    final String _displayName = _displayNameWatch ?? 'Здесь будет твоё имя';
    final _displayNameController =
        context.read<ViewModelProfile>().displayNameController;

    Widget _editName() {
      return SizedBox(
        child: TextField(
          decoration: InputDecoration(hintText: _displayName),
          style: const TextStyle(
            fontFamily: AppFonts.mainFont,
            fontSize: 24,
          ),
          onChanged: _displayNameController,
          textAlign: TextAlign.center,
        ),
        width: 180,
      );
    }

    Widget _name() {
      return Text(
        _displayName,
        style: const TextStyle(
          fontFamily: AppFonts.mainFont,
          fontSize: 24,
        ),
      );
    }

    return _editToogleWatch ? _editName() : _name();
  }
}
