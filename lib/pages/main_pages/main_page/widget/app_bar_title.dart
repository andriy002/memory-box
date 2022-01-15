import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/navigation.dart';
import 'package:provider/provider.dart';

Row appBarTitle(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Подборки',
        style: TextStyle(
          color: Colors.white,
          fontFamily: AppFonts.mainFont,
          fontSize: 24,
        ),
      ),
      TextButton(
          onPressed: () {
            context.read<Navigation>().setCurrentIndex = 1;
          },
          child: const Text(
            'Открыть все',
            style: TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.mainFont,
                fontSize: 14),
          ))
    ],
  );
}
