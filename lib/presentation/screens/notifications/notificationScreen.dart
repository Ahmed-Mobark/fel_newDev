import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../helpers/helpers.dart';
import '../../widgets/widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "notifications".tr(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ).tr(),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF010101),
              kColorPrimaryDark.withOpacity(0.3),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: HorizontalAnimation(
          duration: 500,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            itemCount: 12,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(3.w),
                margin: EdgeInsets.only(top: 3.w),
                decoration: BoxDecoration(
                  color: kColorCard,
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kColorPrimaryDark,
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 7.w,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'title notifications',
                            style: TextStyle(
                              fontFamily: "Algerian",
                              color: kColorPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 11.sp,
                            ),
                            textAlign: TextAlign.start,
                          ).tr(),
                          Text(
                            'descriptions notifications ' * 12,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                            ),
                            maxLines: 3,
                            textAlign: TextAlign.start,
                          ).tr(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
