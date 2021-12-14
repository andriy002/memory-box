import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_colors.dart';

class ButtonNext extends StatelessWidget {
  final void Function() method;
  const ButtonNext({
    required this.method,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: method,
      child: const Text(
        'Продолжить',
        style: TextStyle(fontSize: 18),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(51),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size(309, 59),
        ),
        backgroundColor: MaterialStateProperty.all(AppColors.recordColor),
      ),
    );
  }
}
