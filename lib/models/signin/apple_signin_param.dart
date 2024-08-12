class AppleSigninParam {
  String? identityToken;
  String? userIdentifier;
  String? email;
  String? familyName;
  String? givenName;

  AppleSigninParam(
      {this.identityToken,
      this.userIdentifier,
      this.email,
      this.familyName,
      this.givenName});

  AppleSigninParam.fromJson(Map<String, dynamic> json) {
    identityToken = json['IdentityToken'];
    userIdentifier = json['UserIdentifier'];
    email = json['Email'];
    familyName = json['FamilyName'];
    givenName = json['GivenName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IdentityToken'] = identityToken;
    data['UserIdentifier'] = userIdentifier;
    data['Email'] = email;
    data['FamilyName'] = familyName;
    data['GivenName'] = givenName;
    return data;
  }
}
