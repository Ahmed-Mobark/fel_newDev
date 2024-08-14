// ignore_for_file: require_trailing_commas

import 'dart:developer';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/helpers/loading.dart';
import 'package:football_app/helpers/vars.dart';
import 'package:football_app/models/groups/user_group_model.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/notifiers/groups_notifer.dart';
import 'package:football_app/presentation/notifiers/home_notifier.dart';
import 'package:football_app/presentation/screens/home/video_splash.dart';
import 'package:football_app/presentation/widgets/dialogs/login_popup.dart';
import 'package:football_app/presentation/widgets/groups_additional_data.dart';
import 'package:football_app/presentation/widgets/sliver_sized_box.dart';
import 'package:football_app/presentation/widgets/w_groups.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';

import '../../notifiers/league_notifier.dart';
import '../../widgets/buttons/GroupScreenButton.dart';
import '../../widgets/buttons/custom_button.dart';
import '../home/Widgets/GroupDetails/GeneralRank.dart';
import '../home/Widgets/GroupDetails/RoundRank.dart';
import '../screens.dart';

class ExploreGroupDetailsScreen extends StatefulWidget {
  const ExploreGroupDetailsScreen({
    required this.groupId,
    super.key,
  });

  final String? groupId;

  @override
  State<ExploreGroupDetailsScreen> createState() =>
      _ExploreGroupDetailsScreenState();
}

