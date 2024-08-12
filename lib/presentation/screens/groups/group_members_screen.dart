import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/presentation/notifiers/groups_notifer.dart';
import 'package:provider/provider.dart';

class GroupMembersScreen extends StatefulWidget {
  const GroupMembersScreen({
    super.key,
    required this.groupId,
  });
  final String groupId;
  @override
  State<GroupMembersScreen> createState() => _GroupMembersScreenState();
}

class _GroupMembersScreenState extends State<GroupMembersScreen> {
  GroupNotifier? _groupNotifier;
  @override
  void initState() {
    _groupNotifier = Provider.of<GroupNotifier>(context, listen: false);
    _groupNotifier?.getGroupMembers(widget.groupId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GroupNotifier groupNotifier =
        Provider.of<GroupNotifier>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Members',
          style: TextStyle(
            fontFamily: "Algerian",
          ),
        ).tr(),
      ),
      body: groupNotifier.membersLoading
          ? const Center(child: CircularProgressIndicator())
          : groupNotifier.groupMembers.isEmpty
              ? const Center(
                  child: Text('no members yet'),
                )
              : ListView.builder(
                  itemCount: groupNotifier.groupMembers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: groupNotifier
                                    .groupMembers[index].user?.profilePhoto ==
                                ''
                            ? const CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/Unknown.jpeg',
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(
                                  groupNotifier.groupMembers[index].user
                                          ?.profilePhoto ??
                                      '',
                                ),
                              ),
                      ),
                      title: Text(
                        groupNotifier.groupMembers[index].username ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Algerian",
                        ),
                      ),
                      trailing: const CupertinoListTileChevron(),
                    );
                  },
                ),
    );
  }
}
