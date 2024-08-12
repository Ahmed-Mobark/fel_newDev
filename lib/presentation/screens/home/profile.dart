part of '../screens.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final rxPrefs = RxSharedPreferences(SharedPreferences.getInstance());
  GroupNotifier? _groupsNotifier;

  String? token;

  final GlobalKey _settings = GlobalKey();

  _startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      if (!(prefs.getBool('show_profile_case') ?? false)) {
        ShowCaseWidget.of(context).startShowCase([_settings]);
        prefs.setBool('show_profile_case', true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getToken();
    _groupsNotifier = Provider.of<GroupNotifier>(context, listen: false);
    _groupsNotifier?.getMyGroups();
    _startShowCase();
  }

  _getToken() async {
    token = await rxPrefs.getString('token');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: true);
    final StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: true);

    return Scaffold(
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
        child: CustomScrollView(
          slivers: [
            _AppBar(settings: _settings),
            SliverSizedBox(height: 2.h),
            if (token != null) ...[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    InkWell(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.black.withOpacity(.1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: authNotifier.userModel.data == null ||
                                      authNotifier
                                              .userModel.data?.profilePhoto ==
                                          ''
                                  ? Image.asset(
                                      'assets/images/Unknown.jpeg',
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                    )
                                  : storeNotifier.profilePic != null
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              storeNotifier.profilePic ?? '',
                                          width:
                                              MediaQuery.of(context).size.width,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              // shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: imageProvider,
                                              ),
                                            ),
                                          ),
                                          progressIndicatorBuilder: (
                                            context,
                                            url,
                                            downloadProgress,
                                          ) =>
                                              const CupertinoActivityIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: authNotifier.userModel.data
                                                  ?.profilePhoto ??
                                              '',
                                          width:
                                              MediaQuery.of(context).size.width,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                              ),
                                            ),
                                          ),
                                          progressIndicatorBuilder: (
                                            context,
                                            url,
                                            downloadProgress,
                                          ) =>
                                              const CupertinoActivityIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.person,
                                            size: 50,
                                          ),
                                        ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h),
                  ],
                ),
              ),
            ],
            if (token != null) ...[
              SliverToBoxAdapter(
                child: HorizontalAnimation(
                  duration: 200,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const _UserImage(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: kColorCardHint,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    authNotifier.userModel.data!.pointsEarned
                                        .toString(),
                                    style: Get.textTheme.displayLarge?.copyWith(
                                      fontFamily: "Algerian",
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  Text(
                                    'Points',
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontFamily: "Algerian",
                                      fontSize: 12.sp,
                                    ),
                                  ).tr(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (token != null) ...[
              SliverSizedBox(height: 2.h),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: _EditProfileSettingsButton(),
                ),
              ),
              SliverSizedBox(height: 2.h),
              SliverToBoxAdapter(
                child: HorizontalAnimation(
                  duration: 500,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        const Expanded(child: _TransactionsButton()),
                        SizedBox(width: 4.w),
                        const Expanded(child: _PurchasedItemsButton()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            SliverSizedBox(height: 2.h),
            token != null
                ? const SliverToBoxAdapter(
                    child: HorizontalAnimation(
                      duration: 800,
                      child: TextTileFeed(
                        label: 'My Groups',
                        icon: Icons.groups,
                      ),
                    ),
                  )
                : ListTile1(
                    text: tr('Login'),
                    icon: Ionicons.log_in,
                    onTap: () async {
                      // rxPrefs.remove('token');
                      rxPrefs.remove('guestToken');
                      rxPrefs.remove('isVis');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                      // authNotifier.logout();

                      // bottomNavigationBarNotifier.setNavbarIndex(0);
                    },
                    duration: 800,
                  ),
            SliverSizedBox(
              height: 2.h,
            ),
            const SliverToBoxAdapter(
              child: GroupsRailProfile(),
            ),
            SliverSizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }
}

class _EditProfileSettingsButton extends StatelessWidget {
  const _EditProfileSettingsButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EditProfileSettingsScreen()),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kColorCardHint,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit,
              size: 12.sp,
              color: kColorAccent,
            ),
            const SizedBox(width: 8),
            Text(
              'Edit Profile',
              style: Get.textTheme.titleSmall?.copyWith(
                fontFamily: "Algerian",
                fontSize: 11.sp,
              ),
            ).tr(),
          ],
        ),
      ),
    );
  }
}

