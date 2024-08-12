class GetGroupByIdModel {
  String? id;
  String? name;
  String? description;
  String? logo;
  String? groupLogo;
  bool? isPrivate;
  String? password;
  int? maxMembers;
  bool? isFull;
  int? membersCount;
  int? rank;
  int? totalPoints;
  bool? isSponsor;
  int? leagueId;
  String? adminId;

  GetGroupByIdModel({
    this.id,
    this.name,
    this.description,
    this.logo,
    this.isPrivate,
    this.password,
    this.maxMembers,
    this.isFull,
    this.membersCount,
    this.rank,
    this.totalPoints,
    this.isSponsor,
    this.leagueId,
    this.groupLogo,
    this.adminId,
  });

  GetGroupByIdModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    logo = json['logo'];
    groupLogo = json['groupLogo'];
    isPrivate = json['isPrivate'];
    password = json['password'];
    maxMembers = json['maxMembers'];
    isFull = json['isFull'];
    membersCount = json['membersCount'];
    rank = json['rank'];
    totalPoints = json['totalPoints'];
    isSponsor = json['isSponsor'];
    leagueId = json['leagueId'];
    adminId = json['adminId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['logo'] = logo;
    data['isPrivate'] = isPrivate;
    data['password'] = password;
    data['maxMembers'] = maxMembers;
    data['isFull'] = isFull;
    data['membersCount'] = membersCount;
    data['rank'] = rank;
    data['totalPoints'] = totalPoints;
    data['isSponsor'] = isSponsor;
    data['leagueId'] = leagueId;
    data['adminId'] = adminId;
    return data;
  }
}
