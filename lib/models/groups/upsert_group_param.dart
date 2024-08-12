class UpsertGroupParam {
  String? id;
  String? name;
  String? description;
  bool? isPrivate;
  int? maxMembers;
  int? leagueId;

  UpsertGroupParam({
    this.id,
    this.name,
    this.description,
    this.isPrivate,
    this.maxMembers,
    this.leagueId,
  });

  UpsertGroupParam.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isPrivate = json['isPrivate'];
    maxMembers = json['maxMembers'];
    leagueId = json['leagueId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['isPrivate'] = isPrivate;
    data['maxMembers'] = maxMembers;
    data['leagueId'] = leagueId;
    return data;
  }
}
