import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/presentation/notifiers/bottom_nav_notifier.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';

class CardBottomBar extends StatelessWidget {
  const CardBottomBar(
      {super.key,
      required this.feeds,
      required this.groups,
      required this.store,
      required this.profile});

  final GlobalKey feeds;
  final GlobalKey groups;
  final GlobalKey store;
  final GlobalKey profile;

  @override
  Widget build(BuildContext context) {
    final navigationBarNotifier =
        Provider.of<BottomNavigationBarNotifier>(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 20.sp),
      child: CustomNavigationBar(
        iconSize: 19.sp,
        blurEffect: true,
        isFloating: true,
        currentIndex: navigationBarNotifier.navbarIndex ?? 0,
        onTap: (int val) {
          navigationBarNotifier.setNavbarIndex(val);
        },
        selectedColor: kColorPrimary,
        strokeColor: Colors.transparent,
        backgroundColor: kColorIconCardHint,
        unSelectedColor: Colors.white,
        borderRadius: const Radius.circular(32),
        items: [
          CustomNavigationBarItem(
            icon: Showcase(
              key: feeds,
              title: tr('Home'),
              description: tr('home_desc'),
              targetBorderRadius: BorderRadius.circular(10000),
              targetPadding: const EdgeInsets.all(8),
              titleTextStyle:
                  const TextStyle(fontFamily: 'Algerian', color: Colors.black),
              descTextStyle: TextStyle(
                  fontFamily: 'Algerian', color: Colors.black, fontSize: 8.sp),
              descriptionPadding: const EdgeInsets.symmetric(vertical: 8),
              child: Icon(
                Ionicons.home,
                color: navigationBarNotifier.navbarIndex == 0
                    ? kColorPrimary
                    : null,
              ),
            ),
          ),
          CustomNavigationBarItem(
            icon: Showcase(
              key: groups,
              title: tr('Groups'),
              description: tr('groups_desc'),
              targetBorderRadius: BorderRadius.circular(10000),
              targetPadding: const EdgeInsets.all(8),
              titleTextStyle:
                  const TextStyle(fontFamily: 'Algerian', color: Colors.black),
              descTextStyle: TextStyle(
                  fontFamily: 'Algerian', color: Colors.black, fontSize: 8.sp),
              descriptionPadding: const EdgeInsets.symmetric(vertical: 8),
              child: SvgPicture.asset(
                color: navigationBarNotifier.navbarIndex == 1
                    ? kColorPrimary
                    : null,
                'assets/images/ExploreIcon.svg',
                allowDrawingOutsideViewBox: true,
                height: 10.h,
              ),
            ),
          ),
          CustomNavigationBarItem(
              icon: const Icon(
                FontAwesomeIcons.circleQuestion,
                color: Colors.transparent,
              ),
              title: Container()),
          CustomNavigationBarItem(
            icon: Showcase(
              key: store,
              title: kStore,
              description: tr('store_desc'),
              targetBorderRadius: BorderRadius.circular(10000),
              targetPadding: const EdgeInsets.all(8),
              titleTextStyle:
                  const TextStyle(fontFamily: 'Algerian', color: Colors.black),
              descTextStyle: TextStyle(
                  fontFamily: 'Algerian', color: Colors.black, fontSize: 8.sp),
              descriptionPadding: const EdgeInsets.symmetric(vertical: 8),
              child: SvgPicture.asset(
                color: navigationBarNotifier.navbarIndex == 3
                    ? kColorPrimary
                    : null,
                'assets/images/ShopIcon.svg',
                allowDrawingOutsideViewBox: true,
                height: 10.h,
              ),
            ),
          ),
          CustomNavigationBarItem(
            icon: Showcase(
              key: profile,
              title: tr('Profile'),
              description: tr('profile_desc'),
              targetBorderRadius: BorderRadius.circular(10000),
              targetPadding: const EdgeInsets.all(8),
              titleTextStyle:
                  const TextStyle(fontFamily: 'Algerian', color: Colors.black),
              descTextStyle: TextStyle(
                  fontFamily: 'Algerian', color: Colors.black, fontSize: 8.sp),
              descriptionPadding: const EdgeInsets.symmetric(vertical: 8),
              child: SvgPicture.asset(
                color: navigationBarNotifier.navbarIndex == 4
                    ? kColorPrimary
                    : null,
                'assets/images/profileIcon.svg',
                allowDrawingOutsideViewBox: true,
                height: 10.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
