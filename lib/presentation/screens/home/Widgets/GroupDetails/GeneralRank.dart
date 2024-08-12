import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../models/groups/group_members.dart';
import '../../../../notifiers/groups_notifer.dart';
import 'GroupCard.dart';

class GeneralRank extends StatefulWidget {
  final String userId; // Pass the current user's ID

  const GeneralRank({
    super.key,
    required this.userId,
  });

  @override
  State<GeneralRank> createState() => _GeneralRankState();
}

class _GeneralRankState extends State<GeneralRank> {
  late ScrollController _scrollController;
  final Map<int, GlobalKey> _itemKeys = {}; // Keys for each list item

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

  void _scrollToIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _itemKeys[index];
      if (key != null && key.currentContext != null) {
        final context = key.currentContext!;
        final position = context.findRenderObject() as RenderBox?;
        if (position != null) {
          final itemOffset = position.localToGlobal(Offset.zero).dy;
          final scrollOffset =
              _scrollController.hasClients ? _scrollController.offset : 0;

          print(
            'Scrolling to index $index, itemOffset: $itemOffset, scrollOffset: $scrollOffset',
          );

          _scrollController.animateTo(
            itemOffset - scrollOffset,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          print('RenderBox for index $index is null');
        }
      } else {
        print('Key for index $index is null or currentContext is null');
      }
    });
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
      int userRankIndex =
          groupNotifier.groupMembers.reversed.toList().indexWhere(
                (groupMember) => groupMember.userId == widget.userId,
              );

      // Calculate the correct index in the reversed list
      int displayIndex = groupNotifier.groupMembers.length - userRankIndex - 1;

      GroupsMembersModel? userGroupMember;
      if (userRankIndex != -1) {
        userGroupMember = groupNotifier.groupMembers[
            groupNotifier.groupMembers.length - userRankIndex - 1];
      }

      return Column(
        children: [
          if (userGroupMember != null) ...[
            const Divider(),

            GestureDetector(
              // onTap: () {
              //   if (userRankIndex != -1) {
              //     _scrollToIndex(displayIndex);
              //   }
              // },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Get.locale.toString() == 'ar'
                        ? 'ترتيبك العام : '
                        : Get.locale.toString() == 'en'
                            ? 'Your general ranking : '
                            : Get.locale.toString() == 'es'
                                ? 'Su ranking general : '
                                : 'Sua classificação geral : ', // Display actual rank
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
              itemCount: groupNotifier.groupMembers.length,
              itemBuilder: (context, index) {
                _itemKeys[index] = GlobalKey(); // Assign a unique key
                GroupsMembersModel groupMember = groupNotifier.groupMembers[
                    groupNotifier.groupMembers.length - index - 1];
                return GroupDetailsCard(
                  key: _itemKeys[index], // Use the key here
                  groupMember: groupMember,
                  isGeneralRank: true,
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
