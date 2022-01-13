import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/record_page/view_model_record/view_mode_record.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:provider/provider.dart';
import 'audio_container.dart';
import 'record_container.dart';

class Record extends StatelessWidget {
  const Record({Key? key}) : super(key: key);
  static const routeName = '/record_page';

  static Widget create() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ViewModelRecord()),
      ],
      child: const Record(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recordToogle =
        context.select((ViewModelRecord vm) => vm.state.recordToogle);
    return Scaffold(
      appBar: _appBar(context),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            const CircleAppBar(
              heightCircle: 0,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: !recordToogle
                      ? const RecordContainerWidget()
                      : AudioContainerWidget.create(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

AppBar _appBar(BuildContext context) {
  return AppBar(
    backgroundColor: AppColors.mainColor,
    elevation: 0,
    centerTitle: true,
    automaticallyImplyLeading: false,
    leading: IconButton(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      icon: const Icon(Icons.menu),
    ),
  );
}
