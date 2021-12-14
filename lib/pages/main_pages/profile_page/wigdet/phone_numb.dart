import 'package:flutter/material.dart';
import 'package:memory_box/models/user.dart';
import 'package:memory_box/pages/main_pages/profile_page/view_model_profile/view_model_profile.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/widget/input_widget.dart';
import 'package:provider/provider.dart';

class EditPhoneNumbWidget extends StatefulWidget {
  const EditPhoneNumbWidget({Key? key}) : super(key: key);

  @override
  _EditPhoneNumbWidgetState createState() => _EditPhoneNumbWidgetState();
}

class _EditPhoneNumbWidgetState extends State<EditPhoneNumbWidget> {
  TextEditingController? phoneController = TextEditingController();
  TextEditingController? codeController = TextEditingController();

  @override
  void dispose() {
    phoneController?.dispose();
    codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _editToogleWatch = context.select(
      (ViewModelProfile vm) => vm.state.editToogle,
    );
    final _sendSms = context.select(
      (ViewModelProfile vm) => vm.state.sendSms,
    );

    _sendSms ? phoneController?.clear() : codeController?.clear();

    final _phoneNumb = context.select(
      (UserBuilder? userFB) => userFB?.phoneNumb,
    );
    return Stack(
      children: [
        InputWidget(
          controller: !_sendSms ? phoneController : codeController,
          hintText: !_sendSms ? _phoneNumb ?? '' : 'Смс код...',
          enabled: _editToogleWatch ? false : true,
        ),
        if (_editToogleWatch)
          Padding(
            padding: const EdgeInsets.fromLTRB(270, 4, 0, 0),
            child: IconButton(
              onPressed: () {
                context.read<ViewModelProfile>().updatePhoneNumb(
                    codeController!.text, phoneController!.text);
              },
              icon: !_sendSms
                  ? const Icon(
                      Icons.send,
                      color: AppColors.mainColor,
                    )
                  : const Icon(
                      Icons.done,
                      color: AppColors.mainColor,
                    ),
            ),
          )
      ],
    );
  }
}
