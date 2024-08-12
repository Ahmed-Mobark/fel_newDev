import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/presentation/screens/screens.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../notifiers/groups_notifer.dart';
import '../../widgets/app_text_field.dart';

class MainChallengeScreen extends StatefulWidget {
  const MainChallengeScreen({super.key});

  @override
  State<MainChallengeScreen> createState() => _MainChallengeScreenState();
}

class _MainChallengeScreenState extends State<MainChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 8.h,
          automaticallyImplyLeading: false,
          title: FadeIn(
            child: Container(
              height: 5.h,
              margin: EdgeInsets.only(top: 4.h, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(3.w),
              ),
              padding: const EdgeInsets.all(0),
              child: TabBar(
                labelStyle: Get.textTheme.headlineMedium?.copyWith(
                  fontFamily: "Algerian",
                ),
                indicator: BoxDecoration(
                  color: kColorPrimary, // Change to desired color
                  borderRadius: BorderRadius.circular(3.w),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ), // Reduced padding
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(
                    child: Text(
                      tr('Admin Challenges'),
                      style: const TextStyle(
                        fontSize: 14,
                      ), // Reduce font size to decrease height
                    ),
                  ),
                  Tab(
                    child: Text(
                      tr('Groups'),
                      style: const TextStyle(
                        fontSize: 14,
                      ), // Reduce font size to decrease height
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body:  TabBarView(
          children: [
            // First tab content
            AdminChallengesScreen(), // Second tab content
            GroupsScreen(
              withAppBar: false,
            ),
          ],
        ),
      ),
    );
  }
}

class AdminChallengesScreen extends StatefulWidget {
  const AdminChallengesScreen({super.key});

  @override
  State<AdminChallengesScreen> createState() => _AdminChallengesScreenState();
}

class _AdminChallengesScreenState extends State<AdminChallengesScreen> {
  Timer? _debounce;

  _onSearchChanged(String query, groupNotifier) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      groupNotifier.userGroupsearchFilterChange(query);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final groupNotifier = Provider.of<GroupNotifier>(context, listen: true);
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 50,
            width: context.width - 20,
            child: CustomScrollView(
              slivers: [
                AppTextField(
                  controller: groupNotifier.textEditingMyGroupController,
                  hintText: tr('Search'),
                  icon: Icons.search,
                  duration: 800,
                  onChanged: (v) => _onSearchChanged(v, groupNotifier),
                ),
                //
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Expanded(
            child: MyGroupsTab(),
          ),
        ],
      ),
    );
  }
}
