import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Container InputAuth(BuildContext context, TextEditingController controller) {
  return Container(
    width: MediaQuery.of(context).size.width / 1.2,
    child: Material(
      elevation: 10.5,
      borderRadius: BorderRadius.circular(50),
      child: TextField(
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0+-9]')),
          LengthLimitingTextInputFormatter(13),
        ],
        keyboardType: TextInputType.phone,
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(style: BorderStyle.none)),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.none))),
      ),
    ),
  );
}
