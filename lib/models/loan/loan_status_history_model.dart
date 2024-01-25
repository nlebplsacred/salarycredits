import 'loan_status_model.dart';

class LoanStatusHistoryModel {
  LoanStatusHistoryModel();

  List<LoanStatusModel> _actionHistories = [];

  List<LoanStatusModel> get getActionHistories => _actionHistories;

  set setActionHistories(List<LoanStatusModel> actionHistories) => _actionHistories = actionHistories;

  LoanStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['actionHistories'] != null) {
      _actionHistories = <LoanStatusModel>[];
      json['actionHistories'].forEach((v) {
        _actionHistories.add(LoanStatusModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['actionHistories'] = _actionHistories.map((v) => v.toJson()).toList();
    return data;
  }
}
