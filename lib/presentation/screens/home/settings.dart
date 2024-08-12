// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/notifiers/store_notifier.dart';
import 'package:football_app/presentation/screens/home/Widgets/remove_account_pop_up.dart';
import 'package:football_app/presentation/screens/home/support_screen.dart';
import 'package:football_app/presentation/screens/login/login_screen.dart';
import 'package:football_app/presentation/screens/settings/policy_screen.dart';
import 'package:football_app/presentation/screens/settings/terms_screen.dart';
import 'package:football_app/presentation/widgets/sliver_sized_box.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

enum Languages { english, arabic, spanish, portuguese }

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Languages? selectedMenu = Languages.english;
  final rxPrefs = RxSharedPreferences(SharedPreferences.getInstance());

  String? token;
  bool? _switch;
  bool? _switchNotification;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  _getToken() async {
    token = await rxPrefs.getString('token');
    final prefs = await SharedPreferences.getInstance();

    _switch = !(prefs.getBool('show_home_case') ?? false) &&
        !(prefs.getBool('show_profile_case') ?? false) &&
        !(prefs.getBool('show_store_case') ?? false) &&
        !(prefs.getBool('show_group_details_case') ?? false) &&
        !(prefs.getBool('show_groups_case') ?? false);
    setState(() {});
  }

  launchUrlString(String url) async {
    final url0 = url;
    if (await canLaunchUrl(Uri.parse(url0))) {
      await launchUrl(
        Uri.parse(url0),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url0';
    }
  }

  void toggleNotifications(bool enabled) {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    if (enabled) {
      // Subscribe to notifications
      _firebaseMessaging.subscribeToTopic('notifications');
      log("message>>>>");
    } else {
      // Unsubscribe from notifications
      _firebaseMessaging.unsubscribeFromTopic('notifications');
      log("not enable>>>>");
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    final StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: true);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const _AppBar(),
          SliverSizedBox(height: 2.h),
          // SliverToBoxAdapter(
          //     child: Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       color: Colors.grey.withOpacity(0.5)),
          //   child: Text(
          //     authNotifier.userModel.data?.email ??
          //         authNotifier.userModel.data?.shirtName ??
          //         '',
          //     textAlign: TextAlign.center,
          //   ),
          // )),
          if (isNotBlank(authNotifier.userModel.data?.email)) ...{
            ListTile1(
              text: authNotifier.userModel.data?.email ?? '',
              onTap: null,
              icon: Icons.email_outlined,
              duration: 700,
            ),
            SliverSizedBox(height: 1.h),
            const _Divider(),
            SliverSizedBox(height: 1.h),
          },
          ListTile1(
            text: tr('Language'),
            icon: Ionicons.language,
            onTap: null,
            duration: 600,
            trailing: PopupMenuButton<Languages>(
              color: kColorIconHomeHint,
              iconColor: Colors.white,
              initialValue: selectedMenu,
              onSelected: (Languages item) {
                setState(() {
                  selectedMenu = item;
                });

                authNotifier.setLang(item.name, context);
                authNotifier.changeLang(
                  item.name == 'english'
                      ? 'en'
                      : item.name == 'portuguese'
                          ? 'pt'
                          : item.name == 'spanish'
                              ? 'es'
                              : 'ar',
                );
                setState(() {});
              },
              itemBuilder: (context) => [
                PopupMenuItem<Languages>(
                  value: Languages.english,
                  child: const Text(
                    'English',
                    style: TextStyle(fontFamily: 'Algerian'),
                  ).tr(),
                ),
                PopupMenuItem<Languages>(
                  value: Languages.arabic,
                  child: const Text(
                    'Arabic',
                    style: TextStyle(fontFamily: 'Algerian'),
                  ).tr(),
                ),
                PopupMenuItem<Languages>(
                  value: Languages.portuguese,
                  child: const Text(
                    'Portuguese',
                    style: TextStyle(fontFamily: 'Algerian'),
                  ).tr(),
                ),
                PopupMenuItem<Languages>(
                  value: Languages.spanish,
                  child: const Text(
                    'Spanish',
                    style: TextStyle(fontFamily: 'Algerian'),
                  ).tr(),
                ),
              ],
            ),
          ),

          // if (token != null) ...{
          //   const _Divider(),
          //
          //   // ListTile1(
          //   //   text: tr('Challenges History'),
          //   //   icon: Ionicons.football,
          //   //   onTap: () => Get.to(() => const ChallengesHistoryScreen()),
          //   //   duration: 750,
          //   // ),
          // },
          //mobark
          ListTile1(
            text: tr('notifications'),
            icon: Ionicons.notifications,
            trailing: CupertinoSwitch(
              value: _switchNotification ?? false,
              onChanged: (v) async {
                setState(() {
                  _switchNotification = v;
                });
                toggleNotifications(v);
              },
            ),
            onTap: () {},
            duration: 700,
          ),
          ListTile1(
            text: tr('Guide Line'),
            icon: Ionicons.accessibility,
            trailing: CupertinoSwitch(
              value: _switch ?? false,
              onChanged: (v) async {
                final prefs = await SharedPreferences.getInstance();
                if (!(_switch ?? false)) {
                  prefs.setBool('show_home_case', false);
                  prefs.setBool('show_profile_case', false);
                  prefs.setBool('show_groups_case', false);
                  prefs.setBool('show_store_case', false);
                  prefs.setBool('show_group_details_case', false);
                  _switch = true;
                  setState(() {});
                } else {
                  prefs.setBool('show_home_case', true);
                  prefs.setBool('show_profile_case', true);
                  prefs.setBool('show_groups_case', true);
                  prefs.setBool('show_store_case', true);
                  prefs.setBool('show_group_details_case', true);
                  _switch = false;
                  setState(() {});
                }
              },
            ),
            onTap: () {},
            duration: 700,
          ),
          ListTile1(
            text: tr('Privacy Policy'),
            icon: Ionicons.clipboard_outline,
            onTap: () => Get.to(() => const PolicyScreen()),
            // onTap: () =>
            //     launchUrlString('http://www.felsport.com/privacypolicy'),
            duration: 700,
          ),
          ListTile1(
            text: tr('Terms Of Use'),
            icon: Ionicons.clipboard,
            onTap: () => Get.to(() => const TermsScreen()),
            // onTap: () => launchUrlString('https://www.felsport.com/termofuse'),
            duration: 750,
          ),
          ListTile1(
            text: tr('support'),
            icon: Ionicons.help_circle_outline,
            onTap: () => Get.to(() => const SupportScreen()),
            duration: 750,
          ),
          if (token != null) ...{
            ListTile1(
              text: tr('Remove Account'),
              icon: Ionicons.person,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const RemoveAccountPopUp(),
                );
              },
              duration: 800,
            ),
          },
          SliverSizedBox(height: 1.h),
          if (token != null) ...{
            const _Divider(),
            SliverSizedBox(height: 2.h),
            authNotifier.logoutLoading
                ? const AppLoadingIndicator()
                : ListTile1(
                    text: tr('Logout'),
                    icon: Ionicons.log_out,
                    onTap: () async {
                      // rxPrefs.remove('token');
                      // rxPrefs.remove('guestToken');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                      authNotifier.logout();
                      storeNotifier.tshirtPic = null;
                      storeNotifier.profilePic = null;

                      // bottomNavigationBarNotifier.setNavbarIndex(0);
                    },
                    duration: 800,
                  ),
          } else ...{
            const _Divider(),
            SliverSizedBox(height: 2.h),
            authNotifier.logoutLoading
                ? const AppLoadingIndicator()
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
          },
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      pinned: true,
      title: FadeIn(
        duration: const Duration(milliseconds: 500),
        child: Text(
          'Settings',
          style: Get.textTheme.headlineMedium?.copyWith(
            fontFamily: "Algerian",
          ),
        ).tr(),
      ),
      leading: BackButton(
        color: Colors.white,
        onPressed: () {
          Get.back();
        },
      ),
    );
  }
}

class ListTile1 extends StatelessWidget {
  const ListTile1({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    required this.duration,
    this.trailing,
  });

  final String text;
  final IconData icon;
  final VoidCallback? onTap;
  final int duration;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: HorizontalAnimation(
        duration: duration,
        child: ListTile(
          title: Text(
            text,
            style: Get.textTheme.titleMedium?.copyWith(
              fontFamily: "Algerian",
            ),
          ),
          leading: Icon(
            icon,
            color: kColorIconHomeHint,
          ),
          onTap: onTap,
          trailing: trailing,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: HorizontalAnimation(
        duration: 750,
        child: Container(
          height: 0.1.h,
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[800]?.withOpacity(0.8),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
