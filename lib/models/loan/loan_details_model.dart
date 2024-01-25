class LoanDetailsModel {
  LoanDetailsModel();

  int _applicationId = 0;
  int _applicantId = 0;
  int _employerId = 0;
  int _applicationTypeId = 0;
  String _applicationType = "";
  double _loanAmount = 0.0;
  double _eMI = 0.0;
  double _processingFee = 0.0;
  double _interestRate = 0.0;
  double _preEMI = 0.0;
  double _disbursalAmount = 0.0;
  int _eMICount = 0;
  int _paidEMICount = 0;
  double _discountOnFee = 0.0;
  double _discountOnInterest = 0.0;
  String _lenderName = "";
  String _loanStatus = "";
  int _loanStatusId = 0;
  int _currentStatusId = 0;
  String _remarks = "";
  String _purpose = "";
  String _eMIStartFrom = "";
  String _eMIEnding = "";
  String _appliedOn = "";
  String _disbursedOn = "";
  LoanClosureDetails _loanClosureDetails = LoanClosureDetails();
  LenderDetails _lenderDetails = LenderDetails();
  List<RepaymentDetails> _repaymentDetails = [];

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  int get getApplicantId => _applicantId;

  set setApplicantId(int value) {
    _applicantId = value;
  }

  int get getEmployerId => _employerId;

  set setEmployerId(int value) {
    _employerId = value;
  }

  int get gteApplicationTypeId => _applicationTypeId;

  set setApplicationTypeId(int value) {
    _applicationTypeId = value;
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

  double get getProcessingFee => _processingFee;

  set setProcessingFee(double value) {
    _processingFee = value;
  }

  double get getInterestRate => _interestRate;

  set setInterestRate(double value) {
    _interestRate = value;
  }

  double get getPreEMI => _preEMI;

  set setPreEMI(double value) {
    _preEMI = value;
  }

  double get getDisbursalAmount => _disbursalAmount;

  set setDisbursalAmount(double value) {
    _disbursalAmount = value;
  }

  int get getEMICount => _eMICount;

  set setEMICount(int value) {
    _eMICount = value;
  }

  int get getPaidEMICount => _paidEMICount;

  set setPaidEMICount(int value) {
    _paidEMICount = value;
  }

  double get getDiscountOnFee => _discountOnFee;

  set setDiscountOnFee(double value) {
    _discountOnFee = value;
  }

  double get getDiscountOnInterest => _discountOnInterest;

  set setDiscountOnInterest(double value) {
    _discountOnInterest = value;
  }

  String get getLenderName => _lenderName;

  set setLenderName(String value) {
    _lenderName = value;
  }

  String get getLoanStatus => _loanStatus;

  set setLoanStatus(String value) {
    _loanStatus = value;
  }

  int get getLoanStatusId => _loanStatusId;

  set setLoanStatusId(int value) {
    _loanStatusId = value;
  }

  int get getCurrentStatusId => _currentStatusId;

  set setCurrentStatusId(int value) {
    _currentStatusId = value;
  }

  String get getRemarks => _remarks;

  set setRemarks(String value) {
    _remarks = value;
  }

  String get getPurpose => _purpose;

  set setPurpose(String value) {
    _purpose = value;
  }

  String get getEMIStartFrom => _eMIStartFrom;

  set setEMIStartFrom(String value) {
    _eMIStartFrom = value;
  }

  String get getEMIEnding => _eMIEnding;

  set setEMIEnding(String value) {
    _eMIEnding = value;
  }

  String get getAppliedOn => _appliedOn;

  set setAppliedOn(String value) {
    _appliedOn = value;
  }

  String get getDisbursedOn => _disbursedOn;

  set setDisbursedOn(String value) {
    _disbursedOn = value;
  }

  LoanClosureDetails get getLoanClosureDetails => _loanClosureDetails;

  set setLoanClosureDetails(LoanClosureDetails value) {
    _loanClosureDetails = value;
  }

  LenderDetails get getLenderDetails => _lenderDetails;

  set setLenderDetails(LenderDetails value) {
    _lenderDetails = value;
  }

  List<RepaymentDetails> get getRepaymentDetails => _repaymentDetails;

  set setRepaymentDetails(List<RepaymentDetails> value) {
    _repaymentDetails = value;
  }

  LoanDetailsModel.fromJson(Map<String, dynamic> json) {
    _applicationId = json['ApplicationId'];
    _applicantId = json['ApplicantId'];
    _employerId = json['EmployerId'];
    _applicationTypeId = json['ApplicationTypeId'];
    _applicationType = json['ApplicationType'];
    _loanAmount = json['LoanAmount'];
    _eMI = json['EMI'];
    _processingFee = json['ProcessingFee'];
    _interestRate = json['InterestRate'];
    _preEMI = json['PreEMI'];
    _disbursalAmount = json['DisbursalAmount'];
    _eMICount = json['EMICount'];
    _paidEMICount = json['PaidEMICount'];
    _discountOnFee = json['DiscountOnFee'];
    _discountOnInterest = json['DiscountOnInterest'];
    _lenderName = json['LenderName'];
    _loanStatus = json['LoanStatus'];
    _loanStatusId = json['LoanStatusId'];
    _currentStatusId = json['CurrentStatusId'];
    _remarks = json['Remarks'];
    _purpose = json['Purpose'];
    _eMIStartFrom = json['EMIStartFrom'];
    _eMIEnding = json['EMIEnding'];
    _appliedOn = json['AppliedOn'];
    _disbursedOn = json['DisbursedOn'];
    _loanClosureDetails = (json['loanClosureDetails'] != null ? LoanClosureDetails.fromJson(json['loanClosureDetails']) : null)!;
    _lenderDetails = (json['lenderDetails'] != null ? LenderDetails.fromJson(json['lenderDetails']) : null)!;

    if (json['repaymentDetails'] != null) {
      _repaymentDetails = <RepaymentDetails>[];
      json['repaymentDetails'].forEach((v) {
        _repaymentDetails.add(RepaymentDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicationId'] = _applicationId;
    data['ApplicantId'] = _applicantId;
    data['EmployerId'] = _employerId;
    data['ApplicationTypeId'] = _applicationTypeId;
    data['ApplicationType'] = _applicationType;
    data['LoanAmount'] = _loanAmount;
    data['EMI'] = _eMI;
    data['ProcessingFee'] = _processingFee;
    data['InterestRate'] = _interestRate;
    data['PreEMI'] = _preEMI;
    data['DisbursalAmount'] = _disbursalAmount;
    data['EMICount'] = _eMICount;
    data['PaidEMICount'] = _paidEMICount;
    data['DiscountOnFee'] = _discountOnFee;
    data['DiscountOnInterest'] = _discountOnInterest;
    data['LenderName'] = _lenderName;
    data['LoanStatus'] = _loanStatus;
    data['LoanStatusId'] = _loanStatusId;
    data['CurrentStatusId'] = _currentStatusId;
    data['Remarks'] = _remarks;
    data['Purpose'] = _purpose;
    data['EMIStartFrom'] = _eMIStartFrom;
    data['EMIEnding'] = _eMIEnding;
    data['AppliedOn'] = _appliedOn;
    data['DisbursedOn'] = _disbursedOn;
    data['loanClosureDetails'] = _loanClosureDetails.toJson();
    data['lenderDetails'] = _lenderDetails.toJson();
    data['repaymentDetails'] = _repaymentDetails.map((v) => v.toJson()).toList();
    return data;
  }
}

class LoanClosureDetails {
  LoanClosureDetails();

  int _applicationId = 0;
  double _totalPenaltyPending = 0.0;
  double _totalPrincipalPending = 0.0;
  double _totalInterestPending = 0.0;
  double _dailyInterest = 0.0;
  String _createdOn = "";
  LoanClosureConfirmation _loanClosureConfirmation = LoanClosureConfirmation();

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  double get getTotalPenaltyPending => _totalPenaltyPending;

  set setTotalPenaltyPending(double value) {
    _totalPenaltyPending = value;
  }

  double get getTotalPrincipalPending => _totalPrincipalPending;

  set setTotalPrincipalPending(double value) {
    _totalPrincipalPending = value;
  }

  double get getTotalInterestPending => _totalInterestPending;

  set setTotalInterestPending(double value) {
    _totalInterestPending = value;
  }

  double get getDailyInterest => _dailyInterest;

  set setDailyInterest(double value) {
    _dailyInterest = value;
  }

  String get getCreatedOn => _createdOn;

  set setCreatedOn(String value) {
    _createdOn = value;
  }

  LoanClosureConfirmation get getLoanClosureConfirmation => _loanClosureConfirmation;

  set setLoanClosureConfirmation(LoanClosureConfirmation value) {
    _loanClosureConfirmation = value;
  }

  LoanClosureDetails.fromJson(Map<String, dynamic> json) {
    _applicationId = json['ApplicationId'];
    _totalPenaltyPending = json['TotalPenaltyPending'];
    _totalPrincipalPending = json['TotalPrincipalPending'];
    _totalInterestPending = json['TotalInterestPending'];
    _dailyInterest = json['DailyInterest'];
    _createdOn = json['CreatedOn'];
    _loanClosureConfirmation = (json['loanClosureConfirmation'] != null ? LoanClosureConfirmation.fromJson(json['loanClosureConfirmation']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicationId'] = _applicationId;
    data['TotalPenaltyPending'] = _totalPenaltyPending;
    data['TotalPrincipalPending'] = _totalPrincipalPending;
    data['TotalInterestPending'] = _totalInterestPending;
    data['DailyInterest'] = _dailyInterest;
    data['CreatedOn'] = _createdOn;
    data['loanClosureConfirmation'] = _loanClosureConfirmation.toJson();
    return data;
  }
}

class LoanClosureConfirmation {
  LoanClosureConfirmation();

  int _applicationId = 0;
  String _transactionRef = "";
  String _paymentMadeOn = "";
  double _amountReceived = 0.0;
  String _closureDate = "";
  String _noDuesCertificate = "";
  bool _isLoanClosed = false;

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  String get getTransactionRef => _transactionRef;

  set setTransactionRef(String value) {
    _transactionRef = value;
  }

  String get getPaymentMadeOn => _paymentMadeOn;

  set setPaymentMadeOn(String value) {
    _paymentMadeOn = value;
  }

  double get getAmountReceived => _amountReceived;

  set setAmountReceived(double value) {
    _amountReceived = value;
  }

  String get getClosureDate => _closureDate;

  set setClosureDate(String value) {
    _closureDate = value;
  }

  String get getNoDuesCertificate => _noDuesCertificate;

  set setNoDuesCertificate(String value) {
    _noDuesCertificate = value;
  }

  bool get getIsLoanClosed => _isLoanClosed;

  set setIsLoanClosed(bool value) {
    _isLoanClosed = value;
  }

  LoanClosureConfirmation.fromJson(Map<String, dynamic> json) {
    _applicationId = json['ApplicationId'];
    _transactionRef = json['TransactionRef'];
    _paymentMadeOn = json['PaymentMadeOn'];
    _amountReceived = json['AmountReceived'];
    _closureDate = json['ClosureDate'];
    _noDuesCertificate = json['NoDuesCertificate'];
    _isLoanClosed = json['IsLoanClosed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicationId'] = _applicationId;
    data['TransactionRef'] = _transactionRef;
    data['PaymentMadeOn'] = _paymentMadeOn;
    data['AmountReceived'] = _amountReceived;
    data['ClosureDate'] = _closureDate;
    data['NoDuesCertificate'] = _noDuesCertificate;
    data['IsLoanClosed'] = _isLoanClosed;
    return data;
  }
}

class LenderDetails {
  LenderDetails();

  int _id = 0;
  int _bankId = 0;
  String _lenderName = "";
  String _lenderEmail1 = "";
  String _lenderEmail2 = "";
  String _lenderMobile1 = "";
  String _lenderMobile2 = "";
  String _lenderAddress = "";
  String _beneficiaryName = "";
  String _beneficiaryAccountNumber = "";
  String _bankName = "";
  String _iFSCCode = "";
  String _branchName = "";
  String _beneficiaryAddress = "";
  String _standardTerms = "";

  int get getId => _id;

  set setId(int value) {
    _id = value;
  }

  int get getBankId => _bankId;

  set setBankId(int value) {
    _bankId = value;
  }

  String get getLenderName => _lenderName;

  set setLenderName(String value) {
    _lenderName = value;
  }

  String get getLenderEmail1 => _lenderEmail1;

  set setLenderEmail1(String value) {
    _lenderEmail1 = value;
  }

  String get getLenderEmail2 => _lenderEmail2;

  set setLenderEmail2(String value) {
    _lenderEmail2 = value;
  }

  String get getLenderMobile1 => _lenderMobile1;

  set setLenderMobile1(String value) {
    _lenderMobile1 = value;
  }

  String get getLenderMobile2 => _lenderMobile2;

  set setLenderMobile2(String value) {
    _lenderMobile2 = value;
  }

  String get getLenderAddress => _lenderAddress;

  set setLenderAddress(String value) {
    _lenderAddress = value;
  }

  String get getBeneficiaryName => _beneficiaryName;

  set setBeneficiaryName(String value) {
    _beneficiaryName = value;
  }

  String get getBeneficiaryAccountNumber => _beneficiaryAccountNumber;

  set setBeneficiaryAccountNumber(String value) {
    _beneficiaryAccountNumber = value;
  }

  String get getBankName => _bankName;

  set setBankName(String value) {
    _bankName = value;
  }

  String get getIFSCCode => _iFSCCode;

  set setIFSCCode(String value) {
    _iFSCCode = value;
  }

  String get getBranchName => _branchName;

  set setBranchName(String value) {
    _branchName = value;
  }

  String get getBeneficiaryAddress => _beneficiaryAddress;

  set setBeneficiaryAddress(String value) {
    _beneficiaryAddress = value;
  }

  String get getStandardTerms => _standardTerms;

  set setStandardTerms(String value) {
    _standardTerms = value;
  }

  LenderDetails.fromJson(Map<String, dynamic> json) {
    _id = json['Id'];
    _bankId = json['BankId'];
    _lenderName = json['Lender_Name'];
    _lenderEmail1 = json['Lender_Email1'];
    _lenderEmail2 = json['Lender_Email2'];
    _lenderMobile1 = json['Lender_Mobile1'];
    _lenderMobile2 = json['Lender_Mobile2'];
    _lenderAddress = json['Lender_Address'];
    _beneficiaryName = json['Beneficiary_Name'];
    _beneficiaryAccountNumber = json['Beneficiary_Account_Number'];
    _bankName = json['Bank_Name'];
    _iFSCCode = json['IFSC_Code'];
    _branchName = json['Branch_Name'];
    _beneficiaryAddress = json['Beneficiary_Address'];
    _standardTerms = json['Standard_Terms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = _id;
    data['BankId'] = _bankId;
    data['Lender_Name'] = _lenderName;
    data['Lender_Email1'] = _lenderEmail1;
    data['Lender_Email2'] = _lenderEmail2;
    data['Lender_Mobile1'] = _lenderMobile1;
    data['Lender_Mobile2'] = _lenderMobile2;
    data['Lender_Address'] = _lenderAddress;
    data['Beneficiary_Name'] = _beneficiaryName;
    data['Beneficiary_Account_Number'] = _beneficiaryAccountNumber;
    data['Bank_Name'] = _bankName;
    data['IFSC_Code'] = _iFSCCode;
    data['Branch_Name'] = _branchName;
    data['Beneficiary_Address'] = _beneficiaryAddress;
    data['Standard_Terms'] = _standardTerms;
    return data;
  }
}

class RepaymentDetails {
  RepaymentDetails();

  int _id = 0;
  int _applicationId = 0;
  int _months = 0;
  double _interest = 0.0;
  double _moratoriumInterest = 0.0;
  double _totalRepayment = 0.0;
  double _totalLateFee = 0.0;
  double _balance = 0.0;
  double _principal = 0.0;
  bool _status = false;
  String _transactionRef = "";
  String _payDate = "";
  String _eMIPaidOn = "";
  String _createdOn = "";

  int get getId => _id;

  set setId(int value) {
    _id = value;
  }

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  int get getMonths => _months;

  set setMonths(int value) {
    _months = value;
  }

  double get getInterest => _interest;

  set setInterest(double value) {
    _interest = value;
  }

  double get getMoratoriumInterest => _moratoriumInterest;

  set setMoratoriumInterest(double value) {
    _moratoriumInterest = value;
  }

  double get getTotalRepayment => _totalRepayment;

  set setTotalRepayment(double value) {
    _totalRepayment = value;
  }

  double get getTotalLateFee => _totalLateFee;

  set setTotalLateFee(double value) {
    _totalLateFee = value;
  }

  double get getBalance => _balance;

  set setBalance(double value) {
    _balance = value;
  }

  double get getPrincipal => _principal;

  set setPrincipal(double value) {
    _principal = value;
  }

  bool get getStatus => _status;

  set setStatus(bool value) {
    _status = value;
  }

  String get getTransactionRef => _transactionRef;

  set setTransactionRef(String value) {
    _transactionRef = value;
  }

  String get getPayDate => _payDate;

  set setPayDate(String value) {
    _payDate = value;
  }

  String get getEMIPaidOn => _eMIPaidOn;

  set setEMIPaidOn(String value) {
    _eMIPaidOn = value;
  }

  String get getCreatedOn => _createdOn;

  set setCreatedOn(String value) {
    _createdOn = value;
  }

  RepaymentDetails.fromJson(Map<String, dynamic> json) {
    _id = json['Id'];
    _applicationId = json['ApplicationId'];
    _months = json['Months'];
    _interest = json['Interest'];
    _moratoriumInterest = json['MoratoriumInterest'];
    _totalRepayment = json['TotalRepayment'];
    _totalLateFee = json['TotalLateFee'];
    _balance = json['Balance'];
    _principal = json['Principal'];
    _status = json['Status'];
    _transactionRef = json['Transaction_Ref'];
    _payDate = json['PayDate'];
    _eMIPaidOn = json['EMIPaidOn'];
    _createdOn = json['CreatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = _id;
    data['ApplicationId'] = _applicationId;
    data['Months'] = _months;
    data['Interest'] = _interest;
    data['MoratoriumInterest'] = _moratoriumInterest;
    data['TotalRepayment'] = _totalRepayment;
    data['TotalLateFee'] = _totalLateFee;
    data['Balance'] = _balance;
    data['Principal'] = _principal;
    data['Status'] = _status;
    data['Transaction_Ref'] = _transactionRef;
    data['PayDate'] = _payDate;
    data['EMIPaidOn'] = _eMIPaidOn;
    data['CreatedOn'] = _createdOn;
    return data;
  }
}
