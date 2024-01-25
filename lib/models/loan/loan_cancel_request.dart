class LoanCancelRequestModel {
  LoanCancelRequestModel();

  int _applicationId = 0;
  int _applicantId = 0;
  int _bankId = 0;
  String _remarks = "";

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  int get getApplicantId => _applicantId;

  set setApplicantId(int value) {
    _applicantId = value;
  }

  String get getRemarks => _remarks;

  set setRemarks(String value) {
    _remarks = value;
  }

  int get getBankId => _bankId;

  set setBankId(int value) {
    _bankId = value;
  }

  LoanCancelRequestModel.fromJson(Map<String, dynamic> json) {
    _applicationId = json['ApplicationId'];
    _applicantId = json['ApplicantId'];
    _bankId = json['BankId'];
    _remarks = json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicationId'] = _applicationId;
    data['ApplicantId'] = _applicantId;
    data['BankId'] = _bankId;
    data['Remarks'] = _remarks;
    return data;
  }
}
