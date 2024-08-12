import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/models/home/admin_challenges_model.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/notifiers/groups_notifer.dart';
import 'package:football_app/presentation/notifiers/league_notifier.dart';
import 'package:football_app/presentation/widgets/dialogs/login_popup.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../main.dart';
import '../../../models/groups/answerofadminchallengeparam.dart';
import '../../widgets/widgets.dart';

class ChallengeDetailsScreen extends StatelessWidget {
  const ChallengeDetailsScreen({
    required this.adminChallenges,
    super.key,
  });

  final AdminChallengesModel adminChallenges;
  @override
  Widget build(BuildContext context) {
    final groupsNotifier = Provider.of<GroupNotifier>(context, listen: true);
    final leagueNotifier = Provider.of<LeagueNotifier>(context, listen: true);
    final authNotifier = Provider.of<AuthNotifier>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Get.back();
            groupsNotifier.setPredictionBonusValue(0);
          },
        ),
      ),
      bottomSheet: DateFormat("yyyy-MM-ddTHH:mm:ssZ", 'en')
                  .parseUTC(adminChallenges.match?.startDate ?? "")
                  .isBefore(DateTime.now()) ||
              (adminChallenges.usersAnswers != null &&
                  adminChallenges.usersAnswers!.isNotEmpty)
          ? const SizedBox()
          : leagueNotifier.leagueLoading
              ? const Align(
                  alignment: Alignment.bottomCenter,
                  child: CircularProgressIndicator(),
                )
              : Container(
                  width: context.width,
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    top: 10,
                    left: 10,
                    right: 10,
                  ),
                  child: FilledButton(
                    onPressed: () async {
                      if (authNotifier.userModel.data?.isGuest ?? false) {
                        showDialog(
                          context: context,
                          builder: (context) => const LoginPopUp(),
                        );
                      } else {
                        if (adminChallenges.isWinLoseQuestion!) {
                          AnswersofadminchallengeParam param =
                              AnswersofadminchallengeParam(
                            challengeId: adminChallenges.id,
                            answers: [],
                            homeGoals: groupsNotifier.predictionhomegoalValue,
                            awayGoals: groupsNotifier.predictionawaygoalValue,
                            bonus: groupsNotifier.predictionBonusValue,
                          );
                          leagueNotifier.answerofadmin(param, groupsNotifier);
                        } else {
                          groupsNotifier.setList();
                          if (groupsNotifier.answersList.length ==
                              adminChallenges.questions!.length) {
                            AnswersofadminchallengeParam param =
                                AnswersofadminchallengeParam(
                              challengeId: adminChallenges.id,
                              answers: groupsNotifier.answersList,
                              homeGoals: groupsNotifier.predictionhomegoalValue,
                              awayGoals: groupsNotifier.predictionawaygoalValue,
                              bonus: groupsNotifier.predictionBonusValue,
                            );
                            leagueNotifier.answerofadmin(param, groupsNotifier);
                          } else {
                            ScaffoldMessenger.of(navigatorKey.currentContext!)
                                .showSnackBar(
                              errorSnackBar(tr('answer_all_questions')),
                            );
                          }
                        }
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontFamily: "Algerian",
                      ),
                    ).tr(),
                  ),
                ),
      body: SizedBox(
        height: context.height - 100,
        child: ListView(
          primary: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ChallengeHeader(
              adminChallenges: adminChallenges,
            ),
            adminChallenges.isWinLoseQuestion!
                ? WinLoseQuestionWidget(
                    adminChallengesModel: adminChallenges,
                  )
                : CarouselSlider(
                    items: List.generate(
                      adminChallenges.questions!.length,
                      (index) {
                        return ChallengeWidget(
                          adminChallengesModel: adminChallenges,
                          question: adminChallenges.questions![index],
                          questionindex: index,
                        );
                      },
                    ),
                    options: CarouselOptions(
                      autoPlay: false,
                      height: 45.h,
                      enableInfiniteScroll: false,
                      viewportFraction: 1,
                      onPageChanged: (value, reason) {
                        groupsNotifier.setChallengesPageIndex(value);
                      },
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                adminChallenges.questions?.length ?? 0,
                (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width:
                        groupsNotifier.challengesPageIndex == index ? 8.w : 5.w,
                    height: 6,
                    margin: const EdgeInsetsDirectional.symmetric(
                      horizontal: 2.5,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: groupsNotifier.challengesPageIndex == index
                          ? kColorPrimary
                          : kColorIconHomeHint,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  );
                },
              ),
            ),
            //        const ChallengePredictionBonusListTile(),

            SizedBox(
              height: 1.h,
            ),
            SizedBox(
              height: 7.h,
            ),
          ],
        ),
      ),
    );
  }
}

class ChallengeHeader extends StatelessWidget {
  const ChallengeHeader({
    super.key,
    required this.adminChallenges,
  });

