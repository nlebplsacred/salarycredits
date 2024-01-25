class ActiveSalaryAccountModel {
  ActiveSalaryAccountModel();

  int _accountId = 0;
  String _accountHolderName = "";
  String _accountNumber = "";
  String _accountType = "";
  String _iFSCCode = "";
  String _branchCode = "";
  String _bankName = "";

  int get getAccountId => _accountId;

  set setAccountId(int value) {
    _accountId = value;
  }

  String get getBranchCode => _branchCode;

  set setBranchCode(String value) {
    _branchCode = value;
  }

  String get getBankName => _bankName;

  set setBankName(String value) {
    _bankName = value;
  }

  String get getAccountHolderName => _accountHolderName;

  set setAccountHolderName(String value) {
    _accountHolderName = value;
  }

  String get getAccountNumber => _accountNumber;

  set setAccountNumber(String value) {
    _accountNumber = value;
  }

  String get getAccountType => _accountType;

  set setAccountType(String value) {
    _accountType = value;
  }

  String get getIFSCCode => _iFSCCode;

  set setIFSCCode(String value) {
    _iFSCCode = value;
  }

  ActiveSalaryAccountModel.fromJson(Map<String, dynamic> json) {
    _accountId = json['AccountId'];
    _accountHolderName = json['AccountHolderName'];
    _accountNumber = json['AccountNumber'];
    _accountType = json['AccountType'];
    _iFSCCode = json['IFSCCode'];
    _branchCode = json['BranchCode'];
    _bankName = json['BankName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AccountId'] = _accountId;
    data['AccountHolderName'] = _accountHolderName;
    data['AccountNumber'] = _accountNumber;
    data['AccountType'] = _accountType;
    data['IFSCCode'] = _iFSCCode;
    data['BranchCode'] = _branchCode;
    data['BankName'] = _bankName;
    return data;
  }

}