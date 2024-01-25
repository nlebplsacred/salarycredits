class LoanProcessPending {
  LoanProcessPending();

  String _loanReference = "";
  String _loanAgreement = "";
  String _loanECS = "";

  String get getLoanReference => _loanReference;

  set setLoanReference(String loanReference) => _loanReference = loanReference;

  String get getLoanAgreement => _loanAgreement;

  set setLoanAgreement(String loanAgreement) => _loanAgreement = loanAgreement;

  String get getLoanECS => _loanECS;

  set setLoanECS(String loanECS) => _loanECS = loanECS;

  LoanProcessPending.fromJson(Map<String, dynamic> json) {
    _loanReference = json['LoanReference'];
    _loanAgreement = json['LoanAgreement'];
    _loanECS = json['LoanECS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LoanReference'] = _loanReference;
    data['LoanAgreement'] = _loanAgreement;
    data['LoanECS'] = _loanECS;
    return data;
  }


}