  final AdminChallengesModel adminChallenges;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            Matchgoal.toColor(adminChallenges.match!.homeColor!),
            // Colors.yellow,
            const Color.fromARGB(255, 25, 25, 25),
            Matchgoal.toColor(adminChallenges.match!.awayColor!),
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
                    imageUrl: adminChallenges.match?.homeLogo ?? '',
                    errorWidget: (context, url, error) => Icon(
                      Icons.question_mark,
                      size: 10.h,
                    ),
                  ),
                ),
                Text(
                  adminChallenges.match!.homeTeam!,
                  style: Get.textTheme.headlineSmall?.copyWith(
                    fontFamily: "Algerian",
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Text(
            adminChallenges.match!.homeGoals.toString() == 'null'
                ? ''
                : adminChallenges.match!.homeGoals.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontFamily: "Algerian",
              color: Colors.white,
            ),
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
                  adminChallenges.match?.status ?? '',
                  style: Get.textTheme.headlineMedium?.copyWith(
                    fontFamily: "Algerian",
                  ),
                  textAlign: TextAlign.center,

                  //  TextStyle(
                  //   color: Colors.white,
                  //   fontWeight: FontWeight.w800,
                  //   fontSize: ,
                  // ),
                ).tr(),
                SizedBox(height: 8.h),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    // adminChallenges.match?.startDate?.toHHMM() ?? '',
                    DateFormat.Hm("en").format(
                      DateFormat("yyyy-MM-ddTHH:mm:ssZ", 'en')
                          .parseUTC(adminChallenges.match?.startDate ?? "")
                          .toLocal(),
                    ),
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
            // ignore: unnecessary_null_comparison
            adminChallenges.match!.awayGoals.toString() == "null"
                ? ''
                : adminChallenges.match!.awayGoals.toString(),
            // style: Get.textTheme.headlineMedium,
            style: const TextStyle(
              fontSize: 25,
              fontFamily: "Algerian",
              color: Colors.white,
            ),
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
                    imageUrl: adminChallenges.match?.awayLogo ?? '',
                    errorWidget: (context, url, error) => Icon(
                      Icons.question_mark,
                      size: 10.h,
                    ),
                  ),
                ),
                Text(
                  adminChallenges.match!.awayTeam!,
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

class ChallengeWidget extends StatefulWidget {
  const ChallengeWidget({
    super.key,
    required this.adminChallengesModel,
    required this.question,
    required this.questionindex,
  });
  final AdminChallengesModel adminChallengesModel;
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
    if (!widget.adminChallengesModel.isWinLoseQuestion!) {
      if (widget.adminChallengesModel.usersAnswers != null &&
          widget.adminChallengesModel.usersAnswers!.isNotEmpty) {
        widget.question.id = widget.adminChallengesModel.usersAnswers!.first
            .answers![widget.questionindex];
        groupsNotifier.answersofquetions[widget.questionindex] =
            widget.question.id;
      }
    }
    return !widget.adminChallengesModel.isWinLoseQuestion!
        ? Container(
            color: kColorCard,
            margin: const EdgeInsetsDirectional.symmetric(horizontal: 2),
            padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  qution,
                  style: const TextStyle(fontFamily: 'Algerian'),
                ),
                const SizedBox(height: 10),
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
                          Radio(
                            value: widget.question.answers![index],
                            groupValue: widget.question.id,
                            onChanged: (value) {
                              if (DateFormat("yyyy-MM-ddTHH:mm:ssZ", 'en')
                                      .parseUTC(
                                        widget.adminChallengesModel.match
                                                ?.startDate ??
                                            "",
                                      )
                                      .isAfter(DateTime.now()) &&
                                  (widget.adminChallengesModel.usersAnswers ==
                                          null ||
                                      widget.adminChallengesModel.usersAnswers!
                                          .isEmpty)) {
                                setState(() {
                                  widget.question.id = value;
                                  groupsNotifier.answersofquetions[widget
                                      .questionindex] = widget.question.id;
                                });
                              }
                            },
                          ),
                          Text(
                            widget.question.answers![index],
                            style: const TextStyle(fontFamily: 'Algerian'),
                          ),
                          // Text(widget.question.questionText.toString()),
                          // Text(listofindex[index]),
                          const Spacer(),
                        ],
                      ),
                    );
                  },
                ),
                ChallengePredictionBonusListTile(
                  adminChallengesModel: widget.adminChallengesModel,
                ),
              ],
            ),
          )
        : Container(
            color: kColorCard,
            margin: const EdgeInsetsDirectional.symmetric(horizontal: 2),
            padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
            // decoration: BoxDecoration(
            //                        borderRadius: BorderRadius.circular(30.0),

            // ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.question.questionText!,
                  style: const TextStyle(
                    fontFamily: "Algerian",
                  ),
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
                            style: const TextStyle(
                              fontFamily: "Algerian",
                            ),
                          ),
                          // Text(widget.question.questionText.toString()),
                          // Text(listofindex[index]),
                          const Spacer(),
                          if (widget.adminChallengesModel.usersAnswers ==
                                  null ||
                              (widget.adminChallengesModel.usersAnswers
                                      ?.isEmpty ??
                                  false))
                            IconButton(
                              onPressed: () {
                                // index;
                                //    x = widget.question.answers![index].length;
                                if (DateFormat("yyyy-MM-ddTHH:mm:ssZ", 'en')
                                        .parseUTC(
                                          widget.adminChallengesModel.match
                                                  ?.startDate ??
                                              "",
                                        )
                                        .isAfter(DateTime.now()) &&
                                    (widget.adminChallengesModel.usersAnswers ==
                                            null ||
                                        (widget.adminChallengesModel
                                                .usersAnswers?.isEmpty ??
                                            false))) {
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
                                  widget.adminChallengesModel.usersAnswers !=
                                          null
                                      ? 30
                                      : 0,
                              vertical:
                                  widget.adminChallengesModel.usersAnswers !=
                                          null
                                      ? 4
                                      : 0,
                            ),
                            child: Text(
                              widget.adminChallengesModel.usersAnswers ==
                                          null ||
                                      (widget.adminChallengesModel.usersAnswers
                                              ?.isEmpty ??
                                          false)
                                  ? listofindex[index].toString() ?? '0'
                                  : (index == 0
                                          ? widget.adminChallengesModel
                                              .usersAnswers!.first.homeGoals
                                          : widget.adminChallengesModel
                                              .usersAnswers!.first.awayGoals)
                                      .toString(),
                              style: const TextStyle(
                                fontFamily: "Algerian",
                              ),
                            ),
                          ),
                          if (widget.adminChallengesModel.usersAnswers ==
                                  null ||
                              (widget.adminChallengesModel.usersAnswers
                                      ?.isEmpty ??
                                  false))
                            IconButton(
                              onPressed: () {
                                if (DateFormat("yyyy-MM-ddTHH:mm:ssZ", 'en')
                                        .parseUTC(
                                          widget.adminChallengesModel.match
                                                  ?.startDate ??
                                              "",
                                        )
                                        .isAfter(DateTime.now()) &&
                                    (widget.adminChallengesModel.usersAnswers ==
                                            null ||
                                        (widget.adminChallengesModel
                                                .usersAnswers?.isEmpty ??
                                            false))) {
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
                  adminChallengesModel: widget.adminChallengesModel,
                ),
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
  const ChallengePredictionBonusListTile({
    super.key,
    required this.adminChallengesModel,
  });

  final AdminChallengesModel adminChallengesModel;

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
          if (adminChallengesModel.usersAnswers == null ||
              (adminChallengesModel.usersAnswers?.isEmpty ?? false))
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
              horizontal: adminChallengesModel.usersAnswers != null ? 30 : 0,
              vertical: adminChallengesModel.usersAnswers != null ? 4 : 0,
            ),
            child: Text(
              adminChallengesModel.usersAnswers == null ||
                      (adminChallengesModel.usersAnswers?.isEmpty ?? false)
                  ? groupsNotifier.predictionBonusValue.toString()
                  : adminChallengesModel.usersAnswers!.first.bonus.toString(),
              style: const TextStyle(
                fontFamily: "Algerian",
              ),
            ),
          ),
          if (adminChallengesModel.usersAnswers == null ||
              (adminChallengesModel.usersAnswers?.isEmpty ?? false))
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

class WinLoseQuestionWidget extends StatelessWidget {
  const WinLoseQuestionWidget({super.key, required this.adminChallengesModel});

  final AdminChallengesModel adminChallengesModel;

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
              adminChallengesModel.match?.homeTeam ?? '',
              adminChallengesModel.match?.awayTeam ?? '',
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

class PredictionResultListTile extends StatelessWidget {
  const PredictionResultListTile({super.key, required this.answer});

  final String answer;

  @override
  Widget build(BuildContext context) {
    final groupsNotifier = Provider.of<GroupNotifier>(context, listen: true);
    return ListTile(
      title: Text(
        answer,
        style: const TextStyle(
          fontFamily: "Algerian",
        ),
      ),
      trailing: DropdownButton(
        items: List.generate(4, (index) {
          return DropdownMenuItem<int>(
            value: index,
            child: Text(
              (index).toString(),
              style: Get.textTheme.titleMedium!.copyWith(
                fontFamily: "Algerian",
                color: index == groupsNotifier.predictionBonusValue
                    ? Colors.blue
                    : Colors.white,
              ),
            ),
          );
        }),
        selectedItemBuilder: (context) {
          return List.generate(4, (index) {
            return DropdownMenuItem<int>(
              value: index,
              child: Text(
                (index).toString(),
                style: Get.textTheme.titleMedium!.copyWith(
                  fontFamily: "Algerian",
                  color: index == groupsNotifier.predictionBonusValue
                      ? Colors.blue
                      : Colors.white,
                ),
              ),
            );
          });
        },
        underline: const SizedBox.shrink(),
        dropdownColor: kColorBackground,
        value: groupsNotifier.predictionBonusValue,
        onChanged: (value) {
          groupsNotifier.setPredictionBonusValue(value ?? 0);
        },
      ),
    );
  }
}
