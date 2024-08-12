class UpdateProfileParam {
  String? firstName;
  String? lastName;
  String? userName;
  String? birthDate;
  String? shirtName;
  int? shirtNumber;
  int? gender;
  int? countryId;

  UpdateProfileParam({
    this.firstName,
    this.lastName,
    this.userName,
    this.birthDate,
    this.shirtNumber,
    this.gender,
    this.shirtName,
    this.countryId,
  });

  UpdateProfileParam.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    userName = json['userName'];
    birthDate = json['birthDate'];
    shirtNumber = json['shirtNumber'];
    gender = json['gender'];
    shirtName = json['shirtName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['userName'] = userName;
    data['birthDate'] = birthDate;
    data['shirtNumber'] = shirtNumber;
    data['gender'] = gender;
    data['shirtName'] = shirtName;
    return data;
  }
}
