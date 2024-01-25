class AskQueryModel {

  AskQueryModel();

  int _applicantId = 0;
  String _message = "";

  int get getApplicantId => _applicantId;

  set setApplicantId(int value) {
    _applicantId = value;
  }

  String get getMessage => _message;

  set setMessage(String value) {
    _message = value;
  }

  AskQueryModel.fromJson(Map<String, dynamic> json) {
    _applicantId = json["ApplicantId"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["ApplicantId"] = _applicantId;
    data["Message"] = _message;
    return data;
  }

}
