class LoanStatusModel {
  LoanStatusModel();

  int _actionId = 0;
  int _applicationId = 0;
  int _userTypeId = 0;
  int _statusId = 0;
  String _statusName = "";
  String _remarks = "";
  int _actionById = 0;
  String _actionOn = "";
  bool _isActive = false;

  int get getActionId => _actionId;

  set setActionId(int value) {
    _actionId = value;
  }

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  bool get getIsActive => _isActive;

  set setIsActive(bool value) {
    _isActive = value;
  }

  String get getActionOn => _actionOn;

  set setActionOn(String value) {
    _actionOn = value;
  }

  int get getActionById => _actionById;

  set setActionById(int value) {
    _actionById = value;
  }

  String get getRemarks => _remarks;

  set setRemarks(String value) {
    _remarks = value;
  }

  String get getStatusName => _statusName;

  set setStatusName(String value) {
    _statusName = value;
  }

  int get getStatusId => _statusId;

  set setStatusId(int value) {
    _statusId = value;
  }

  int get getUserTypeId => _userTypeId;

  set setUserTypeId(int value) {
    _userTypeId = value;
  }


  LoanStatusModel.fromJson(Map<String, dynamic> json) {
    _actionId = json['ActionId'];
    _applicationId = json['ApplicationId'];
    _userTypeId = json['UserTypeId'];
    _statusId = json['StatusId'];
    _statusName = json['StatusName'];
    _remarks = json['Remarks'];
    _actionById = json['ActionById'];
    _actionOn = json['ActionOn'];
    _isActive = json['IsActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ActionId'] = _actionId;
    data['ApplicationId'] = _applicationId;
    data['UserTypeId'] = _userTypeId;
    data['StatusId'] = _statusId;
    data['StatusName'] = _statusName;
    data['Remarks'] = _remarks;
    data['ActionById'] = _actionById;
    data['ActionOn'] = _actionOn;
    data['IsActive'] = _isActive;
    return data;
  }
}
