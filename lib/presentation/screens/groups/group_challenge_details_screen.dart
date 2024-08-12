import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/models/groups/answerofchallengeparam.dart';
import 'package:football_app/models/groups/group_matches_model.dart';
import 'package:football_app/models/groups/user_group_model.dart';
import 'package:football_app/models/home/admin_challenges_model.dart';
import 'package:football_app/presentation/notifiers/groups_notifer.dart';
import 'package:get/get.dart';
import 'package:get/get.dart' as getx;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GroupChallengeDetailsScreen extends StatelessWidget {
  const GroupChallengeDetailsScreen(
      {super.key,
      required this.challengeModel,
      this.groupId,
      this.group,
      this.fromChallenges = false});

  final GroupMatchesModel challengeModel;
  final String? groupId;
  final UserGroupModel? group;
  final bool fromChallenges;

  @override
  Widget build(BuildContext context) {
    final groupsNotifier = Provider.of<GroupNotifier>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Get.back();
            groupsNotifier.setPredictionBonusValue(0);
          },
        ),
      ),
      bottomSheet: DateFormat("yyyy-MM-ddTHH:mm:ssZ", 'en')
                  .parseUTC(challengeModel.startDate ?? "")
                  .isBefore(DateTime.now()) ||
              (challengeModel.predictions != null &&
                  challengeModel.predictions!.isNotEmpty)
          ? const SizedBox()
          : groupsNotifier.challengeLoading
              ? const Align(
                  alignment: Alignment.bottomCenter,
                  child: CircularProgressIndicator())
              : Container(
                  width: context.width,
                  margin: const EdgeInsets.only(
                      bottom: 20, top: 10, left: 10, right: 10),
                  child: FilledButton(
                    onPressed: () async {
                      AnswersofchallengeParam param = AnswersofchallengeParam(
                        groupId: groupId,
                        matchId: challengeModel.id,
                        homeGoals: groupsNotifier.predictionhomegoalValue,
                        awayGoals: groupsNotifier.predictionawaygoalValue,
                        bonus: groupsNotifier.predictionBonusValue,
                      );
                      await groupsNotifier.answerChallenge(param,
                          fromChallenges: fromChallenges,
                          groupMatchModel: challengeModel,
                          userGroupModel: group);

                      // groupsNotifier.groupMatches(groupId ?? '');
                      // Navigator.pop(context);
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontFamily: 'Algerian'),
                    ).tr(),
                  ),
                ),
      body: Container(
        height: context.height - 100,
        child: ListView(
          primary: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            GroupChallengeHeader(
              adminChallenges: challengeModel,
            ),
            WinLoseQuestionWidget(
              adminChallengesModel: challengeModel,
            ),
            SizedBox(
              height: 1.h,
            ),
            SizedBox(
              height: 8.h,
            ),
          ],
        ),
      ),
    );
  }
}

class GroupChallengeHeader extends StatelessWidget {
  const GroupChallengeHeader({
    super.key,
    required this.adminChallenges,
  });

