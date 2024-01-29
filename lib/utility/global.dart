import 'dart:math';
import 'package:flutter/material.dart';
import 'package:salarycredits/values/styles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/loan/master_data_model.dart';
import '../services/api_auth.dart';
import 'package:intl/intl.dart';

import '../values/colors.dart';

class Global {
  DateFormat outputFormatDate = DateFormat('yyyy-MM-dd');

  static int daysBetween(DateTime fromDate, DateTime toDate) {
    fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day);
    toDate = DateTime(toDate.year, toDate.month, toDate.day);
    return (toDate.difference(fromDate).inHours / 24).round();
  }

  static String getIconName(int applicationTypeId) {
    String lIConFIle = "assets/rupees1_white_100.png";
    switch (applicationTypeId) {
      case 13:
        lIConFIle = "assets/ewa_white_64.png";
        break;
      case 9:
        lIConFIle = "assets/fast_pay_white_100.png";
        break;
      case 6:
        lIConFIle = "assets/rupees1_white_100.png";
        break;
      case 5:
        lIConFIle = "assets/stpl_white_100.png";
        break;
      case 3:
        lIConFIle = "assets/debt_consolidation.png";
        break;
      case 1:
        lIConFIle = "assets/pl_white_100.png";
        break;
    }
    return lIConFIle;
  }

  static String getApplicationType(int applicationTypeId) {
    String lLoanType = "Salary Advance";

    switch (applicationTypeId) {
      case 13:
        lLoanType = "Earned Wage Access";
        break;
      case 9:
        lLoanType = "Fast Pay";
        break;
      case 6:
        lLoanType = "Salary Advance";
        break;
      case 5:
        lLoanType = "Custom Advance";
        break;
      case 3:
        lLoanType = "Debt Consolidation";
        break;
      case 1:
        lLoanType = "Personal Loan";
        break;
    }

    return lLoanType;
  }

  static String getValueByItemText(List<SelectListItem> lstArray, String name) {
    String indexValue = "0";
    for (int i = 0; i < lstArray.length; i++) {
      String lText = lstArray[i].text;
      if (lText.contains(name)) {
        indexValue = lstArray[i].value;
        break;
      }
    }
    return indexValue;
  }

  static String? getValueByItemText2(List<DropdownMenuItem<String>> lstArray, String name) {
    String? indexValue = "0";
    for (int i = 0; i < lstArray.length; i++) {
      String? lText = lstArray[i].value;
      if (lText!.contains(name)) {
        indexValue = lstArray[i].value;
        break;
      }
    }
    return indexValue;
  }

  static void showAlertDialog(BuildContext context, String message) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: 300.0,
              height: 210.0,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.info_outline, size: 28, color: AppColor.lightBlack),
                          const SizedBox(height: 16.0),
                          Material(child: Text(message, style: AppStyle.textLabel2)),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.lightBlue,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)), // <-- Radius
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Ok",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          );
        });
  }

  static void getReToken() async {
    final ApiToken apiToken = ApiToken();
    apiToken.getToken();
  }

  static String getNextLoanStatus(int currentStatusId) {
    String lNextStatus = "";

    switch (currentStatusId) {
      case 1:
        lNextStatus = "Waiting for HR Confirmation";
        break;
      case 2:
        lNextStatus = "Waiting for Amount Disbursal";
        break;
      case 4:
        lNextStatus = "Waiting for Bank Approval";
        break;
      case 6:
        lNextStatus = "Waiting for Bank Approval";
        break;
    }

    return lNextStatus;
  }

  static double getNetIncomeFOIR(double netSalary) {
    double lNetIncomeFOIR = 0;

    if (netSalary > 8000 && netSalary <= 20000) {
      lNetIncomeFOIR = netSalary * 0.4.round();
    } else if (netSalary > 20000 && netSalary <= 50000) {
      lNetIncomeFOIR = netSalary * 0.5.round();
    } else if (netSalary > 50000 && netSalary <= 75000) {
      lNetIncomeFOIR = netSalary * 0.6.round();
    } else if (netSalary > 75000 && netSalary <= 100000) {
      lNetIncomeFOIR = netSalary * 0.65.round();
    } else if (netSalary > 100000) {
      lNetIncomeFOIR = netSalary * 0.65.round();
    }

    return lNetIncomeFOIR;
  }

  static int getYears(String dob) {
    DateTime startDate = DateTime.now();

    try {
      if (dob != "") {
        startDate = DateTime.parse(dob);
      }
    } on FormatException catch (_) {}

    DateTime endDate = DateTime.now(); // Use the current date as the end date

    int yearsDifference = endDate.year - startDate.year;

    // Check if the end date hasn't reached the anniversary of the start date yet
    if (endDate.month < startDate.month || (endDate.month == startDate.month && endDate.day < startDate.day)) {
      yearsDifference--;
    }

    return yearsDifference;
  }

  static void launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static String getRandomNumber() {
    Random r = Random();
    int number = r.nextInt(999999 - 100000) + 100000;
    return number.toString();
  }

  static String getMaskedMobile(String mobileNo) {
    String lMaskNumber = "NA";

    if (mobileNo != "" && mobileNo.length > 8) {
      lMaskNumber = "XXXX${mobileNo.substring(6, 10)}";
    }
    return lMaskNumber;
  }

  static String? validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,10}$)';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    } else {
      String pattern2 = r'([6-9][0-9]{9}$)';
      RegExp regExp2 = RegExp(pattern2);
      if (!regExp2.hasMatch(value)) {
        return 'Please enter valid mobile number';
      } else {
        if (value.toString() == "6666666666" ||
            value.toString() == "7777777777" ||
            value.toString() == "8888888888" ||
            value.toString() == "9999999999") {
          return 'Please enter valid mobile number';
        }
      }
    }
    return null;
  }

  static String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid Email';
    }
    return null;
  }

  static String? validateEmployer(String value) {
    if (value.isEmpty) {
      return "Enter Employer Name";
    } else if (value.length < 4) {
      return "Please provide valid Employer name";
    }
    return null;
  }

  static String? validateCommonName(String value, String name, int minLength) {
    if (value.isEmpty) {
      return "Enter $name";
    } else if (value.length < minLength) {
      return "Please provide valid $name";
    }
    return null;
  }

  static String getMaskedEmail(final String email) {
    String emailCharacter = "";
    if (email.isNotEmpty) {
      var nameUser = email.split("@");
      emailCharacter = email.replaceRange(2, nameUser[0].length, "*" * (nameUser[0].length - 2));
    }
    return emailCharacter;
  }

  static String getMaskedEmailAddress(final String email) {
    if (email.isNotEmpty) {
      const String mask = "*****";
      final int at = email.indexOf("@");
      if (at > 2) {
        final int maskLen = min(max((at / 2) as int, 2), 4);
        final int start = ((at - maskLen) / 2) as int;
        return email.substring(0, start) + mask.substring(0, maskLen) + email.substring(start + maskLen);
      }
    }
    return email;
  }

  static String? isValidAadhaar(String value) {
    String pattern = r'^[0-9]{12}$';

    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid Aadhaar Number';
    }
    return null;
  }

  static String? isValidPAN(String value) {
    String pattern = r'^[A-Za-z]{5}\d{4}[A-Za-z]$';

    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid PAN Number';
    }
    return null;
  }

  static String? isValidDOB(String value) {
    String pattern = r'^\d{2}\/[A-Za-z]{3}\/\d{4}$';

    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid DOB';
    }
    return null;
  }

  static String? isValidDOJ(String value) {
    String pattern = r'^\d{2}\/[A-Za-z]{3}\/\d{4}$';

    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid DOJ';
    }
    return null;
  }

  static String? isValidDOB2(String value) {
    String pattern = r'^\d{2}\/\d{2}\/\d{4}$';

    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid DOB';
    }
    return null;
  }

  static String? isValidPincode(String value) {
    String pattern = r'^\d{6}$';

    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid PIN code';
    }
    return null;
  }

  static String? isValidAccountNumber(String value) {
    String pattern = r'^\d{6,20}$';

    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter valid account number code';
    }
    return null;
  }

  static String getNameInitials(String? firstName, String? lastName) {
    String initialsName = "NA";

    if (firstName != null && lastName != null) {
      initialsName = '${firstName[0]}${lastName[0]}';
    } else if (firstName != null) {
      if (firstName.length > 2) {
        initialsName = '${firstName[0]}${firstName[1]}';
      } else {
        initialsName = firstName[0];
      }
    }
    return initialsName.toUpperCase();
  }

  static String getMaskedAccountNo(String accountNumber) {
    String lMaskNumber = "NA";

    if (accountNumber != "" && accountNumber.length > 8) {
      lMaskNumber = "XXXXXX${accountNumber.substring(2)}";
    }
    return lMaskNumber;
  }

  static String getMaskedCardNo(String cardNumber) {
    String lMaskNumber = "**** **** **** ****";

    if (cardNumber != "" && cardNumber.length > 12) {
      lMaskNumber = "**** **** **** ${cardNumber.substring(12)}";
    }
    return lMaskNumber;
  }
}

// class SecureStorage {
//   final FlutterSecureStorage storage = const FlutterSecureStorage();
//   Future<void> writeSecureToken(String key, String value) async {
//     // I'm not exactly sure how you get the data from storage.write, because it has a type of Future<void>
//     // So the whole function should be await storage.write(key: key, value: value);
//     await storage.write(key: key, value: value);
//   }
//
//   Future<String?> readSecureToken(String key) async {
//     return await storage.read(key: key);
//   }
//
//   Future<void> deleteSecureToken(String key) async {
//     // Same here: delete is a type of void, so it shouldn't return anything
//     await storage.delete(key: key);
//   }
// }
