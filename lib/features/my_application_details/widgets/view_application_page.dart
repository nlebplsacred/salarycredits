import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:salarycredits/models/loan/loan_details_model.dart';
import 'package:salarycredits/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/login/login_response_model.dart';
import '../../../values/colors.dart';

class ViewApplicationPage extends StatefulWidget {
  final LoanDetailsModel loanDetails;

  const ViewApplicationPage({required this.loanDetails, super.key});

  @override
  State<ViewApplicationPage> createState() => _ViewApplicationPageState();
}

class _ViewApplicationPageState extends State<ViewApplicationPage> {
  LoginResponseModel user = LoginResponseModel();
  LoanDetailsModel loanDetailsModel = LoanDetailsModel();
  DateFormat outputFormatDate = DateFormat('dd-MMM-yyyy');
  DateFormat outputFormatMonth = DateFormat('MMM-yyyy');
  bool showHideInterestRate = false;
  bool showHideDiscountOnFee = false;
  bool showHideDiscountOnROI = false;
  bool showHideNetDisbursalAmount = false;
  bool showHideDisbursalDate = false;

  @override
  void initState() {
    super.initState();

    loanDetailsModel = widget.loanDetails;

    if (loanDetailsModel.getEmployerId == 20870) {
      showHideInterestRate = true;
    }

    if (loanDetailsModel.getCurrentStatusId == 2) {
      showHideDisbursalDate = true;
      showHideNetDisbursalAmount = true;
    }

    if (loanDetailsModel.getDiscountOnFee > 0) {
      showHideDiscountOnFee = true;
    }

    if (loanDetailsModel.getDiscountOnInterest > 0) {
      showHideDiscountOnROI = true;
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
    } on FormatException catch (_) {}

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
          "View Other Details",
          style: TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(color: AppColor.white),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 12.0, right: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Application Id", style: AppStyle.pageTitle2grey),
                      Text('${loanDetailsModel.getApplicationId}', style: AppStyle.pageTitle2),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Divider(thickness: 1.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Application Type", style: AppStyle.pageTitle2grey),
                      Text(loanDetailsModel.getApplicationType, style: AppStyle.pageTitle2),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Divider(thickness: 1.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Lender Name", style: AppStyle.pageTitle2grey),
                      Text(loanDetailsModel.getLenderName, style: AppStyle.pageTitle2),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Divider(thickness: 1.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Processing Fee", style: AppStyle.pageTitle2grey),
                      Text("\u20b9${loanDetailsModel.getProcessingFee}", style: AppStyle.pageTitle2),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Divider(thickness: 1.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Broken Period Interest", style: AppStyle.pageTitle2grey),
                      Text("\u20b9${loanDetailsModel.getPreEMI}", style: AppStyle.pageTitle2),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Divider(thickness: 1.0),
                  ),
                  Visibility(
                    visible: showHideInterestRate,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Interest Rate", style: AppStyle.pageTitle2grey),
                            Text("${loanDetailsModel.getInterestRate}% monthly", style: AppStyle.pageTitle2),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: Divider(thickness: 1.0),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Interest Payable", style: AppStyle.pageTitle2grey),
                      Text("\u20b9${loanDetailsModel.getEMI * loanDetailsModel.getEMICount - loanDetailsModel.getLoanAmount}",
                          style: AppStyle.pageTitle2),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Divider(thickness: 1.0),
                  ),
                  Visibility(
                    visible: showHideDiscountOnFee,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Discount on Fee", style: AppStyle.pageTitle2grey),
                            Text("\u20b9${loanDetailsModel.getDiscountOnFee}", style: AppStyle.pageTitle2),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: Divider(thickness: 1.0),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showHideDiscountOnROI,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Discount on ROI", style: AppStyle.pageTitle2grey),
                            Text("\u20b9${loanDetailsModel.getDiscountOnInterest}", style: AppStyle.pageTitle2),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: Divider(thickness: 1.0),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Apply Date", style: AppStyle.pageTitle2grey),
                      Text(getDate(loanDetailsModel.getAppliedOn, outputFormatDate), style: AppStyle.pageTitle2),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Divider(thickness: 1.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("EMI Start Month", style: AppStyle.pageTitle2grey),
                      Text(getDate(loanDetailsModel.getEMIStartFrom, outputFormatMonth), style: AppStyle.pageTitle2),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Divider(thickness: 1.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("EMI End Month", style: AppStyle.pageTitle2grey),
                      Text(getDate(loanDetailsModel.getEMIEnding, outputFormatMonth), style: AppStyle.pageTitle2),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Divider(thickness: 1.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Application Status", style: AppStyle.pageTitle2grey),
                      Text(loanDetailsModel.getLoanStatus, style: AppStyle.pageTitle2),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Divider(thickness: 1.0),
                  ),
                  Visibility(
                    visible: showHideNetDisbursalAmount,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Net Disbursal Amount", style: AppStyle.pageTitle2grey),
                            Text("\u20b9${loanDetailsModel.getDisbursalAmount}", style: AppStyle.pageTitle2),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: Divider(thickness: 1.0),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showHideDisbursalDate,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Disbursal Date", style: AppStyle.pageTitle2grey),
                            Text(getDate(loanDetailsModel.getDisbursedOn, outputFormatDate), style: AppStyle.pageTitle2),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: Divider(thickness: 1.0),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Purpose of Advance", style: AppStyle.pageTitle2grey),
                      Text(loanDetailsModel.getPurpose, style: AppStyle.pageTitle2),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Divider(thickness: 1.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
