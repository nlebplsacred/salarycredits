import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salarycredits/features/loan_process_status/widgets/my_timeline_tile.dart';
import 'package:salarycredits/services/loan_handler.dart';
import 'package:salarycredits/values/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/loan/applicant_dashboard_base_model.dart';
import '../../models/loan/loan_model.dart';
import '../../models/loan/loan_status_history_model.dart';
import '../../models/loan/loan_status_model.dart';
import '../../models/loan/short_loan_details.dart';
import '../../models/loan/short_loan_model.dart';
import '../../models/login/login_response_model.dart';
import '../../utility/custom_loader.dart';
import '../../utility/global.dart';
import '../../values/styles.dart';

class LoanProcessStatusPage extends StatefulWidget {
  final String loanType;

  const LoanProcessStatusPage({required this.loanType, super.key});

  @override
  State<LoanProcessStatusPage> createState() => _LoanProcessStatusPageState();
}

class _LoanProcessStatusPageState extends State<LoanProcessStatusPage> {
  LoanHandler loanHandler = LoanHandler();
  LoginResponseModel user = LoginResponseModel();
  LoanModel loanApplicationModel = LoanModel();
  ApplicantDashboardBaseModel userBaseDashboard = ApplicantDashboardBaseModel();
  LoanStatusHistoryModel loanStatusHistoryModel = LoanStatusHistoryModel();
  ShortLoanModel shortLoanModel = ShortLoanModel();
  ShortLoanDetails shortLoan = ShortLoanDetails();
  List<LoanStatusModel> timeLineCollection = [];

  bool isLoading = true, showHideAlreadyApplied = false, showHideStatusTimeRemarks = true;
  String errorMessage = "";
  String loanType = "", alreadyApplied = "";
  int loanId = 0;
  double loanAmount = 0.0;
  String statusRemarks = "";
  String statusTimeRemarks = "";

