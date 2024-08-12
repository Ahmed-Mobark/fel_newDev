import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../models/groups/group_members.dart';
import '../../../../notifiers/groups_notifer.dart';
import 'GroupCard.dart';

class RoundRank extends StatefulWidget {
  final String myUserId;

  const RoundRank({
    super.key,
    required this.myUserId,
  });

  @override
  _RoundRankState createState() => _RoundRankState();
}

class _RoundRankState extends State<RoundRank> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupNotifier = Provider.of<GroupNotifier>(context, listen: true);

    if (groupNotifier.matchesLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // Find the index of the user in the list
      int userRankIndex = groupNotifier.roundGroupMembers.indexWhere(
        (groupMember) => groupMember.userId == widget.myUserId,
      );

      GroupsMembersModel? userGroupMember;
      if (userRankIndex != -1) {
        userGroupMember = groupNotifier.roundGroupMembers[userRankIndex];
      }

      return Column(
        children: [
          if (userGroupMember != null) ...[
            const Divider(), // Divider between the rank and the list

            GestureDetector(
              // onTap: () {
              //   if (userRankIndex != -1) {
              //     _scrollController.animateTo(
              //       userRankIndex * 120.0, // Adjust based on item height
              //       duration: const Duration(milliseconds: 500),
              //       curve: Curves.easeInOut,
              //     );
              //   }
              // },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Get.locale.toString() == 'ar'
                        ? 'ترتيبك في الجولة : '
                        : Get.locale.toString() == 'en'
                            ? 'Your ranking in the round : '
                            : Get.locale.toString() == 'es'
                                ? 'Tu clasificación en la ronda : '
                                : 'Sua classificação na rodada : ',
                    style:
                        const TextStyle(fontSize: 12, fontFamily: "Algerian"),
                  ),
                  Container(
                    padding: EdgeInsets.all(1.5.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${userRankIndex + 1}',
                      style: TextStyle(fontSize: 3.5.w),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  const Icon(
                    FontAwesomeIcons.trophy,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
            const Divider(), // Divider between the rank and the list
          ],
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: groupNotifier.roundGroupMembers.length,
              itemBuilder: (context, index) {
                GroupsMembersModel groupMember =
                    groupNotifier.roundGroupMembers[index];
                return GroupDetailsCard(
                  groupMember: groupMember,
                  isGeneralRank: false,
                  index: index,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 0),
            ),
          ),
        ],
      );
    }
  }
}
