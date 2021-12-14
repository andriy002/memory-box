import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/main_page/widget/sliver_adapter.dart';
import 'package:memory_box/pages/main_pages/main_page/widget/sliver_app_bar.dart';
import 'package:memory_box/pages/main_pages/main_page/widget/sliver_list.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBarWidget(),
        SliverAdapterWidget(),
        SliverListWidget(),
        SliverToBoxAdapter(
          child: SizedBox(height: 80),
        ),
      ],
    );
  }
}
