class LenderConsent {
  LenderConsent();

  int _id = 0;
  int _bankId = 0;
  String _bankName = "";
  String _consentName = "";
  String _consentDescription = "";

  int get getId => _id;

  set setId(int value) {
    _id = value;
  }

  int get getBankId => _bankId;

  set setBankId(int value) {
    _bankId = value;
  }

  String get getBankName => _bankName;

  set setBankName(String value){
    _bankName = value;
  }

  String get getConsentName => _consentName;

  set setConsentName(String value) {
    _consentName = value;
  }

  String get getConsentDescription => _consentDescription;

  set setConsentDescription(String value) {
    _consentDescription = value;
  }

  LenderConsent.fromJson(Map<String, dynamic> json) {
    _id = json['Id'];
    _bankId = json['BankId'];
    _bankName = json['BankName'];
    _consentName = json['ConsentName'];
    _consentDescription = json['ConsentDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = _id;
    data['BankId'] = _bankId;
    data['BankName'] = _bankName;
    data['ConsentName'] = _consentName;
    data['ConsentDescription'] = _consentDescription;
    return data;
  }


}
