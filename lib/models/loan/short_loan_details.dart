class ShortLoanDetails {
  ShortLoanDetails();

  int _applicationId = 0;
  String _applicationType = "";
  int _applicationTypeId = 0;
  bool _statusFlag = false;
  String _applicationIconPath = "";
  double _loanAmount = 0.0;
  double _disbursalAmount = 0.0;
  double _emi = 0.0;
  int _statusId = 0;
  String _loanStatus = "";
  bool _isProcessDone = false;
  int _bankId = 0;
  String _appliedOn = "";
  String _lastAction = "";

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  String get getApplicationType => _applicationType;

  set setApplicationType(String value) {
    _applicationType = value;
  }

  int get getApplicationTypeId => _applicationTypeId;

  set setApplicationTypeId(int value) {
    _applicationTypeId = value;
  }

  bool get getStatusFlag => _statusFlag;

  set setStatusFlag(bool value) {
    _statusFlag = value;
  }

  String get getApplicationIconPath => _applicationIconPath;

  set setApplicationIconPath(String value) {
    _applicationIconPath = value;
  }

  double get getLoanAmount => _loanAmount;

  set setLoanAmount(double value) {
    _loanAmount = value;
  }

  double get getDisbursalAmount => _disbursalAmount;

  set setDisbursalAmount(double value) {
    _disbursalAmount = value;
  }

  double get getEMI => _emi;

  set setEMI(double value) {
    _emi = value;
  }

  int get getStatusId => _statusId;

  set setStatusId(int value) {
    _statusId = value;
  }

  String get getLoanStatus => _loanStatus;

  set setLoanStatus(String value) {
    _loanStatus = value;
  }

  bool get getIsProcessDone => _isProcessDone;

  set setIsProcessDone(bool value) {
    _isProcessDone = value;
  }

  int get getBankId => _bankId;

  set setBankId(int value) {
    _bankId = value;
  }

  String get getAppliedOn => _appliedOn;

  set setAppliedOn(String value) {
    _appliedOn = value;
  }

  String get getLastAction => _lastAction;

  set setLastAction(String value) {
    _lastAction = value;
  }

  ShortLoanDetails.fromJson(Map<String, dynamic> json) {
    _applicationId = json['ApplicationId'];
    _applicationType = json['ApplicationType'];
    _applicationTypeId = json['ApplicationTypeId'];
    _statusFlag = json['statusFlag'];
    _applicationIconPath = json['ApplicationIconPath'];
    _loanAmount = json['LoanAmount'];
    _disbursalAmount = json['DisbursalAmount'];
    _statusId = json['StatusId'];
    _loanStatus = json['LoanStatus'];
    _isProcessDone = json['IsProcessDone'];
    _bankId = json['BankId'];
    _appliedOn = json['AppliedOn'];
    _lastAction = json['LastAction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicationId'] = _applicationId;
    data['ApplicationType'] = _applicationType;
    data['ApplicationTypeId'] = _applicationTypeId;
    data['statusFlag'] = _statusFlag;
    data['ApplicationIconPath'] = _applicationIconPath;
    data['LoanAmount'] = _loanAmount;
    data['DisbursalAmount'] = _disbursalAmount;
    data['StatusId'] = _statusId;
    data['LoanStatus'] = _loanStatus;
    data['IsProcessDone'] = _isProcessDone;
    data['BankId'] = _bankId;
    data['AppliedOn'] = _appliedOn;
    data['LastAction'] = _lastAction;
    return data;
  }
}