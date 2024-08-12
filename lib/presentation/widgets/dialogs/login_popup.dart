import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LoginPopUp extends StatelessWidget {
  const LoginPopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(tr('Login'),
          style: TextStyle(
            fontSize: 10.sp,
            fontFamily: "Algerian",
          )),
      content: Column(
        children: <Widget>[
          const SizedBox(height: 24.0),
          Text(
            tr('loginMsg'),
            style: Get.textTheme.displayMedium!.copyWith(
              fontFamily: "Algerian",
              color: kColorPrimaryDark,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 36.0),
          GestureDetector(
            onTap: () => Get.offNamedUntil("/login", (route) => false),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 27),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.16),
                      offset: const Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ]),
              child: Text(
                tr('Login'),
                style: Get.textTheme.labelLarge!.copyWith(
                  fontFamily: "Algerian",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
