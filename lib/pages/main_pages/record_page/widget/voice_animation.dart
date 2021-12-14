import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/record_page/view_model_record/view_mode_record.dart';
import 'package:provider/provider.dart';

class VoiceAnimationWidget extends StatelessWidget {
  const VoiceAnimationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final _incWidth = context.select((ViewModelRecord vm) => vm.state.incWidth);
    final _listAmplitude =
        context.select((ViewModelRecord vm) => vm.state.listAmplitude);
    ScrollController? _scrollController = ScrollController();

    return SizedBox(
      width: double.infinity,
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        controller: _scrollController,
        itemCount: _listAmplitude.length,
        itemBuilder: (BuildContext context, int index) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                height: _listAmplitude[index],
                width: 2,
                color: Colors.black,
              ),
              SizedBox(
                width: 2,
                height: 2,
                child: Container(
                  color: Colors.black,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
