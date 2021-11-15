import 'package:flutter/material.dart';
import 'package:memory_box/components/bottom_nav.dart';
import 'package:memory_box/components/drawer.dart';

class Audio extends StatelessWidget {
  const Audio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff8C84E2),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu)),
      ),
    );
  }
}
