import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/loan/loan_details_model.dart';
import '../../../models/login/login_response_model.dart';
import '../../../values/colors.dart';
import '../../../values/styles.dart';

class ViewForeclosurePage extends StatefulWidget {
  final LoanDetailsModel loanDetails;

  const ViewForeclosurePage({required this.loanDetails, super.key});

  @override
  State<ViewForeclosurePage> createState() => _ViewForeclosurePageState();
}

class _ViewForeclosurePageState extends State<ViewForeclosurePage> {
  LoginResponseModel user = LoginResponseModel();
  LoanDetailsModel loanDetailsModel = LoanDetailsModel();
  LoanClosureDetails loanClosureDetails = LoanClosureDetails();
  DateFormat outputFormatDate = DateFormat('dd-MMM-yyyy');
  DateFormat outputFormatMonth = DateFormat('MMM-yyyy');
  bool showHideForeclosure = false;
  bool showHideNEFTDetails = false;
  bool showHideClosureConfirmation = false;
  bool showHideClosureRemark = false;
  String closureRemark = "NA";

  String loanAmount = "\u20B90.00";
  String principalAmount = "\u20B90.00";
  String interestAmount = "\u20B90.00";
  String dailyInterestAmount = "\u20B90.00";
  String totalOutStandingAmount = "\u20B90.00";

  String beneficiaryName = "NA";
  String beneficiaryAccount = "NA";
  String beneficiaryBankName = "NA";
  String beneficiaryIfscCode = "NA";
  String beneficiaryAccountType = "NA";

  String amountReceived = "\u20B90.00";
  String closureDate = "NA";
  String currentStatus = "NA";
  String transactionRef = "NA";