  final GroupMatchesModel adminChallenges;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            GroupMatchesModel.toColor(adminChallenges.homeColor!),
            // Colors.yellow,
            const Color.fromARGB(255, 25, 25, 25),
            GroupMatchesModel.toColor(adminChallenges.awayColor!),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20.h,
                  width: 25.w,
                  child: CachedNetworkImage(
                    imageUrl: adminChallenges.homeLogo ?? '',
                    errorWidget: (context, url, error) => Icon(
                      Icons.question_mark,
                      size: 10.h,
                    ),
                  ),
                ),
                Text(
                  adminChallenges.homeTeam!,
                  style: Get.textTheme.headlineMedium?.copyWith(
                    fontFamily: "Algerian",
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Text(
            adminChallenges.homeGoals.toString() == 'null'
                ? ''
                : adminChallenges.homeGoals.toString(),
            style: const TextStyle(
                fontSize: 20, fontFamily: "Algerian", color: Colors.white),
            //  style: Get.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          Expanded(
            flex: 1,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  adminChallenges.status ?? '',
                  style: Get.textTheme.headlineMedium?.copyWith(
                    fontFamily: "Algerian",
                  ),
                  textAlign: TextAlign.center,
                ).tr(),
                SizedBox(height: 8.h),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    DateFormat.Hm("en").format(
                        DateFormat("yyyy-MM-ddTHH:mm:ssZ", 'en')
                            .parseUTC(adminChallenges.startDate ?? "")
                            .toLocal()),
                    style: TextStyle(
                      fontFamily: "Algerian",
                      color: Colors.yellow,
                      fontWeight: FontWeight.w800,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            adminChallenges.awayGoals.toString() == "null"
                ? ''
                : adminChallenges.awayGoals.toString(),
            // style: Get.textTheme.headlineMedium,
            style: const TextStyle(
                fontSize: 20, fontFamily: "Algerian", color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20.h,
                  width: 25.w,
                  child: CachedNetworkImage(
                    imageUrl: adminChallenges.awayLogo ?? '',
                    errorWidget: (context, url, error) => Icon(
                      Icons.question_mark,
                      size: 10.h,
                    ),
                  ),
                ),
                Text(
                  adminChallenges.awayTeam!,
                  style: Get.textTheme.headlineMedium?.copyWith(
                    fontFamily: "Algerian",
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WinLoseQuestionWidget extends StatelessWidget {
  const WinLoseQuestionWidget({super.key, required this.adminChallengesModel});

  final GroupMatchesModel adminChallengesModel;

  @override
  Widget build(BuildContext context) {
    final groupNotifier = Provider.of<GroupNotifier>(context);
    return CarouselSlider(
      items: [
        ChallengeWidget(
          adminChallengesModel: adminChallengesModel,
          question: Questions(
            questionText: tr("What do you expect"),
            answers: [
              adminChallengesModel.homeTeam ?? '',
              adminChallengesModel.awayTeam ?? '',
            ],
          ),
          questionindex: 1,
        ),
      ],
      options: CarouselOptions(
        autoPlay: false,
        height: 50.h,
        enableInfiniteScroll: false,
        viewportFraction: 1,
        onPageChanged: (value, reason) {
          groupNotifier.setChallengesPageIndex(value);
        },
      ),
    );
  }
}

class ChallengeWidget extends StatefulWidget {
  const ChallengeWidget(
      {super.key,
      required this.adminChallengesModel,
      required this.question,
      required this.questionindex});
  final GroupMatchesModel adminChallengesModel;
  final Questions question;
  final int questionindex;

  @override
  State<ChallengeWidget> createState() => _ChallengeWidgetState();
}

class _ChallengeWidgetState extends State<ChallengeWidget> {
  List listofindex = [];
  int x = 0;
  Map answers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makelist();
  }

  List<String> options = [];
  String qution = '1';
  void makelist() {
    for (int i = 0; i < widget.question.answers!.length; i++) {
      listofindex.add(0);
      options.add(widget.question.answers![i]);

      if (qution == '1') {
        qution = widget.question.questionText.toString();
      }
    }

    //I/flutter (30386): [محمد صلاح, مانى, هالاند]
  }

  @override
  Widget build(BuildContext context) {
    final groupsNotifier = Provider.of<GroupNotifier>(context, listen: true);
    return Container(
      color: kColorCard,
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 2),
      padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
 

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.question.questionText!,
            style: const TextStyle(fontFamily: 'Algerian'),
          ),
          const SizedBox(height: 16),
          _divider(),
          ListView.builder(
            itemCount: widget.question.answers!.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 4.w),
                    Text(
                      widget.question.answers![index],
                      style: const TextStyle(fontFamily: 'Algerian'),
                    ),
                    // Text(widget.question.questionText.toString()),
                    // Text(listofindex[index]),
                    const Spacer(),
                    if (widget.adminChallengesModel.predictions?.isEmpty ??
                        false)
                      IconButton(
                        onPressed: () {
                          // index;
                          //    x = widget.question.answers![index].length;
                          if (DateFormat("yyyy-MM-ddTHH:mm:ssZ", 'en')
                                  .parseUTC(
                                      widget.adminChallengesModel.startDate ??
                                          "")
                                  .isAfter(DateTime.now()) &&
                              (widget.adminChallengesModel.predictions ==
                                      null ||
                                  widget.adminChallengesModel.predictions!
                                      .isEmpty)) {
                            setState(() {
                              listofindex[index]++;
                              groupsNotifier.predictionhomegoalValue =
                                  listofindex[0];

                              groupsNotifier.predictionawaygoalValue =
                                  listofindex[1];
                            });
                          }
                        },
                        splashRadius: 12.sp,
                        icon: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: kColorPrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                            size: 12.sp,
                          ),
                        ),
                      ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                widget.adminChallengesModel.predictions != null
                                    ? 30
                                    : 0,
                            vertical: widget.adminChallengesModel.predictions !=
                                    null
                                ? 4
                                : 0),
                        child: Text(widget.adminChallengesModel.predictions ==
                                    null ||
                                (widget.adminChallengesModel.predictions
                                        ?.isEmpty ??
                                    false)
                            ? listofindex[index].toString() ?? '0'
                            : (index == 0
                                    ? widget.adminChallengesModel.predictions!
                                        .first.homeGoals
                                    : widget.adminChallengesModel.predictions!
                                        .first.awayGoals)
                                .toString())),
                    if (widget.adminChallengesModel.predictions?.isEmpty ??
                        false)
                      IconButton(
                        onPressed: () {
                          if (DateFormat("yyyy-MM-ddTHH:mm:ssZ", 'en')
                                  .parseUTC(
                                      widget.adminChallengesModel.startDate ??
                                          "")
                                  .isAfter(DateTime.now()) &&
                              (widget.adminChallengesModel.predictions ==
                                      null ||
                                  widget.adminChallengesModel.predictions!
                                      .isEmpty)) {
                            if (listofindex[index] <= 0) {
                            } else {
                              setState(() {
                                listofindex[index]--;
                              });
                              groupsNotifier.predictionhomegoalValue =
                                  listofindex[0];
                              groupsNotifier.predictionawaygoalValue =
                                  listofindex[1];
                            }
                          }
                        },
                        splashRadius: 12.sp,
                        icon: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: kColorPrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            FontAwesomeIcons.minus,
                            color: Colors.white,
                            size: 12.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          ChallengePredictionBonusListTile(
              adminChallengesModel: widget.adminChallengesModel),
        ],
      ),
    );
  }

  Widget listTilesLeading(String url) {
    return SizedBox(
      width: 10.w,
      child: CachedNetworkImage(
        imageUrl: url,
        errorWidget: (context, url, error) => Icon(
          Icons.question_mark,
          size: 3.h,
          color: Colors.white,
        ),
      ),
    );
  }

  Divider _divider() => Divider(
        thickness: 1,
        height: 5,
        color: Colors.grey.shade500,
      );
}

