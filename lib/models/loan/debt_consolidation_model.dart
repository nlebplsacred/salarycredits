import 'loan_eligibility_request_model.dart';

class DebtConsolidationModel {
  DebtConsolidationModel();

  bool _isEligibleForDC = false;
  LoanEligibilityResponseModel _eligibilityResponseModel = LoanEligibilityResponseModel();
  LoanHistoryBaseModel _loanHistoryBaseModel = LoanHistoryBaseModel();

  bool get getIsEligibleForDC => _isEligibleForDC;

  set setIsEligibleForDC(bool isEligibleForDC) => _isEligibleForDC = isEligibleForDC;

  LoanEligibilityResponseModel get getEligibilityResponseModel => _eligibilityResponseModel;

  set setEligibilityResponseModel(LoanEligibilityResponseModel eligibilityResponseModel) => _eligibilityResponseModel = eligibilityResponseModel;

  LoanHistoryBaseModel get getLoanHistoryBaseModel => _loanHistoryBaseModel;

  set setLoanHistoryBaseModel(LoanHistoryBaseModel loanHistoryBaseModel) => _loanHistoryBaseModel = loanHistoryBaseModel;

  DebtConsolidationModel.fromJson(Map<String, dynamic> json) {
    _isEligibleForDC = json['IsEligibleForDC'];
    _eligibilityResponseModel =
        (json['eligibilityResponseModel'] != null ? LoanEligibilityResponseModel.fromJson(json['eligibilityResponseModel']) : null)!;
    _loanHistoryBaseModel = (json['loanHistoryBaseModel'] != null ? LoanHistoryBaseModel.fromJson(json['loanHistoryBaseModel']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsEligibleForDC'] = _isEligibleForDC;
    data['eligibilityResponseModel'] = _eligibilityResponseModel.toJson();
    data['loanHistoryBaseModel'] = _loanHistoryBaseModel.toJson();
    return data;
  }
}

class LoanHistoryBaseModel {
  LoanHistoryBaseModel();

  int _applicantId = 0;
  double _totalAmountApplied = 0.0;
  double _totalAmountDisbursed = 0.0;
  int _totalLoanCount = 0;
  int _activeLoanCount = 0;
  int _closedLoanCount = 0;
  int _pendingEMICount = 0;
  int _paidEMICount = 0;
  double _pendingEMIAmount = 0.0;
  double _paidEMIAmount = 0.0;
  double _monthlyEMIPaying = 0.0;
  double _upcomingDeduction = 0.0;
  List<LoanHistories> _loanHistories = [];

  int get getApplicantId => _applicantId;

  set setApplicantId(int applicantId) => _applicantId = applicantId;

  double get getTotalAmountApplied => _totalAmountApplied;

  set setTotalAmountApplied(double totalAmountApplied) => _totalAmountApplied = totalAmountApplied;

  double get getTotalAmountDisbursed => _totalAmountDisbursed;

  set setTotalAmountDisbursed(double totalAmountDisbursed) => _totalAmountDisbursed = totalAmountDisbursed;

  int get getTotalLoanCount => _totalLoanCount;

  set setTotalLoanCount(int totalLoanCount) => _totalLoanCount = totalLoanCount;

  int get getActiveLoanCount => _activeLoanCount;

  set setActiveLoanCount(int activeLoanCount) => _activeLoanCount = activeLoanCount;

  int get getClosedLoanCount => _closedLoanCount;

  set setClosedLoanCount(int closedLoanCount) => _closedLoanCount = closedLoanCount;

  int get getPendingEMICount => _pendingEMICount;

  set setPendingEMICount(int pendingEMICount) => _pendingEMICount = pendingEMICount;

  int get getPaidEMICount => _paidEMICount;

  set setPaidEMICount(int paidEMICount) => _paidEMICount = paidEMICount;

  double get getPendingEMIAmount => _pendingEMIAmount;

  set setPendingEMIAmount(double pendingEMIAmount) => _pendingEMIAmount = pendingEMIAmount;

  double get getPaidEMIAmount => _paidEMIAmount;

  set setPaidEMIAmount(double paidEMIAmount) => _paidEMIAmount = paidEMIAmount;

  double get getMonthlyEMIPaying => _monthlyEMIPaying;

  set setMonthlyEMIPaying(double monthlyEMIPaying) => _monthlyEMIPaying = monthlyEMIPaying;

  double get getUpcomingDeduction => _upcomingDeduction;

  set upcomingDeduction(double upcomingDeduction) => _upcomingDeduction = upcomingDeduction;

  List<LoanHistories> get getLoanHistories => _loanHistories;

  set setLoanHistories(List<LoanHistories> loanHistories) => _loanHistories = loanHistories;

  LoanHistoryBaseModel.fromJson(Map<String, dynamic> json) {
    _applicantId = json['ApplicantId'];
    _totalAmountApplied = json['TotalAmountApplied'];
    _totalAmountDisbursed = json['TotalAmountDisbursed'];
    _totalLoanCount = json['TotalLoanCount'];
    _activeLoanCount = json['ActiveLoanCount'];
    _closedLoanCount = json['ClosedLoanCount'];
    _pendingEMICount = json['PendingEMICount'];
    _paidEMICount = json['PaidEMICount'];
    _pendingEMIAmount = json['PendingEMIAmount'];
    _paidEMIAmount = json['PaidEMIAmount'];
    _monthlyEMIPaying = json['MonthlyEMIPaying'];
    _upcomingDeduction = json['upcomingDeduction'];
    if (json['loanHistories'] != null) {
      _loanHistories = <LoanHistories>[];
      json['loanHistories'].forEach((v) {
        _loanHistories.add(LoanHistories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicantId'] = _applicantId;
    data['TotalAmountApplied'] = _totalAmountApplied;
    data['TotalAmountDisbursed'] = _totalAmountDisbursed;
    data['TotalLoanCount'] = _totalLoanCount;
    data['ActiveLoanCount'] = _activeLoanCount;
    data['ClosedLoanCount'] = _closedLoanCount;
    data['PendingEMICount'] = _pendingEMICount;
    data['PaidEMICount'] = _paidEMICount;
    data['PendingEMIAmount'] = _pendingEMIAmount;
    data['PaidEMIAmount'] = _paidEMIAmount;
    data['MonthlyEMIPaying'] = _monthlyEMIPaying;
    data['upcomingDeduction'] = _upcomingDeduction;
    data['loanHistories'] = _loanHistories.map((v) => v.toJson()).toList();
    return data;
  }
}

class LoanHistories {
  LoanHistories();

  int _applicationId = 0;
  String _applicationType = "";
  int _applicationTypeId = 0;
  double _loanAmount = 0.0;
  double _eMIAmount = 0.0;
  int _pendingEMICount = 0;
  int _paidEMICount = 0;
  String _lenderName = "";
  String _currentStatus = "";
  String _startDate = "";
  String _endDate = "";
  String _lastActionDate = "";
  bool _isActive = false;
  bool _isOptedForDC = false;
  bool _isEligibleForDC = false;

  int get getApplicationId => _applicationId;

  set setApplicationId(int applicationId) => _applicationId = applicationId;

  String get getApplicationType => _applicationType;

  set setApplicationType(String applicationType) => _applicationType = applicationType;

  int get getApplicationTypeId => _applicationTypeId;

  set setApplicationTypeId(int applicationTypeId) => _applicationTypeId = applicationTypeId;

  double get getLoanAmount => _loanAmount;

  set setLoanAmount(double loanAmount) => _loanAmount = loanAmount;

  double get getEMIAmount => _eMIAmount;

  set setEMIAmount(double eMIAmount) => _eMIAmount = eMIAmount;

  int get getPendingEMICount => _pendingEMICount;

  set setPendingEMICount(int pendingEMICount) => _pendingEMICount = pendingEMICount;

  int get getPaidEMICount => _paidEMICount;

  set setPaidEMICount(int paidEMICount) => _paidEMICount = paidEMICount;

  String get getLenderName => _lenderName;

  set setLenderName(String lenderName) => _lenderName = lenderName;

  String get getCurrentStatus => _currentStatus;

  set setCurrentStatus(String currentStatus) => _currentStatus = currentStatus;

  String get getStartDate => _startDate;

  set setStartDate(String startDate) => _startDate = startDate;

  String get getEndDate => _endDate;

  set setEndDate(String endDate) => _endDate = endDate;

  String get getLastActionDate => _lastActionDate;

  set setLastActionDate(String lastActionDate) => _lastActionDate = lastActionDate;

  bool get getIsActive => _isActive;

  set setIsActive(bool isActive) => _isActive = isActive;

  bool get getIsOptedForDC => _isOptedForDC;

  set setIsOptedForDC(bool isOptedForDC) => _isOptedForDC = isOptedForDC;

  bool get getIsEligibleForDC => _isEligibleForDC;

  set setIsEligibleForDC(bool isEligibleForDC) => _isEligibleForDC = isEligibleForDC;

  LoanHistories.fromJson(Map<String, dynamic> json) {
    _applicationId = json['ApplicationId'];
    _applicationType = json['ApplicationType'];
    _applicationTypeId = json['ApplicationTypeId'];
    _loanAmount = json['LoanAmount'];
    _eMIAmount = json['EMIAmount'];
    _pendingEMICount = json['PendingEMICount'];
    _paidEMICount = json['PaidEMICount'];
    _lenderName = json['LenderName'];
    _currentStatus = json['CurrentStatus'];
    _startDate = json['StartDate'];
    _endDate = json['EndDate'];
    _lastActionDate = json['LastActionDate'];
    _isActive = json['IsActive'];
    _isOptedForDC = json['IsOptedForDC'];
    _isEligibleForDC = json['IsEligibleForDC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicationId'] = _applicationId;
    data['ApplicationType'] = _applicationType;
    data['ApplicationTypeId'] = _applicationTypeId;
    data['LoanAmount'] = _loanAmount;
    data['EMIAmount'] = _eMIAmount;
    data['PendingEMICount'] = _pendingEMICount;
    data['PaidEMICount'] = _paidEMICount;
    data['LenderName'] = _lenderName;
    data['CurrentStatus'] = _currentStatus;
    data['StartDate'] = _startDate;
    data['EndDate'] = _endDate;
    data['LastActionDate'] = _lastActionDate;
    data['IsActive'] = _isActive;
    data['IsOptedForDC'] = _isOptedForDC;
    data['IsEligibleForDC'] = _isEligibleForDC;
    return data;
  }
}

class DCForeclosureRequest{
  DCForeclosureRequest();

  int _applicantId = 0;
  String _jsonData = "";

  int get getApplicantId => _applicantId;

  set setApplicantId(int value) {
    _applicantId = value;
  }

  String get getJsonData => _jsonData;

  set setJsonData(String value) {
    _jsonData = value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicantId'] = _applicantId;
    data['JSONData'] = _jsonData;

    return data;
  }

}