import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:football_app/presentation/notifiers/groups_notifer.dart';
import 'package:football_app/presentation/screens/screens.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MyGroupsScreen extends StatefulWidget {
  const MyGroupsScreen({super.key});

  @override
  State<MyGroupsScreen> createState() => _MyGroupsScreenState();
}

class _MyGroupsScreenState extends State<MyGroupsScreen> {
  GroupNotifier? _groupNotifier;

  @override
  void initState() {
    _groupNotifier = Provider.of<GroupNotifier>(context, listen: false);
    _groupNotifier?.getUserGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final groupsNotifier = Provider.of<GroupNotifier>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Groups',
          style: Get.textTheme.headlineMedium?.copyWith(
            fontFamily: "Algerian",
          ),
        ).tr(),
      ),
      body: groupsNotifier.userGroupsLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : groupsNotifier.userGroups.isEmpty
              ? Center(
                  child: const Text(
                    'You have no groups',
                    style: TextStyle(
                      fontFamily: "Algerian",
                    ),
                  ).tr(),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: groupsNotifier.userGroups.length,
                  padding: const EdgeInsetsDirectional.all(8),
                  itemBuilder: (context, index) {
                    return UserGroupCard(
                      onTap: () {},
                      group: groupsNotifier.userGroups[index],
                      index: index,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 2.h,
                  ),
                ),
    );
  }
}
