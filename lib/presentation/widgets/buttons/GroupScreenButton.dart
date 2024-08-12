import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class GroupPageButton extends StatelessWidget {
  final double width;
  final String text;
  final Color? color;
  final double height;
  final double? fontSize;
  final double? iconSize;
  final bool isRounded, hasFrozenEffect, isJoin, isIconOnTheLeft;
  final IconData? icon;
  final Function()? onTap;

  const GroupPageButton({
    required this.width,
    required this.text,
    this.isRounded = false,
    this.isJoin = false,
    this.hasFrozenEffect = false,
    this.isIconOnTheLeft = false,
    this.color,
    this.height = 50,
    this.onTap,
    this.iconSize,
    this.icon,
    this.fontSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color ??
            (isJoin ? Colors.green : kColorPrimary), // Use the provided color
        borderRadius: isRounded
            ? BorderRadius.circular(100.0)
            : BorderRadius.circular(8.0),
      ),
      child: MaterialButton(
        minWidth: width,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        shape: RoundedRectangleBorder(
          borderRadius: isRounded
              ? BorderRadius.circular(100.0)
              : BorderRadius.circular(8.0),
        ),
        onPressed: onTap,
        // Remove the color from MaterialButton to avoid overriding the Container's color
        child: Row(
          children: [
            if (icon != null && isIconOnTheLeft)
              Icon(
                icon,
                size: iconSize ?? 12,
                color: Colors.white,
              ),
            if (icon != null && isIconOnTheLeft)
              const SizedBox(
                width: 5,
              ),
            Text(
              text,
              style: TextStyle(
                fontFamily: "Algerian",
                color: Colors.white,
                fontWeight: FontWeight.w100,
                fontSize: fontSize,
              ),
            ),
            if (icon != null && !isIconOnTheLeft)
              const SizedBox(
                width: 3,
              ),
            if (icon != null && !isIconOnTheLeft)
              Icon(
                icon,
                size: 12,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
