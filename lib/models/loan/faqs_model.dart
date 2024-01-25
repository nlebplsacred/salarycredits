class FAQBaseModel {
  FAQBaseModel();

  List<FaqsList> _faqsList = [];

  List<FaqsList> get getFaqsList => _faqsList;

  set setFaqsList(List<FaqsList> faqsList) => _faqsList = faqsList;

  FAQBaseModel.fromJson(Map<String, dynamic> json) {
    if (json['faqsList'] != null) {
      _faqsList = <FaqsList>[];
      json['faqsList'].forEach((v) {
        _faqsList.add(FaqsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['faqsList'] = _faqsList.map((v) => v.toJson()).toList();
    return data;
  }
}

class FaqsList {
  FaqsList();

  int _id = 0;
  String _question = "";
  String _answers = "";
  bool _isActive = false;

  int? get getId => _id;

  set setId(int id) => _id = id;

  String get getQuestion => _question;

  set setQuestion(String question) => _question = question;

  String get getAnswers => _answers;

  set setAnswers(String answers) => _answers = answers;

  bool get getIsActive => _isActive;

  set setIsActive(bool isActive) => _isActive = isActive;

  FaqsList.fromJson(Map<String, dynamic> json) {
    _id = json['Id'];
    _question = json['Question'];
    _answers = json['Answers'];
    _isActive = json['IsActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = _id;
    data['Question'] = _question;
    data['Answers'] = _answers;
    data['IsActive'] = _isActive;
    return data;
  }
}
