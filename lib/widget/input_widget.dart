import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool enabled;

  const InputWidget({
    Key? key,
    required this.controller,
    this.hintText = '',
    this.enabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Material(
        elevation: 10.5,
        borderRadius: BorderRadius.circular(50),
        child: TextField(
          controller: controller,
          readOnly: enabled,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0+-9]')),
            LengthLimitingTextInputFormatter(13),
          ],
          keyboardType: TextInputType.phone,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            isCollapsed: true,
            hintText: hintText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(style: BorderStyle.none)),
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(style: BorderStyle.none),
            ),
          ),
        ),
      ),
    );
  }
}
