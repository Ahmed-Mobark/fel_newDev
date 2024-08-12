// ignore_for_file: require_trailing_commas

part of '../screens.dart';

class GroupsScreen extends StatefulWidget {
  GroupsScreen({super.key, this.withAppBar});
  bool? withAppBar = false;
  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final GlobalKey _menu = GlobalKey();
  final GlobalKey _myItems = GlobalKey();

  Timer? _debounce;

  _onSearchChanged(String query, groupNotifier) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      groupNotifier.allGroupsearchFilterChange(query);
    });
  }

  _startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      if (!(prefs.getBool('show_groups_case') ?? false)) {
        ShowCaseWidget.of(context).startShowCase([_menu]);
        prefs.setBool('show_groups_case', true);
      }
    });
  }

  @override
  initState() {
    super.initState();
    _startShowCase();
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final groupNotifier = Provider.of<GroupNotifier>(context, listen: true);
    final authNotifier = Provider.of<AuthNotifier>(context, listen: true);

    return DefaultTabController(
      animationDuration: Duration.zero,
      length: 1,
      child: Scaffold(
        appBar: widget.withAppBar == true
            ? AppBar(
                centerTitle: true,
                automaticallyImplyLeading:false,
                title: FadeIn(
                  duration: const Duration(milliseconds: 900),
                  child: Text(
                    'Groups',
                    style: Get.textTheme.headlineMedium?.copyWith(
                      fontFamily: "Algerian",
                    ),
                  ).tr(),
                ),
              )
            : null,
        body: widget.withAppBar == true
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   Assets.imagesAppIcon,
                    //   width: 60.w,
                    // ),
                    Icon(
                      Icons.groups_outlined,
                      color: Colors.white,
                      size: 25.w,
                    ),

                    HorizontalAnimation(
                      duration: 500,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .55,
                        child: FilledButton(
                          onPressed: () {
                            if (authNotifier.userModel.data?.isGuest ?? false) {
                              showDialog(
                                context: context,
                                builder: (context) => const LoginPopUp(),
                              );
                            } else {
                              Get.to(() => const UpsertGroupScreen());
                            }
                          },
                          style: FilledButton.styleFrom(
                            disabledBackgroundColor: Colors.grey.shade600,
                            disabledForegroundColor: Colors.white,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.create),
                              SizedBox(
                                width: 3.w,
                              ),
                              const Text(
                                'Create Group',
                                style: TextStyle(fontFamily: 'Algerian'),
                              ).tr(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    HorizontalAnimation(
                      duration: 500,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .55,
                        child: FilledButton(
                          onPressed: () {
                            if (authNotifier.userModel.data?.isGuest ?? false) {
                              showDialog(
                                context: context,
                                builder: (context) => const LoginPopUp(),
                              );
                            } else {
                              Get.to(() => const JoinGroupScreen());
                            }
                          },
                          style: FilledButton.styleFrom(
                            disabledBackgroundColor: Colors.grey.shade600,
                            disabledForegroundColor: Colors.white,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.login),
                              SizedBox(
                                width: 3.w,
                              ),
                              const Text(
                                'Join Group',
                                style: TextStyle(fontFamily: 'Algerian'),
                              ).tr(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 13.w,
                        child: Showcase(
                          key: _menu,
                          title: tr('options'),
                          description: tr('options_desc'),
                          targetBorderRadius: BorderRadius.circular(10000),
                          titleTextStyle: const TextStyle(
                              fontFamily: 'Algerian', color: Colors.black),
                          descTextStyle: TextStyle(
                            fontFamily: 'Algerian',
                            color: Colors.black,
                            fontSize: 8.sp,
                          ),
                          descriptionPadding:
                              const EdgeInsets.symmetric(vertical: 8),
                          child: SpeedDial(
                            switchLabelPosition:
                                context.locale.languageCode == "ar"
                                    ? false
                                    : true,
                            direction: SpeedDialDirection.down,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            renderOverlay: false,
                            animatedIcon: AnimatedIcons.menu_close,
                            children: [
                              SpeedDialChild(
                                labelWidget: _speedDialButton(
                                    tr('Create Group'), Icons.create),
                                onTap: () {
                                  if (authNotifier.userModel.data?.isGuest ??
                                      false) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const LoginPopUp(),
                                    );
                                  } else {
                                    Get.to(() => const UpsertGroupScreen());
                                  }
                                },
                              ),
                              SpeedDialChild(
                                labelWidget: _speedDialButton(
                                    tr('Join Group'), Icons.login),
                                onTap: () {
                                  if (authNotifier.userModel.data?.isGuest ??
                                      false) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const LoginPopUp(),
                                    );
                                  } else {
                                    Get.to(() => const JoinGroupScreen());
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 50,
                          // width: context.width / 1.8,
                          child: CustomScrollView(
                            slivers: [
                              AppTextField(
                                controller:
                                    groupNotifier.textEditingGroupsController,
                                hintText: tr('Search'),
                                icon: Icons.search,
                                duration: 800,
                                onChanged: (v) =>
                                    _onSearchChanged(v, groupNotifier),
                              ),
                              //
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: HorizontalAnimation(
                          duration: 650,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: InkWell(
                              onTap: () => showModalBottomSheet(
                                context: context,
                                backgroundColor: kColorBackground,
                                showDragHandle: false,
                                builder: (context) =>
                                    const LeaguesListForGroupScreen(),
                              ),
                              child: Container(
                                // width: context.width / 2.8,
                                height: 47,
                                margin: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: kColorCard,
                                ),
                                child: ClipRRect(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.arrow_drop_down_sharp,
                                        color: Colors.white,
                                        size: 6.w,
                                      ),

                                      //omar
                                      Expanded(
                                        child: Text(
                                          context.locale.languageCode == "ar"
                                              ? groupNotifier
                                                  .arleagueNameForGroupScreen
                                              : groupNotifier
                                                  .leagueNameForGroupScreen,
                                          overflow: TextOverflow.ellipsis,
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
                                            fontFamily: "Algerian",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Expanded(
                    child: ExploreGroupsTab(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _speedDialButton(String text, IconData icon) {
    return Container(
      width: 150,
      padding: const EdgeInsetsDirectional.all(10),
      margin: const EdgeInsetsDirectional.only(start: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black,
            size: 20,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Algerian",
              fontSize: 8.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreGroupsTab extends StatefulWidget {
  const ExploreGroupsTab({super.key});

  @override
  State<ExploreGroupsTab> createState() => _ExploreGroupsTabState();
}

class _ExploreGroupsTabState extends State<ExploreGroupsTab> {
  ScrollController scrollController = ScrollController();
  GroupNotifier? groupNotifier;

  @override
  void initState() {
    super.initState();
    groupNotifier = Provider.of<GroupNotifier>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initFunction();
    });
  }

  initFunction() async {
    final leagueNotifier = Provider.of<LeagueNotifier>(context, listen: false);
    GroupNotifier groupNotifier =
        Provider.of<GroupNotifier>(context, listen: false);
    final homeNotifier = Provider.of<HomeNotifier>(context, listen: false);
    final rxPrefs = RxSharedPreferences(SharedPreferences.getInstance());
    String? token = await rxPrefs.getString('token');
    if (token != null) {
      await leagueNotifier
          .getLeagueData(homeNotifier.mainPageModel.groupHLImage!);
      await leagueNotifier
          .getChangeLeagueData(homeNotifier.mainPageModel.groupHLImage!);
    }
    if (leagueNotifier.leaguesModel.isNotEmpty &&
        isBlank(groupNotifier.leagueNameForGroupScreen) &&
        isBlank(groupNotifier.arleagueNameForGroupScreen)) {
      groupNotifier.setLeagueIdForGroupScreen(
        leagueNotifier.leaguesModelForGroupScreen[0].id,
      );
      groupNotifier.setLeagueNameForGroupScreen(
        leagueNotifier.leaguesModelForGroupScreen[0].name!,
        leagueNotifier.leaguesModelForGroupScreen[0].arName!,
      );
      groupNotifier.setLeagueId(leagueNotifier.leaguesModel[0].id);
      groupNotifier.setLeagueName(
        leagueNotifier.leaguesModel[0].name!,
        leagueNotifier.leaguesModel[0].arName!,
      );
      setState(() {});
    }

    groupNotifier.allGroupController
        .addListener(groupNotifier.updateAllGroupsData);
    groupNotifier.getAllUserGroups();
    if (groupNotifier.exploreGroupsList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        groupNotifier.getExploreGroups(groupNotifier.groupsFilter);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    groupNotifier!.allGroupController
        .removeListener(groupNotifier!.updateAllGroupsData);
  }

  @override
  Widget build(BuildContext context) {
    GroupNotifier groupNotifier =
        Provider.of<GroupNotifier>(context, listen: true);
    return Stack(
      children: [
        CustomScrollView(
          controller: groupNotifier.allGroupController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              sliver: SliverList.separated(
                itemCount: groupNotifier.exploreGroupsList.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 24);
                },
                itemBuilder: (context, index) {
                  return GroupCard(
                    onTap: () {},
                    group: groupNotifier.exploreGroupsList[index],
                    index: index,
                  );
                },
              ),
            ),
            SliverSizedBox(
              height: 15.h,
            ),
          ],
        ),
        if (groupNotifier.loadMoreExplore)
          const Padding(
            padding: EdgeInsets.only(top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
      ],
    );
  }
}

class MyGroupsTab extends StatefulWidget {
  const MyGroupsTab({super.key});

  @override
  State<MyGroupsTab> createState() => _MyGroupsTabState();
}

class _MyGroupsTabState extends State<MyGroupsTab> {
  GroupNotifier? _groupNotifier;

  @override
  void initState() {
    super.initState();
    _groupNotifier = Provider.of<GroupNotifier>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _groupNotifier?.getUserGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupNotifier = Provider.of<GroupNotifier>(context, listen: true);

    return Stack(
      children: [
        groupNotifier.userGroups.isEmpty
            ? Center(
                child: Text(
                  "You're not a member in any group",
                  style: TextStyle(
                    fontFamily: "Algerian",
                    fontSize: 10.sp,
                  ),
                ).tr(),
              )
            : CustomScrollView(
                controller: _groupNotifier?.myGroupController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    sliver: SliverList.separated(
                      itemCount: groupNotifier.userGroups.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        return UserGroupCard(
                          index: index,
                          group: groupNotifier.userGroups[index],
                          onTap: () {
                            Get.to(
                              () => ShowCaseWidget(
                                builder: Builder(
                                  builder: (context) => UserGroupDetailsScreen(
                                    group: groupNotifier.userGroups[index],
                                    groupIndex: index,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SliverSizedBox(
                    height: 15.h,
                  ),
                ],
              ),
        if (groupNotifier.userGroupsLoading)
          const Padding(
            padding: EdgeInsets.only(top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
      ],
    );
  }
}

class GroupTab extends StatelessWidget {
  const GroupTab({super.key, required this.groups});

  final List<GroupModel> groups;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          sliver: SliverList.separated(
            itemCount: groups.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 24,
            ),
            itemBuilder: (context, index) {
              return GroupCard(
                onTap: () {},
                group: groups[index],
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }
}

class GroupCard extends StatefulWidget {
  const GroupCard({
    required this.group,
    required this.index,
    required this.onTap,
    super.key,
  });

  final GroupModel group;
  final VoidCallback onTap;
  final int index;

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  bool isShowText = false;

  @override
  Widget build(BuildContext context) {
    final groupNotifier = Provider.of<GroupNotifier>(context, listen: true);
    final homeNotifier = Provider.of<HomeNotifier>(context, listen: true);
    final authNotifier = Provider.of<AuthNotifier>(context, listen: true);

    String imageUrl =
        widget.group.leagueLogo == null || widget.group.leagueLogo == ""
            ? homeNotifier.mainPageModel.groupHLImage!
            : widget.group.leagueLogo!;

    return InkWell(
      onTap: null,
      child: isShowText == true
          ? Container(
              padding: EdgeInsets.all(3.w),
              height: 26.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: kColorCard,
                  boxShadow:
                      widget.group.isSponsor == true ? kShadowPrimary : [],
                  border: Border.all(
                      color: widget.group.isSponsor == true
                          ? kColorPrimary
                          : Colors.transparent)),
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
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 1.w,
                  ),
                  Text(
                    Get.locale.toString() == 'ar'
                        ? widget.group.arGroupRules ?? ''
                        : Get.locale.toString() == 'en'
                            ? widget.group.groupRules ?? ''
                            : Get.locale.toString() == 'es'
                                ? widget.group.esGroupRules ?? ''
                                : widget.group.poGroupRules ?? '',
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
          : Container(
              height: 26.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: kColorCard,
                  boxShadow:
                      widget.group.isSponsor == true ? kShadowPrimary : [],
                  border: Border.all(
                      color: widget.group.isSponsor == true
                          ? kColorPrimary
                          : Colors.transparent)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.group.groupLogo ??
                        widget.group.logo ??
                        homeNotifier.mainPageModel.groupHLImage ??
                        '',
                    height: 26.h,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        // shape: BoxShape.circle,
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      vertical: 8,
                      horizontal: 14,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.people_alt,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 5),
                                  //omar
                                  SizedBox(
                                    width: 55.w,
                                    child: Text(
                                      context.locale.languageCode == "ar"
                                          ? widget.group.name.toString()
                                          : widget.group.leagueName.toString(),
                                      maxLines: 2,
                                      style:
                                          Get.textTheme.displayMedium?.copyWith(
                                        fontFamily: "Algerian",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GroupPageButton(
                                icon: groupNotifier
                                            .userGroupIDS[widget.group.id] ==
                                        null
                                    ? FontAwesomeIcons.rightToBracket
                                    : null,
                                isRounded: true,
                                isJoin: groupNotifier
                                            .userGroupIDS[widget.group.id] ==
                                        null
                                    ? false
                                    : true,
                                height: 25,
                                width: 75,
                                fontSize: context.locale.languageCode == "ar"
                                    ? 12
                                    : 10,
                                text: groupNotifier
                                            .userGroupIDS[widget.group.id] ==
                                        null
                                    ? tr('Join')
                                    : tr('AlreadyJoined'),
                                onTap: (authNotifier.userModel.data?.isGuest ??
                                        false)
                                    ? () => showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const LoginPopUp(),
                                        )
                                    : groupNotifier.userGroupIDS[
                                                widget.group.id] ==
                                            null
                                        ? () => groupNotifier
                                            .joinGroup(widget.group.id ?? '')
                                        : null,
                              ),
                            ],
                          ),
                        ),
                        if (widget.group.isSponsor == true &&
                            widget.group.groupRules != '')
                          Row(
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
                                    color: Colors.white,
                                    size: 8.w,
                                  ))
                            ],
                          ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.network(imageUrl).image,
                                ),
                              ),
                              height: 50,
                              width: 50,
                            ),
                            //omar
                            Text(
                              context.locale.languageCode == "ar"
                                  ? widget.group.leagueNameAR ?? ""
                                  : widget.group.leagueName ?? "",
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: "Algerian",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GroupsAdditionalData(
                                animationDuration: 0,
                                data: widget.group.membersCount,
                                secondaryData: widget.group.maxMembers == 0
                                    ? null
                                    : widget.group.maxMembers,
                                icon: Ionicons.people,
                                color: Colors.white,
                              ),
                              GroupsAdditionalData(
                                animationDuration: 0,
                                data: widget.group.totalPoints,
                                icon: Ionicons.trophy,
                                color: Colors.white,
                              ),
                              GroupsAdditionalData(
                                animationDuration: 0,
                                data: widget.group.rank,
                                color: Colors.white,
                                icon: FontAwesomeIcons.rankingStar,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      // ),
    );
  }
}

class UserGroupCard extends StatefulWidget {
  const UserGroupCard({
    required this.group,
    required this.index,
    required this.onTap,
    super.key,
  });

  final UserGroupModel group;
  final VoidCallback onTap;
  final int index;

  @override
  State<UserGroupCard> createState() => _UserGroupCardState();
}

class _UserGroupCardState extends State<UserGroupCard> {
  bool isShowText = false;
  @override
  Widget build(BuildContext context) {
    final homeNotifier = Provider.of<HomeNotifier>(context);
    final groupNotifier = Provider.of<GroupNotifier>(context);
    String? imageUrl = widget.group.group!.leagueLogo == null ||
            widget.group.group!.leagueLogo == ""
        ? homeNotifier.mainPageModel.groupHLImage!
        : widget.group.group!.leagueLogo;
    return HorizontalAnimation(
      duration: 600,
      child: isShowText == true
          ? Container(
              padding: EdgeInsets.all(3.w),
              height: 26.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: kColorCard,
                  boxShadow: widget.group.group?.isSponsor == true
                      ? kShadowPrimary
                      : [],
                  border: Border.all(
                      color: widget.group.group?.isSponsor == true
                          ? kColorPrimary
                          : Colors.transparent)),
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
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 1.w,
                  ),
                  Text(
                    Get.locale.toString() == 'ar'
                        ? widget.group.group?.arGroupRules ?? ''
                        : Get.locale.toString() == 'en'
                            ? widget.group.group!.groupRules ?? ''
                            : Get.locale.toString() == 'es'
                                ? widget.group.group!.esGroupRules ?? ''
                                : widget.group.group!.poGroupRules ?? '',
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
          : InkWell(
              onTap: widget.onTap,
              child: Container(
                height: 26.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: kColorCard,
                    boxShadow: widget.group.group?.isSponsor == true
                        ? kShadowPrimary
                        : [],
                    border: Border.all(
                        color: widget.group.group?.isSponsor == true
                            ? kColorPrimary
                            : Colors.transparent)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.group.group?.groupLogo ??
                          widget.group.group?.logo ??
                          homeNotifier.mainPageModel.groupHLImage ??
                          '',
                      height: 26.h,
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.6),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.people_alt,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        widget.group.group?.name.toString() ??
                                            '',
                                        style: Get.textTheme.displayMedium
                                            ?.copyWith(
                                          fontFamily: "Algerian",
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      if (groupNotifier.userGroups[widget.index]
                                                  .userId ==
                                              groupNotifier
                                                  .userGroups[widget.index]
                                                  .group!
                                                  .adminId &&
                                          groupNotifier.userGroups[widget.index]
                                                  .group!.isGroupLeagueActive ==
                                              false)
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 1.w),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3.w, vertical: 1.6.w),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(9.w),
                                            color: Colors.red.withOpacity(0.8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              tr("Finished"),
                                              style: Get.textTheme.displaySmall
                                                  ?.copyWith(
                                                fontSize: 11,
                                                fontFamily: "Algerian",
                                              ),
                                            ),
                                          ),
                                        ),
                                      GroupPageButton(
                                        icon: FontAwesomeIcons.rightFromBracket,
                                        isRounded: true,
                                        height: 25,
                                        width: 70,
                                        fontSize:
                                            context.locale.languageCode == "ar"
                                                ? 13
                                                : 11,
                                        text: tr('leave'),
                                        hasFrozenEffect: true,
                                        color: Colors.grey.shade800
                                            .withOpacity(0.3),
                                        onTap: () => leaveGroupDialog(
                                          context,
                                          () => groupNotifier.leaveGroup(
                                            widget.group.group?.id ?? "",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: Image.network(imageUrl!).image,
                                      ),
                                    ),
                                    height: 45,
                                    width: 45,
                                  ),
                                  if (groupNotifier.userGroups[widget.index]
                                              .group!.isSponsor ==
                                          true &&
                                      groupNotifier.userGroups[widget.index]
                                              .group!.groupRules !=
                                          '')
                                    Row(
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
                                              color: Colors.white,
                                              size: 8.w,
                                            ))
                                      ],
                                    ),
                                  if (groupNotifier
                                          .userGroups[widget.index].userId ==
                                      groupNotifier.userGroups[widget.index]
                                          .group!.adminId)
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.amber.withOpacity(0.4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          tr("admin"),
                                          style: Get.textTheme.displaySmall
                                              ?.copyWith(
                                            fontSize: 11,
                                            fontFamily: "Algerian",
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (groupNotifier.userGroups[widget.index].group!
                                      .isPrivate ==
                                  true)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.green.withOpacity(0.4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          tr('Private'),
                                          style: Get.textTheme.displaySmall
                                              ?.copyWith(
                                            fontSize: 11,
                                            fontFamily: "Algerian",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GroupsAdditionalData(
                                animationDuration: 0,
                                data: widget.group.group?.membersCount,
                                secondaryData:
                                    widget.group.group?.maxMembers == 0
                                        ? null
                                        : widget.group.group?.maxMembers,
                                icon: Ionicons.people,
                                color: Colors.white,
                              ),
                              GroupsAdditionalData(
                                animationDuration: 0,
                                data: widget.group.totalPoints,
                                icon: Ionicons.trophy,
                                color: Colors.white,
                              ),
                              GroupsAdditionalData(
                                animationDuration: 0,
                                data: widget.group.totalRight,
                                icon: FontAwesomeIcons.check,
                                color: Colors.white,
                              ),
                              GroupsAdditionalData(
                                animationDuration: 0,
                                data: widget.group.totalWrong,
                                icon: FontAwesomeIcons.x,
                                color: Colors.white,
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
    );
  }
}
