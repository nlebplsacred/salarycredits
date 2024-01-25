import 'dart:convert';

List<LoginResponseModel> userFromJson(String str) => List<LoginResponseModel>.from(json.decode(str).map((x) => LoginResponseModel.fromJson(x)));

String userToJson(List<LoginResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginResponseModel {
  int? statusId;
  String? message;
  int? applicantId;
  String? userEmail;
  String? firstName;
  String? lastName;
  String? dOB;
  String? workingSince;
  String? userPassword;
  String? confirmPassword;
  String? newPassword;
  int? mPassCode;
  bool? isRemember;
  int? userTypeId;
  int? accountTypeId;
  String? languageCode;
  int? employerTypeId;
  String? companyLogo;
  String? companyName;
  String? entity;
  String? dssgIds;
  int? approverId;
  int? bankId;
  int? employerId;
  String? employeeId;
  String? employeeNo;
  String? mobile;
  int? profilePhotoId;
  String? profilePicture;
  double? grossIncome;
  double? netPayableSalary;
  bool? isAppInstall;
  bool? isMobileVerified;
  bool? isResigned;
  bool? isActive;

  LoginResponseModel(
      {this.userEmail,
      this.firstName,
      this.lastName,
      this.dOB,
      this.workingSince,
      this.applicantId,
      this.userPassword,
      this.confirmPassword,
      this.newPassword,
      this.mPassCode,
      this.isRemember,
      this.userTypeId,
      this.accountTypeId,
      this.languageCode,
      this.employerTypeId,
      this.companyLogo,
      this.companyName,
      this.entity,
      this.dssgIds,
      this.approverId,
      this.bankId,
      this.employerId,
      this.employeeId,
      this.employeeNo,
      this.mobile,
      this.profilePhotoId,
      this.profilePicture,
      this.grossIncome,
      this.netPayableSalary,
      this.statusId,
      this.message,
      this.isAppInstall,
      this.isMobileVerified,
      this.isResigned,
      this.isActive});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    statusId = json['StatusId'];
    message = json['Message'];
    applicantId = json['ApplicantId'];
    userEmail = json['UserEmail'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    dOB = json['DOB'];
    workingSince = json['WorkingSince'];
    userPassword = json['userPassword'];
    confirmPassword = json['confirmPassword'];
    newPassword = json['NewPassword'];
    mPassCode = json['MPassCode'];
    isRemember = json['IsRemember'];
    userTypeId = json['UserTypeId'];
    accountTypeId = json['AccountTypeId'];
    languageCode = json['LanguageCode'];
    employerTypeId = json['EmployerTypeId'];
    companyLogo = json['CompanyLogo'];
    companyName = json['CompanyName'];
    entity = json['Entity'];
    dssgIds = json['Dssg_Ids'];
    approverId = json['ApproverId'];
    bankId = json['BankId'];
    employerId = json['EmployerId'];
    employeeId = json['EmployeeId'];
    employeeNo = json['EmployeeNo'];
    mobile = json['Mobile'];
    profilePhotoId = json['ProfilePhotoId'];
    profilePicture = json['ProfilePicture'];
    grossIncome = json['GrossIncome'];
    netPayableSalary = json['Net_payable_salary'];
    isAppInstall = json['IsAppInstall'];
    isMobileVerified = json['IsMobileVerified'];
    isResigned = json['IsResigned'];
    isActive = json['IsActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["StatusId"] = statusId;
    data['Message'] = message;
    data['ApplicantId'] = applicantId;
    data['UserEmail'] = userEmail;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['DOB'] = dOB;
    data['WorkingSince'] = workingSince;
    data['userPassword'] = userPassword;
    data['confirmPassword'] = confirmPassword;
    data['NewPassword'] = newPassword;
    data['MPassCode'] = mPassCode;
    data['IsRemember'] = isRemember;
    data['UserTypeId'] = userTypeId;
    data['AccountTypeId'] = accountTypeId;
    data['LanguageCode'] = languageCode;
    data['EmployerTypeId'] = employerTypeId;
    data['CompanyLogo'] = companyLogo;
    data['CompanyName'] = companyName;
    data['Entity'] = entity;
    data['Dssg_Ids'] = dssgIds;
    data['ApproverId'] = approverId;
    data['BankId'] = bankId;
    data['EmployerId'] = employerId;
    data['EmployeeId'] = employeeId;
    data['EmployeeNo'] = employeeNo;
    data['Mobile'] = mobile;
    data['ProfilePhotoId'] = profilePhotoId;
    data['ProfilePicture'] = profilePicture;
    data['GrossIncome'] = grossIncome;
    data['Net_payable_salary'] = netPayableSalary;
    data['IsAppInstall'] = isAppInstall;
    data['IsMobileVerified'] = isMobileVerified;
    data['IsResigned'] = isResigned;
    data['IsActive'] = isActive;

    return data;
  }
}