class _ExploreGroupDetailsScreenState extends State<ExploreGroupDetailsScreen> {
  late GroupNotifier _groupNotifier;
  Future<dynamic> getData() async {
    return await Future.delayed(Duration.zero).then((value) {
      _groupNotifier = Provider.of<GroupNotifier>(context, listen: false);
      _groupNotifier.getGroupById(widget.groupId ?? '');
      _groupNotifier.groupMatches(widget.groupId ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GroupNotifier>(
          builder: (BuildContext context, value, Widget? child) {
        return value.getGroupByIdLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    centerTitle: true,
                    iconTheme: const IconThemeData(color: Colors.white),
                    pinned: true,
                    title: FadeIn(
                      duration: const Duration(milliseconds: 900),
                      child: Text(
                        value.groupByIdModel.name ?? '',
                        style: Get.textTheme.headlineMedium,
                      ),
                    ),
                    actions: const [
                      // FadeIn(
                      //   child: IconButton(
                      //     icon: const Icon(Ionicons.people),
                      //     onPressed: () => Get.to(
                      //       () => GroupMembersScreen(
                      //         groupId: groupNotifier.groupByIdModel.id ?? '',
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                    automaticallyImplyLeading: true,
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 34.h,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: value.groupByIdModel.groupLogo ??
                                  Provider.of<HomeNotifier>(context,
                                          listen: false)
                                      .mainPageModel
                                      .groupBGImage!,
                              placeholder: (context, url) => const SizedBox(),
                              height: 34.h,
                              width: double.infinity,
                              fit: BoxFit.fitHeight,
                              errorWidget: (context, url, error) =>
                                  const SizedBox.shrink(),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.transparent,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Spacer(),
                                Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: HorizontalAnimation(
                                    duration: 950,
                                    child: Text(
                                      value.groupByIdModel.description ?? '',
                                      style: Get.textTheme.displayMedium,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GroupsAdditionalData(
                                      animationDuration: 900,
                                      data: value.groupByIdModel.membersCount ??
                                          0,
                                      icon: Ionicons.people,
                                      color: Colors.white,
                                    ),
                                    GroupsAdditionalData(
                                      animationDuration: 900,
                                      data: value.groupByIdModel.totalPoints,
                                      icon: Ionicons.trophy,
                                      color: Colors.white,
                                    ),
                                    GroupsAdditionalData(
                                      animationDuration: 900,
                                      data: value.groupByIdModel.rank,
                                      color: Colors.white,
                                      icon: FontAwesomeIcons.rankingStar,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: GroupMatches(),
                  ),
                  SliverSizedBox(
                    height: 10.h,
                  ),
                ],
              );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 90.w,
        child: FloatingActionButton.extended(
          backgroundColor: kColorPrimary,
          onPressed: () => Provider.of<GroupNotifier>(context, listen: false)
              .joinGroup(widget.groupId ?? ''),
          label: const Text('Join Group').tr(),
        ),
      ),
    );
  }
}

class UserGroupDetailsScreen extends StatefulWidget {
  const UserGroupDetailsScreen({
    required this.group,
    super.key,
    this.groupIndex,
  });

  final UserGroupModel? group;
  final int? groupIndex;

  @override
  State<UserGroupDetailsScreen> createState() => _UserGroupDetailsScreenState();
}

class _UserGroupDetailsScreenState extends State<UserGroupDetailsScreen> {
  final GlobalKey _copy = GlobalKey();
  final GlobalKey _share = GlobalKey();
  bool isShowText = false;
  _startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      if (!(prefs.getBool('show_group_details_case') ?? false)) {
        if (widget.group!.group!.isPrivate ?? false) {
          ShowCaseWidget.of(context).startShowCase([_share, _copy]);
        } else {
          ShowCaseWidget.of(context).startShowCase([_share]);
        }
        prefs.setBool('show_group_details_case', true);
      }
    });
  }

  Future<dynamic> getData() async {
    return await Future.delayed(Duration.zero).then((value) {
      Provider.of<GroupNotifier>(context, listen: false)
          .groupMatches(widget.group?.groupId ?? '');
      Provider.of<GroupNotifier>(context, listen: false)
          .getGroupMembers(widget.group?.groupId ?? '');
      Provider.of<GroupNotifier>(context, listen: false)
          .getRoundGroupMembers(widget.group?.groupId ?? '');
      Provider.of<GroupNotifier>(context, listen: false)
          .setLeagueIdForGroupScreen(int.parse(widget.group!.id!));
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    _startShowCase();
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.group?.userId == widget.group?.group!.adminId;
    final groupNotifier = Provider.of<GroupNotifier>(context, listen: true);
    final homeNotifier = Provider.of<HomeNotifier>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        // pinned: true,
        title: FadeIn(
          child: Text(
            widget.group?.group?.name ?? '',
            style: Get.textTheme.displaySmall?.copyWith(
              fontFamily: "Algerian",
            ),
          ),
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
          Showcase(
            key: _share,
            title: tr('share'),
            description: tr('share_desc'),
            targetBorderRadius: BorderRadius.circular(10000),
            // targetPadding: const EdgeInsets.all(8),
            titleTextStyle:
                const TextStyle(fontFamily: 'Algerian', color: Colors.black),
            descTextStyle: TextStyle(
              fontFamily: 'Algerian',
              color: Colors.black,
              fontSize: 8.sp,
            ),
            descriptionPadding: const EdgeInsets.symmetric(vertical: 8),
            child: FadeIn(
              child: IconButton(
                tooltip: 'Share Group',
                onPressed: () => Share.share(
                  '${tr('join_group')} ${Connection.BASE_URL}${UniVars.GROUP}/${widget.group!.group!.id}',
                ),
                icon: const Icon(
                  Icons.share,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (widget.group!.group!.isPrivate ?? false)
            Showcase(
              key: _copy,
              title: tr('copy'),
              description: tr('copy_desc'),
              targetBorderRadius: BorderRadius.circular(10000),
              // targetPadding: const EdgeInsets.all(8),
              titleTextStyle:
                  const TextStyle(fontFamily: 'Algerian', color: Colors.black),
              descTextStyle: TextStyle(
                fontFamily: 'Algerian',
                color: Colors.black,
                fontSize: 8.sp,
              ),
              descriptionPadding: const EdgeInsets.symmetric(vertical: 8),
              child: FadeIn(
                child: IconButton(
                  tooltip: 'Copy Group Code',
                  onPressed: () => groupNotifier.copyGroupCodeToClipboard(
                    widget.group?.group?.password ?? '',
                  ),
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          isShowText == true
              ? Container(
                  padding: EdgeInsets.all(3.w),
                  height: 35.h,
                  decoration: BoxDecoration(
                    color: kColorCard,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isShowText = false;
                              });
                            },
                            child: Icon(
                              Icons.highlight_remove_rounded,
                              color: Colors.white,
                              size: 8.w,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.w,
                      ),
                      Text(
                        Get.locale.toString() == 'ar'
                            ? widget.group!.group?.arGroupRules ?? ''
                            : Get.locale.toString() == 'en'
                                ? widget.group!.group!.groupRules ?? ''
                                : Get.locale.toString() == 'es'
                                    ? widget.group!.group!.esGroupRules ?? ''
                                    : widget.group!.group!.poGroupRules ?? '',
                        maxLines: 8,
                        style: Get.textTheme.bodySmall?.copyWith(
                          fontFamily: "Algerian",
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 35.h,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.group!.group?.groupLogo ??
                            widget.group!.group?.logo ??
                            homeNotifier.mainPageModel.groupHLImage ??
                            '',
                        imageBuilder: (context, imageProvider) => Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(16),
                                color: Colors.transparent,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const SizedBox.shrink(),
                      ),
                      Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Spacer(),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: HorizontalAnimation(
                                duration: 950,
                                child: Text(
                                  widget.group!.group!.description.toString(),
                                  style: Get.textTheme.displayMedium?.copyWith(
                                    fontFamily: "Algerian",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GroupsAdditionalData(
                                  animationDuration: 900,
                                  data: widget.group?.group?.membersCount ?? 0,
                                  icon: Ionicons.people,
                                  color: Colors.white,
                                ),
                                GroupsAdditionalData(
                                  animationDuration: 900,
                                  data: widget.group?.totalPoints,
                                  icon: Ionicons.trophy,
                                  color: Colors.white,
                                ),
                                GroupsAdditionalData(
                                  animationDuration: 900,
                                  data: widget.group?.totalRight,
                                  color: Colors.white,
                                  icon: FontAwesomeIcons.check,
                                ),
                                GroupsAdditionalData(
                                  animationDuration: 900,
                                  data: widget.group?.totalWrong,
                                  color: Colors.white,
                                  icon: FontAwesomeIcons.x,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isAdmin && widget.groupIndex != null)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GroupPageButton(
                                icon: FontAwesomeIcons.photoFilm,
                                isRounded: false,
                                isIconOnTheLeft: true,
                                height: 30,
                                width: 130,
                                fontSize: context.locale.languageCode == "ar"
                                    ? 13
                                    : 11,
                                text: tr('Change cover'),
                                onTap: () {
                                  Get.to(
                                    () => UserGroupImages(
                                      groupId: widget.group?.groupId ?? "",
                                      groupIndex: widget.groupIndex ?? 0,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      if (isAdmin &&
                          widget.groupIndex != null &&
                          widget.group!.group!.isGroupLeagueActive == false)
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GroupPageButton(
                                icon: Icons.change_circle_outlined,
                                color: Colors.red,
                                iconSize: 16,
                                isRounded: false,
                                isIconOnTheLeft: true,
                                height: 30,
                                width: 48.w,
                                fontSize: context.locale.languageCode == "ar"
                                    ? 13
                                    : 11,
                                text: tr('You can change the league'),

                                ///
                                onTap: () => showModalBottomSheet(
                                  context: context,
                                  backgroundColor: kColorBackground,
                                  showDragHandle: false,
                                  builder: (context) =>
                                      LeaguesListForChangGroup(
                                    id: widget.group!.groupId.toString(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (widget.group!.group!.isSponsor == true &&
                          widget.group!.group!.groupRules != '')
                        Padding(
                          padding: EdgeInsets.only(
                              top: isAdmin &&
                                      widget.groupIndex != null &&
                                      widget.group!.group!
                                              .isGroupLeagueActive ==
                                          false
                                  ? 5.h
                                  : 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isShowText = true;
                                  });
                                },
                                icon: Icon(
                                  Icons.error,
                                  color: kColorAccent,
                                  size: 9.w,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
          GroupDetailsTabScreens(
            groupId: widget.group?.groupId,
            group: widget.group,
            userId: widget.group!.userId!,
          ),
        ],
      ),
    );
  }
}

class GroupDetailsTabScreens extends StatelessWidget {
  const GroupDetailsTabScreens(
      {super.key, this.groupId, this.group, required this.userId});
  final String? groupId;
  final String userId;
  final UserGroupModel? group;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            indicatorColor: kColorPrimary,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: Get.textTheme.bodyLarge?.copyWith(
              fontFamily: "Algerian",
              // fontWeight: FontWeight.bold,
              fontSize: 9.5.sp,
              color: Colors.white,
            ),
            // : Get.textTheme.bodySmall,
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(
                text: tr('My Groups'),
                icon: const Icon(FontAwesomeIcons.soccerBall),
              ),
              Tab(
                text: tr('Round Rank'),
                icon: const Icon(Icons.format_align_center),
              ),
              Tab(text: tr('General Rank'), icon: const Icon(Icons.toc)),
              // Tab(text: tr('Admin Challenges')),
            ],
          ),
          SizedBox(
            height: context.height - (context.height / 1.73),
            child: TabBarView(
              children: [
                GroupMatches(
                  groupId: groupId,
                  group: group,
                ),
                RoundRank(myUserId: userId),
                GeneralRank(userId: userId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LeaguesListForChangGroup extends StatefulWidget {
  const LeaguesListForChangGroup({super.key, required this.id});
  final String id;
  @override
  State<LeaguesListForChangGroup> createState() =>
      _LeaguesListForChangGroupState();
}

class _LeaguesListForChangGroupState extends State<LeaguesListForChangGroup> {
  int? groubId;

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
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: const Text(
            "Finished",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ).tr(),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: leagueNotifier.leaguesModelForChangGroupScreen.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => RadioListTile<int>(
              selectedTileColor: Colors.white, // Background color when selected
              hoverColor: Colors.white,
              activeColor: Colors.white,
              groupValue: groupNotifier.leagueIdForGroupScreen,
              onChanged: (value) {
                log(value.toString());
                groupNotifier.setLeagueIdForGroupScreen(value);
                setState(() {
                  groubId = value;
                });
              },
              value: leagueNotifier.leaguesModelForChangGroupScreen[index].id!,
              secondary: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.network(
                      leagueNotifier
                          .leaguesModelForChangGroupScreen[index].logo!,
                    ).image,
                  ),
                ),
                height: 40,
                width: 40,
              ),
              title: Text(
                context.locale.languageCode == "ar"
                    ? leagueNotifier
                            .leaguesModelForChangGroupScreen[index].arName ??
                        ""
                    : leagueNotifier
                            .leaguesModelForChangGroupScreen[index].name ??
                        "",
                style: const TextStyle(
                  fontFamily: "Algerian",
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        groupNotifier.isLoading
            ? const LoadingWidget(
                size: 50,
              )
            : Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomButton(
                  onTap: () {
                    groupNotifier
                        .changeUserGroub(
                      groubId.toString(),
                      widget.id,
                    )
                        .then((e) {
                      groupNotifier.setLeagueIdForGroupScreen(null);
                      Navigator.pop(context);
                    });
                  },
                  width: 100.w,
                  text: tr("confirm"),
                ),
              ),
      ],
    );
  }
}
