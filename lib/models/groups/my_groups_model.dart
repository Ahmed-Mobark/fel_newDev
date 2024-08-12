import 'package:football_app/models/groups/user_group_model.dart';

class MyGroupModel {
  List<GroupModel>? groups;
  int? count;

  MyGroupModel({this.groups, this.count});

  MyGroupModel.fromJson(Map<String, dynamic> json) {
    if (json['groups'] != null) {
      groups = <GroupModel>[];
      json['groups'].forEach((v) {
        groups!.add(GroupModel.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    return data;
  }
}

class GroupModel {
  String? id;
  String? name;
  String? logo;
  String? leagueLogo;
  String? groupLogo;
  int? maxMembers;
  int? membersCount;
  int? rank;
  bool? isSponsor;
  int? totalPoints;
  int? leagueId;
  String? leagueName;
  String? leagueNameAR;
  String? groupRules;
  String? arGroupRules;
  String? esGroupRules;
  String? poGroupRules;
  Group? group;

  GroupModel({
    this.id,
    this.name,
    this.logo,
    this.isSponsor,
    this.leagueLogo,
    this.leagueName,
    this.groupRules,
    this.arGroupRules,
    this.esGroupRules,
    this.poGroupRules,
    this.leagueNameAR,
    this.maxMembers,
    this.membersCount,
    this.rank,
    this.totalPoints,
    this.groupLogo,
    this.group,
  });

  GroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    isSponsor = json['isSponsor'];
    groupLogo = json['groupLogo'];
    leagueLogo = json['leagueLogo'];
    groupRules = json['groupRules'];
    arGroupRules = json['arGroupRules'];
    esGroupRules = json['esGroupRules'];
    poGroupRules = json['poGroupRules'];
    if (json['league'] != null) leagueName = json['league']["name"];
    if (json['league'] != null) leagueNameAR = json['league']["arName"];
    maxMembers = json['maxMembers'];
    membersCount = json['membersCount'];
    rank = json['rank'];
    totalPoints = json['totalPoints'];
    group = json['group'] != null ? Group.fromJson(json['group']) : null;
    // group = json['group'] != null ? Group.fromJson(json['group']) : null;
    // group = json['group'] != null ? Group.fromJson(json['group']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    data['isSponsor'] = isSponsor;
    data['groupRules'] = groupRules;
    data['arGroupRules'] = arGroupRules;
    data['esGroupRules'] = esGroupRules;
    data['poGroupRules'] = poGroupRules;
    data['leagueLogo'] = leagueLogo;
    data['totalPoints'] = totalPoints;

    data['maxMembers'] = maxMembers;
    data['membersCount'] = membersCount;
    data['league'] = {"name": leagueName, "arName": leagueNameAR};
    data['rank'] = rank;
    if (group != null) {
      data['group'] = group!.toJson();
    }
    return data;
  }
}

class GroupFilter {
  int skip;
  int take;
  String groupName;
  int leagueId;

  GroupFilter({
    required this.skip,
    required this.take,
    required this.groupName,
    required this.leagueId,
  });

  factory GroupFilter.fromJson(Map<String, dynamic> json) {
    return GroupFilter(
      skip: json['skip'] ?? 0,
      take: json['take'] ?? 30,
      groupName: json['groupName'] ?? "",
      leagueId: json['leagueId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skip'] = skip;
    data['take'] = take;
    data['groupName'] = groupName;
    data['leagueId'] = leagueId;
    return data;
  }
}