class _PurchasedItemsButton extends StatelessWidget {
  const _PurchasedItemsButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => const PurchasedProducts()),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kColorPrimary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Ionicons.bag_handle,
              size: 12.sp,
              color: kColorAccent,
            ),
            const SizedBox(width: 8),
            Text(
              'Purchased Items',
              style: Get.textTheme.titleSmall?.copyWith(
                fontFamily: "Algerian",
                fontSize: 10.sp,
              ),
            ).tr(),
          ],
        ),
      ),
    );
  }
}

class _TransactionsButton extends StatelessWidget {
  const _TransactionsButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => const Transactions()),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kColorCardHint,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Ionicons.swap_vertical_outline,
              size: 12.sp,
              color: kColorAccent,
            ),
            const SizedBox(width: 8),
            Text(
              'Transactions',
              style: Get.textTheme.titleSmall?.copyWith(
                fontFamily: "Algerian",
                fontSize: 10.sp,
              ),
            ).tr(),
          ],
        ),
      ),
    );
  }
}

class _UserImage extends StatelessWidget {
  const _UserImage();

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: true);
    final StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: true);

    return UserShirt(
      name: authNotifier.userModel.data?.shirtName ?? '',
      number: '${authNotifier.userModel.data?.shirtNumber ?? 0}',
      textColor: '${authNotifier.userModel.data?.shirtTextColor}',
      shirtPhoto:
          storeNotifier.tshirtPic ?? authNotifier.userModel.data?.shirtPhoto,
      gradient: RadialGradient(
        colors: [
          kColorAccent.withOpacity(0.3),
          authNotifier.userModel.data?.shirtBGColor == null
              ? kColorPrimary.withOpacity(0.2)
              : hexToColor(
                  authNotifier.userModel.data?.shirtBGColor ?? "#FFFFFF",
                ),
          kColorPrimaryDark.withOpacity(0.3),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({required this.settings});

  final GlobalKey settings;

  @override
  Widget build(BuildContext context) {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return SliverAppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      pinned: true,
      title: FadeIn(
        duration: const Duration(milliseconds: 500),
        child: Text(
          'Profile',
          style: Get.textTheme.headlineMedium?.copyWith(
            fontFamily: "Algerian",
          ),
        ).tr(),
      ),
      leadingWidth: 100,
      leading: authNotifier.userModel.data == null
          ? const SizedBox()
          : UserCoins(authNotifier.userModel.data!.coinsBalance.toString()),
      actions: [
        InkWell(
          onTap: () => Get.to(() => const Settings()),
          child: Showcase(
            key: settings,
            title: tr('settings'),
            description: tr('settings_desc'),
            targetBorderRadius: BorderRadius.circular(10000),
            targetPadding: const EdgeInsets.all(8),
            titleTextStyle: const TextStyle(
              fontFamily: 'Algerian',
              color: Colors.black,
            ),
            descTextStyle: TextStyle(
              fontFamily: 'Algerian',
              color: Colors.black,
              fontSize: 8.sp,
            ),
            descriptionPadding: const EdgeInsets.symmetric(vertical: 8),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 2.w,
        ),
      ],
    );
  }
}

class GroupsRailProfile extends StatelessWidget {
  const GroupsRailProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GroupNotifier groupNotifier =
        Provider.of<GroupNotifier>(context, listen: true);
    final homeNotifier = Provider.of<HomeNotifier>(context, listen: true);

    return SizedBox(
      width: 100.w,
      height: 14.h,
      child: ListView.separated(
        itemCount: groupNotifier.myGroups?.count ?? 0,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        itemBuilder: (context, int i) {
          final group = groupNotifier.myGroups?.groups![i];
          return HorizontalAnimation(
            duration: 700,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CachedNetworkImage(
                      imageUrl: group?.group?.logo ??
                          homeNotifier.mainPageModel.groupHLImage ??
                          "",
                      height: 10.h,
                      width: 20.w,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const CupertinoActivityIndicator(),
                      imageBuilder: (context, imageProvider) => Container(
                        height: 10.h,
                        width: 20.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: imageProvider,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 10.h,
                        width: 20.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: kColorPrimaryDark,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          'FEL',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontFamily: 'Algerian'),
                        ),
                      ),
                    ),
                    Container(
                      height: 26,
                      width: 26,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kColorCardHint,
                      ),
                      child: FittedBox(
                        child: Text(
                          '${group?.rank ?? 0}',
                          style: Get.textTheme.bodySmall?.copyWith(
                            fontFamily: "Algerian",
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  group?.group?.name ?? '',
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontFamily: "Algerian",
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 16,
          );
        },
      ),
    );
  }
}
