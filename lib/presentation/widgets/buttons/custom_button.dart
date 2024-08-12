import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final String text;
  final Color? color;
  final double height;
  final double? fontSize;
  final bool isRounded, hasFrozenEffect;
  final Function()? onTap;
  const CustomButton(
      {required this.width,
      required this.text,
      this.isRounded = false,
      this.hasFrozenEffect = false,
      this.color,
      this.height = 50,
      this.onTap,
      this.fontSize,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          isRounded ? BorderRadius.circular(100.0) : BorderRadius.circular(8.0),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: onTap != null
              ? hasFrozenEffect
                  ? Colors.grey.shade800.withOpacity(0.8)
                  : color ?? kColorPrimary
              : Colors.transparent,
        ),
        child: MaterialButton(
          minWidth: width,
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: isRounded
                ? BorderRadius.circular(100.0)
                : BorderRadius.circular(8.0),
          ),
          onPressed: onTap,
          color: onTap != null
              ? hasFrozenEffect
                  ? Colors.grey.shade800
                  : color ?? kColorPrimary
              : Colors.transparent,
          splashColor: Colors.white.withOpacity(0.5),
          child: BackdropFilter(
            filter: hasFrozenEffect
                ? ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0)
                : ImageFilter.blur(sigmaX: 0, sigmaY: 0.0),
            child: SizedBox(
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(text,
                        style: TextStyle(
                            fontFamily: "Algerian",
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontSize: fontSize)),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
