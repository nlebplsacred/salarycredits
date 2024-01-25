class LoanEligibilityRequestModel {
  int _applicantId = 0;
  int _applicationTypeId = 0;
  double _loanAmount = 0.0;
  int tenure = 0;

  int get getApplicantId => _applicantId;

  set setApplicantId(int value) {
    _applicantId = value;
  }

  int get getApplicationTypeId => _applicationTypeId;

  set setApplicationTypeId(int value) {
    _applicationTypeId = value;
  }

  double get getLoanAmount => _loanAmount;

  set setLoanAmount(double value) {
    _loanAmount = value;
  }

  LoanEligibilityRequestModel(int appId, int loanTypeId, double amount, int tenor) {
    _applicantId = appId;
    _applicationTypeId = loanTypeId;
    _loanAmount = amount;
    tenure = tenor;
  }

  LoanEligibilityRequestModel.fromJson(Map<String, dynamic> json) {
    _applicantId = json['ApplicantId'];
    _applicationTypeId = json['ApplicationTypeId'];
    _loanAmount = json['LoanAmount'];
    tenure = json['Tenure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicantId'] = _applicantId;
    data['ApplicationTypeId'] = _applicationTypeId;
    data['LoanAmount'] = _loanAmount;
    data['Tenure'] = tenure;
    return data;
  }
}

class LoanEligibilityResponseModel {
  LoanEligibilityResponseModel();

  int _statusId = 0;
  String _message = "";
  double _loanAmount = 0.0;
  double _newMonthlyPayment = 0.0;
  double _consolidatedMonthlyPayment = 0.0;
  double _processingFee = 0.0;
  double _processingFeeWithGST = 0.0;
  double _preEMI = 0.0;
  double _youReceiveAmount = 0.0;
  int _tenure = 0;
  int _maxTenure = 0;
  double _availableLoanLimit = 0.0;
  double _minLoanEligibility = 0.0;
  double _maxLoanEligibility = 0.0;
  double _netPayableAmount = 0.0;
  double _interestRate = 0.0;
  bool _isCouponActive = false;
  String _eMIStartDate = "";
  String _eMIEndDate = "";

  int get getStatusId => _statusId;

  set setStatusId(int statusId) => _statusId = statusId;

  String get getMessage => _message;

  set setMessage(String message) => _message = message;

  double get getLoanAmount => _loanAmount;

  set setLoanAmount(double loanAmount) => _loanAmount = loanAmount;

  double get getNewMonthlyPayment => _newMonthlyPayment;

  set setNewMonthlyPayment(double newMonthlyPayment) => _newMonthlyPayment = newMonthlyPayment;

  double get getConsolidatedMonthlyPayment => _consolidatedMonthlyPayment;

  set setConsolidatedMonthlyPayment(double consolidatedMonthlyPayment) => _consolidatedMonthlyPayment = consolidatedMonthlyPayment;

  double get getProcessingFee => _processingFee;

  set setProcessingFee(double processingFee) => _processingFee = processingFee;

  double get getProcessingFeeWithGST => _processingFeeWithGST;

  set setProcessingFeeWithGST(double processingFeeWithGST) => _processingFeeWithGST = processingFeeWithGST;

  double get getPreEMI => _preEMI;

  set setPreEMI(double preEMI) => _preEMI = preEMI;

  double get getYouReceiveAmount => _youReceiveAmount;

  set setYouReceiveAmount(double youReceiveAmount) => _youReceiveAmount = youReceiveAmount;

  int get getTenure => _tenure;

  set setTenure(int tenure) => _tenure = tenure;

  int get getMaxTenure => _maxTenure;

  set setMaxTenure(int maxTenure) => _maxTenure = maxTenure;

  double get getAvailableLoanLimit => _availableLoanLimit;

  set setAvailableLoanLimit(double availableLoanLimit) => _availableLoanLimit = availableLoanLimit;

  double get getMinLoanEligibility => _minLoanEligibility;

  set setMinLoanEligibility(double minLoanEligibility) => _minLoanEligibility = minLoanEligibility;

  double get getMaxLoanEligibility => _maxLoanEligibility;

  set setMaxLoanEligibility(double maxLoanEligibility) => _maxLoanEligibility = maxLoanEligibility;

  double get getNetPayableAmount => _netPayableAmount;

  set setNetPayableAmount(double netPayableAmount) => _netPayableAmount = netPayableAmount;

  double get getInterestRate => _interestRate;

  set setInterestRate(double interestRate) => _interestRate = interestRate;

  bool get getIsCouponActive => _isCouponActive;

  set setIsCouponActive(bool isCouponActive) => _isCouponActive = isCouponActive;

  String get getEMIStartDate => _eMIStartDate;

  set setEMIStartDate(String eMIStartDate) => _eMIStartDate = eMIStartDate;

  String get getEMIEndDate => _eMIEndDate;

  set setEMIEndDate(String eMIEndDate) => _eMIEndDate = eMIEndDate;

  LoanEligibilityResponseModel.fromJson(Map<String, dynamic> json) {
    _statusId = json['StatusId'];
    _message = json['Message'];
    _loanAmount = json['LoanAmount'];
    _newMonthlyPayment = json['NewMonthlyPayment'];
    _consolidatedMonthlyPayment = json['ConsolidatedMonthlyPayment'];
    _processingFee = json['ProcessingFee'];
    _processingFeeWithGST = json['ProcessingFeeWithGST'];
    _preEMI = json['PreEMI'];
    _youReceiveAmount = json['YouReceiveAmount'];
    _tenure = json['Tenure'];
    _maxTenure = json['MaxTenure'];
    _availableLoanLimit = json['AvailableLoanLimit'];
    _minLoanEligibility = json['MinLoanEligibility'];
    _maxLoanEligibility = json['MaxLoanEligibility'];
    _netPayableAmount = json['NetPayableAmount'];
    _interestRate = json['InterestRate'];
    _isCouponActive = json['IsCouponActive'];
    _eMIStartDate = json['EMIStartDate'];
    _eMIEndDate = json['EMIEndDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusId'] = _statusId;
    data['Message'] = _message;
    data['LoanAmount'] = _loanAmount;
    data['NewMonthlyPayment'] = _newMonthlyPayment;
    data['ConsolidatedMonthlyPayment'] = _consolidatedMonthlyPayment;
    data['ProcessingFee'] = _processingFee;
    data['ProcessingFeeWithGST'] = _processingFeeWithGST;
    data['PreEMI'] = _preEMI;
    data['YouReceiveAmount'] = _youReceiveAmount;
    data['Tenure'] = _tenure;
    data['MaxTenure'] = _maxTenure;
    data['AvailableLoanLimit'] = _availableLoanLimit;
    data['MinLoanEligibility'] = _minLoanEligibility;
    data['MaxLoanEligibility'] = _maxLoanEligibility;
    data['NetPayableAmount'] = _netPayableAmount;
    data['InterestRate'] = _interestRate;
    data['IsCouponActive'] = _isCouponActive;
    data['EMIStartDate'] = _eMIStartDate;
    data['EMIEndDate'] = _eMIEndDate;
    return data;

  }
}
