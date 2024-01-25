class EMICalculatorBaseModel {
  EMICalculatorBaseModel();

  int _tenure = 0;
  double _eMI = 0.0;
  double _netPayableAmount = 0.0;
  double _payableInterest = 0.0;
  int _id = 0;
  int _employerId = 0;
  int _employerTypeId = 0;
  double _loanAmount = 0.0;
  int _bankId = 0;
  double _maxEligibility = 0.0;
  double _maxEligibilityByTenure = 0;
  int _minLoanTenure = 0;
  int _maxLoanTenure = 0;
  double _minLoanAmount = 0.0;
  double _maxLoanAmount = 0.0;
  double _minIncome = 0.0;
  double _maxIncome = 0.0;
  double _interestRate = 0.0;
  double _processingFee = 0.0;
  double _discountOnFee = 0.0;
  double _discountOnInterest = 0.0;
  int _fOIR = 0;
  List<Repayments> _repayments = [];

  List<Repayments> get getRepayments => _repayments;

  set setRepayments(List<Repayments> repayments) => _repayments = repayments;

  int get getTenure => _tenure;

  set setTenure(int tenure) => _tenure = tenure;

  double get getEMI => _eMI;

  set setEMI(double eMI) => _eMI = eMI;

  double get getNetPayableAmount => _netPayableAmount;

  set setNetPayableAmount(double netPayableAmount) => _netPayableAmount = netPayableAmount;

  double get getPayableInterest => _payableInterest;

  set setPayableInterest(double payableInterest) => _payableInterest = payableInterest;

  int get getId => _id;

  set setId(int id) => _id = id;

  int get getEmployerId => _employerId;

  set setEmployerId(int employerId) => _employerId = employerId;

  int get getEmployerTypeId => _employerTypeId;

  set setEmployerTypeId(int employerTypeId) => _employerTypeId = employerTypeId;

  double get getLoanAmount => _loanAmount;

  set setLoanAmount(double loanAmount) => _loanAmount = loanAmount;

  int get getBankId => _bankId;

  set setBankId(int bankId) => _bankId = bankId;

  double get getMaxEligibility => _maxEligibility;

  set setMaxEligibility(double maxEligibility) => _maxEligibility = maxEligibility;

  double get getMaxEligibilityByTenure => _maxEligibilityByTenure;

  set setMaxEligibilityByTenure(double maxEligibilityByTenure) => _maxEligibilityByTenure = maxEligibilityByTenure;

  int get getMinLoanTenure => _minLoanTenure;

  set setMinLoanTenure(int minLoanTenure) => _minLoanTenure = minLoanTenure;

  int get getMaxLoanTenure => _maxLoanTenure;

  set setMaxLoanTenure(int maxLoanTenure) => _maxLoanTenure = maxLoanTenure;

  double get getMinLoanAmount => _minLoanAmount;

  set setMinLoanAmount(double minLoanAmount) => _minLoanAmount = minLoanAmount;

  double get getMaxLoanAmount => _maxLoanAmount;

  set setMaxLoanAmount(double maxLoanAmount) => _maxLoanAmount = maxLoanAmount;

  double get getMinIncome => _minIncome;

  set setMinIncome(double minIncome) => _minIncome = minIncome;

  double get getMaxIncome => _maxIncome;

  set setMaxIncome(double maxIncome) => _maxIncome = maxIncome;

  double get getInterestRate => _interestRate;

  set setInterestRate(double interestRate) => _interestRate = interestRate;

  double get getProcessingFee => _processingFee;

  set setProcessingFee(double processingFee) => _processingFee = processingFee;

  double get getDiscountOnFee => _discountOnFee;

  set setDiscountOnFee(double discountOnFee) => _discountOnFee = discountOnFee;

  double get getDiscountOnInterest => _discountOnInterest;

  set setDiscountOnInterest(double discountOnInterest) => _discountOnInterest = discountOnInterest;

  int get getFoir => _fOIR;

  set setFoir(int foir) => _fOIR = foir;

  EMICalculatorBaseModel.fromJson(Map<String, dynamic> json) {
    if (json['Repayments'] != null) {
      _repayments = <Repayments>[];
      json['Repayments'].forEach((v) {
        _repayments.add(Repayments.fromJson(v));
      });
    }
    _tenure = json['Tenure'];
    _eMI = json['EMI'];
    _netPayableAmount = json['NetPayableAmount'];
    _payableInterest = json['PayableInterest'];
    _id = json['Id'];
    _employerId = json['EmployerId'];
    _employerTypeId = json['EmployerTypeId'];
    _loanAmount = json['LoanAmount'];
    _bankId = json['BankId'];
    _maxEligibility = json['MaxEligibility'];
    _maxEligibilityByTenure = json['MaxEligibilityByTenure'];
    _minLoanTenure = json['MinLoanTenure'];
    _maxLoanTenure = json['MaxLoanTenure'];
    _minLoanAmount = json['MinLoanAmount'];
    _maxLoanAmount = json['MaxLoanAmount'];
    _minIncome = json['MinIncome'];
    _maxIncome = json['MaxIncome'];
    _interestRate = json['InterestRate'];
    _processingFee = json['ProcessingFee'];
    _discountOnFee = json['DiscountOnFee'];
    _discountOnInterest = json['DiscountOnInterest'];
    _fOIR = json['FOIR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Repayments'] = _repayments.map((v) => v.toJson()).toList();
    data['Tenure'] = _tenure;
    data['EMI'] = _eMI;
    data['NetPayableAmount'] = _netPayableAmount;
    data['PayableInterest'] = _payableInterest;
    data['Id'] = _id;
    data['EmployerId'] = _employerId;
    data['EmployerTypeId'] = _employerTypeId;
    data['LoanAmount'] = _loanAmount;
    data['BankId'] = _bankId;
    data['MaxEligibility'] = _maxEligibility;
    data['MaxEligibilityByTenure'] = _maxEligibilityByTenure;
    data['MinLoanTenure'] = _minLoanTenure;
    data['MaxLoanTenure'] = _maxLoanTenure;
    data['MinLoanAmount'] = _minLoanAmount;
    data['MaxLoanAmount'] = _maxLoanAmount;
    data['MinIncome'] = _minIncome;
    data['MaxIncome'] = _maxIncome;
    data['InterestRate'] = _interestRate;
    data['ProcessingFee'] = _processingFee;
    data['DiscountOnFee'] = _discountOnFee;
    data['DiscountOnInterest'] = _discountOnInterest;
    data['FOIR'] = _fOIR;
    return data;
  }
}

