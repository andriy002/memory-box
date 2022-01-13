import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/navigation.dart';
import 'package:provider/provider.dart';

class SliverAdapterWidget extends StatelessWidget {
  const SliverAdapterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ClipRRect(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Аудиозаписи',
                style: TextStyle(
                  fontFamily: AppFonts.mainFont,
                  fontSize: 24,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<Navigation>().setCurrentIndex = 3;
                },
                child: const Text(
                  'Открыть все',
                  style: TextStyle(
                    fontFamily: AppFonts.mainFont,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
