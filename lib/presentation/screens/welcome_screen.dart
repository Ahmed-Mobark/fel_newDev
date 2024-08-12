part of 'screens.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  static final List<Widget> _pages = [
    const FeedsPage(),
    GroupsScreen(
      withAppBar: true,
    ),
    const MainChallengeScreen(),
    const StorePage(),
    const ProfilePage(),
  ];

  final GlobalKey _feeds = GlobalKey();
  final GlobalKey _groups = GlobalKey();
  final GlobalKey _challenges = GlobalKey();
  final GlobalKey _store = GlobalKey();
  final GlobalKey _profile = GlobalKey();

  _startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      if (!(prefs.getBool('show_home_case') ?? false)) {
        ShowCaseWidget.of(context)
            .startShowCase([_feeds, _groups, _challenges, _store, _profile]);
        prefs.setBool('show_home_case', true);
      }
    });
  }

  @override
  initState() {
    super.initState();
    _startShowCase();
  }

  DateTime? currentBackPressTime;

  Future<bool> onWillPop(BottomNavigationBarNotifier navigationBarNotifier) {
    DateTime now = DateTime.now();
    if (navigationBarNotifier.navbarIndex != 0) {
      navigationBarNotifier.setNavbarIndex(0);
      return Future.value(false);
    } else {
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime ?? now) >
              const Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: tr('tab_again_leave'));
        return Future.value(false);
      }
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarNotifier navigationBarNotifier =
        Provider.of<BottomNavigationBarNotifier>(context, listen: true);
    return WillPopScope(
      onWillPop: () => onWillPop(navigationBarNotifier),
      child: Scaffold(
        endDrawerEnableOpenDragGesture: false,
        drawerEnableOpenDragGesture: false,
        extendBodyBehindAppBar: true,
        floatingActionButton: Showcase(
          key: _challenges,
          title: tr('My Groups'),
          description: tr('my_challenges_desc'),
          targetBorderRadius: BorderRadius.circular(10000),
          titleTextStyle:
              const TextStyle(fontFamily: 'Algerian', color: Colors.black),
          descTextStyle: TextStyle(
            fontFamily: 'Algerian',
            color: Colors.black,
            fontSize: 8.sp,
          ),
          descriptionPadding: const EdgeInsets.symmetric(vertical: 8),
          child: FloatingActionbotton(
            floatingactionfunction: () =>
                navigationBarNotifier.setNavbarIndex(2),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: CardBottomBar(
          feeds: _feeds,
          profile: _profile,
          groups: _groups,
          store: _store,
        ),
        body: _pages[navigationBarNotifier.navbarIndex ?? 0],
        extendBody: true,
      ),
    );
  }
}
