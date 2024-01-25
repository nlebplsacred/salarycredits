import 'loan_model.dart';

class LoanRequestModel {
  LoanRequestModel();

  int _applicantId = 0;
  int _applicationId = 0;
  int _applicationTypeId = 0;
  int _employerTypeId = 0;
  int _bankId = 0;
  int _cityId = 0;
  String _dOB = "";
  int _employerId = 0;
  double _interstRate = 0.0;
  double _loanAmount = 0.0;
  double _processingFee = 0.0;
  int _tenure = 0;
  double _eMI = 0.0;
  double _netPayableSalary = 0.0;
  int _moratoriumPeriod = 0;
  String _discountCoupon = "";
  String _dssgIds = "";
  int _loanPurposeId = 0;
  BankAccount _bankAccount = BankAccount();
  Applicant _applicant = Applicant();

  int get getApplicantId => _applicantId;

  set setApplicantId(int value) {
    _applicantId = value;
  }

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  int get getApplicationTypeId => _applicationTypeId;

  set setApplicationTypeId(int value) {
    _applicationTypeId = value;
  }

  int get getEmployerTypeId => _employerTypeId;

  set setEmployerTypeId(int value) {
    _employerTypeId = value;
  }

  int get getBankId => _bankId;

  set setBankId(int value) {
    _bankId = value;
  }

  int get getCityId => _cityId;

  set setCityId(int value) {
    _cityId = value;
  }

  String get getDOB => _dOB;

  set setDOB(String value) {
    _dOB = value;
  }

  int get getEmployerId => _employerId;

  set setEmployerId(int value) {
    _employerId = value;
  }

  double get getInterstRate => _interstRate;

  set setInterstRate(double value) {
    _interstRate = value;
  }

  double get getLoanAmount => _loanAmount;

  set setLoanAmount(double value) {
    _loanAmount = value;
  }

  double get getProcessingFee => _processingFee;

  set setProcessingFee(double value) {
    _processingFee = value;
  }

  int get getTenure => _tenure;

  set setTenure(int value) {
    _tenure = value;
  }

  double get getEMI => _eMI;

  set setEMI(double value) {
    _eMI = value;
  }

  double get getNetPayableSalary => _netPayableSalary;

  set setNetPayableSalary(double value) {
    _netPayableSalary = value;
  }

  int get getMoratoriumPeriod => _moratoriumPeriod;

  set setMoratoriumPeriod(int value) {
    _moratoriumPeriod = value;
  }

  String get getDiscountCoupon => _discountCoupon;

  set setDiscountCoupon(String value) {
    _discountCoupon = value;
  }

  String get getDssgIds => _dssgIds;

  set setDssgIds(String value) {
    _dssgIds = value;
  }

  int get getLoanPurposeId => _loanPurposeId;

  set setLoanPurposeId(int value) {
    _loanPurposeId = value;
  }

  BankAccount get getBankAccount => _bankAccount;

  set setBankAccount(BankAccount value) {
    _bankAccount = value;
  }

  Applicant get getApplicant => _applicant;

  set setApplicant(Applicant value) {
    _applicant = value;
  }

  LoanRequestModel.fromJson(Map<String, dynamic> json) {
    _applicantId = json['ApplicantId'];
    _applicationId = json['ApplicationId'];
    _applicationTypeId = json['ApplicationTypeId'];
    _employerTypeId = json['EmployerTypeId'];
    _bankId = json['BankId'];
    _cityId = json['CityId'];
    _dOB = json['DOB'];
    _dssgIds = json['Dssg_Ids'];
    _eMI = json['EMI'];
    _employerId = json['EmployerId'];
    _interstRate = json['InterstRate'];
    _loanAmount = json['LoanAmount'];
    _loanPurposeId = json['LoanPurposeId'];
    _moratoriumPeriod = json['MoratoriumPeriod'];
    _netPayableSalary = json['Net_payable_salary'];
    _processingFee = json['ProcessingFee'];
    _tenure = json['Tenure'];
    _discountCoupon = json['DiscountCoupon'];
    _applicant = (json['Applicant'] != null ? Applicant.fromJson(json['Applicant']) : null)!;
    _bankAccount = (json['BankAccount'] != null ? BankAccount.fromJson(json['BankAccount']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicantId'] = _applicantId;
    data['ApplicationId'] = _applicationId;
    data['ApplicationTypeId'] = _applicationTypeId;
    data['EmployerTypeId'] = _employerTypeId;
    data['BankId'] = _bankId;
    data['CityId'] = _cityId;
    data['DOB'] = _dOB;
    data['Dssg_Ids'] = _dssgIds;
    data['EMI'] = _eMI;
    data['EmployerId'] = _employerId;
    data['InterstRate'] = _interstRate;
    data['LoanAmount'] = _loanAmount;
    data['LoanPurposeId'] = _loanPurposeId;
    data['MoratoriumPeriod'] = _moratoriumPeriod;
    data['Net_payable_salary'] = _netPayableSalary;
    data['ProcessingFee'] = _processingFee;
    data['Tenure'] = _tenure;
    data['DiscountCoupon'] = _discountCoupon;
    data['Applicant'] = _applicant.toJson();
    data['BankAccount'] = _bankAccount.toJson();
    return data;
  }
}

class LoanResponseModel {
  LoanResponseModel();

  String _statusId = "";
  String _message = "";
  int _applicationId = 0;

  String get getStatusId => _statusId;

  set setStatusId(String value) {
    _statusId = value;
  }

  String get getMessage => _message;

  set setMessage(String value) {
    _message = value;
  }

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  LoanResponseModel.fromJson(Map<String, dynamic> json) {
    _statusId = (json['StatusId'])!;
    _message = (json['Message'])!;
    _applicationId = (json['ApplicationId'])!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusId'] = _statusId;
    data['Message'] = _message;
    data['ApplicationId'] = _applicationId;
    return data;
  }

}
