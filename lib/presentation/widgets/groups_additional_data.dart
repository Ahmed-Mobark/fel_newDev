import 'package:flutter/material.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class GroupsAdditionalData extends StatelessWidget {
  const GroupsAdditionalData({
    required this.data,
    this.secondaryData,
    required this.icon,
    this.animationDuration = 200,
    this.color,
    super.key,
  });

  final int? data;
  final int? secondaryData;
  final IconData icon;
  final int animationDuration;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return HorizontalAnimation(
      duration: animationDuration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color ?? kColorPrimary,
          ),
          SizedBox(
            width: 4.w,
          ),
          Text(
            '${data ?? 0}${secondaryData == null ? "" : "/$secondaryData"}',
            style: TextStyle(
              fontFamily: "Algerian",
              color: color ?? kColorPrimary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ).paddingOnly(bottom: 8);
  }
}
