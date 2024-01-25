import 'dart:core';
import 'lender_consent_model.dart';
import 'master_data_model.dart';

class LoanModel {
  LoanModel();

  int _applicantId = 0;
  int _applicationId = 0;
  int _applicationTypeId = 0;
  int _employerTypeId = 0;
  int _bankId = 0;
  int _employerId = 0;
  String _dOB = "";
  int _cityId = 0;
  double _interstRate = 0.0;
  double _loanAmount = 0.0;
  double _processingFee = 0.0;
  int _tenure = 0;
  double _eMI = 0.0;
  double _grossIncome = 0.0;
  double _netPayableSalary = 0.0;
  int _moratoriumPeriod = 0;
  String _discountCoupon = "";
  bool _isCouponActive = false;
  String _dssgIds = "";
  int _loanPurposeId = 0;
  int _rentId = 0;
  double _loanEligibility = 0.0;
  List<SelectListItem> _stability = List.empty();
  LenderConsent _lenderConsent = LenderConsent();
  BankAccount _bankAccount = BankAccount();
  Applicant _applicant = Applicant();

  int get getLoanPurposeId => _loanPurposeId;

  set setLoanPurposeId(int value) {
    _loanPurposeId = value;
  }

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

  int get getEmployerId => _employerId;

  set setEmployerId(int value) {
    _employerId = value;
  }

  String get getDOB => _dOB;

  set setDOB(String value) {
    _dOB = value;
  }

  int get getCityId => _cityId;