class Repayments {
  Repayments();

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

  Repayments.fromJson(Map<String, dynamic> json) {
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
    data['PayDate'] = _payDate;
    data['EMIPaidOn'] = _eMIPaidOn;
    data['CreatedOn'] = _createdOn;
    return data;
  }
}

class EMICalculatorRequestModel {
  EMICalculatorRequestModel();

  int _applicantId = 0;
  int _employerId = 0;
  double _netPayableSalary = 0.0;
  double _loanAmount = 0.0;
  int _tenure = 0;

  int get getApplicantId => _applicantId;

  set setApplicantId(int applicantId) => _applicantId = applicantId;

  int get getEmployerId => _employerId;

  set setEmployerId(int employerId) => _employerId = employerId;

  double get getNetPayableSalary => _netPayableSalary;

  set setNetPayableSalary(double netPayableSalary) => _netPayableSalary = netPayableSalary;

  double get getLoanAmount => _loanAmount;

  set setLoanAmount(double loanAmount) => _loanAmount = loanAmount;

  int get getTenure => _tenure;

  set setTenure(int tenure) => _tenure = tenure;

  EMICalculatorRequestModel.fromJson(Map<String, dynamic> json) {
    _applicantId = json['ApplicantId'];
    _employerId = json['EmployerId'];
    _netPayableSalary = json['Net_payable_salary'];
    _loanAmount = json['LoanAmount'];
    _tenure = json['Tenure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicantId'] = _applicantId;
    data['EmployerId'] = _employerId;
    data['Net_payable_salary'] = _netPayableSalary;
    data['LoanAmount'] = _loanAmount;
    data['Tenure'] = _tenure;
    return data;
  }

}
