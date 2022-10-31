import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.widget,
    required this.function,
    required this.color,
    this.radius = 16,
    this.disable =false,
    this.size = const Size(366, 64),
    Key? key,
  }) : super(key: key);
  final Color color;
  final double radius;
  final bool disable;
  final Function function;
  final Widget widget;
  final Size size;



  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r)),
          fixedSize: size,
        ),
        onPressed: disable
            ? () {
          function();
        }
            : null,
        child: widget);
  }
}