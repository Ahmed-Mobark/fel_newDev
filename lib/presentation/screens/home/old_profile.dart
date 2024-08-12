// part of '../screens.dart';
//
// enum Languages {
//   english,
//   arabic,
// }
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   Languages? selectedMenu = Languages.english;
//   final rxPrefs = RxSharedPreferences(SharedPreferences.getInstance());
//
//   String? token;
//
//   @override
//   void initState() {
//     super.initState();
//     _getToken();
//   }
//
//   _getToken() async {
//     token = await rxPrefs.getString('token');
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final AuthNotifier authNotifier =
//     Provider.of<AuthNotifier>(context, listen: true);
//
//     final bottomNavigationBarNotifier =
//     Provider.of<BottomNavigationBarNotifier>(context, listen: true);
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               const Color(0xFF010101),
//               kColorPrimaryDark.withOpacity(0.3),
//             ],
//             begin: Alignment.bottomCenter,
//             end: Alignment.topCenter,
//           ),
//         ),
//         child: CustomScrollView(
//           slivers: [
//             const _AppBar(),
//             SliverSizedBox(height: 2.h),
//             SliverToBoxAdapter(
//               child: Center(
//                 child: InkWell(
//                   // onTap: () {
//                   //   authNotifier.selectProfilePhoto();
//                   // },
//                   child: Stack(
//                     alignment: Alignment.topRight,
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(40),
//                           child: authNotifier.userModel.data == null ||
//                               authNotifier.userModel.data?.profilePhoto ==
//                                   ''
//                               ? Image.asset(
//                             'assets/images/Unknown.jpeg',
//                             fit: BoxFit.cover,
//                             width: MediaQuery.of(context).size.width,
//                           )
//                               : Image.network(
//                             authNotifier.userModel.data!.profilePhoto ??
//                                 '',
//                             fit: BoxFit.cover,
//                             width: MediaQuery.of(context).size.width,
//                           ),
//                         ),
//                       ),
//                       // Container(
//                       //   decoration: BoxDecoration(
//                       //     color: Colors.black.withOpacity(0.4),
//                       //     shape: BoxShape.circle,
//                       //   ),
//                       //   padding: const EdgeInsets.all(4),
//                       //   child: const Icon(
//                       //     Icons.edit,
//                       //     color: Colors.amber,
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const _UserImage(),
//             if (token != null) const _EditProfileSettingsButton(),
//             const _Divider(),
//             _ListTile(
//               text: tr('Language'),
//               icon: Ionicons.language,
//               onTap: null,
//               duration: 600,
//               trailing: PopupMenuButton<Languages>(
//                 color: kColorIconHomeHint,
//                 initialValue: selectedMenu,
//                 onSelected: (Languages item) {
//                   setState(() {
//                     selectedMenu = item;
//                   });
//
//                   authNotifier.setLang(item.name, context);
//                 },
//                 itemBuilder: (context) => [
//                   PopupMenuItem<Languages>(
//                     value: Languages.english,
//                     child: const Text('English').tr(),
//                   ),
//                   PopupMenuItem<Languages>(
//                     value: Languages.arabic,
//                     child: const Text('Arabic').tr(),
//                   ),
//                 ],
//               ),
//             ),
//             SliverSizedBox(height: 1.h),
//             if (token != null) ...{
//               const _Divider(),
//               _ListTile(
//                 text: tr('My Groups'),
//                 icon: Ionicons.people_circle,
//                 onTap: () {
//                   Get.to(() => const MyGroupsScreen());
//                 },
//                 duration: 700,
//               ),
//               _ListTile(
//                 text: tr('Challenges History'),
//                 icon: Ionicons.football,
//                 onTap: () => Get.to(() => const ChallengesHistoryScreen()),
//                 duration: 750,
//               ),
//               _ListTile(
//                 text: tr('Purchased Items'),
//                 icon: Ionicons.football,
//                 onTap: () => Get.to(() => const ChallengesHistoryScreen()),
//                 duration: 750,
//               ),
//             },
//             const _Divider(),
//             _ListTile(
//               text: tr('Privacy Policy'),
//               icon: Ionicons.clipboard_outline,
//               onTap: () {},
//               duration: 700,
//             ),
//             _ListTile(
//               text: tr('Terms Of Use'),
//               icon: Ionicons.clipboard,
//               onTap: () {},
//               duration: 750,
//             ),
//             SliverSizedBox(height: 1.h),
//             if (token != null) ...{
//               const _Divider(),
//               SliverSizedBox(height: 2.h),
//               authNotifier.logoutLoading
//                   ? const AppLoadingIndicator()
//                   : _ListTile(
//                 text: tr('Logout'),
//                 icon: Ionicons.log_out,
//                 onTap: () async {
//                   // rxPrefs.remove('token');
//                   // rxPrefs.remove('guestToken');
//                   Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => const LoginScreen()),
//                           (route) => false);
//                   authNotifier.logout();
//
//                   // bottomNavigationBarNotifier.setNavbarIndex(0);
//                 },
//                 duration: 800,
//               ),
//             },
//             SliverSizedBox(height: 15.h),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _Divider extends StatelessWidget {
//   const _Divider();
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: HorizontalAnimation(
//         duration: 750,
//         child: Container(
//           height: 0.1.h,
//           margin: const EdgeInsetsDirectional.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.grey[800]?.withOpacity(0.8),
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _ListTile extends StatelessWidget {
//   const _ListTile({
//     required this.text,
//     required this.icon,
//     required this.onTap,
//     required this.duration,
//     this.trailing,
//   });
//
//   final String text;
//   final IconData icon;
//   final VoidCallback? onTap;
//   final int duration;
//   final Widget? trailing;
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: HorizontalAnimation(
//         duration: duration,
//         child: ListTile(
//           title: Text(
//             text,
//             style: Get.textTheme.titleMedium,
//           ),
//           leading: Icon(
//             icon,
//             color: kColorIconHomeHint,
//           ),
//           onTap: onTap,
//           trailing: trailing,
//         ),
//       ),
//     );
//   }
// }
//
// class _EditProfileSettingsButton extends StatelessWidget {
//   const _EditProfileSettingsButton();
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: HorizontalAnimation(
//         duration: 500,
//         child: TextButton.icon(
//           icon: Icon(
//             Icons.edit,
//             size: 12.sp,
//             color: kColorPrimary,
//           ),
//           label: Text(
//             'Edit Profile Settings',
//             style: Get.textTheme.titleSmall?.copyWith(
//               fontFamily: "Algerian",
//               color: kColorPrimary,
//               fontSize: 11.sp,
//             ),
//           ).tr(),
//           onPressed: () => Get.to(() => const EditProfileSettingsScreen()),
//         ),
//       ),
//     );
//   }
// }
//
// class _UserImage extends StatelessWidget {
//   const _UserImage();
//
//   @override
//   Widget build(BuildContext context) {
//     AuthNotifier authNotifier =
//     Provider.of<AuthNotifier>(context, listen: true);
//     return SliverToBoxAdapter(
//       child: HorizontalAnimation(
//         duration: 200,
//         child: UserShirt(
//           name: authNotifier.userModel.data?.shirtName ?? '',
//           number: '${authNotifier.userModel.data?.shirtNumber ?? 0}',
//           gradient: RadialGradient(
//             colors: [
//               kColorAccent.withOpacity(0.3),
//               kColorPrimary.withOpacity(0.2),
//               // Colors.yellow.withOpacity(0.3),
//               // Colors.greenAccent.withOpacity(0.3),
//               kColorPrimaryDark.withOpacity(0.3),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _AppBar extends StatelessWidget {
//   const _AppBar();
//
//   @override
//   Widget build(BuildContext context) {
//     final AuthNotifier authNotifier =
//     Provider.of<AuthNotifier>(context, listen: false);
//     return SliverAppBar(
//       automaticallyImplyLeading: false,
//       centerTitle: true,
//       pinned: true,
//       title: FadeIn(
//         duration: const Duration(milliseconds: 500),
//         child: Text(
//           'Profile',
//           style: Get.textTheme.headlineMedium,
//         ).tr(),
//       ),
//       actions: [
//         UserCoins(authNotifier.userModel.data!.coinsBalance.toString()),
//         SizedBox(
//           width: 2.w,
//         ),
//       ],
//     );
//   }
// }
