import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:football_app/data_layer/api/api_provider.dart';
import 'package:football_app/main.dart';
import 'package:football_app/models/groups/answerofchallengeparam.dart';
import 'package:football_app/models/groups/explore_groups_model.dart';
import 'package:football_app/models/groups/get_group_by_id_model.dart';
import 'package:football_app/models/groups/group_matches_model.dart';
import 'package:football_app/models/groups/group_members.dart';
import 'package:football_app/models/groups/join_group_model.dart';
import 'package:football_app/models/groups/join_private_group_model.dart';
import 'package:football_app/models/groups/my_groups_model.dart';
import 'package:football_app/models/groups/predict_group_match_param.dart';
import 'package:football_app/models/groups/upsert_group_param.dart';
import 'package:football_app/models/groups/user_group_model.dart';
import 'package:football_app/models/groups/user_groups_ids_model.dart';
import 'package:get/get.dart';

import '../widgets/widgets.dart';

class GroupNotifier extends ChangeNotifier {
  GroupFilter myGroupFilter = GroupFilter.fromJson({});
  GroupFilter groupsFilter = GroupFilter.fromJson({});
  ScrollController myGroupController = ScrollController();
  ScrollController allGroupController = ScrollController();
  TextEditingController textEditingMyGroupController = TextEditingController();
  TextEditingController textEditingGroupsController = TextEditingController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Map userGroupIDS = {};
  void copyGroupCodeToClipboard(String id) {
    Clipboard.setData(ClipboardData(text: id)).then((_) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Copied Group Code to clipboard'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text('Error copying to clipboard: $error'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  bool _isLoadingExplore = false;
  bool get isLoadingExplore => _isLoadingExplore;
  int groupExploreSkip = 1;
  bool firstHitExplore = true;
  bool loadMoreExplore = true;
  setExploreLoadMore(bool newValue) {
    loadMoreExplore = newValue;
    notifyListeners();
  }

  increaseExploreSkip() {
    groupExploreSkip = groupExploreSkip + 1;
    notifyListeners();
  }

  resetExploreSkip() {
    groupExploreSkip = 1;
  }

  bool stopExploreLoading = false;
  setExploreStopLoading(bool newValue) {
    stopExploreLoading = newValue;
  }

  List<GroupModel> exploreGroupsList = [];

  getExploreGroups(GroupFilter groupFilter) async {
    try {
      setExploreLoadMore(true);
      if (firstHitExplore == true) {
        exploreGroupsList.clear();
      }
      _isLoadingExplore = true;

      await ApiProvider(httpClient: Dio())
          .getExploreGroups(groupFilter)
          .then((ExploreGroupModel value) {
        _isLoadingExplore = false;
        if (value.data != null) {
          exploreGroupsList.addAll(value.data!);
          log("exploreList>>>${exploreGroupsList.toString()}");
          firstHitExplore = false;
          setExploreLoadMore(false);
          if (value.data!.isEmpty) {
            setExploreLoadMore(false);
          }
        }
      });
      setExploreLoadMore(false);
    } catch (e) {
      _isLoadingExplore = false;
      setExploreLoadMore(false);
      notifyListeners();
    }
  }

  leaveGroup(String groupid) async {
    try {
      _isLoadingExplore = true;
      await ApiProvider(httpClient: Dio()).leaveGroups(groupid);
      myGroupFilter.skip = 0;
      getUserGroups();
    } catch (e) {
      _isLoadingExplore = false;
      notifyListeners();
    }
  }

  getDetailedGroup(String groupid) async {
    try {
      _isLoadingExplore = true;
      await ApiProvider(httpClient: Dio()).leaveGroups(groupid);
      myGroupFilter.skip = 0;
      getUserGroups();
    } catch (e) {
      _isLoadingExplore = false;
      notifyListeners();
    }
  }

  //get group by id
  bool _getGroupByIdLoading = false;
  bool get getGroupByIdLoading => _getGroupByIdLoading;

  GetGroupByIdModel groupByIdModel = GetGroupByIdModel();
  getGroupById(String id) async {
    try {
      _getGroupByIdLoading = true;
      notifyListeners();
      await ApiProvider(httpClient: Dio()).getGroupById(id).then((value) {
        groupByIdModel = value;
        _getGroupByIdLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _getGroupByIdLoading = false;
      notifyListeners();
    }
  }

  //get group members
  bool _membersLoading = false;
  bool get membersLoading => _membersLoading;

  List<GroupsMembersModel> groupMembers = [];
  List<GroupsMembersModel> roundGroupMembers = [];
  getGroupMembers(String id) async {
    try {
      _membersLoading = true;
      groupMembers = await ApiProvider(httpClient: Dio()).getGroupMembers(id);
      _membersLoading = false;
      notifyListeners();
    } catch (e) {
      _membersLoading = false;
      notifyListeners();
    }
  }

  getRoundGroupMembers(String id) async {
    try {
      _membersLoading = true;

      roundGroupMembers =
          await ApiProvider(httpClient: Dio()).getGroupRoundMembers(id);
      // _membersLoading = false;
      notifyListeners();
    } catch (e) {
      _membersLoading = false;
      notifyListeners();
    }
  }

  List<UserGroupModel> userGroups = [];
  bool _userGroupsLoading = true;
  bool get userGroupsLoading => _userGroupsLoading;
  getUserGroups() async {
    _userGroupsLoading = true;
    notifyListeners(); // Notify here before the async operation begins.

    try {
      userGroups =
          await ApiProvider(httpClient: Dio()).getUserGroups(myGroupFilter);
      userGroups.map((e) => log(e.group.toString()));
    } catch (e) {
      // Handle error
    } finally {
      _userGroupsLoading = false;

      // Delay state change until after the build completes.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  setGroupPicture(int groupIndex, String imageUrl) async {
    userGroups[groupIndex].group!.logo = imageUrl;
    notifyListeners();
  }

  userGroupsearchFilterChange(String newValue) async {
    myGroupFilter.groupName = newValue;
    myGroupFilter.skip = 0;
    _userGroupsLoading = true;
    notifyListeners();
    try {
      userGroups =
          await ApiProvider(httpClient: Dio()).getUserGroups(myGroupFilter);
      _userGroupsLoading = false;
      notifyListeners();
    } catch (e) {
      _userGroupsLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  changeUserGroub(String groubId, id) async {
    log(groubId);
    try {
      _isLoading = true;
      notifyListeners();

      await ApiProvider(httpClient: Dio())
          .changeGroub(groubId, id)
          .then((value) async {
        // if (value.statusCode == 200 || value.statusCode == 201) {}
        _isLoading = false;

        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  allGroupsearchFilterChange(String newValue) async {
    groupsFilter.groupName = newValue;
    groupsFilter.skip = 0;
    setExploreLoadMore(true);
    notifyListeners();
    try {
      exploreGroupsList =
          (await ApiProvider(httpClient: Dio()).getExploreGroups(groupsFilter))
              .data!;
      setExploreLoadMore(false);
      notifyListeners();
    } catch (e) {
      setExploreLoadMore(false);
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> updateUserGroupsData() async {
    if (userGroups.length > myGroupFilter.skip + 29 &&
        myGroupController.offset >
            myGroupController.position.maxScrollExtent - 50) {
      myGroupFilter.skip = userGroups.length;
      List<UserGroupModel> restOfItems =
          await ApiProvider(httpClient: Dio()).getUserGroups(myGroupFilter);
      userGroups.addAll(restOfItems);
    }
    notifyListeners();
  }

  Future<void> updateAllGroupsData() async {
    setExploreLoadMore(true);
    if (exploreGroupsList.length > groupsFilter.skip + 29 &&
        allGroupController.offset >
            allGroupController.position.maxScrollExtent - 30) {
      groupsFilter.skip = exploreGroupsList.length;
      ExploreGroupModel restOfItems =
          await ApiProvider(httpClient: Dio()).getExploreGroups(groupsFilter);
      exploreGroupsList.addAll(restOfItems.data ?? []);

      notifyListeners();
    }

    setExploreLoadMore(false);
  }

  // getUserGroupsIds
  List<UserGroupIdsModel> userGroupIds = [];
  bool get getUserGroupsIdsLoading => _getUserGroupsIdsLoading;
  bool _getUserGroupsIdsLoading = false;
  getUserGroupsIds() async {
    try {
      _getUserGroupsIdsLoading = true;
      notifyListeners();
      userGroupIds = await ApiProvider(httpClient: Dio()).getUserGroupsIds();
      _getUserGroupsIdsLoading = false;
      notifyListeners();
    } catch (e) {
      _getUserGroupsIdsLoading = false;
      notifyListeners();
    }
  }

  // join group
  bool _joinGroupLoading = false;
  bool get joinGroupLoading => _joinGroupLoading;

  JoinGroupModel joinGroupModel = JoinGroupModel();
  joinGroup(String groupId) async {
    try {
      _joinGroupLoading = true;
      await ApiProvider(httpClient: Dio()).joinGroup(groupId).then(
        (value) {
          //omar
          //joinGroupModel = value;
          _joinGroupLoading = false;
          getAllUserGroups();
        },
      );
    } catch (e) {
      _joinGroupLoading = false;
      notifyListeners();
    }
  }

  getAllUserGroups() async {
    try {
      _joinGroupLoading = true;
      notifyListeners();
      List userGroupIDSList =
          await ApiProvider(httpClient: Dio()).getAllUserGroups();
      userGroupIDS = {};
      for (var element in userGroupIDSList) {
        userGroupIDS[element["groupId"]] = true;
      }
      _joinGroupLoading = false;
      notifyListeners();
    } catch (e) {
      _joinGroupLoading = false;
      notifyListeners();
    }
  }

  // join private group
  bool _joinPrivateGroupLoading = false;
  bool get joinPrivateGroupLoading => _joinPrivateGroupLoading;
  var groupCodeController = TextEditingController();
  JoinPrivateGroupModel joinPrivateGroupModel = JoinPrivateGroupModel();
  joinPrivateGroup(String groupCode) async {
    try {
      _joinPrivateGroupLoading = true;
      await ApiProvider(httpClient: Dio()).joinPrivateGroup(groupCode).then(
        (value) {
          //joinPrivateGroupModel = value;
          _joinPrivateGroupLoading = false;
          groupCodeController.clear();
          notifyListeners();
        },
      );
    } catch (e) {
      _joinPrivateGroupLoading = false;
      groupCodeController.clear();
      notifyListeners();
    }
  }

  // Upsert Group
  bool _upsertGroupLoading = false;
  bool get upsertGroupLoading => _upsertGroupLoading;

  final createGroupFormKey = GlobalKey<FormState>();

  var groupNameController = TextEditingController();
  var groupDescriptionController = TextEditingController();
  var groupMaxMembersController = TextEditingController();
  int? leagueId = 307;
  bool? isGroupPrivate = false;
  String leagueName = '';
  String arleagueName = '';
  int? leagueIdForGroupScreen = 0;
  String leagueNameForGroupScreen = '';
  String arleagueNameForGroupScreen = '';

  void setLeagueId(int? value) {
    leagueId = value ?? 0;
    notifyListeners();
  }

  void setLeagueName(String? value, String? arValue) {
    leagueName = value ?? '';
    arleagueName = arValue ?? '';
    notifyListeners();
  }

  void setLeagueIdForGroupScreen(int? value) {
    leagueIdForGroupScreen = value ?? 0;
    notifyListeners();
  }

  void setLeagueNameForGroupScreen(String? value, String? arValue) {
    leagueNameForGroupScreen = value ?? '';
    arleagueNameForGroupScreen = arValue ?? '';
    notifyListeners();
  }

  String? validateGroupName(String? value) {
    if (value!.isEmpty) {
      return tr('This field cannot be empty');
    }
    if (value.length >= 20) {
      return tr('Too long');
    }
    return null;
  }

  String? validateGroupDescription(String? value) {
    if (value!.isEmpty) {
      return tr('This field cannot be empty');
    }
    return null;
  }

  String? validateGroupMembersCount(String? value) {
    // if (value!.isEmpty) {
    //   return tr('This field cannot be empty');
    // }
    // if (value == '0') {
    //   return 'Cannot be zero';
    // }
    // if (value.length > 2) {
    //   return 'Count can be from 1 - 99';
    // }
    return null;
  }

  void setIsGroupPrivate(bool? value) {
    isGroupPrivate = value;
    notifyListeners();
  }

  clearCreateGroupControllers() {
    groupNameController.clear();
    groupDescriptionController.clear();
    groupMaxMembersController.clear();
  }

  upsertGroup(UpsertGroupParam param) async {
    try {
      _upsertGroupLoading = true;
      notifyListeners();
      bool isGroupAdded =
          await ApiProvider(httpClient: Dio()).upsertGroup(param);
      _upsertGroupLoading = false;
      notifyListeners();
      if (isGroupAdded) {
        clearCreateGroupControllers();
        Get.back();
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          successSnackBar('Group created successfully'),
        );
      }
    } catch (e) {
      // clearCreateGroupControllers();
      _upsertGroupLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.toString()),
      );

      // Get.back();
    }
  }

  //get group matches
  List<GroupMatchesModel> groupsMatchesModel = [];
  bool _matchesLoading = false;
  bool get matchesLoading => _matchesLoading;
  groupMatches(String groupId) async {
    try {
      _matchesLoading = true;
      await ApiProvider(httpClient: Dio())
          .getGroupMatches(groupId)
          .then((value) {
        groupsMatchesModel = value;
        _matchesLoading = false;

        notifyListeners();
      });
    } catch (e) {
      _matchesLoading = false;
      notifyListeners();
    }
  }

  bool _predictMatchLoading = false;
  bool get predictMatchLoading => _predictMatchLoading;

  int predictionBonusValue = 0;
  int predictionhomegoalValue = 0;
  int predictionawaygoalValue = 0;

  resetValues() {
    predictionBonusValue = 0;
    predictionhomegoalValue = 0;
    predictionawaygoalValue = 0;

    notifyListeners();
  }

  Map answersofquetions = {};
  List<String> answersList = [];
  void setList() {
    answersList = List.generate(
      answersofquetions.length,
      (index) => answersofquetions[index],
    );
    notifyListeners();
  }

  void setPredictionBonusValue(int value) {
    predictionBonusValue = value;
    notifyListeners();
  }

  void setpredictionhomegoalValue(int value) {
    predictionhomegoalValue = value;
    notifyListeners();
  }

  void setpredictionawaygoalValue(int value) {
    predictionhomegoalValue = value;
    notifyListeners();
  }

  int predictionChosenAnswer = 0;

  void setPredictionChosenAnswer(int? value) {
    predictionChosenAnswer = value ?? 0;
    notifyListeners();
  }

  predictGroupMatch(PredictGroupMatchParam param) async {
    try {
      _predictMatchLoading = true;
      await ApiProvider(httpClient: Dio())
          .predictGroupMatch(param)
          .then((value) {
        _predictMatchLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _predictMatchLoading = false;
      notifyListeners();
    }
  }

  int challengesPageIndex = 0;

  void setChallengesPageIndex(int value) {
    challengesPageIndex = value;
    notifyListeners();
  }

  MyGroupModel? myGroups;
  bool _myGroupsLoading = false;
  bool get myGroupsLoading => _myGroupsLoading;
  getMyGroups() async {
    try {
      _myGroupsLoading = true;
      await ApiProvider(httpClient: Dio()).getMyGroups().then((value) {
        myGroups = value;
        _myGroupsLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _myGroupsLoading = false;
      notifyListeners();
    }
  }

  bool _challengeLoading = false;
  bool get challengeLoading => _challengeLoading;
  answerChallenge(
    AnswersofchallengeParam param, {
    bool fromChallenges = false,
    GroupMatchesModel? groupMatchModel,
    UserGroupModel? userGroupModel,
  }) async {
    try {
      _challengeLoading = true;
      notifyListeners();

      await ApiProvider(httpClient: Dio())
          .answerChallenge(
        param,
        fromChallenges: fromChallenges,
        groupMatchModel: groupMatchModel,
        userGroupModel: userGroupModel,
      )
          .then((value) async {
        if (value) {
          await groupMatches(param.groupId ?? '');
          Navigator.pop(navigatorKey.currentContext!);
          predictionhomegoalValue = 0;
          predictionawaygoalValue = 0;
          predictionBonusValue = 0;
        }
        _challengeLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _challengeLoading = false;
      notifyListeners();
    }
  }
}