  @override
  void initState() {
    super.initState();
    //loanApplicationModel = widget.loanModel;
    alreadyApplied = widget.loanType;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));

        if (alreadyApplied.isNotEmpty) {
          showHideAlreadyApplied = true;
        }

        getLoanUnderProcessStatus(user.applicantId!);
      });
    });
  }

  void getLoanUnderProcessStatus(int applicantId) async {
    try {
      await loanHandler.getLoanUnderProcessStatus(applicantId).then((value) {
        setState(() {
          shortLoanModel = value;
          //isLoading = false;

          if (shortLoanModel.getShortLoanList.isNotEmpty) {
            userBaseDashboard.shortLoanDetails = shortLoanModel.getShortLoanList[0];

            shortLoan = shortLoanModel.getShortLoanList[0];

            if (shortLoan.getApplicationId > 0) {
              loanType = shortLoan.getApplicationType;
              loanAmount = shortLoan.getLoanAmount;
              loanId = shortLoan.getApplicationId;

              if (shortLoan.getStatusId == 1) {
                statusRemarks = "Your Advance application has been submitted for HR Approval";
                statusTimeRemarks = "Advance Expected in 60 minutes";
              } else if (shortLoan.getStatusId == 3) {
                statusRemarks = "Your Application has been rejected by Lender";
                showHideStatusTimeRemarks = false;
              } else if (shortLoan.getStatusId == 5) {
                statusRemarks = "Your Application has been rejected by HR";
                showHideStatusTimeRemarks = false;
              } else if (shortLoan.getStatusId == 7) {
                statusRemarks = "This Application has been canceled.";
                showHideStatusTimeRemarks = false;
              } else if (shortLoan.getStatusId == 4) {
                statusRemarks = "Your Advance application has been forwarded for Lender Approval";
                statusTimeRemarks = "Advance Expected in 60 minutes";
              } else if (shortLoan.getStatusId == 2) {
                if (shortLoan.getStatusId == 2 && shortLoan.getIsProcessDone) {
                  statusRemarks = "Transferring money into your account";
                } else {
                  statusRemarks =
                      "Your Application has been Approved \nNow, complete the application process to quickly disburse money in your account";
                }

                statusTimeRemarks = "Advance Expected in 60 minutes";
              } else if (shortLoan.getStatusId == 6) {
                statusRemarks = "Congratulations! Money Transferred Successfully.";
                statusTimeRemarks = "Advance Credited in your Account";
              }

              int lApplicationId = shortLoan.getApplicationId;
              getLoanStatusHistoryList(lApplicationId); //load status history
            } else {
              isLoading = false;
            }
          } else {
            Global.showAlertDialog(context, loanHandler.errorMessage);
          }
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoading = false;
          errorMessage = 'Network not available';
          Global.showAlertDialog(context, errorMessage);
        });
      });
    } catch (ex) {
      setState(() {
        isLoading = false;
        errorMessage = loanHandler.errorMessage;
        Global.showAlertDialog(context, errorMessage);
      });
    }
  }

  void getLoanStatusHistoryList(int applicationId) async {
    try {
      await loanHandler.getLoanStatusHistoryList(applicationId).then((value) {
        setState(() {
          loanStatusHistoryModel = value;
          isLoading = false;

          if (loanStatusHistoryModel.getActionHistories.isNotEmpty) {
            if (shortLoan.getStatusId > 0) {
              int lCurrentStatusId = shortLoan.getStatusId;
              bool lIsProcessStatus = shortLoan.getIsProcessDone;

              if (lCurrentStatusId == 1) {
                lCurrentStatusId = 4;
              } else if (lCurrentStatusId == 4) {
                lCurrentStatusId = 2;
              } else if (lCurrentStatusId == 2 && !lIsProcessStatus) {
                lCurrentStatusId = 21;
              } else if (lCurrentStatusId == 5) {
                lCurrentStatusId = 5;
              } else if (lCurrentStatusId == 3) {
                lCurrentStatusId = 3;
              } else {
                lCurrentStatusId = 6;
              }

              shortLoan.setStatusId = lCurrentStatusId;

              LoanStatusModel model0 = LoanStatusModel();
              model0.setStatusId = 1;
              model0.setStatusName = "Applied";
              model0.setIsActive = false;
              timeLineCollection.add(model0);

              LoanStatusModel model1 = LoanStatusModel();
              model1.setStatusId = 4;
              model1.setStatusName = "HR Approval";
              model1.setIsActive = false;
              timeLineCollection.add(model1);

              LoanStatusModel model2 = LoanStatusModel();
              model2.setStatusId = 2;
              model2.setStatusName = "Bank Approval";
              model2.setIsActive = false;
              timeLineCollection.add(model2);

              LoanStatusModel model3 = LoanStatusModel();
              model3.setStatusId = 21;
              model3.setStatusName = "E-Sign & Reference";
              model3.setIsActive = false;
              timeLineCollection.add(model3);

              LoanStatusModel model4 = LoanStatusModel();
              model4.setStatusId = 6;
              model4.setStatusName = "Disbursal";
              model4.setIsActive = false;
              timeLineCollection.add(model4);

              if (loanStatusHistoryModel.getActionHistories.isNotEmpty) {
                if (shortLoan.getStatusId == 3 || shortLoan.getStatusId == 5 || shortLoan.getStatusId == 7) {
                  for (int i = 0; i < loanStatusHistoryModel.getActionHistories.length; i++) {
                    loanStatusHistoryModel.getActionHistories[i].setIsActive = true;
                  }
                  timeLineCollection = loanStatusHistoryModel.getActionHistories;
                } else {
                  LoanStatusModel itemTemp;

                  for (int i = 0; i < loanStatusHistoryModel.getActionHistories.length; i++) {
                    itemTemp = loanStatusHistoryModel.getActionHistories[i];

                    for (int j = 0; j < timeLineCollection.length; j++) {
                      if (timeLineCollection[j].getStatusId == itemTemp.getStatusId) {
                        timeLineCollection[j].setIsActive = true;
                        timeLineCollection[j].setActionOn = itemTemp.getActionOn;
                      } else {
                        if (timeLineCollection[j].getStatusId == 21 && lCurrentStatusId == 6) {
                          timeLineCollection[j].setIsActive = true;
                        }
                        timeLineCollection[j].setActionOn = itemTemp.getActionOn;
                      }
                    }
                  }
                }
              }
            }
          } else {
            Global.showAlertDialog(context, loanHandler.errorMessage);
          }
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoading = false;
          errorMessage = err.toString();
          Global.showAlertDialog(context, errorMessage);
        });
      });
    } catch (ex) {
      setState(() {
        isLoading = false;
        errorMessage = loanHandler.errorMessage;
        Global.showAlertDialog(context, errorMessage);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        elevation: 1.0,
        toolbarHeight: 60.0,
        titleSpacing: 2.0,
        title: const Text(
          "Application Status",
          style: TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColor.white, // <-- SEE HERE
          statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: isLoading
              ? const Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: CustomLoader(),
                )
              : Column(
                  children: [
                    Visibility(
                      visible: showHideAlreadyApplied,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          width: double.maxFinite,
                          height: 100.0,
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: AppColor.lightBlue),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                                child: Text(
                              "One of your $loanType request is already in process. You can apply for only one advance at a time. Below find the details of your existing request.",
                              style: const TextStyle(fontSize: 14.0, color: AppColor.white, height: 1.3, fontWeight: FontWeight.w400),
                            )),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      height: 120.0,
                      decoration: const BoxDecoration(color: AppColor.grey2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            loanType,
                            style: AppStyle.pageTitleLarge2,
                          ),
                          const SizedBox(height: 18.0),
                          Text("INR $loanAmount", style: AppStyle.pageTitleLarge1),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
                      child: Text(statusRemarks, style: AppStyle.pageTitle, textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 18.0),
                    Visibility(
                        visible: showHideStatusTimeRemarks,
                        child: Text(statusTimeRemarks, style: AppStyle.pageTitle2grey, textAlign: TextAlign.center)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
                      child: SizedBox(
                        height: 500.0,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: timeLineCollection.length,
                          itemBuilder: (context, index) {
                            return MyTimeLineTile(statusModel: timeLineCollection[index], shortLoanModel: shortLoan);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
