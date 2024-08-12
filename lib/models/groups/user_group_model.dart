class UserGroupModel {
  String? id;
  String? username;
  int? totalPoints;
  int? totalRight;
  int? totalWrong;
  int? groupBonus;
  String? userId;
  String? groupId;
  Group? group;

  UserGroupModel({
    this.id,
    this.username,
    this.totalPoints,
    this.totalRight,
    this.totalWrong,
    this.groupBonus,
    this.userId,
    this.groupId,
    this.group,
  });

  static List<UserGroupModel> fromUserGroupJsonToUserGroupModel(List json) {
    List<UserGroupModel> data = [];
    for (var element in json) {
      data.add(UserGroupModel.fromJson(element));
    }
    return data;
  }

  factory UserGroupModel.fromJson(Map<String, dynamic> json) {
    return UserGroupModel(
      id: json['id'].toString(),
      username: json['username'],
      totalPoints: json['totalPoints'],
      totalRight: json['totalRight'],
      totalWrong: json['totalWrong'],
      groupBonus: json['groupBonus'],
      userId: json['userId'].toString(),
      groupId: json['groupId'].toString(),
      group: json['group'] != null ? Group.fromJson(json['group']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['totalPoints'] = totalPoints;
    data['totalRight'] = totalRight;
    data['totalWrong'] = totalWrong;
    data['groupBonus'] = groupBonus;
    data['userId'] = userId;
    data['groupId'] = groupId;
    if (group != null) {
      data['group'] = group!.toJson();
    }
    return data;
  }
}

class Group {
  String? id;
  String? name;
  String? description;
  String? logo;
  String? leagueLogo;
  String? groupLogo;
  bool? isPrivate;
  String? password;
  int? maxMembers;
  bool? isFull;
  bool? isGroupLeagueActive;
  int? membersCount;
  String? groupRules;
  String? arGroupRules;
  String? esGroupRules;
  String? poGroupRules;
  bool? isSponsor;
  int? leagueId;
  String? adminId;

  Group({
    this.id,
    this.name,
    this.description,
    this.logo,
    this.leagueLogo,
    this.isPrivate,
    this.groupRules,
    this.arGroupRules,
    this.esGroupRules,
    this.poGroupRules,
    this.isGroupLeagueActive,
    this.password,
    this.maxMembers,
    this.isFull,
    this.groupLogo,
    this.membersCount,
    this.isSponsor,
    this.leagueId,
    this.adminId,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'].toString(),
      name: json['name'].toString(),
      description: json['description'].toString(),
      logo: json['logo'],
      groupRules: json['groupRules'],
      arGroupRules: json['arGroupRules'],
      esGroupRules: json['esGroupRules'],
      poGroupRules: json['poGroupRules'],
      groupLogo: json['groupLogo'],
      leagueLogo: json['leagueLogo'],
      isPrivate: json['isPrivate'],
      password: json['password'].toString(),
      maxMembers: json['maxMembers'],
      isFull: json['isFull'],
      isGroupLeagueActive: json['isGroupLeagueActive'],
      membersCount: json['membersCount'],
      isSponsor: json['isSponsor'],
      leagueId: json['leagueId'],
      adminId: json['adminId'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['logo'] = logo;
    data['leagueLogo'] = leagueLogo;
    data['groupRules'] = groupRules;
    data['arGroupRules'] = arGroupRules;
    data['esGroupRules'] = esGroupRules;
    data['poGroupRules'] = poGroupRules;
    data['isPrivate'] = isPrivate;
    data['password'] = password;
    data['maxMembers'] = maxMembers;
    data['isFull'] = isFull;
    data['isGroupLeagueActive'] = isGroupLeagueActive;
    data['membersCount'] = membersCount;
    data['isSponsor'] = isSponsor;
    data['leagueId'] = leagueId;
    data['adminId'] = adminId;
    return data;
  }
}
