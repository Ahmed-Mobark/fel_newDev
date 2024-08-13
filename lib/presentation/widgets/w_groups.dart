import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:football_app/helpers/extensions.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/models/groups/group_matches_model.dart';
import 'package:football_app/models/groups/user_group_model.dart';
import 'package:football_app/presentation/notifiers/groups_notifer.dart';
import 'package:football_app/presentation/screens/groups/group_challenge_details_screen.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GroupChallengesCard extends StatelessWidget {
  const GroupChallengesCard({
    required this.groupMatchModel,
    this.groupId,
    this.group,
    this.notClickable = false,
    super.key,
  });

  final bool notClickable;
  final GroupMatchesModel groupMatchModel;
  final String? groupId;
  final UserGroupModel? group;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: notClickable
          ? null
          : () => Get.to(
                () => GroupChallengeDetailsScreen(
                  challengeModel: groupMatchModel,
                  groupId: groupId,
                  group: group,
                  fromChallenges: true,
                ),
              ),
      child: Container(
        // height: 15.h,
        margin:
            const EdgeInsetsDirectional.symmetric(vertical: 6, horizontal: 8),
        padding:
            const EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 25, 25, 25),
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              GroupMatchesModel.toColor(groupMatchModel.homeColor!),
              // Colors.yellow,
              const Color.fromARGB(255, 25, 25, 25),
              GroupMatchesModel.toColor(groupMatchModel.awayColor!),
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
                  name: groupMatchModel.homeTeam ?? '',
                  imageUrl: groupMatchModel.homeLogo ?? '',
                ),
                const Spacer(),
                Text(
                  groupMatchModel.homeGoals == null
                      ? ''
                      : groupMatchModel.homeGoals.toString(),
                  style: const TextStyle(fontFamily: 'Algerian'),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        groupMatchModel.status.toString(),
                        style: TextStyle(
                          fontFamily: "Algerian",
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 10.sp,
                        ),
                        textAlign: TextAlign.center,
                      ).tr(),
                      SizedBox(height: 1.h),
                      Text(
                        DateFormat.Hm("en").format(
                          DateFormat("yyyy-MM-ddTHH:mm:ssZ", 'en')
                              .parseUTC(groupMatchModel.startDate ?? "")
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
                          Icon(
                            Ionicons.clipboard_outline,
                            color: kColorAccent,
                          ),
                          groupMatchModel.predictions?.isEmpty ?? false
                              ? Icon(
                                  Icons.horizontal_rule,
                                  color: kColorAccent,
                                )
                              : groupMatchModel.predictions?.isNotEmpty ?? false
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 1.w,
                                        ),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          gradient: LinearGradient(
                                            begin:
                                                AlignmentDirectional.topStart,
                                            end: AlignmentDirectional.bottomEnd,
                                            colors: [
                                              GroupMatchesModel.toColor(
                                                groupMatchModel.homeColor!,
                                              ),
                                              // Colors.yellow,
                                              const Color.fromARGB(
                                                255,
                                                25,
                                                25,
                                                25,
                                              ),
                                              GroupMatchesModel.toColor(
                                                groupMatchModel.awayColor!,
                                              ),
                                            ],
                                          ),
                                        ),
                                        child: Text(
                                          '${groupMatchModel.predictions?.first.homeGoals} / ${groupMatchModel.predictions?.first.awayGoals}',
                                          style: Get.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontFamily: "Algerian",
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                          if (groupMatchModel.predictions == null ||
                              (groupMatchModel.predictions?.isEmpty ?? false))
                            const SizedBox(width: 20)
                          else if ((groupMatchModel.predictions!.first.bonus ??
                                  0) >
                              0)
                            Text(
                              "x${groupMatchModel.predictions!.first.bonus}",
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
                  groupMatchModel.awayGoals == null
                      ? ''
                      : groupMatchModel.awayGoals.toString(),
                ),
                const Spacer(),
                team(
                  name: groupMatchModel.awayTeam ?? '',
                  imageUrl: groupMatchModel.awayLogo ?? '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
          const SizedBox(
            height: 8,
          ),
          Text(
            name,
            style: Get.textTheme.headlineSmall?.copyWith(
              fontFamily: "Algerian",
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class GroupChallengesRail extends StatelessWidget {
  const GroupChallengesRail({
    required this.challenges,
    this.groupId,
    this.group,
    this.notClickable = false,
    super.key,
  });

  final bool notClickable;
  final List<GroupMatchesModel>? challenges;
  final String? groupId;
  final UserGroupModel? group;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: challenges?.length ?? 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return HorizontalAnimation(
          duration: 250 * (index + 3),
          child: GroupChallengesCard(
            notClickable: notClickable,
            groupMatchModel: challenges![index],
            groupId: groupId,
            group: group,
          ),
        );
      },
    );
  }
}

class GroupMatches extends StatelessWidget {
  const GroupMatches({
    super.key,
    this.groupId,
    this.notClickable = false,
    this.group,
  });

  final bool notClickable;
  final String? groupId;
  final UserGroupModel? group;

  @override
  Widget build(BuildContext context) {
    // Listening to changes in the matchesLoading state
    final groupNotifier = Provider.of<GroupNotifier>(context);

    // Group matches by start date outside the build method
    final groupedMatches = _groupByStartDate(
      groupNotifier.groupsMatchesModel,
    );

    if (groupNotifier.matchesLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.separated(
        padding: EdgeInsets.only(top: 3.w),
        primary: true,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: groupedMatches.length,
        itemBuilder: (context, index) {
          final dayMatches = groupedMatches[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                child: HorizontalAnimation(
                  duration: 250 * (index + 3),
                  child: Text(
                    dayMatches[0].startDate!.convertToCustomDateFormat(),
                    style: Get.textTheme.displaySmall?.copyWith(
                      fontFamily: "Algerian",
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              GroupChallengesRail(
                notClickable: notClickable,
                challenges: groupedMatches[index],
                groupId: groupId,
                group: group,
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 4.h),
      );
    }
  }

  // This method does not trigger any state changes and is safe to call in build
  List<List<GroupMatchesModel>> _groupByStartDate(
    List<GroupMatchesModel> matches,
  ) {
    final Map<DateTime, List<GroupMatchesModel>> groupedMatches = {};

    for (final match in matches) {
      final startDate = match.stringToDate(match.startDate ?? '');
      if (!groupedMatches.containsKey(startDate)) {
        groupedMatches[startDate] = [];
      }
      groupedMatches[startDate]!.add(match);
    }
    final List<List<GroupMatchesModel>> result = groupedMatches.values.toList();

    return result;
  }
}
