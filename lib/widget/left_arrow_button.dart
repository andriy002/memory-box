import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_icons.dart';

Widget leftArrowButton(Function func) {
  return GestureDetector(
    onTap: () {
      func();
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: const ImageIcon(
        AppIcons.leftArrow,
        color: Colors.black,
      ),
    ),
  );
}
