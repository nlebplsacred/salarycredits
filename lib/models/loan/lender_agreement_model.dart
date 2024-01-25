class LenderAgreementModel {
  LenderAgreementModel();

  int _agreementId = 0;
  int _applicationId = 0;
  int _applicationTypeId = 0;
  String _agreementText = "";
  String _agreementFilePath = "";
  int _otp = 0;
  int _bankId = 0;
  bool _accepted = false;
  String _status = "";
  String _agreementLink = "";
  String _acceptedOn = "";
  String _createdOn = "";
  TermsAcceptanceProof _termsAcceptanceProof = TermsAcceptanceProof();

  int get getAgreementId => _agreementId;

  set setAgreementId(int agreementId) => _agreementId = agreementId;

  int get getApplicationId => _applicationId;

  set setApplicationId(int applicationId) => _applicationId = applicationId;

  int get getApplicationTypeId => _applicationTypeId;

  set setApplicationTypeId(int applicationTypeId) => _applicationTypeId = applicationTypeId;

  String get getAgreementText => _agreementText;

  set setAgreementText(String agreementText) => _agreementText = agreementText;

  String get getAgreementFilePath => _agreementFilePath;

  set setAgreementFilePath(String agreementFilePath) => _agreementFilePath = agreementFilePath;

  int get getOTP => _otp;

  set setOTP(int oTP) => _otp = oTP;

  int get getBankId => _bankId;

  set setBankId(int bankId) => _bankId = bankId;

  bool get getAccepted => _accepted;

  set setAccepted(bool accepted) => _accepted = accepted;

  String get getStatus => _status;

  set setStatus(String status) => _status = status;

  String get getAgreementLink => _agreementLink;

  set setAgreementLink(String agreementLink) => _agreementLink = agreementLink;

  String get getAcceptedOn => _acceptedOn;

  set setAcceptedOn(String acceptedOn) => _acceptedOn = acceptedOn;

  String get getCreatedOn => _createdOn;

  set setCreatedOn(String createdOn) => _createdOn = createdOn;

  TermsAcceptanceProof get getTermsAcceptanceProof => _termsAcceptanceProof;

  set setTermsAcceptanceProof(TermsAcceptanceProof value) {
    _termsAcceptanceProof = value;
  }

  LenderAgreementModel.fromJson(Map<String, dynamic> json) {
    _agreementId = json['AgreementId'];
    _applicationId = json['ApplicationId'];
    _applicationTypeId = json['ApplicationTypeId'];
    _agreementText = json['AgreementText'];
    _agreementFilePath = json['AgreementFilePath'];
    _otp = json['OTP'];
    _bankId = json['BankId'];
    _accepted = json['Accepted'];
    _status = json['Status'];
    _agreementLink = json['AgreementLink'];
    _acceptedOn = json['AcceptedOn'];
    _createdOn = json['CreatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AgreementId'] = _agreementId;
    data['ApplicationId'] = _applicationId;
    data['ApplicationTypeId'] = _applicationTypeId;
    data['AgreementText'] = _agreementText;
    data['AgreementFilePath'] = _agreementFilePath;
    data['OTP'] = _otp;
    data['BankId'] = _bankId;
    data['Accepted'] = _accepted;
    data['Status'] = _status;
    data['AgreementLink'] = _agreementLink;
    data['AcceptedOn'] = _acceptedOn;
    data['CreatedOn'] = _createdOn;
    data['termsAcceptanceProof'] = _termsAcceptanceProof.toJson();
    return data;
  }
}

class TermsAcceptanceProof {
  TermsAcceptanceProof();

  int _id = 0;
  int _applicationId = 0;
  String _ipAddress = "";
  String _computerName = "";
  String _browserName = "";
  String _osName = "";
  String _screenshotUrl = "";
  String _accessedUrl = "";
  String _acceptanceDateTime = "";
  double _loanAmount = 0;
  double _emi = 0;
  int _tenure = 0;
  double _processingFee = 0;
  double _premiumAmount = 0;
  String _lenderName = "";
  int _bankId = 0;

  int get getId => _id;

  set setId(int value) {
    _id = value;
  }

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  String get getIPAddress => _ipAddress;

  set setIPAddress(String value) {
    _ipAddress = value;
  }

  String get getComputerName => _computerName;

  set setComputerName(String value) {
    _computerName = value;
  }

  String get getBrowserName => _browserName;

  set setBrowserName(String value) {
    _browserName = value;
  }

  String get getOSName => _osName;

  set setOSName(String value) {
    _osName = value;
  }

  String get getScreenshotUrl => _screenshotUrl;

  set setScreenshotUrl(String value) {
    _screenshotUrl = value;
  }

  String get getAccessedUrl => _accessedUrl;

  set setAccessedUrl(String value) {
    _accessedUrl = value;
  }

  String get getAcceptanceDateTime => _acceptanceDateTime;

  set setAcceptanceDateTime(String value) {
    _acceptanceDateTime = value;
  }

  double get getLoanAmount => _loanAmount;

  set setLoanAmount(double value) {
    _loanAmount = value;
  }

  double get getEmi => _emi;

  set setEmi(double value) {
    _emi = value;
  }

  int get getTenure => _tenure;

  set setTenure(int value) {
    _tenure = value;
  }

  double get getProcessingFee => _processingFee;

  set setProcessingFee(double value) {
    _processingFee = value;
  }

  double get getPremiumAmount => _premiumAmount;

  set setPremiumAmount(double value) {
    _premiumAmount = value;
  }

  String get getLenderName => _lenderName;

  set setLenderName(String value) {
    _lenderName = value;
  }

  int get getBankId => _bankId;

  set setBankId(int value) {
    _bankId = value;
  }

  TermsAcceptanceProof.fromJson(Map<String, dynamic> json) {
    _id = json["Id"];
    _applicationId = json["ApplicationId"];
    _ipAddress = json["IP_Address"];
    _computerName = json["Computer_Name"];
    _browserName = json["Browser_Name"];
    _osName = json["OS_Name"];
    _screenshotUrl = json["Screenshot_Url"];
    _accessedUrl = json["Accessed_Url"];
    _acceptanceDateTime = json["Acceptance_DateTime"];
    _loanAmount = json["LoanAmount"];
    _emi = json["EMI"];
    _tenure = json["Tenure"];
    _processingFee = json["ProcessingFee"];
    _premiumAmount = json["PremiumAmount"];
    _lenderName = json["LenderName"];
    _bankId = json["BankId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Id"] = _id;
    data["ApplicationId"] = _applicationId;
    data["IP_Address"] = _ipAddress;
    data["Computer_Name"] = _computerName;
    data["Browser_Name"] = _browserName;
    data["OS_Name"] = _osName;
    data["Screenshot_Url"] = _screenshotUrl;
    data["Accessed_Url"] = _accessedUrl;
    data["Acceptance_DateTime"] = _acceptanceDateTime;
    data["LoanAmount"] = _loanAmount;
    data["EMI"] = _emi;
    data["Tenure"] = _tenure;
    data["ProcessingFee"] = _processingFee;
    data["PremiumAmount"] = _premiumAmount;
    data["LenderName"] = _lenderName;
    data["BankId"] = _bankId;
    return data;
  }
}