class ChallengePredictionBonusListTile extends StatelessWidget {
  const ChallengePredictionBonusListTile(
      {super.key, required this.adminChallengesModel});

  final GroupMatchesModel adminChallengesModel;

  @override
  Widget build(BuildContext context) {
    final groupsNotifier = Provider.of<GroupNotifier>(context, listen: true);

    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 4.w),
          Text(
            tr('Choose Bonus'),
            style: const TextStyle(fontFamily: 'Algerian'),
          ),
          const Spacer(),
          if (adminChallengesModel.predictions?.isEmpty ?? false)
            IconButton(
              onPressed: () {
                if (groupsNotifier.predictionBonusValue >= 3) {
                } else {
                  groupsNotifier.setPredictionBonusValue(
                    groupsNotifier.predictionBonusValue += 1,
                  );
                }
                log(groupsNotifier.predictionBonusValue.toString());
              },
              splashRadius: 12.sp,
              icon: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: kColorPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                  size: 12.sp,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: adminChallengesModel.predictions != null ? 30 : 0,
                vertical: adminChallengesModel.predictions != null ? 4 : 0),
            child: Text(adminChallengesModel.predictions == null ||
                    (adminChallengesModel.predictions?.isEmpty ?? false)
                ? groupsNotifier.predictionBonusValue.toString()
                : adminChallengesModel.predictions!.first.bonus.toString()),
          ),
          if (adminChallengesModel.predictions?.isEmpty ?? false)
            IconButton(
              onPressed: () {
                if (groupsNotifier.predictionBonusValue <= 0) {
                } else {
                  groupsNotifier.setPredictionBonusValue(
                    groupsNotifier.predictionBonusValue -= 1,
                  );
                }
                log(groupsNotifier.predictionBonusValue.toString());
              },
              splashRadius: 12.sp,
              icon: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: kColorPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  FontAwesomeIcons.minus,
                  color: Colors.white,
                  size: 12.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
