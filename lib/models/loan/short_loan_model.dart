import 'package:salarycredits/models/loan/short_loan_details.dart';

class ShortLoanModel {

  ShortLoanModel();

  List<ShortLoanDetails> _shortLoanList = [];

  List<ShortLoanDetails> get getShortLoanList => _shortLoanList;

  set setShortLoanList(List<ShortLoanDetails> shortLoanList) => _shortLoanList = shortLoanList;

  ShortLoanModel.fromJson(Map<String, dynamic> json) {
    if (json['ShortLoanList'] != null) {
      _shortLoanList = <ShortLoanDetails>[];
      json['ShortLoanList'].forEach((v) {
        _shortLoanList.add(ShortLoanDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ShortLoanList'] = _shortLoanList.map((v) => v.toJson()).toList();
    return data;
  }
}