  @override
  void initState() {
    super.initState();

    loanDetailsModel = widget.loanDetails;
    loanClosureDetails = loanDetailsModel.getLoanClosureDetails;

    if (loanDetailsModel.getLoanStatusId == 6) {
      if (loanDetailsModel.getCurrentStatusId == 2) {
        //set foreclosure details
        loanAmount = "\u20B9${loanDetailsModel.getLoanAmount}";
        principalAmount = "\u20B9${loanClosureDetails.getTotalPrincipalPending}";
        interestAmount = "\u20B9${loanClosureDetails.getTotalInterestPending}";
        dailyInterestAmount = "\u20B9${loanClosureDetails.getDailyInterest}";
        totalOutStandingAmount = "\u20B9${loanClosureDetails.getTotalPrincipalPending + loanClosureDetails.getTotalInterestPending}";

        //set NEFT details
        if (loanDetailsModel.getLenderDetails.getBeneficiaryName.isNotEmpty) {
          beneficiaryName = loanDetailsModel.getLenderDetails.getBeneficiaryName;
          beneficiaryAccount = loanDetailsModel.getLenderDetails.getBeneficiaryAccountNumber;
          beneficiaryBankName = loanDetailsModel.getLenderDetails.getBankName;
          beneficiaryIfscCode = loanDetailsModel.getLenderDetails.getIFSCCode;
          beneficiaryAccountType = "Current";
        }

        showHideForeclosure = true;
        showHideNEFTDetails = true;
        showHideClosureConfirmation = false;
        showHideClosureRemark = false;
      } else if (loanDetailsModel.getCurrentStatusId == 3) {
        showHideClosureRemark = true;
        closureRemark = "The Advance has been fully paid and closed";
      } else if (loanDetailsModel.getCurrentStatusId == 4) {
        if (loanDetailsModel.getLoanClosureDetails.getLoanClosureConfirmation.getAmountReceived > 0) {
          amountReceived = "\u20B9${loanDetailsModel.getLoanClosureDetails.getLoanClosureConfirmation.getAmountReceived}";
          closureDate = getDate(loanDetailsModel.getLoanClosureDetails.getLoanClosureConfirmation.getClosureDate, outputFormatDate);

          if (loanDetailsModel.getLoanClosureDetails.getLoanClosureConfirmation.getTransactionRef.isNotEmpty) {
            transactionRef = loanDetailsModel.getLoanClosureDetails.getLoanClosureConfirmation.getTransactionRef;
          }
          currentStatus = "Foreclosed";
          showHideClosureRemark = true;
          showHideClosureConfirmation = true;
          closureRemark = "The Advance has been fully paid and closed";
        }
      } else if (loanDetailsModel.getCurrentStatusId == 6) {
        showHideClosureRemark = true;
        closureRemark = "The Advance has been waved off";
      }
    } else {
      showHideClosureRemark = true;
      closureRemark = "No foreclosure details are available";
    }

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));
      });
    });
  }

  String getDate(String date, DateFormat format) {
    String lDate = "N/A";
    try {
      if (date != "") {
        lDate = format.format(DateTime.parse(date));
      }
    } on FormatException catch (_, ex) {}

    return lDate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgDefault1,
      appBar: AppBar(
        elevation: 1.0,
        toolbarHeight: 60.0,
        titleSpacing: 2.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColor.white, // <-- SEE HERE
          statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        title: const Text(
          "Foreclosure Details of Advance",
          style: TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: showHideForeclosure,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
                    child: Text(
                      "Foreclosure details",
                      style: AppStyle.pageTitleLarge2,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(12),
                    height: 230.0,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppColor.lightBlue,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(width: 1, color: AppColor.grey2),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColor.lightGrey,
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0, bottom: 20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Loan Amount", style: AppStyle.pageTitle2White),
                              Text(loanAmount, style: AppStyle.pageTitle2White),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Principal Outstanding", style: AppStyle.pageTitle2White),
                              Text(principalAmount, style: AppStyle.pageTitle2White),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Interest Outstanding", style: AppStyle.pageTitle2White),
                              Text(interestAmount, style: AppStyle.pageTitle2White),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Daily Interest", style: AppStyle.pageTitle2White),
                              Text(dailyInterestAmount, style: AppStyle.pageTitle2White),
                            ],
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          const Divider(thickness: 1, color: AppColor.grey2),
                          const SizedBox(
                            height: 12.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Outstanding", style: AppStyle.pageTitle2White),
                              Text(totalOutStandingAmount, style: AppStyle.pageTitle2White),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: showHideNEFTDetails,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
                    child: Text(
                      "NEFT details",
                      style: AppStyle.pageTitleLarge2,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(12),
                    height: 210.0,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(width: 1, color: AppColor.grey2),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColor.lightGrey,
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0, bottom: 20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Beneficiary Name", style: AppStyle.pageTitle2grey),
                              Text(beneficiaryName, style: AppStyle.pageTitle3),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Beneficiary Account", style: AppStyle.pageTitle2grey),
                              Text(beneficiaryAccount, style: AppStyle.pageTitle3),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Bank Name", style: AppStyle.pageTitle2grey),
                              Text(beneficiaryBankName, style: AppStyle.pageTitle3),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("IFSC Code", style: AppStyle.pageTitle2grey),
                              Text(beneficiaryIfscCode, style: AppStyle.pageTitle3),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Account Type", style: AppStyle.pageTitle2grey),
                              Text(beneficiaryAccountType, style: AppStyle.pageTitle2),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: showHideClosureConfirmation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(12),
                    height: 210.0,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(width: 1, color: AppColor.grey2),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColor.lightGrey,
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0, bottom: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Amount Received", style: AppStyle.pageTitle2grey),
                              Text(amountReceived, style: AppStyle.pageTitle3),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Closure Date", style: AppStyle.pageTitle2grey),
                              Text(closureDate, style: AppStyle.pageTitle3),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Current Status", style: AppStyle.pageTitle2grey),
                              Text(currentStatus, style: AppStyle.pageTitle3),
                            ],
                          ),
                          const SizedBox(
                            height: 22.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Transaction Reference", style: AppStyle.pageTitle2grey),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(transactionRef, style: AppStyle.pageTitle2),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: showHideClosureRemark,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(12),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(width: 1, color: AppColor.grey2),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColor.lightGrey,
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0, bottom: 20.0),
                      child: Text(closureRemark, style: const TextStyle(color: AppColor.green, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
