import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/helpers.dart';
import '../../../../../models/groups/group_members.dart';
import '../../../../notifiers/home_notifier.dart';

class GroupDetailsCard extends StatelessWidget {
  final GroupsMembersModel groupMember;
  final bool isGeneralRank;
  final int index;
  const GroupDetailsCard({
    required this.groupMember,
    required this.index,
    required this.isGeneralRank,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homeNotifier = Provider.of<HomeNotifier>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(color: kColorCard),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.black.withOpacity(.4),
                          backgroundImage: Image.network(
                            groupMember.user?.profilePhoto ??
                                homeNotifier.mainPageModel.groupHLImage!,
                          ).image,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "${groupMember.user?.firstName ?? ""} ${groupMember.user?.lastName ?? ""}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Algerian',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${tr("Points")}:${isGeneralRank ? groupMember.totalPoints ?? "" : groupMember.roundPoints ?? ""}",
                                style: TextStyle(
                                  fontFamily: "Algerian",
                                  fontWeight: FontWeight.w100,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (index < 3)
                        const Icon(
                          FontAwesomeIcons.trophy,
                          color: Colors.amber,
                        ),
                      if (index < 3) const SizedBox(width: 10),
                      Container(
                        height: 50,
                        width: 50,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Center(
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(fontFamily: 'Algerian'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
