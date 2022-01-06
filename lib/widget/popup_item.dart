import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_fonts.dart';

PopupMenuItem popupMenuItem(String text, Function onTap, int val) {
  return PopupMenuItem(
    onTap: () {
      onTap();
    },
    value: val,
    child: Text(
      text,
      style: const TextStyle(fontFamily: AppFonts.mainFont, fontSize: 14),
    ),
  );
}
