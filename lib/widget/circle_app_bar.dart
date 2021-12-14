import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';

class CircleAppBar extends StatelessWidget {
  final double heightCircle;
  final Color colorCircle;
  final String? title;
  final String? subTitle;

  const CircleAppBar({
    Key? key,
    required this.heightCircle,
    this.colorCircle = AppColors.mainColor,
    this.title,
    this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        CustomPaint(
          size: Size(
            MediaQuery.of(context).size.width,
            heightCircle,
          ),
          painter: _PaintCircke(colorCircle),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title ?? '',
              style: const TextStyle(
                  fontSize: 48,
                  color: AppColors.titleColor,
                  fontFamily: AppFonts.mainFont,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              subTitle ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.titleColor,
              ),
            )
          ],
        )
      ],
    );
  }
}

class _PaintCircke extends CustomPainter {
  final Color colorCircle;
  _PaintCircke(this.colorCircle);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = colorCircle;
    canvas.drawCircle(Offset(size.width / 1.5, size.height - size.width),
        size.width * 1.1, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
