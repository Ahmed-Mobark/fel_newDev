import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.duration = 500,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onTapOutside,
    this.readOnly,
    this.onTap,
  });

  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final int duration;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  final TapRegionCallback? onTapOutside;
  final bool? readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: HorizontalAnimation(
        duration: duration,
        child: TextFormField(
          readOnly: readOnly ?? false,
          onTap: onTap,
          textCapitalization: TextCapitalization.sentences,
          autovalidateMode: autovalidateMode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          controller: controller,
          style: TextStyle(
            fontSize: 10.sp,
            fontFamily: "Algerian",
          ),
          onTapOutside:
              onTapOutside ?? (event) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            fillColor: kColorCard,
            filled: true,
            hintText: tr(hintText),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.red.shade900),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.red.shade900),
            ),
            contentPadding: const EdgeInsetsDirectional.only(top: 9),
            hintStyle: Get.textTheme.titleMedium!.copyWith(
              fontFamily: "Algerian",
              color: kColorIconHomeHint,
            ),
            suffixIcon: suffixIcon,
            prefixIcon: Icon(
              icon,
              color: kColorIconHomeHint,
            ),
          ),
        ),
      ),
    );
  }
}
