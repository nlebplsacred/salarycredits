import 'dart:core';
import 'loan_model.dart';
import 'master_data_model.dart';

class PersonalDataModel {
  PersonalDataModel();

  Applicant _applicant = Applicant();
  BankAccount _bankAccount = BankAccount();
  MasterData _masterData = MasterData();

  Applicant get getApplicant => _applicant;

  set setApplicant(Applicant value) {
    _applicant = value;
  }

  BankAccount get getBankAccount => _bankAccount;

  set setBankAccount(BankAccount value) {
    _bankAccount = value;
  }

  MasterData get getMasterData => _masterData;

  set setMasterData(MasterData value) {
    _masterData = value;
  }

  PersonalDataModel.fromJson(Map<String, dynamic> json) {
    _applicant = (json['Applicant'] != null ? Applicant.fromJson(json['Applicant']) : null)!;
    _bankAccount = (json['BankAccount'] != null ? BankAccount.fromJson(json['BankAccount']) : null)!;
    _masterData = (json['MasterData'] != null ? MasterData.fromJson(json['MasterData']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Applicant'] = _applicant.toJson();
    data['BankAccount'] = _bankAccount.toJson();
    data['MasterData'] = _masterData.toJson();
    return data;
  }
}
