class ExternalLoanProcessModel {
  ExternalLoanProcessModel();

  int _id = 0;
  int _applicantId = 0;
  int _applicationId = 0;
  int _processTypeId = 0;
  int _serviceProviderId = 0;
  int _bankId = 0;
  String _lenderName = "";
  String _bankName = "";
  int _totalNumber = 0;
  double _amount = 0.0;
  String _eCSLink = "";
  bool _isActive = false;
  String _createdOn = "";

  int get getId => _id;

  set setId(int value) {
    _id = value;
  }

  int get getApplicantId => _applicantId;

  set setApplicantId(int value) {
    _applicantId = value;
  }

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  int get getProcessTypeId => _processTypeId;

  set setProcessTypeId(int value) {
    _processTypeId = value;
  }

  int get getServiceProviderId => _serviceProviderId;

  set setServiceProviderId(int value) {
    _serviceProviderId = value;
  }

  int get getBankId => _bankId;

  set setBankId(int value) {
    _bankId = value;
  }

  String get getLenderName => _lenderName;

  set setLenderName(String value) {
    _lenderName = value;
  }

  String get getBankName => _bankName;

  set setBankName(String value) {
    _bankName = value;
  }

  int get getTotalNumber => _totalNumber;

  set setTotalNumber(int value) {
    _totalNumber = value;
  }

  double get getAmount => _amount;

  set setAmount(double value) {
    _amount = value;
  }

  String get getECSLink => _eCSLink;

  set setECSLink(String value) {
    _eCSLink = value;
  }

  bool get getIsActive => _isActive;

  set setIsActive(bool value) {
    _isActive = value;
  }

  String get getCreatedOn => _createdOn;

  set setCreatedOn(String value) {
    _createdOn = value;
  }

  ExternalLoanProcessModel.fromJson(Map<String, dynamic> json) {
    _id = json['Id'];
    _applicantId = json['ApplicantId'];
    _applicationId = json['ApplicationId'];
    _processTypeId = json['ProcessTypeId'];
    _serviceProviderId = json['ServiceProviderId'];
    _bankId = json['BankId'];
    _lenderName = json['LenderName'];
    _bankName = json['BankName'];
    _totalNumber = json['TotalNumber'];
    _amount = json['Amount'];
    _eCSLink = json['ECSLink'];
    _isActive = json['IsActive'];
    _createdOn = json['CreatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = _id;
    data['ApplicantId'] = _applicantId;
    data['ApplicationId'] = _applicationId;
    data['ProcessTypeId'] = _processTypeId;
    data['ServiceProviderId'] = _serviceProviderId;
    data['BankId'] = _bankId;
    data['LenderName'] = _lenderName;
    data['BankName'] = _bankName;
    data['TotalNumber'] = _totalNumber;
    data['Amount'] = _amount;
    data['ECSLink'] = _eCSLink;
    data['IsActive'] = _isActive;
    data['CreatedOn'] = _createdOn;
    return data;
  }

}
