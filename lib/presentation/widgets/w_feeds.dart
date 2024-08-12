// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison

import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:football_app/helpers/extensions.dart';
import 'package:football_app/helpers/helper.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/models/home/admin_challenges_model.dart';
import 'package:football_app/models/home/home_page_model.dart';
import 'package:football_app/presentation/notifiers/home_notifier.dart';
import 'package:football_app/presentation/screens/groups/group_details_screen.dart';
import 'package:football_app/presentation/screens/home/challenge_details_screen.dart';
import 'package:football_app/presentation/widgets/dialogs/login_popup.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../notifiers/auth_notifier.dart';

class AdminChallengesCard extends StatelessWidget {
  const AdminChallengesCard({
    required this.challengeModel,
    this.onUpdate,
    super.key,
  });
  final AdminChallengesModel challengeModel;
  final VoidCallback? onUpdate;

  Widget team({
    required String name,
    required String imageUrl,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            width: 15.w,
            errorWidget: (context, url, error) => const Icon(
              Icons.question_mark,
            ),
          ),
          // const SizedBox(
          //   height: 3,
          // ),
          // Flexible(
          //   child:
          Text(
            name,
            style: Get.textTheme.titleSmall?.copyWith(
              fontFamily: "Algerian",
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Get.to(
          () => ChallengeDetailsScreen(
            adminChallenges: challengeModel,
          ),
        );

        onUpdate!();
      },
      child: Container(
        // height: 15.h,
        margin:
            const EdgeInsetsDirectional.symmetric(vertical: 6, horizontal: 8),
        padding:
            const EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 235, 221, 221),
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              Matchgoal.toColor(challengeModel.match!.homeColor!),
              // Colors.yellow,
              const Color.fromARGB(255, 25, 25, 25),
              Matchgoal.toColor(challengeModel.match!.awayColor!),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                team(
                  name: challengeModel.match?.homeTeam ?? '',
                  imageUrl: challengeModel.match?.homeLogo ?? '',
                ),
                const Spacer(),
                Text(
                  challengeModel.match!.homeGoals.toString(),
                  style: const TextStyle(fontFamily: 'Algerian'),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SizedBox(
                      //   height: 1.h,
                      // ),
                      Text(
                        challengeModel.match!.status.toString(),
                        style: TextStyle(
                          fontFamily: "Algerian",
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 10.sp,
                        ),
                        textAlign: TextAlign.center,
                      ).tr(),
                      SizedBox(height: 3.h),
                      Text(
                        DateFormat.Hm("en").format(
                          DateFormat("yyyy-MM-ddTHH:mm:ssZ", 'en')
                              .parseUTC(challengeModel.match?.startDate ?? "")
                              .toLocal(),
                        ),
                        // challengeModel.match?.startDate?.toHHMM() ?? '',
                        style: TextStyle(
                          fontFamily: "Algerian",
                          color: Colors.yellow,
                          fontWeight: FontWeight.w800,
                          fontSize: 10.sp,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (challengeModel.isWinLoseQuestion ?? false)
                            Icon(
                              Ionicons.clipboard_outline,
                              color: kColorAccent,
                            )
                          else
                            Icon(
                              Ionicons.help_circle_outline,
                              color: kColorAccent,
                            ),
                          challengeModel.usersAnswers?.isEmpty ?? false
                              ? Icon(
                                  Icons.horizontal_rule,
                                  color: kColorAccent,
                                )
                              : challengeModel.isWinLoseQuestion == false &&
                                      (challengeModel
                                              .usersAnswers?.isNotEmpty ??
                                          false)
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 1.w,
                                        vertical: 1.h,
                                      ),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        gradient: LinearGradient(
                                          begin: AlignmentDirectional.topStart,
                                          end: AlignmentDirectional.bottomEnd,
                                          colors: [
                                            Matchgoal.toColor(
                                              challengeModel.match!.homeColor!,
                                            ),
                                            // Colors.yellow,
                                            const Color.fromARGB(
                                              255,
                                              25,
                                              25,
                                              25,
                                            ),
                                            Matchgoal.toColor(
                                              challengeModel.match!.awayColor!,
                                            ),
                                          ],
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        size: 26,
                                        color: kColorAccent,
                                      ),
                                    )
                                  : challengeModel.isWinLoseQuestion == true &&
                                          (challengeModel
                                                  .usersAnswers?.isNotEmpty ??
                                              false)
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 1.w,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 1.w,
                                            ),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              gradient: LinearGradient(
                                                begin: AlignmentDirectional
                                                    .topStart,
                                                end: AlignmentDirectional
                                                    .bottomEnd,
                                                colors: [
                                                  Matchgoal.toColor(
                                                    challengeModel
                                                        .match!.homeColor!,
                                                  ),
                                                  // Colors.yellow,
                                                  const Color.fromARGB(
                                                    255,
                                                    25,
                                                    25,
                                                    25,
                                                  ),
                                                  Matchgoal.toColor(
                                                    challengeModel
                                                        .match!.awayColor!,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            child: Text(
                                              '${challengeModel.usersAnswers?.first.homeGoals} / ${challengeModel.usersAnswers?.first.awayGoals}',
                                              style: Get.textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontFamily: "Algerian",
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                          if (challengeModel.usersAnswers == null ||
                              (challengeModel.usersAnswers?.isEmpty ?? false))
                            const SizedBox(width: 20)
                          else if ((challengeModel.usersAnswers!.first.bonus ??
                                  0) >
                              0)
                            Text(
                              "x${challengeModel.usersAnswers!.first.bonus}",
                              style: const TextStyle(fontFamily: 'Algerian'),
                            )
                          else
                            const SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  challengeModel.match!.awayGoals.toString() == "null"
                      ? ''
                      : challengeModel.match!.awayGoals.toString(),
                ),
                const Spacer(),
                team(
                  name: challengeModel.match?.awayTeam ?? '',
                  imageUrl: challengeModel.match?.awayLogo ?? '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AdminChallengesRail extends StatelessWidget {
  const AdminChallengesRail({
    super.key,
    required this.challenges,
    this.onUpdate,
  });

  final List<AdminChallengesModel>? challenges;
  final VoidCallback? onUpdate;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsetsDirectional.zero,
      itemCount: challenges?.length ?? 1,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        return HorizontalAnimation(
          duration: 250 * (index + 3),
          child: AdminChallengesCard(
            challengeModel: challenges![index],
            onUpdate: onUpdate,
          ),
        );
      },
    );
  }
}

class GroupsRail extends StatelessWidget {
  const GroupsRail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeNotifier homeNotifier =
        Provider.of<HomeNotifier>(context, listen: true);
    final AuthNotifier authNotifier = Provider.of<AuthNotifier>(
      context,
      listen: false,
    );
    return SizedBox(
      width: 100.w,
      height: 14.h,
      child: ListView.separated(
        itemCount: homeNotifier.mainPageModel.groups?.length ?? 0,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        itemBuilder: (context, int i) {
          final group = homeNotifier.mainPageModel.groups?[i];
          return HorizontalAnimation(
            duration: 700,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (authNotifier.userModel.data?.isGuest ?? false) {
                      showDialog(
                        context: context,
                        builder: (context) => const LoginPopUp(),
                      );
                    } else {
                      Get.to(
                        () => ExploreGroupDetailsScreen(
                          groupId: homeNotifier.mainPageModel.groups?[i].id,
                        ),
                      );
                    }
                  },
                  child: CachedNetworkImage(
                    imageUrl: group?.logo ??
                        homeNotifier.mainPageModel.groupHLImage ??
                        '',
                    height: 10.h,
                    width: 20.w,
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  //omar

                  Get.locale.toString() == 'ar'
                      ? group?.arName ?? ''
                      : Get.locale.toString() == 'en'
                          ? group?.name ?? ''
                          : Get.locale.toString() == 'es'
                              ? group?.esName ?? ''
                              : group?.poName ?? '',

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

class SponsorsRail extends StatelessWidget {
  const SponsorsRail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeNotifier = Provider.of<HomeNotifier>(context, listen: true);

    return SizedBox(
      width: 100.w,
      height: 12.h,
      child: ListView.builder(
        itemCount: homeNotifier.mainPageModel.sponsors?.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, int i) {
          final sponsor = homeNotifier.mainPageModel.sponsors?[i];
          return HorizontalAnimation(
            duration: 300 * (i + 2),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Helper().launchUniversalLink('${sponsor?.url}'),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 8),
                    child: Container(
                      width: 20.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: sponsor?.logo ?? '',
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) {
                            return const Icon(Icons.question_mark);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                //omar
                Text(
                  Get.locale.toString() == 'ar'
                      ? sponsor?.arName ?? ''
                      : Get.locale.toString() == 'en'
                          ? sponsor?.name ?? ''
                          : Get.locale.toString() == 'es'
                              ? sponsor?.esName ?? ''
                              : sponsor?.poName ?? '',
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontFamily: "Algerian",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CardCarousel extends StatelessWidget {
  const CardCarousel({
    required this.newsModel,
    super.key,
  });

  final Advertisements newsModel;

  static const _borderRadiusValue = 8.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Helper().launchUniversalLink('${newsModel.companyUrl}');
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: kColorCard,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(_borderRadiusValue),
            bottomRight: Radius.circular(_borderRadiusValue),
          ),
        ),
        child: CachedNetworkImage(
          imageUrl: newsModel.adsPhoto.toString(),
          imageBuilder: (context, imageProvider) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: kColorCard,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(_borderRadiusValue),
                      bottomRight: Radius.circular(_borderRadiusValue),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imageProvider,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        //    Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //omar
                            Text(
                              Get.locale.toString() == 'en'
                                  ? newsModel.companyName ?? ''
                                  : Get.locale.toString() == 'ar'
                                      ? newsModel.arCompanyName ?? ''
                                      : Get.locale.toString() == 'es'
                                          ? newsModel.esCompanyName ?? ""
                                          : newsModel.poCompanyName ?? "",
                              style: Get.textTheme.bodyLarge?.copyWith(
                                fontFamily: "Algerian",
                                fontSize: 16.sp,
                              ),
                            ),
                            const SizedBox(height: 8),
                            //omar

                            Text(
                              Get.locale.toString() == 'ar'
                                  ? newsModel.arDescription ?? ''
                                  : Get.locale.toString() == 'en'
                                      ? newsModel.description ?? ''
                                      : Get.locale.toString() == 'es'
                                          ? newsModel.esDescription ?? ""
                                          : newsModel.poDescription ?? "",
                              style: Get.textTheme.bodyLarge?.copyWith(
                                fontFamily: "Algerian",
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Helper()
                              .launchUniversalLink('${newsModel.companyUrl}');
                        },
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: kColorPrimary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'showMore',
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  fontFamily: "Algerian",
                                  fontSize: 5.sp,
                                ),
                              ).tr(),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_sharp,
                                color: Colors.white,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ).paddingAll(16),
              ],
            );
          },
          fit: BoxFit.fitHeight,
          width: double.infinity,
        ),
      ),
    );
  }
}

class TextTileFeed extends StatelessWidget {
  const TextTileFeed({
    required this.label,
    this.onTap,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      child: Row(
        children: [
          Visibility(
            visible: icon != null,
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          Visibility(
            visible: icon != null,
            child: SizedBox(
              width: 2.w,
            ),
          ),
          Text(
            label,
            style: Get.textTheme.headlineSmall
                ?.copyWith(fontFamily: "Algerian", fontSize: 16),
          ).tr(),
          const Spacer(),
          Visibility(
            visible: onTap != null,
            child: InkWell(
              onTap: onTap,
              child: Text(
                kShowAll,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontFamily: "Algerian",
                  color: kColorPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChipBarCaty extends StatelessWidget {
  const ChipBarCaty({
    Key? key,
    required this.isSelected,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 3),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected ? Get.theme.primaryColor : kColorPrimaryDark,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            label,
            style: isSelected
                ? Get.textTheme.headlineSmall?.copyWith(
                    fontFamily: "Algerian",
                  )
                : Get.textTheme.titleSmall!.copyWith(
                    fontFamily: "Algerian",
                    color: kColorAccent,
                  ),
          ),
        ),
      ),
    );
  }
}

class FeedCarousel extends StatefulWidget {
  const FeedCarousel({super.key});

  @override
  State<FeedCarousel> createState() => _FeedCarouselState();
}

class _FeedCarouselState extends State<FeedCarousel> {
  int currentIndex = 0;
  final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
  int count = 0;
  @override
  void initState() {
    super.initState();
    _loadCount();
  }

  void _loadCount() async {
    // Await the result of rxPrefs.getInt('count')
    count = (await rxPrefs.getInt('count'))!;
    // Log the actual value of count
    log(">>>>>${count.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    final homeNotifier = Provider.of<HomeNotifier>(
      context,
      listen: true,
    );
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Stack(
            children: [
              HorizontalAnimation(
                duration: 400,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 75.h,
                    autoPlay: true,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: true,
                    viewportFraction: 1,
                    onPageChanged: (int index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                  items: List.generate(
                    homeNotifier.mainPageModel.advertisements?.length ?? 0,
                    (index) => CardCarousel(
                      newsModel:
                          homeNotifier.mainPageModel.advertisements?[index] ??
                              Advertisements(),
                    ),
                  ),
                ),
              ),
              //mobark
              // Align(
              //   alignment: AlignmentDirectional.topStart,
              //   child: InkWell(
              //     onTap: () {
              //       Get.to(() => const NotificationsScreen());
              //       setState(() {
              //         rxPrefs.remove('count');
              //       });
              //     },
              //     child: Stack(
              //       children: [
              //         Container(
              //           margin: EdgeInsets.only(top: 3.h),
              //           width: 12.w,
              //           height: 12.w,
              //           padding: EdgeInsets.all(2.w),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(12),
              //             color: kColorPrimary.withOpacity(.8),
              //           ),
              //           child: Icon(
              //             Icons.notifications,
              //             color: Colors.white,
              //             size: 8.w,
              //           ),
              //         ),
              //         count == 0 || count == null
              //             ? const SizedBox()
              //             : Positioned(
              //                 bottom: 1.5.w,
              //                 right: .6.w,
              //                 child: CircleAvatar(
              //                   backgroundColor: Colors.red,
              //                   radius: 2.5.w,
              //                   child: Text(
              //                     count.toString(),
              //                     style: TextStyle(fontSize: 3.w),
              //                   ),
              //                 ),
              //               ),
              //       ],
              //     ),
              //   ),
              // ).paddingAll(16),
            ],
          ),

          ///Carousel Dotes
          HorizontalAnimation(
            duration: 500,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                homeNotifier.mainPageModel.advertisements?.length ?? 0,
                (index) {
                  return GestureDetector(
                    onTap: () {},
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: currentIndex == index ? 8.w : 5.w,
                      height: 6,
                      margin: const EdgeInsetsDirectional.symmetric(
                        horizontal: 2.5,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? kColorPrimary
                            : kColorIconHomeHint,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  void onEnd() {}

  DateTime? _combinedDateTime;
  Timer? _timer;
  Duration _timeRemaining = const Duration();

  @override
  void initState() {
    super.initState();

    final homeNotifier = Provider.of<HomeNotifier>(context, listen: false);
    final question = homeNotifier.mainPageModel.question;
    final time = DateTime.parse(question?.endDate ?? DateTime.now().toString());
    _combinedDateTime = time;
    _startCountdownTimer();
  }

  void _startCountdownTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      final now = DateTime.now();
      if (_combinedDateTime?.isAfter(now) ?? false) {
        _timeRemaining = _combinedDateTime!.difference(now);
      } else {
        _timer?.cancel();
      }
      setState(() {});
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeRemaining.inDays;
    final hours = _timeRemaining.inHours % 24;
    final minutes = _timeRemaining.inMinutes % 60;
    final seconds = _timeRemaining.inSeconds % 60;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'challenge_ends_in',
              style: TextStyle(
                fontFamily: 'Algerian',
                fontWeight: FontWeight.w400,
                fontSize: 8.sp,
              ),
            ).tr(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                TimeContainer(
                  data: days.toString(),
                  type: tr('days'),
                ),
                TimeContainer(
                  data: hours.toString(),
                  type: tr('hours'),
                ),
                TimeContainer(
                  data: minutes.toString(),
                  type: tr('minuets'),
                ),
                TimeContainer(
                  data: seconds.toString(),
                  type: tr('seconds'),
                  isLast: true,
                ),
              ],
            ),
          ],
        ),
        // child: CountdownTimer(
        //   onEnd: onEnd,
        //   endTime: DateTime.parse(question?.endDate ?? DateTime.now.toString())
        //           .millisecondsSinceEpoch +
        //       1000 * 30,
        // ),
      ),
    );
  }
}

class TimeContainer extends StatelessWidget {
  const TimeContainer({
    super.key,
    required this.data,
    required this.type,
    this.isLast = false,
  });

  final String data;
  final String type;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Text(data),
            ),
            if (!isLast) const Text(':'),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          type,
          style: TextStyle(
            fontFamily: 'Algerian',
            fontWeight: FontWeight.w400,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({super.key});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int _selectedOption = -1;
  final _optionCounts = <int>[0, 0, 0, 0];
  bool _hasSelected = false;

  void _selectOption(int optionIndex, HomeNotifier homeNotifier) {
    if (_selectedOption == -1) {
      setState(() {
        _selectedOption = optionIndex;
        _optionCounts[optionIndex]++;
        _hasSelected = true;
      });

      if (homeNotifier.mainPageModel.hasAnsweredQuestion == false) {
        String? myAnswer = homeNotifier
            .mainPageModel.question?.answers?[_selectedOption]
            .toString();

        log('data=${homeNotifier.mainPageModel.question?.answers?[_selectedOption].toString()}');
        homeNotifier.answerQues(myAnswer ?? '');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double totalVotes = _optionCounts.reduce((a, b) => a + b).toDouble();
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: true);
    final homeNotifier = Provider.of<HomeNotifier>(context, listen: true);
    final question = homeNotifier.mainPageModel.question;
    return SliverToBoxAdapter(
      child: Visibility(
        visible: true,
        // visible: homeNotifier.mainPageModel.question != null &&
        //     homeNotifier.mainPageModel.hasAnsweredQuestion != true,
        child: Container(
          height: 75.h,
          margin: const EdgeInsetsDirectional.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CachedNetworkImage(
                height: 75.h,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: imageProvider,
                    ),
                  ),
                ),
                imageUrl: question?.photo ?? '',
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(unKnowperson),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.45),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 15.h),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kColorBackground.withOpacity(0.7),
                    ),
                    child: Text(
                      question?.question ?? '.',
                      style: Get.textTheme.displayMedium?.copyWith(
                        fontFamily: "Algerian",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      homeNotifier.mainPageModel.question?.answers?.length ?? 0,
                      (index) {
                        // double percentage = totalVotes > 0
                        //     ? (_optionCounts[index] / totalVotes) * 100
                        //     : 0;
                        return homeNotifier
                                    .mainPageModel.hasAnsweredQuestion! ||
                                _selectedOption != -1
                            ? Container(
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: (authNotifier.userModel.data?.questions
                                                  ?.isEmpty ??
                                              false) &&
                                          (question?.answers?[index] ==
                                              homeNotifier
                                                  .mainPageModel
                                                  .question
                                                  ?.answers?[_selectedOption])
                                      ? Colors.blue
                                      : (authNotifier.userModel.data?.questions?.isEmpty ??
                                                  false) &&
                                              (question?.answers?[index] !=
                                                  homeNotifier.mainPageModel
                                                          .question?.answers?[
                                                      _selectedOption])
                                          ? const Color.fromARGB(
                                              255,
                                              25,
                                              25,
                                              25,
                                            )
                                          : question?.answers?[index] ==
                                                  authNotifier.userModel.data
                                                      ?.questions?[0].answer
                                              ? Colors.blue
                                              : const Color.fromARGB(255, 25, 25, 25),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                padding: const EdgeInsetsDirectional.all(10),
                                margin: const EdgeInsetsDirectional.symmetric(
                                  vertical: 5,
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      question?.answers?[index] ?? '',
                                      style:
                                          Get.textTheme.titleMedium?.copyWith(
                                        fontFamily: "Algerian",
                                      ),
                                    ),
                                    // _hasSelected
                                    //     ? Text(
                                    //         '  -  ${percentage.toStringAsFixed(0)}%',
                                    //         style: Get.textTheme.titleSmall,
                                    //       )
                                    //     :
                                    // const SizedBox.shrink(),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  if (authNotifier.userModel.data?.isGuest ??
                                      false) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const LoginPopUp(),
                                    );
                                  } else {
                                    _selectOption(index, homeNotifier);
                                  }
                                },
                                child: Container(
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    color: _selectedOption == index
                                        ? Colors.blue
                                        : const Color.fromARGB(255, 25, 25, 25),
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  padding: const EdgeInsetsDirectional.all(10),
                                  margin: const EdgeInsetsDirectional.symmetric(
                                    vertical: 5,
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        question?.answers?[index] ?? '',
                                        style:
                                            Get.textTheme.titleMedium?.copyWith(
                                          fontFamily: "Algerian",
                                        ),
                                      ),
                                      // _hasSelected
                                      //     ? Text(
                                      //         '  -  ${percentage.toStringAsFixed(0)}%',
                                      //         style: Get.textTheme.titleSmall,
                                      //       )
                                      //     :
                                      // const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopTenChallengers extends StatelessWidget {
  const TopTenChallengers({super.key});

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    final homeNotifier = Provider.of<HomeNotifier>(context, listen: true);
    final width = 28.w;
    final height = 24.5.h;
    return SizedBox(
      height: height,
      child: homeNotifier.mainPageModel.top10Challengers == null
          ? const SizedBox.shrink()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount:
                  homeNotifier.mainPageModel.top10Challengers!.length + 1,
              itemBuilder: (context, index) {
                if (index ==
                    homeNotifier.mainPageModel.top10Challengers!.length) {
                  return SizedBox(width: 3.w);
                }

                final challenger =
                    homeNotifier.mainPageModel.top10Challengers?[index];
                return HorizontalAnimation(
                  duration: 200 + (index * 3),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.center,
                    children: [
                      //   _image(width, height, challenger),
                      // _topTenText(),
                      //  _points('${challenger?.pointsEarned ?? "0"}'),
                      //      _gradiant(width),
                      Container(
                        height: double.infinity,
                        width: width,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: RadialGradient(
                            colors: [
                              challenger?.shirtBGColor == null
                                  ? kColorPrimary.withOpacity(0.2)
                                  : hexToColor(
                                      challenger?.shirtBGColor ?? "#FFFFFF",
                                    ),
                              challenger?.shirtBGColor == null
                                  ? kColorPrimary.withOpacity(0.2)
                                  : hexToColor(
                                      challenger?.shirtBGColor ?? "#FFFFFF",
                                    ),
                              Colors.white,
                            ],
                          ),
                          // image: DecorationImage(
                          //   image: AssetImage(kBackgroundPlayerPng),
                          //   fit: BoxFit.cover,
                          // ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _points('${challenger?.pointsEarned ?? "0"}'),
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                _image(width, height, challenger, newShirt),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 3.5.h),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${challenger?.shirtName?.split(' ').first}',
                                        style:
                                            Get.textTheme.titleMedium?.copyWith(
                                          fontFamily: 'Aero',
                                          fontSize: 8.sp,
                                          color: hexToColor(
                                            challenger?.shirtTextColor ??
                                                "#FFFFFF",
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        '${challenger?.shirtNumber}',
                                        style:
                                            Get.textTheme.titleMedium?.copyWith(
                                          fontFamily: 'Aero',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          color: hexToColor(
                                            challenger?.shirtTextColor ??
                                                "#FFFFFF",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // _points('${challenger?.pointsEarned ?? "0"}'),
                          ],
                        ),
                      ),
                      _indexText(index),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: 5.w);
              },
            ),
    );
  }

  CachedNetworkImage _image(
    double width,
    double height,
    Top10Challengers? challenger,
    String imagename,
  ) {
    return CachedNetworkImage(
      width: width,
      height: 20.h,
      fit: BoxFit.cover,
      imageUrl: challenger?.photo ?? '',
      // imageBuilder: (context, imageProvider) {
      //   return Container(
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(8),
      //       // gradient: RadialGradient(
      //       //   colors: [
      //       //     kColorAccent.withOpacity(0.3),
      //       //     hexToColor(shirtBGColor),
      //       //   ],
      //       // ),
      //       // color: hexToColor(shirtBGColor),
      //       image: DecorationImage(
      //         fit: BoxFit.cover,
      //         image: imageProvider,
      //       ),
      //     ),
      //   );
      // },
      errorWidget: (context, url, error) => Image.asset(
        imagename,
        fit: BoxFit.cover,
      ),
    );
  }

  Container _gradiant(double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.25),
            Colors.black.withOpacity(0.5),
          ],
        ),
      ),
    );
  }

  Positioned _topTenText() {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(4),
            bottomEnd: Radius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(4),
          child: Text(
            'Top\n10',
            style: Get.textTheme.titleSmall?.copyWith(
              fontFamily: "Algerian",
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Container _points(String points) {
    return Container(
      decoration: const BoxDecoration(
        //  color: Colors.red,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(8),
          bottomEnd: Radius.circular(8),
          bottomStart: Radius.circular(8),
          topEnd: Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(4),
        child: Text(
          points,
          style: Get.textTheme.titleLarge?.copyWith(
            fontFamily: "Algerian",
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _indexText(int index) {
    return Positioned(
      right: -30,
      bottom: -24,
      child: Text(
        (index + 1).toString(),
        style: const TextStyle(
          inherit: true,
          fontSize: 100,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          shadows: [
            Shadow(
              // bottomLeft
              offset: Offset(-0.5, -.5),
              color: Colors.white,
            ),
            Shadow(
              // bottomRight
              offset: Offset(0.5, -.5),
              color: Colors.white,
            ),
            Shadow(
              // topRight
              offset: Offset(0.5, .5),
              color: Colors.white,
            ),
            Shadow(
              // topLeft
              offset: Offset(0.5, .5),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class AdminMatches extends StatelessWidget {
  const AdminMatches({super.key, this.onUpdate});

  final VoidCallback? onUpdate;

  @override
  Widget build(BuildContext context) {
    final homeNotifier = Provider.of<HomeNotifier>(context, listen: true);

    final list = <AdminChallengesModel>[];

    for (var element in homeNotifier.adminChallengesModel) {
      list.add(element);
    }

    final List<List<AdminChallengesModel>> groupedMatches = groupByStartDate(
      list,
    );
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsetsDirectional.zero,
      itemCount: groupedMatches.length,
      itemBuilder: (context, index) {
        final dayMatches = groupedMatches[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
              child: HorizontalAnimation(
                duration: 250 * (index + 3),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer,
                      color: Colors.white,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      dayMatches[0]
                              .match
                              ?.startDate
                              ?.convertToCustomDateFormat() ??
                          '',
                      // 'Admin 1',
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontFamily: "Algerian",
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.h),
            AdminChallengesRail(
              challenges: groupedMatches[index],
              onUpdate: onUpdate,
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 2.h,
        );
      },
    );
  }

  List<List<AdminChallengesModel>> groupByStartDate(
    List<AdminChallengesModel> matches,
  ) {
    // Create a map to group matches by startDate
    final Map<DateTime, List<AdminChallengesModel>> groupedMatches = {};

    // Iterate through each match
    for (final match in matches) {
      final startDate = match.stringToDate(match.match?.startDate ?? '');

      // Check if the startDate is already a key in the map
      if (!groupedMatches.containsKey(startDate)) {
        // If not, create a new list for that startDate
        groupedMatches[startDate] = [];
      }

      // Add the match to the list corresponding to its startDate
      groupedMatches[startDate]!.add(match);
    }

    // Convert the map values (lists of matches) to a list of lists
    final List<List<AdminChallengesModel>> result =
        groupedMatches.values.toList();

    return result;
  }
}

// extension HexColor on Color {
//   /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
//   static Color fromHex(String hexString) {
//     final buffer = StringBuffer();
//     if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
//     buffer.write(hexString.replaceFirst('#', ''));
//     return Color(int.parse(buffer.toString(), radix: 16));
//   }

//   /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
//   String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
//       '${alpha.toRadixString(16).padLeft(2, '0')}'
//       '${red.toRadixString(16).padLeft(2, '0')}'
//       '${green.toRadixString(16).padLeft(2, '0')}'
//       '${blue.toRadixString(16).padLeft(2, '0')}';
// }
