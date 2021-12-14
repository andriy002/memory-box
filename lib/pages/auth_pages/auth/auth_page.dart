import 'package:flutter/material.dart';
import 'package:memory_box/pages/auth_pages/auth/view_model/view_model_auth.dart';
import 'package:memory_box/pages/loading_page.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/widget/button_next.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/input_widget.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);
  static const routeName = '/auth_page';

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => ViewModelAuth(),
      child: const AuthPage(),
    );
  }

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
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
    void _nav() {
      Navigator.of(context).pushReplacementNamed(LoadingPage.routeName);
    }

    final ViewModelAuth _viewModel = context.read<ViewModelAuth>();
    final bool _checkSmsBool = context.select(
      (ViewModelAuth vm) => vm.state.sendSms,
    );
    final bool _errorCheck = _viewModel.state.authError.isNotEmpty;
    final String errorText = context.select(
      (ViewModelAuth vm) => vm.state.authError,
    );
    _checkSmsBool ? phoneController!.clear() : codeController!.clear();

    final String _text = !_checkSmsBool
        ? 'Введи номер телефона'
        : 'Введи код из смс, чтобы мы тебя запомнили';
    final TextEditingController? _checkSmsController =
        !_checkSmsBool ? phoneController : codeController;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAppBar(
                  heightCircle: MediaQuery.of(context).size.height / 3.5,
                  title: 'Регистрация',
                ),
                const SizedBox(height: 5),
                _title(_text),
                InputWidget(
                  controller: _checkSmsController,
                ),
                if (_errorCheck) _errorText(errorText),
                ButtonNext(method: () {
                  _viewModel.auth(
                      codeController!.text, phoneController!.text, _nav);
                }),
                const _ButtomAnonAuth(),
                _textAuth(),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _title(String text) {
    return Text(
      text,
      style: const TextStyle(fontFamily: AppFonts.mainFont, fontSize: 16),
    );
  }
}

class _ButtomAnonAuth extends StatelessWidget {
  const _ButtomAnonAuth({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final checkSmsBool = context.watch<ViewModelAuth>().state.sendSms;

    return !checkSmsBool
        ? TextButton(
            onPressed: () {
              context.read<ViewModelAuth>().signInAnon();
              Navigator.of(context).pushReplacementNamed(LoadingPage.routeName);
            },
            child: const Text(
              'Позже',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontFamily: AppFonts.mainFont,
              ),
            ))
        : const SizedBox(
            height: 55,
          );
  }
}

Widget _textAuth() {
  return const SizedBox(
    width: 230,
    child: Text(
      'Регистрация привяжет твои сказки  к облаку, после чего они всегда будут с тобой',
      style: TextStyle(fontSize: 14, fontFamily: AppFonts.mainFont),
      textAlign: TextAlign.center,
    ),
  );
}

Widget _errorText(String text) {
  return Text(
    text,
    style: const TextStyle(color: Colors.red, fontFamily: AppFonts.mainFont),
  );
}
