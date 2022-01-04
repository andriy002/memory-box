import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/profile_page/wigdet/button_edit.dart';
import 'package:memory_box/pages/main_pages/profile_page/wigdet/display_name.dart';
import 'package:memory_box/pages/main_pages/profile_page/wigdet/phone_numb.dart';
import 'package:memory_box/repositories/user_repositories.dart';
import 'package:memory_box/models/user_model.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/widget/left_arrow_button.dart';
import 'package:provider/provider.dart';

import 'view_model_profile/view_model_profile.dart';
import 'wigdet/avatar.dart';
import 'wigdet/edit_account.dart';

class Profile extends StatelessWidget {
  static const routeName = '/profile_page';
  const Profile({Key? key}) : super(key: key);

  static Widget create() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModelProfile()),
        StreamProvider(
          create: (_) => UsersRepositories.instance.user,
          initialData: null,
        ),
      ],
      child: const Profile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserBuilder? data = context.watch<UserBuilder?>();

    if (data == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: _appBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                AvatarWidget(),
                DisplayNameWidget(),
                EditPhoneNumbWidget(),
                ButtonEditWidget(),
                SizedBox(height: 30),
                EditAccountWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    final _editToogleWatch = context.select(
      (ViewModelProfile vm) => vm.state.editToogle,
    );
    return AppBar(
      backgroundColor: AppColors.mainColor,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: _editToogleWatch
          ? leftArrowButton(context.read<ViewModelProfile>().editToogle)
          : IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
      title: Column(
        children: const [
          Text(
            'Профиль',
            style: TextStyle(
                fontFamily: AppFonts.mainFont,
                fontSize: 36,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            'Твоя частичка',
            style: TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.mainFont,
                fontSize: 16),
          )
        ],
      ),
    );
  }
}
