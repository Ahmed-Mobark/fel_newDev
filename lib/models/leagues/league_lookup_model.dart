class LeagueLookupModel {
  int? id;
  String? name;
  String? arName;
  String? logo;

  LeagueLookupModel({this.id, this.name, this.arName, this.logo});

  LeagueLookupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['arName'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['arName'] = arName;
    data['logo'] = logo;
    return data;
  }
}
