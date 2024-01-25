import 'package:salarycredits/models/loan/short_loan_details.dart';

class ApplicantDashboardBaseModel {
  ShortLoanDetails shortLoanDetails = ShortLoanDetails();
  ProductBaseModel productBaseModel = ProductBaseModel();
  ApprovedOffer approvedOffer = ApprovedOffer();
  ActiveDeductionBase activeDeductionBase = ActiveDeductionBase();

  //initialize constructor
  ApplicantDashboardBaseModel({shortLoanDetails, productBaseModel, approvedOffer, activeDeductionBase});

  ApplicantDashboardBaseModel.fromJson(Map<String, dynamic> json) {
    shortLoanDetails = (json['ShortLoanDetails'] != null ? ShortLoanDetails.fromJson(json['ShortLoanDetails']) : null)!;
    productBaseModel = (json['ProductBaseModel'] != null ? ProductBaseModel.fromJson(json['ProductBaseModel']) : null)!;
    approvedOffer = (json['ApprovedOffer'] != null ? ApprovedOffer.fromJson(json['ApprovedOffer']) : null)!;
    activeDeductionBase = (json['ActiveDeductionBase'] != null ? ActiveDeductionBase.fromJson(json['ActiveDeductionBase']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ShortLoanDetails'] = shortLoanDetails.toJson();
    data['ProductBaseModel'] = productBaseModel.toJson();
    data['ApprovedOffer'] = approvedOffer.toJson();
    data['ActiveDeductionBase'] = activeDeductionBase.toJson();
    return data;
  }
}

class ProductBaseModel {
  int statusCode = 0;
  String message = "";
  List<ProductList> productList = List.empty();

  ProductBaseModel({statusCode, message, productList});

  ProductBaseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['product_list'] != null) {
      productList = <ProductList>[];
      json['product_list'].forEach((v) {
        productList.add(ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['message'] = message;
    data['product_list'] = productList.map((v) => v.toJson()).toList();
    return data;
  }
}

class ProductList {
  int applicationTypeId = 0;
  int employerId = 0;
  int bankId = 0;
  String applicationType = "";
  String applicationURL = "";
  String applicationIconPath = "";
  String? applicationDescription = "";
  double minLoanAmount = 0;
  double maxLoanAmount = 0;
  int minTenure = 0;
  int maxTenure = 0;
  String documentRequired = "";
  int productRank = 0;
  bool isCouponActive = false;
  bool isActive = false;

  ProductList(
      {applicationTypeId,
      employerId,
      bankId,
      applicationType,
      applicationURL,
      applicationIconPath,
      applicationDescription,
      minLoanAmount,
      maxLoanAmount,
      minTenure,
      maxTenure,
      documentRequired,
      productRank,
      isCouponActive,
      isActive,
      documents});

  ProductList.fromJson(Map<String, dynamic> json) {
    applicationTypeId = json['ApplicationTypeId'];
    employerId = json['EmployerId'];
    bankId = json['BankId'];
    applicationType = json['ApplicationType'];
    applicationURL = json['ApplicationURL'];
    applicationIconPath = json['ApplicationIconPath'];
    applicationDescription = json['ApplicationDescription'];
    minLoanAmount = json['MinLoanAmount'];
    maxLoanAmount = json['MaxLoanAmount'];
    minTenure = json['MinTenure'];
    maxTenure = json['MaxTenure'];
    documentRequired = json['DocumentRequired'];
    productRank = json['ProductRank'];
    isCouponActive = json['IsCouponActive'];
    isActive = json['IsActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicationTypeId'] = applicationTypeId;
    data['EmployerId'] = employerId;
    data['BankId'] = bankId;
    data['ApplicationType'] = applicationType;
    data['ApplicationURL'] = applicationURL;
    data['ApplicationIconPath'] = applicationIconPath;
    data['ApplicationDescription'] = applicationDescription;
    data['MinLoanAmount'] = minLoanAmount;
    data['MaxLoanAmount'] = maxLoanAmount;
    data['MinTenure'] = minTenure;
    data['MaxTenure'] = maxTenure;
    data['DocumentRequired'] = documentRequired;
    data['ProductRank'] = productRank;
    data['IsCouponActive'] = isCouponActive;
    data['IsActive'] = isActive;
    return data;
  }
}

class ApprovedOffer {
  ApprovedOffer();

  int _id = 0;
  int _applicantId = 0;
  int _applicationId = 0;
  int _applicationTypeId = 0;
  double _loanAmount = 0.0;
  int _loanTenure = 0;
  double _interestRate = 0.0;
  int _bankId = 0;
  double _netPayableSalary = 0.0;
  double _eMI = 0.0;
  String _message = "";
  String _lastSent = "";
  bool _isActive = false;
  String _applicationType = "";
  String _eMIStartMonth = "";
  String _acceptedOn = "";
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

  int get getApplicationTypeId => _applicationTypeId;

  set setApplicationTypeId(int value) {
    _applicationTypeId = value;
  }

  double get getLoanAmount => _loanAmount;

  set setLoanAmount(double value) {
    _loanAmount = value;
  }

  int get getLoanTenure => _loanTenure;

  set setLoanTenure(int value) {
    _loanTenure = value;
  }

  double get getInterestRate => _interestRate;

  set setInterestRate(double value) {
    _interestRate = value;
  }

  int get getBankId => _bankId;

  set setBankId(int value) {
    _bankId = value;
  }

  double get getNetPayableSalary => _netPayableSalary;

  set setNetPayableSalary(double value) {
    _netPayableSalary = value;
  }

  double get getEMI => _eMI;

  set setEMI(double value) {
    _eMI = value;
  }

  String get getMessage => _message;

  set setMessage(String value) {
    _message = value;
  }

  String get getLastSent => _lastSent;

  set setLastSent(String value) {
    _lastSent = value;
  }

  bool get getIsActive => _isActive;

  set setIsActive(bool value) {
    _isActive = value;
  }

  String get getApplicationType => _applicationType;

  set setApplicationType(String value) {
    _applicationType = value;
  }

  String get getEMIStartMonth => _eMIStartMonth;

  set setEMIStartMonth(String value) {
    _eMIStartMonth = value;
  }

  String get getAcceptedOn => _acceptedOn;

  set setAcceptedOn(String value) {
    _acceptedOn = value;
  }

  String get getCreatedOn => _createdOn;

  set setCreatedOn(String value) {
    _createdOn = value;
  }

  ApprovedOffer.fromJson(Map<String, dynamic> json) {
    _id = json['Id'];
    _applicantId = json['ApplicantId'];
    _applicationId = json['ApplicationId'];
    _applicationTypeId = json['ApplicationTypeId'];
    _loanAmount = json['LoanAmount'];
    _loanTenure = json['LoanTenure'];
    _interestRate = json['InterestRate'];
    _bankId = json['BankId'];
    _netPayableSalary = json['Net_Payable_Salary'];
    _eMI = json['EMI'];
    _message = json['Message'];
    _lastSent = json['LastSent'];
    _isActive = json['IsActive'];
    _applicationType = json['ApplicationType'];
    _eMIStartMonth = json['EMIStartMonth'];
    _acceptedOn = json['AcceptedOn'];
    _createdOn = json['CreatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = _id;
    data['ApplicantId'] = _applicantId;
    data['ApplicationId'] = _applicationId;
    data['ApplicationTypeId'] = _applicationTypeId;
    data['LoanAmount'] = _loanAmount;
    data['LoanTenure'] = _loanTenure;
    data['InterestRate'] = _interestRate;
    data['BankId'] = _bankId;
    data['Net_Payable_Salary'] = _netPayableSalary;
    data['EMI'] = _eMI;
    data['Message'] = _message;
    data['LastSent'] = _lastSent;
    data['IsActive'] = _isActive;
    data['ApplicationType'] = _applicationType;
    data['EMIStartMonth'] = _eMIStartMonth;
    data['AcceptedOn'] = _acceptedOn;
    data['CreatedOn'] = _createdOn;
    return data;
  }
}

class ActiveDeductionBase {
  double activeLoanDeductionAmount = 0.0;
  List<ActiveDeductions> activeDeductions = List.empty();

  ActiveDeductionBase({activeLoanDeductionAmount, activeDeductions});

  ActiveDeductionBase.fromJson(Map<String, dynamic> json) {
    activeLoanDeductionAmount = json['ActiveLoanDeductionAmount'];
    if (json['ActiveDeductions'] != null) {
      activeDeductions = <ActiveDeductions>[];
      json['ActiveDeductions'].forEach((v) {
        activeDeductions.add(ActiveDeductions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ActiveLoanDeductionAmount'] = activeLoanDeductionAmount;
    data['ActiveDeductions'] = activeDeductions.map((v) => v.toJson()).toList();
    return data;
  }
}

class ActiveDeductions {
  ActiveDeductions();

  int _applicationId = 0;
  String _applicationType = "";
  double _loanAmount = 0.0;
  double _eMI = 0.0;
  String _eMIDate = "";
  String _appliedOn = "";

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  String get getApplicationType => _applicationType;

  set setApplicationType(String value) {
    _applicationType = value;
  }

  double get getLoanAmount => _loanAmount;

  set setLoanAmount(double value) {
    _loanAmount = value;
  }

  double get getEMI => _eMI;

  set setEMI(double value) {
    _eMI = value;
  }

  String get getEMIDate => _eMIDate;

  set setEMIDate(String value) {
    _eMIDate = value;
  }

  String get getAppliedOn => _appliedOn;

  set setAppliedOn(String value) {
    _appliedOn = value;
  }

  ActiveDeductions.fromJson(Map<String, dynamic> json) {
    _applicationId = json['ApplicationId'];
    _applicationType = json['ApplicationType'];
    _loanAmount = json['LoanAmount'];
    _eMI = json['EMI'];
    _eMIDate = json['EMIDate'];
    _appliedOn = json['AppliedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicationId'] = _applicationId;
    data['ApplicationType'] = _applicationType;
    data['LoanAmount'] = _loanAmount;
    data['EMI'] = _eMI;
    data['EMIDate'] = _eMIDate;
    data['AppliedOn'] = _appliedOn;
    return data;
  }
}
