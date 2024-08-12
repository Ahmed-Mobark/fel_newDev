import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/models/groups/upsert_group_param.dart';
import 'package:football_app/presentation/notifiers/groups_notifer.dart';
import 'package:football_app/presentation/notifiers/league_notifier.dart';
import 'package:football_app/presentation/widgets/app_text_field.dart';
import 'package:football_app/presentation/widgets/sliver_sized_box.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:sizer/sizer.dart';

import '../../notifiers/home_notifier.dart';

class UpsertGroupScreen extends StatefulWidget {
  const UpsertGroupScreen({super.key});

  @override
  State<UpsertGroupScreen> createState() => _UpsertGroupScreenState();
}

class _UpsertGroupScreenState extends State<UpsertGroupScreen> {
  LeagueNotifier? _leagueNotifier;
  @override
  void initState() {
    super.initState();
    getLeagueModel();
  }

  getLeagueModel() async {
    _leagueNotifier = Provider.of<LeagueNotifier>(context, listen: false);
    final groupNotifier = Provider.of<GroupNotifier>(context, listen: false);
    final homeNotifier = Provider.of<HomeNotifier>(context, listen: false);
    await _leagueNotifier
        ?.getLeagueData(homeNotifier.mainPageModel.groupHLImage!);
    if (_leagueNotifier?.leaguesModel.isNotEmpty ?? false) {
      groupNotifier.setLeagueId(_leagueNotifier?.leaguesModel[0].id);
      groupNotifier.setLeagueName(
        _leagueNotifier?.leaguesModel[0].name!,
        _leagueNotifier?.leaguesModel[0].arName!,
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupNotifier = Provider.of<GroupNotifier>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.white,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          tr('Create Group'),
          style: Get.textTheme.headlineMedium?.copyWith(
            fontFamily: "Algerian",
          ),
        ),
      ),
      body: Form(
        key: groupNotifier.createGroupFormKey,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: 12,
            horizontal: 24,
          ),
          child: CustomScrollView(
            slivers: [
              AppTextField(
                duration: 1000,
                hintText: tr('Group Name'),
                icon: Icons.title_rounded,
                controller: groupNotifier.groupNameController,
                validator: (p0) => groupNotifier.validateGroupName(p0),
              ),
              SliverSizedBox(height: 2.h),
              AppTextField(
                duration: 900,
                hintText: tr('Group Description'),
                icon: Icons.notes,
                controller: groupNotifier.groupDescriptionController,
                validator: (p0) => groupNotifier.validateGroupDescription(p0),
              ),
              SliverSizedBox(height: 2.h),
              AppTextField(
                duration: 800,
                hintText: tr('Max Members'),
                icon: Icons.numbers,
                controller: groupNotifier.groupMaxMembersController,
                keyboardType: TextInputType.number,
                validator: (p0) => groupNotifier.validateGroupMembersCount(p0),
              ),
              SliverSizedBox(
                height: 2.h,
              ),
              _textFieldHeader(
                tr('Choose the league'),
                650,
              ),
              SliverSizedBox(
                height: 1.h,
              ),
              SliverToBoxAdapter(
                child: HorizontalAnimation(
                  duration: 650,
                  child: InkWell(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      backgroundColor: kColorBackground,
                      showDragHandle: true,
                      builder: (context) => const LeaguesList(),
                    ),
                    child: Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: kColorCard,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.privacy_tip_outlined,
                            color: kColorIconHomeHint,
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          if (isNotBlank(groupNotifier.leagueName) &&
                              isNotBlank(groupNotifier.arleagueName))
                            //omer
                            Text(
                              context.locale.languageCode == "ar"
                                  ? groupNotifier.arleagueName
                                  : groupNotifier.leagueName,
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontFamily: "Algerian",
                              ),
                            )
                          else
                            Text(
                              tr('select_champion'),
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontFamily: "Algerian",
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverSizedBox(height: 2.h),
              _textFieldHeader(
                tr('Would you like your group to be private or public?'),
                700,
              ),
              SliverToBoxAdapter(
                child: HorizontalAnimation(
                  duration: 700,
                  child: Container(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kColorCard,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.privacy_tip_outlined,
                          color: kColorIconHomeHint,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: DropdownButton<bool>(
                            underline: const SizedBox.shrink(),
                            isExpanded: true,
                            value: groupNotifier.isGroupPrivate,
                            selectedItemBuilder: (context) => List.generate(
                              2,
                              (index) => DropdownMenuItem(
                                child: Text(
                                  groupNotifier.isGroupPrivate!
                                      ? tr('Private')
                                      : tr('Public'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Algerian",
                                  ),
                                ),
                              ),
                            ).toList(),
                            dropdownColor: kColorBackground,
                            items: [
                              DropdownMenuItem(
                                value: false,
                                child: Text(
                                  tr('Public'),
                                  style: const TextStyle(
                                    fontFamily: "Algerian",
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: true,
                                child: Text(
                                  tr('Private'),
                                  style: const TextStyle(
                                    fontFamily: "Algerian",
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              groupNotifier.setIsGroupPrivate(value);
                              log(groupNotifier.isGroupPrivate.toString());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverSizedBox(
                height: 2.h,
              ),
              SliverToBoxAdapter(
                child: HorizontalAnimation(
                  duration: 600,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      disabledBackgroundColor: Colors.grey.shade600,
                      disabledForegroundColor: Colors.white,
                    ),
                    onPressed: groupNotifier.upsertGroupLoading
                        ? null
                        : () {
                            if (groupNotifier.createGroupFormKey.currentState!
                                .validate()) {
                              var upsertGroupParam = UpsertGroupParam(
                                id: '',
                                name: groupNotifier.groupNameController.text,
                                description: groupNotifier
                                    .groupDescriptionController.text,
                                isPrivate: groupNotifier.isGroupPrivate,
                                leagueId: groupNotifier.leagueId,
                                maxMembers: int.tryParse(
                                  groupNotifier.groupMaxMembersController.text
                                          .isEmpty
                                      ? "0"
                                      : groupNotifier
                                          .groupMaxMembersController.text,
                                ),
                              );
                              groupNotifier.upsertGroup(upsertGroupParam);
                            } else {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  errorSnackBar(
                                    tr('Fill fields with correct data'),
                                  ),
                                );
                            }
                          },
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            tr('Create Group'),
                            style: const TextStyle(
                              fontFamily: "Algerian",
                            ),
                          ),
                        ),
                        if (groupNotifier.upsertGroupLoading)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 20, right: 20),
                                width: 20,
                                height: 20,
                                child: const CircularProgressIndicator(),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldHeader(String text, int duration) {
    return SliverToBoxAdapter(
      child: HorizontalAnimation(
        duration: duration,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 4),
          child: Text(
            text,
            style: Get.textTheme.titleSmall?.copyWith(
              fontFamily: "Algerian",
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class LeaguesList extends StatelessWidget {
  const LeaguesList({super.key});

  @override
  Widget build(BuildContext context) {
    final groupNotifier = Provider.of<GroupNotifier>(context, listen: true);
    final leagueNotifier = Provider.of<LeagueNotifier>(context, listen: true);
    return ListView.builder(
      itemCount: leagueNotifier.leaguesModel.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => RadioListTile<int>(
        groupValue: groupNotifier.leagueId,
        onChanged: (value) {
          groupNotifier.setLeagueId(value);
          groupNotifier.setLeagueName(
            leagueNotifier.leaguesModel[index].name,
            leagueNotifier.leaguesModel[index].arName,
          );
          Get.back();
        },
        value: leagueNotifier.leaguesModel[index].id!,
        secondary: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.white,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.network(
                leagueNotifier.leaguesModel[index].logo!,
              ).image,
            ),
          ),
          height: 40,
          width: 40,
        ),
        title: Text(
          context.locale.languageCode == "ar"
              ? leagueNotifier.leaguesModel[index].arName ?? ""
              : leagueNotifier.leaguesModel[index].name ?? "",
          style: const TextStyle(
            fontFamily: "Algerian",
          ),
        ),
      ),
    );
  }
}

class LeaguesListForGroupScreen extends StatelessWidget {
  const LeaguesListForGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groupNotifier = Provider.of<GroupNotifier>(context, listen: true);
    final leagueNotifier = Provider.of<LeagueNotifier>(context, listen: true);
    return Column(
      children: [
        Container(
          width: 20.w,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white, // Color of the drag handle
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: leagueNotifier.leaguesModelForGroupScreen.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => RadioListTile<int>(
              selectedTileColor: Colors.white, // Background color when selected
              hoverColor: Colors.white,
              activeColor: Colors.white,
              groupValue: groupNotifier.leagueIdForGroupScreen,
              onChanged: (value) {
                groupNotifier.setLeagueIdForGroupScreen(value);
                groupNotifier.setLeagueNameForGroupScreen(
                  leagueNotifier.leaguesModelForGroupScreen[index].name,
                  leagueNotifier.leaguesModelForGroupScreen[index].arName,
                );
                groupNotifier.groupsFilter.skip = 0;
                groupNotifier.groupsFilter.leagueId = value ?? 0;
                groupNotifier.exploreGroupsList = [];
                groupNotifier.getExploreGroups(groupNotifier.groupsFilter);
                Get.back();
              },
              value: leagueNotifier.leaguesModelForGroupScreen[index].id!,
              secondary: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.network(
                      leagueNotifier.leaguesModelForGroupScreen[index].logo!,
                    ).image,
                  ),
                ),
                height: 40,
                width: 40,
              ),
              title: Text(
                context.locale.languageCode == "ar"
                    ? leagueNotifier.leaguesModelForGroupScreen[index].arName ??
                        ""
                    : leagueNotifier.leaguesModelForGroupScreen[index].name ??
                        "",
                style: const TextStyle(
                  fontFamily: "Algerian",
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
