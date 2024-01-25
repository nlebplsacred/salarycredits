class PersonalReferenceBaseModel {
  PersonalReferenceBaseModel();

  int _applicationId = 0;
  List<PersonalReferenceModel> _personalRef = [];

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  List<PersonalReferenceModel> get getPersonalRef => _personalRef;

  set setPersonalRef(List<PersonalReferenceModel> value) {
    _personalRef = value;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicationId'] = _applicationId;
    data['personalRef'] = _personalRef.map((v) => v.toJson()).toList();
    return data;
  }
}

class PersonalReferenceModel {
  PersonalReferenceModel();

  int _applicationId = 0;
  String _name = "";
  String _mobile = "";
  String _emailId = "";
  int _relationId = 0;

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  String get getName => _name;

  set setName(String value) {
    _name = value;
  }

  int get getRelationId => _relationId;

  set setRelationId(int value) {
    _relationId = value;
  }

  String get getEmailId => _emailId;

  set setEmailId(String value) {
    _emailId = value;
  }

  String get getMobile => _mobile;

  set setMobile(String value) {
    _mobile = value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicationId'] = _applicationId;
    data['Name'] = _name;
    data['Mobile'] = _mobile;
    data['EmailId'] = _emailId;
    data['RelationId'] = _relationId;
    return data;
  }
}
