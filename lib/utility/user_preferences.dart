import 'package:salarycredits/models/login/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserSession {
  Future<void> saveUser(LoginResponseModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("Mobile", user.mobile!);
    prefs.setString("UserEmail", user.userEmail!);
    prefs.setString("FirstName", user.firstName!);
    prefs.setString("LastName", user.lastName!);
    prefs.setString("DOB", user.dOB!);
    prefs.setString("WorkingSince", user.workingSince!);
    prefs.setInt("ApplicantId", user.applicantId!);
    prefs.setString("userPassword", user.userPassword!);
    prefs.setString("confirmPassword", user.confirmPassword!);
    prefs.setString("NewPassword", user.newPassword!);
    prefs.setInt("MPassCode", user.mPassCode!);
    prefs.setBool("IsRemember", user.isRemember!);
    prefs.setInt("UserTypeId", user.userTypeId!);
    prefs.setInt("AccountTypeId", user.accountTypeId!);
    prefs.setString("LanguageCode", user.languageCode!);
    prefs.setInt("EmployerTypeId", user.employerTypeId!);
    prefs.setString("CompanyLogo", user.companyLogo!);
    prefs.setString("CompanyName", user.companyName!);
    prefs.setString("Entity", user.entity!);
    prefs.setString("Dssg_Ids", user.dssgIds!);
    prefs.setInt("ApproverId", user.approverId!);
    prefs.setInt("BankId", user.bankId!);
    prefs.setInt("EmployerId", user.employerId!);
    prefs.setString("EmployeeId", user.employeeId!);
    prefs.setString("EmployeeNo", user.employeeNo!);

    prefs.setInt("ProfilePhotoId", user.profilePhotoId!);
    prefs.setString("ProfilePicture", user.profilePicture!);
    prefs.setDouble("GrossIncome", user.grossIncome!);
    prefs.setDouble("Net_payable_salary", user.netPayableSalary!);
    prefs.setString("Message", user.message!);
    prefs.setBool("IsAppInstall", user.isAppInstall!);
    prefs.setBool("IsMobileVerified", user.isMobileVerified!);
    prefs.setBool("IsResigned", user.isResigned!);
    prefs.setBool("IsActive", user.isActive!);
  }

  Future<LoginResponseModel> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userEmail = prefs.getString("UserEmail");
    String? firstName = prefs.getString("FirstName");
    String? lastName = prefs.getString("LastName");
    String? dOB = prefs.getString("DOB");
    String? workingSince = prefs.getString("WorkingSince");
    int? applicantId = prefs.getInt("ApplicantId");
    String? userPassword = prefs.getString("userPassword");
    String? confirmPassword = prefs.getString("confirmPassword");
    String? newPassword = prefs.getString("NewPassword");
    int? mPassCode = prefs.getInt("MPassCode");
    bool? isRemember = prefs.getBool("IsRemember");
    int? userTypeId = prefs.getInt("UserTypeId");
    int? accountTypeId = prefs.getInt("AccountTypeId");
    String? languageCode = prefs.getString("LanguageCode");
    int? employerTypeId = prefs.getInt("EmployerTypeId");
    String? companyLogo = prefs.getString("CompanyLogo");
    String? companyName = prefs.getString("CompanyName");
    String? entity = prefs.getString("Entity");
    String? dssgIds = prefs.getString("Dssg_Ids");
    int? approverId = prefs.getInt("ApproverId");
    int? bankId = prefs.getInt("BankId");
    int? employerId = prefs.getInt("EmployerId");
    String? employeeId = prefs.getString("EmployeeId");
    String? employeeNo = prefs.getString("EmployeeNo");
    String? mobile = prefs.getString("Mobile");
    int? profilePhotoId = prefs.getInt("ProfilePhotoId");
    String? profilePicture = prefs.getString("ProfilePicture");
    double? grossIncome = prefs.getDouble("GrossIncome");
    double? netPayableSalary = prefs.getDouble("Net_payable_salary");
    String? message = prefs.getString("Message");
    bool? isAppInstall = prefs.getBool("IsAppInstall");
    bool? isMobileVerified = prefs.getBool("IsMobileVerified");
    bool? isResigned = prefs.getBool("IsResigned");
    bool? isActive = prefs.getBool("IsActive");

    return LoginResponseModel(
        userEmail: userEmail,
        firstName: firstName,
        lastName: lastName,
        dOB: dOB,
        workingSince: workingSince,
        applicantId: applicantId,
        userPassword: userPassword,
        confirmPassword: confirmPassword,
        newPassword: newPassword,
        mPassCode: mPassCode,
        isRemember: isRemember,
        userTypeId: userTypeId,
        accountTypeId: accountTypeId,
        languageCode: languageCode,
        employerTypeId: employerTypeId,
        companyLogo: companyLogo,
        companyName: companyName,
        entity: entity,
        dssgIds: dssgIds,
        approverId: approverId,
        bankId: bankId,
        employerId: employerId,
        employeeId: employeeId,
        employeeNo: employeeNo,
        mobile: mobile,
        profilePhotoId: profilePhotoId,
        profilePicture: profilePicture,
        grossIncome: grossIncome,
        netPayableSalary: netPayableSalary,
        message: message,
        isAppInstall: isAppInstall,
        isMobileVerified: isMobileVerified,
        isResigned: isResigned,
        isActive: isActive);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("UserEmail");
    prefs.remove("FirstName");
    prefs.remove("LastName");
    prefs.remove("DOB");
    prefs.remove("WorkingSince");
    prefs.remove("ApplicantId");
    prefs.remove("userPassword");
    prefs.remove("confirmPassword");
    prefs.remove("NewPassword");
    prefs.remove("MPassCode");
    prefs.remove("IsRemember");
    prefs.remove("UserTypeId");
    prefs.remove("AccountTypeId");
    prefs.remove("LanguageCode");
    prefs.remove("EmployerTypeId");
    prefs.remove("CompanyLogo");
    prefs.remove("CompanyName");
    prefs.remove("Entity");
    prefs.remove("Dssg_Ids");
    prefs.remove("ApproverId");
    prefs.remove("BankId");
    prefs.remove("EmployerId");
    prefs.remove("EmployeeId");
    prefs.remove("EmployeeNo");
    prefs.remove("Mobile");
    prefs.remove("ProfilePhotoId");
    prefs.remove("ProfilePicture");
    prefs.remove("GrossIncome");
    prefs.remove("Net_payable_salary");
    prefs.remove("Message");
    prefs.remove("IsAppInstall");
    prefs.remove("IsMobileVerified");
    prefs.remove("IsResigned");
    prefs.remove("IsActive");
  }

  Future<void> setStringValue(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<void> setBoolValue(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<void> setIntValue(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("tokenValue");
    return token;
  }

  Future<void> setIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }
}
