import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:salarycredits/features/my_application_details/widgets/view_application_page.dart';
import 'package:salarycredits/features/my_application_details/widgets/view_foreclosure_page.dart';
import 'package:salarycredits/features/my_application_details/widgets/view_installments_page.dart';
import 'package:salarycredits/services/loan_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/loan/loan_details_model.dart';
import '../../models/loan/short_loan_details.dart';
import '../../models/login/login_response_model.dart';
import '../../utility/custom_loader.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';

class MyApplicationDetailsPage extends StatefulWidget {
  final int applicationId;

  const MyApplicationDetailsPage({required this.applicationId, super.key});

  @override
  State<MyApplicationDetailsPage> createState() => _MyApplicationDetailsPageState();
}

class _MyApplicationDetailsPageState extends State<MyApplicationDetailsPage> {
  ShortLoanDetails shortLoanList = ShortLoanDetails();
  LoginResponseModel user = LoginResponseModel();
  LoanHandler loanHandler = LoanHandler();
  LoanDetailsModel loanDetailsModel = LoanDetailsModel();
  Future<LoanDetailsModel> futureLoanDetailsModel = Future(() => LoanDetailsModel());
  DateFormat outputFormatDate = DateFormat('MMM-yyyy');

  @override
  void initState() {
    super.initState();

    shortLoanList.setApplicationId = widget.applicationId;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));

        futureLoanDetailsModel = getApplicationDetails(shortLoanList.getApplicationId);
      });
    });
  }

  Future<LoanDetailsModel> getApplicationDetails(int applicationId) async {
    return await loanHandler.getApplicationDetails(applicationId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getDate(String date) {
    String lDate = "N/A";
    try {
      if (date != "") {
        lDate = outputFormatDate.format(DateTime.parse(date));
      }
    } on FormatException catch (_) {}

    return lDate;
  }

  String getRemarkAndStatus(LoanDetailsModel model) {
    String result = "NA";

    if (model.getLoanStatusId == 3 || model.getLoanStatusId == 5 || model.getLoanStatusId == 7) {
      if (model.getRemarks.isNotEmpty) {
        result = model.getRemarks;
      }
    } else {
      if (model.getLoanStatusId == 1 || model.getLoanStatusId == 2 || model.getLoanStatusId == 4) {
        result = Global.getNextLoanStatus(model.getLoanStatusId);
      } else if (model.getLoanStatusId == 6) {
        result = "Disbursed";
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColor.lightBlue, // <-- SEE HERE
          statusBarIconBrightness: Brightness.light, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<LoanDetailsModel>(
          future: futureLoanDetailsModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                loanDetailsModel = snapshot.data!;
              }
              return loanDetailsModel.getApplicationId == 0 ? const Center(child: Text("Data not available")) : getDetailScreen(loanDetailsModel);
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else {
              return const CustomLoader();
            }
          },
        ),
      ),
    );
  }

  SingleChildScrollView getDetailScreen(LoanDetailsModel model) {
    double lTotalAmountDue = 0;
    double lTotalAmountPaid = 0;

    //in case loan is running
    if (model.getCurrentStatusId == 2) {
      lTotalAmountDue = model.getLoanClosureDetails.getTotalInterestPending + model.getLoanClosureDetails.getTotalPrincipalPending;
    }

    if (model.getLoanStatusId == 6) {
      if (model.getRepaymentDetails.isNotEmpty) {
        for (RepaymentDetails item in model.getRepaymentDetails) {
          if (item.getStatus) {
            lTotalAmountPaid += item.getTotalRepayment;
          }
        }
      }

      //in case of foreclosure
      if (model.getCurrentStatusId == 4) {
        if (model.getLoanClosureDetails.getLoanClosureConfirmation.getAmountReceived > 0) {
          lTotalAmountPaid += model.getLoanClosureDetails.getLoanClosureConfirmation.getAmountReceived;
        }
      }
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 230.0,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  color: AppColor.lightBlue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16, left: 8.0),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back, color: AppColor.white),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 32, left: 25.0),
                          child: Text(
                            "Application Details",
                            style: AppStyle.title1White,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0),
                      child: Text(
                        "Application Id - ${model.getApplicationId}",
                        style: AppStyle.title2White,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 130.0, left: 30.0, right: 30.0),
                  child: Container(
                    height: 360.0,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.grey,
                          blurRadius: 2.0,
                          //spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 26.0),
                        Text("\u20b9${model.getLoanAmount}", style: AppStyle.titleValue),
                        const SizedBox(height: 6.0),
                        const Text("Advance Amount", style: AppStyle.textLabel),
                        const SizedBox(height: 32.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              child: Column(
                                children: [
                                  Text(model.getEMICount == 1 ? "${model.getEMICount} Month" : "${model.getEMICount} Months",
                                      style: AppStyle.pageTitleLarge2),
                                  const SizedBox(height: 6.0),
                                  const Text("Repayment Period", style: AppStyle.textLabel),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Column(
                                children: [
                                  Text("\u20b9${model.getEMI}", style: AppStyle.pageTitleLarge2),
                                  const SizedBox(height: 6.0),
                                  const Text("Repayment(EMI)", style: AppStyle.textLabel),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              child: Column(
                                children: [
                                  Text(getDate(model.getEMIStartFrom), style: AppStyle.pageTitleLarge2),
                                  const SizedBox(height: 6.0),
                                  const Text("EMI Start Month", style: AppStyle.textLabel),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Column(
                                children: [
                                  Text(model.getLoanStatus, style: AppStyle.pageTitleLarge2),
                                  const SizedBox(height: 6.0),
                                  const Text("Current Status", style: AppStyle.textLabel),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Remarks:",
                                    style: AppStyle.pageTitle3,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(getRemarkAndStatus(model), style: AppStyle.smallGrey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 30,
                right: 30,
                bottom: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      //send installment details page
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ViewInstallmentsPage(loanDetails: loanDetailsModel);
                      }));
                    },
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        color: AppColor.lightBlue,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.grey,
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                      child: const Center(child: Text("REPAYMENT SCHEDULE", style: AppStyle.pageTitle2White)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 26.0, left: 30.0, right: 30.0),
            child: Text("Other Details", style: AppStyle.pageTitle),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0),
            child: Container(
              height: 120.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.lightGrey,
                    blurRadius: 2.0,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      //send foreclosure details page
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ViewForeclosurePage(loanDetails: loanDetailsModel);
                      }));
                    },
                    child: SizedBox(
                        width: 90.0,
                        height: 85.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColor.loanBox1,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Amount Due", style: TextStyle(color: AppColor.lightBlack, fontSize: 12.0)),
                              const SizedBox(height: 6.0),
                              Text("\u20b9$lTotalAmountDue",
                                  style: const TextStyle(color: AppColor.lightBlack, fontSize: 13.0, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 6.0),
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Align(alignment: Alignment.bottomRight, child: Icon(Icons.arrow_forward,  size: 18, color: AppColor.lightBlack,)),
                              )
                            ],
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      //send installment details page
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ViewInstallmentsPage(loanDetails: loanDetailsModel);
                      }));
                    },
                    child: SizedBox(
                        width: 90.0,
                        height: 85.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColor.loanBox2,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Installments", style: TextStyle(color: AppColor.white, fontSize: 12.0)),
                              const SizedBox(height: 6.0),
                              Text("${model.getPaidEMICount}/${model.getEMICount}",
                                  style: const TextStyle(color: AppColor.white, fontSize: 13.0, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 6.0),
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Align(alignment: Alignment.bottomRight, child: Icon(Icons.arrow_forward, size: 18, color: AppColor.white)),
                              )
                            ],
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      //go to application details page
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ViewApplicationPage(loanDetails: loanDetailsModel);
                      }));
                    },
                    child: SizedBox(
                        width: 90.0,
                        height: 85.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColor.loanBox3,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("View", style: TextStyle(color: AppColor.white, fontSize: 12.0)),
                              SizedBox(height: 6.0),
                              Text("Details", style: TextStyle(color: AppColor.white, fontSize: 13.0)),
                              SizedBox(height: 6.0),
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Align(alignment: Alignment.bottomRight, child: Icon(Icons.arrow_forward, size: 18, color: AppColor.white)),
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 26.0, left: 30.0, right: 30.0),
            child: Container(
              height: 75.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.lightGrey,
                    blurRadius: 2.0,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 60.0,
                    child: Image.asset("assets/money_bag_blue.png", width: 40, height: 40, color: AppColor.darkBlue),
                  ),
                  const SizedBox(
                    width: 150.0,
                    child: Text(
                      "Amount paid total",
                      style: AppStyle.pageTitle,
                    ),
                  ),
                  SizedBox(
                    width: 100.0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "\u20b9$lTotalAmountPaid",
                          style: const TextStyle(color: AppColor.lightBlue, fontSize: 14.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
