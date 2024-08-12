class JoinGroupModel {
  String? id;
  String? name;
  String? description;
  String? logo;
  bool? isPrivate;
  String? password;
  int? maxMembers;
  bool? isFull;
  int? membersCount;
  bool? isSponsor;
  int? leagueId;
  String? adminId;
  List<dynamic>? users;

  JoinGroupModel({
    this.id,
    this.name,
    this.description,
    this.logo,
    this.isPrivate,
    this.password,
    this.maxMembers,
    this.isFull,
    this.membersCount,
    this.isSponsor,
    this.leagueId,
    this.adminId,
    this.users,
  });

  JoinGroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    logo = json['logo'];
    isPrivate = json['isPrivate'];
    password = json['password'];
    maxMembers = json['maxMembers'];
    isFull = json['isFull'];
    membersCount = json['membersCount'];
    isSponsor = json['isSponsor'];
    leagueId = json['leagueId'];
    adminId = json['adminId'];
    users = json['users'];
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
    data['isSponsor'] = isSponsor;
    data['leagueId'] = leagueId;
    data['adminId'] = adminId;
    data['users'] = users;
    return data;
  }
}
