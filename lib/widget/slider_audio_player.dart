import 'package:flutter/material.dart';

class SliderAudioPlayer extends StatelessWidget {
  final double? position;
  final double? audioLength;
  final Function(double)? positionFoo;
  final Color? color;
  const SliderAudioPlayer(
      {Key? key,
      required this.position,
      required this.audioLength,
      required this.positionFoo,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 1,
            inactiveTrackColor: color ?? Colors.black,
            activeTrackColor: color ?? Colors.black,
            thumbColor: color ?? Colors.black,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 3),
          ),
          child: Slider.adaptive(
              value: position!,
              max: audioLength!,
              onChanged: (val) {
                positionFoo!(val);
              }),
        ),
      ],
    );
  }
}