  set setCityId(int value) {
    _cityId = value;
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

  double get getGrossIncome => _grossIncome;

  set setGrossIncome(double value) {
    _grossIncome = value;
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

  bool get getIsCouponActive => _isCouponActive;

  set setIsCouponActive(bool value) {
    _isCouponActive = value;
  }

  String get getDssgIds => _dssgIds;

  set setDssgIds(String value) {
    _dssgIds = value;
  }

  int get getRentId => _rentId;

  set setRentId(int value) {
    _rentId = value;
  }

  double get getLoanEligibility => _loanEligibility;

  set setLoanEligibility(double value) {
    _loanEligibility = value;
  }

  BankAccount get getBankAccount => _bankAccount;

  set setBankAccount(BankAccount value) {
    _bankAccount = value;
  }

  Applicant get getApplicant => _applicant;

  set setApplicant(Applicant value) {
    _applicant = value;
  }

  LenderConsent get getLenderConsent => _lenderConsent;

  set setLenderConsent(LenderConsent value) {
    _lenderConsent = value;
  }

  List<SelectListItem> get getStability => _stability;

  set setStability(List<SelectListItem> value) {
    _stability = value;
  }

  LoanModel.fromJson(Map<String, dynamic> json) {
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
    _grossIncome = json['Net_payable_salary'];
    _netPayableSalary = json['GrossIncome'];
    _processingFee = json['ProcessingFee'];
    _tenure = json['Tenure'];
    _discountCoupon = json['DiscountCoupon'];
    _isCouponActive = json['IsCouponActive'];
    _rentId = json['RentId'];
    _loanEligibility = json['LoanEligibility'];
    _applicant = (json['Applicant'] != null ? Applicant.fromJson(json['Applicant']) : null)!;
    _bankAccount = (json['BankAccount'] != null ? BankAccount.fromJson(json['BankAccount']) : null)!;
    _lenderConsent = (json['LenderConsent'] != null ? LenderConsent.fromJson(json['LenderConsent']) : null)!;

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
    data['GrossIncome'] = _grossIncome;
    data['Net_payable_salary'] = _netPayableSalary;
    data['ProcessingFee'] = _processingFee;
    data['Tenure'] = _tenure;
    data['DiscountCoupon'] = _discountCoupon;
    data['IsCouponActive'] = _isCouponActive;
    data['RentId'] = _rentId;
    data['LoanEligibility'] = _loanEligibility;
    data['Applicant'] = _applicant.toJson();
    data['BankAccount'] = _bankAccount.toJson();
    data['LenderConsent'] = _lenderConsent.toJson();
    return data;
  }
}

class Applicant {
  Applicant();

  int _applicantId = 0;
  String _aadhaar = "";
  String _pancard = "";
  String _personalEmailId = "";
  String _dOB = "";
  int _educationId = 0;
  int _genderTypeId = 0;
  int _maritalStatusId = 0;
  int _noOfDependants = 0;
  String _currentAddress = "";
  String _currentAddress2 = "";
  int _cityId = 0;
  String _pincode = "";
  String _permanentAddress = "";
  String _permanentAddress2 = "";
  int _permanentCityId = 0;
  String _permanentPincode = "";
  bool _currentAddressSameAsKycAddress = false;
  bool _permanentAddressSameAsLocalAddress = false;
  double _residenceRentAmount = 0.0;
  int _residenceTypeId = 0;
  String _residingSinceOnCurrentAddress = "";
  int _totalExperience = 0;
  String _workingSince = "";

  int get getApplicantId => _applicantId;

  set setApplicantId(int value) {
    _applicantId = value;
  }

  String get getAadhaar => _aadhaar;

  set setAadhaar(String value) {
    _aadhaar = value;
  }

  String get getPancard => _pancard;

  set setPancard(String value) {
    _pancard = value;
  }

  String get getPersonalEmailId => _personalEmailId;

  set setPersonalEmailId(String value) {
    _personalEmailId = value;
  }

  String get getDOB => _dOB;

  set setDOB(String value) {
    _dOB = value;
  }

  int get getEducationId => _educationId;

  set setEducationId(int value) {
    _educationId = value;
  }

  int get getGenderTypeId => _genderTypeId;

  set setGenderTypeId(int value) {
    _genderTypeId = value;
  }

  int get getMaritalStatusId => _maritalStatusId;

  set setMaritalStatusId(int value) {
    _maritalStatusId = value;
  }

  int get getNoOfDependants => _noOfDependants;

  set setNoOfDependants(int value) {
    _noOfDependants = value;
  }

  String get getCurrentAddress => _currentAddress;

  set setCurrentAddress(String value) {
    _currentAddress = value;
  }

  String get getCurrentAddress2 => _currentAddress2;

  set setCurrentAddress2(String value) {
    _currentAddress2 = value;
  }

  int get getCityId => _cityId;

  set setCityId(int value) {
    _cityId = value;
  }

  String get getPincode => _pincode;

  set setPincode(String value) {
    _pincode = value;
  }

  String get getPermanentAddress => _permanentAddress;

  set setPermanentAddress(String value) {
    _permanentAddress = value;
  }

  String get getPermanentAddress2 => _permanentAddress2;

  set setPermanentAddress2(String value) {
    _permanentAddress2 = value;
  }

  int get getPermanentCityId => _permanentCityId;

  set setPermanentCityId(int value) {
    _permanentCityId = value;
  }

  String get getPermanentPincode => _permanentPincode;

  set setPermanentPincode(String value) {
    _permanentPincode = value;
  }

  bool get getCurrentAddressSameAsKycAddress => _currentAddressSameAsKycAddress;

  set setCurrentAddressSameAsKycAddress(bool value) {
    _currentAddressSameAsKycAddress = value;
  }

  bool get getPermanentAddressSameAsLocalAddress => _permanentAddressSameAsLocalAddress;

  set setPermanentAddressSameAsLocalAddress(bool value) {
    _permanentAddressSameAsLocalAddress = value;
  }

  double get getResidenceRentAmount => _residenceRentAmount;

  set setResidenceRentAmount(double value) {
    _residenceRentAmount = value;
  }

  int get getResidenceTypeId => _residenceTypeId;

  set setResidenceTypeId(int value) {
    _residenceTypeId = value;
  }

  String get getResidingSinceOnCurrentAddress => _residingSinceOnCurrentAddress;

  set setResidingSinceOnCurrentAddress(String value) {
    _residingSinceOnCurrentAddress = value;
  }

  int get getTotalExperience => _totalExperience;

  set setTotalExperience(int value) {
    _totalExperience = value;
  }

  String get getWorkingSince => _workingSince;

  set setWorkingSince(String value) {
    _workingSince = value;
  }

  Applicant.fromJson(Map<String, dynamic> json) {
    _aadhaar = json['Aadhaar'];
    _applicantId = json['ApplicantId'];
    _cityId = json['CityId'];
    _currentAddress = json['CurrentAddress'];
    _currentAddress2 = json['CurrentAddress2'];
    _currentAddressSameAsKycAddress = json['Current_address_same_as_kyc_address'];
    _dOB = json['DOB'];
    _educationId = json['EducationId'];
    _genderTypeId = json['GenderTypeId'];
    _maritalStatusId = json['MaritalStatusId'];
    _noOfDependants = json['No_of_dependants'];
    _pancard = json['Pancard'];
    _permanentAddress = json['PermanentAddress'];
    _permanentAddress2 = json['PermanentAddress2'];
    _permanentCityId = json['PermanentCityId'];
    _permanentPincode = json['PermanentPincode'];
    _permanentAddressSameAsLocalAddress = json['Permanent_address_same_as_local_address'];
    _personalEmailId = json['PersonalEmailId'];
    _pincode = json['Pincode'];
    _residenceRentAmount = json['ResidenceRentAmount'];
    _residenceTypeId = json['ResidenceTypeId'];
    _residingSinceOnCurrentAddress = json['Residing_since_on_current_address'];
    _totalExperience = json['TotalExperience'];
    _workingSince = json['WorkingSince'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Aadhaar'] = _aadhaar;
    data['ApplicantId'] = _applicantId;
    data['CityId'] = _cityId;
    data['CurrentAddress'] = _currentAddress;
    data['CurrentAddress2'] = _currentAddress2;
    data['Current_address_same_as_kyc_address'] = _currentAddressSameAsKycAddress;
    data['DOB'] = _dOB;
    data['EducationId'] = _educationId;
    data['GenderTypeId'] = _genderTypeId;
    data['MaritalStatusId'] = _maritalStatusId;
    data['No_of_dependants'] = _noOfDependants;
    data['Pancard'] = _pancard;
    data['PermanentAddress'] = _permanentAddress;
    data['PermanentAddress2'] = _permanentAddress2;
    data['PermanentCityId'] = _permanentCityId;
    data['PermanentPincode'] = _permanentPincode;
    data['Permanent_address_same_as_local_address'] = _permanentAddressSameAsLocalAddress;
    data['PersonalEmailId'] = _personalEmailId;
    data['Pincode'] = _pincode;
    data['ResidenceRentAmount'] = _residenceRentAmount;
    data['ResidenceTypeId'] = _residenceTypeId;
    data['Residing_since_on_current_address'] = _residingSinceOnCurrentAddress;
    data['TotalExperience'] = _totalExperience;
    data['WorkingSince'] = _workingSince;
    return data;
  }
}

class BankAccount {
  BankAccount();

  String _accountHolderName = "";
  String _accountNumber = "";
  String _accountType = "";
  String _iFSCCode = "";

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

  BankAccount.fromJson(Map<String, dynamic> json) {
    _accountHolderName = json['AccountHolderName'];
    _accountNumber = json['AccountNumber'];
    _accountType = json['AccountType'];
    _iFSCCode = json['IFSCCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AccountHolderName'] = _accountHolderName;
    data['AccountNumber'] = _accountNumber;
    data['AccountType'] = _accountType;
    data['IFSCCode'] = _iFSCCode;
    return data;
  }
}

