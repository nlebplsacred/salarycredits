class Employer {
  Employer();

  int _employerId = 0;
  int _employerTypeId = 0;
  String _employerName = "";
  String _companyAddressLine1 = "";
  String _companyAddressLine2 = "";
  int _companyPin = 0;
  String _companyCity = "";
  String _companyState = "";
  String _companyLogo = "";
  String _hRName = "";
  String _hREmail = "";
  String _hRMobile = "";
  String _hRPhone = "";
  String _termsAgreement = "";

  int get getEmployerId => _employerId;

  set setEmployerId(int value) {
    _employerId = value;
  }

  int get getEmployerTypeId => _employerTypeId;

  set setEmployerTypeId(int value) {
    _employerTypeId = value;
  }

  String get getTermsAgreement => _termsAgreement;

  set setTermsAgreement(String value) {
    _termsAgreement = value;
  }

  String get getHRPhone => _hRPhone;

  set setHRPhone(String value) {
    _hRPhone = value;
  }

  String get getHRMobile => _hRMobile;

  set setHRMobile(String value) {
    _hRMobile = value;
  }

  String get getHREmail => _hREmail;

  set setHREmail(String value) {
    _hREmail = value;
  }

  String get getHRName => _hRName;

  set setHRName(String value) {
    _hRName = value;
  }

  String get getCompanyLogo => _companyLogo;

  set setCompanyLogo(String value) {
    _companyLogo = value;
  }

  String get getCompanyState => _companyState;

  set setCompanyState(String value) {
    _companyState = value;
  }

  String get getCompanyCity => _companyCity;

  set setCompanyCity(String value) {
    _companyCity = value;
  }

  int get getCompanyPin => _companyPin;

  set setCompanyPin(int value) {
    _companyPin = value;
  }

  String get getCompanyAddressLine2 => _companyAddressLine2;

  set setCompanyAddressLine2(String value) {
    _companyAddressLine2 = value;
  }

  String get getCompanyAddressLine1 => _companyAddressLine1;

  set setCompanyAddressLine1(String value) {
    _companyAddressLine1 = value;
  }

  String get getEmployerName => _employerName;

  set setEmployerName(String value) {
    _employerName = value;
  }

  Employer.fromJson(Map<String, dynamic> json) {
    _employerId = json['EmployerId'];
    _employerTypeId = json['EmployerTypeId'];
    _employerName = json['EmployerName'];
    _companyAddressLine1 = json['CompanyAddressLine1'];
    _companyAddressLine2 = json['CompanyAddressLine2'];
    _companyPin = json['CompanyPin'];
    _companyCity = json['CompanyCity'];
    _companyState = json['CompanyState'];
    _companyLogo = (json['CompanyLogo'])!;
    _hRName = json['HR_Name'];
    _hREmail = json['HR_Email'];
    _hRMobile = json['HR_Mobile'];
    _hRPhone = json['HR_Phone'];
    _termsAgreement = json['Terms_Agreement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EmployerId'] = _employerId;
    data['EmployerTypeId'] = _employerTypeId;
    data['EmployerName'] = _employerName;
    data['CompanyAddressLine1'] = _companyAddressLine1;
    data['CompanyAddressLine2'] = _companyAddressLine2;
    data['CompanyPin'] = _companyPin;
    data['CompanyCity'] = _companyCity;
    data['CompanyState'] = _companyState;
    data['CompanyLogo'] = _companyLogo;
    data['HR_Name'] = _hRName;
    data['HR_Email'] = _hREmail;
    data['HR_Mobile'] = _hRMobile;
    data['HR_Phone'] = _hRPhone;
    data['Terms_Agreement'] = _termsAgreement;
    return data;
  }
}
