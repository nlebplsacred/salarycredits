import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salarycredits/features/active_salary_account/active_salary_account_page.dart';
import 'package:salarycredits/features/cancel_loan_request/cancel_loan_request_page.dart';
import 'package:salarycredits/features/dashboard/widgets/app_bar_widget.dart';
import 'package:salarycredits/features/dashboard/widgets/offer_listview_widget.dart';
import 'package:salarycredits/features/faqs/faqs_page.dart';
import 'package:salarycredits/features/loan_approved_offer/loan_approved_offer_page.dart';
import 'package:salarycredits/features/loan_process_status/loan_process_status_page.dart';
import 'package:salarycredits/features/loan_statement_download/loan_statement_download_page.dart';
import 'package:salarycredits/features/upcoming_deduction/my_upcoming_deduction_page.dart';
import 'package:salarycredits/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../menu/nav_bar.dart';
import '../../models/loan/applicant_dashboard_base_model.dart';
import '../../models/loan/short_loan_details.dart';
import '../../models/login/login_response_model.dart';
import '../../services/user_handler.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../emi_calculator/emi_calculator_page.dart';
import '../loan_process_pending/loan_process_pending_page.dart';
import '../my_applications/my_applications_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final UserHandler userHandler = UserHandler();
  LoginResponseModel user = LoginResponseModel();
  ApplicantDashboardBaseModel applicantDashboardBaseModel = ApplicantDashboardBaseModel();
  late Future<ApplicantDashboardBaseModel> futureDashboardModel = Future(() => ApplicantDashboardBaseModel());
  DateFormat outputFormatDate = DateFormat('dd-MMM hh:mm:ss');
  ShortLoanDetails shortLoan = ShortLoanDetails();
  bool showHideLoanProcess = false, showHideApprovedOffer = false, showHideUpcomingDeduction = false;
  String processTitle = "", offerTitle = "", offerDescription = "";
  String processDescription = "";
  String processActionTitle = "Check Status";

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));

        futureDashboardModel = getApplicantDashboardInfo(user.applicantId!);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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

  String getTotalDeduction(ApplicantDashboardBaseModel model) {
    String totalDeduction = "INR. 0.0";
    if (model.activeDeductionBase.activeLoanDeductionAmount > 0) {
      totalDeduction = "INR. ${model.activeDeductionBase.activeLoanDeductionAmount}";
    }
    return totalDeduction;
  }

  void bindProcessStatus(ShortLoanDetails shortLoanDetails) {

    shortLoan = shortLoanDetails;

    if (shortLoan.getApplicationId > 0) {
      showHideLoanProcess = true;
      processTitle = "${shortLoan.getApplicationType} in progress";

      int lDaysOld = 0;
      final DateTime disbursalDate = DateTime.parse(shortLoan.getLastAction);
      final DateTime dateToday = DateTime.now();
      lDaysOld = Global.daysBetween(disbursalDate, dateToday);

      if (shortLoan.getStatusId == 1) {
        //Applied
        processDescription = "Application Id - ${shortLoan.getApplicationId} submitted for HR Approval";
      } else if (shortLoan.getStatusId == 3) {
        //Lender Rejected
        if (lDaysOld <= 3) {
          processTitle = "${shortLoan.getApplicationType} is declined";
          processDescription = "Application Id - ${shortLoan.getApplicationId} Rejected by Lender";
        } else {
          showHideLoanProcess = false;
        }
      } else if (shortLoan.getStatusId == 4) {
        //HR Approved
        processDescription = "Application Id - ${shortLoan.getApplicationId} Approved by HR";
      } else if (shortLoan.getStatusId == 5) {
        //HR Rejected

        if (lDaysOld <= 3) {
          processTitle = "${shortLoan.getApplicationType} is declined";
          processDescription = "Application Id - ${shortLoan.getApplicationId} Rejected by HR";
        } else {
          showHideLoanProcess = false;
        }
      } else if (shortLoan.getStatusId == 2) {
        //Lender Approved

        if (shortLoan.getStatusId == 2 && shortLoan.getIsProcessDone) {
          processDescription = "Application Id - ${shortLoan.getApplicationId} is being prepared to disburse";
        } else {
          processDescription = "Application Id - ${shortLoan.getApplicationId} is waiting for e-sign & references";
          processActionTitle = "Complete Process";
        }
      } else if (shortLoan.getStatusId == 6) {
        if (lDaysOld <= 3) {
          processTitle = "Money transferred into your account";
          processDescription = "Application Id - ${shortLoan.getApplicationId} is completed";
          processActionTitle = "View More";
        } else {
          showHideLoanProcess = false;
        }
      }
    }
  }

  void bindApprovedOffer(ApprovedOffer approvedOffer) {
    if (approvedOffer.getApplicationId > 0) {
      offerTitle = "Offer received for Application Id - ${approvedOffer.getApplicationId}";
      offerDescription = "Offer sent by lender at ${getDate(approvedOffer.getCreatedOn, outputFormatDate)}";
      showHideApprovedOffer = true;
    }
  }

  //load dashboard data model o page load
  Future<ApplicantDashboardBaseModel> getApplicantDashboardInfo(int applicantId) async {
    return userHandler.getDashboardInfo(applicantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(user),
      appBar: AppBarWidget(user),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              futureDashboardModel = getApplicantDashboardInfo(user.applicantId!);
            });
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 12.0, right: 12.0),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //add more widgets here
                  SizedBox(
                    child: FutureBuilder<ApplicantDashboardBaseModel>(
                      future: futureDashboardModel,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            if (snapshot.data != null) {
                              applicantDashboardBaseModel = snapshot.data!;

                              //check if there is any deduction available for current month
                              if (applicantDashboardBaseModel.activeDeductionBase.activeLoanDeductionAmount > 0) {
                                showHideUpcomingDeduction = true;
                              }
                            }
                          }
                          return getOfferView(applicantDashboardBaseModel);
                        } else if (snapshot.hasError) {
                          // Handle the error
                          return Center(child: Text('${snapshot.error}'));
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator(color: AppColor.lightBlue)),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text("Advance Services", style: AppStyle.pageTitle2, textAlign: TextAlign.start),
                  const SizedBox(height: 16.0),
                  Container(
                    height: 220.0,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(width: 1, color: AppColor.grey2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 80,
                                child: InkWell(
                                  onTap: () {
                                    //send to cancel request page
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const CancelLoanRequestPage();
                                    }));
                                  },
                                  child: Column(
                                    children: [
                                      ClipRRect(child: Image.asset("assets/cancel_l_blue.png", color: AppColor.darkBlue, width: 32.0, height: 32.0)),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text("Cancel Request", style: AppStyle.userTitle),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 80,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const MyApplicationsPage();
                                    }));
                                  },
                                  child: Column(
                                    children: [
                                      ClipRRect(child: Image.asset("assets/list_loans.png", color: AppColor.darkBlue, width: 32.0, height: 32.0)),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text("Applications", style: AppStyle.userTitle),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 80,
                                child: InkWell(
                                  onTap: () {
                                    //send to download stmt page
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const LoanStatementDownloadPage();
                                    }));
                                  },
                                  child: Column(
                                    children: [
                                      ClipRRect(child: Image.asset("assets/bill_payment.png", color: AppColor.darkBlue, width: 32.0, height: 32.0)),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text("Statements", style: AppStyle.userTitle),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 80,
                                child: InkWell(
                                  onTap: () {
                                    //send to active salary account page
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const ActiveSalaryAccountPage();
                                    }));
                                  },
                                  child: Column(
                                    children: [
                                      ClipRRect(child: Image.asset("assets/bank_dark_100.png", color: AppColor.darkBlue, width: 32.0, height: 32.0)),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text("Active Salary Account", style: AppStyle.userTitle),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 80,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const EMICalculatorPage();
                                    }));
                                  },
                                  child: const Column(
                                    children: [
                                      ClipRRect(child: Icon(Icons.calculate, color: AppColor.darkBlue, size: 32)),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text("EMI Calculator", style: AppStyle.userTitle),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: InkWell(
                                  onTap: () {
                                    //send to faqs page
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const FaqsPage();
                                    }));
                                  },
                                  child: const Column(
                                    children: [
                                      ClipRRect(child: Icon(Icons.question_answer, color: AppColor.darkBlue, size: 32)),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text("FAQs", style: AppStyle.userTitle),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //add more widget
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column getOfferView(ApplicantDashboardBaseModel applicantDashboardBaseModel) {

    bindProcessStatus(applicantDashboardBaseModel.shortLoanDetails);
    bindApprovedOffer(applicantDashboardBaseModel.approvedOffer);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: showHideLoanProcess,
          child: SizedBox(
            width: double.maxFinite,
            child: Card(
              margin: const EdgeInsets.only(top: 0.0, bottom: 10.0),
              elevation: 1,
              color: AppColor.lightBlue2,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      processTitle,
                      style: AppStyle.pageTitle,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      processDescription,
                      style: AppStyle.smallGrey13,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          if (shortLoan.getStatusId == 2 && !shortLoan.getIsProcessDone) {
                            return LoanProcessPendingPage(shortLoanDetails: shortLoan);
                          } else {
                            return LoanProcessStatusPage(loanType: "", loanId: shortLoan.getApplicationId);
                            //return LoanProcessPendingPage(shortLoanDetails: shortLoan);
                          }
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.lightBlue,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(width: 1, color: AppColor.lightBlue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                          child: Text(
                            processActionTitle,
                            style: const TextStyle(color: AppColor.white, fontWeight: FontWeight.w500, fontSize: 12.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: showHideApprovedOffer,
          child: SizedBox(
            width: double.maxFinite,
            child: Card(
              margin: const EdgeInsets.only(top: 0.0, bottom: 10.0),
              elevation: 1,
              color: AppColor.loanBox1,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      offerTitle,
                      style: AppStyle.pageTitle,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      offerDescription,
                      style: AppStyle.smallGrey13,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return LoanApprovedOfferPage(approvedOffer: applicantDashboardBaseModel.approvedOffer);
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.darkBlue,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(width: 1, color: AppColor.darkBlue),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                          child: Text(
                            "View & Accept Offer",
                            style: TextStyle(color: AppColor.white, fontWeight: FontWeight.w500, fontSize: 12.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        applicantDashboardBaseModel.productBaseModel.productList.isEmpty
            ? const SizedBox(
                height: 80.0,
                width: double.maxFinite,
                child: Card(
                  elevation: 4,
                  color: AppColor.bgDefault2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Center(
                    child: Text(
                      "Sorry, you do not have any offers available",
                      style: AppStyle.textLabel2,
                    ),
                  ),
                ),
              )
            : const Text("SalaryCredits offers you", style: AppStyle.pageTitle2, textAlign: TextAlign.start),
        const SizedBox(height: 10.0),
        OfferListView(applicantDashboardBaseModel),
        Visibility(
          visible: showHideUpcomingDeduction,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              height: 70.0,
              child: InkWell(
                onTap: () {
                  //send installment details page
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyUpcomingDeductionPage(deductionBase: applicantDashboardBaseModel.activeDeductionBase);
                  }));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.bgScreen3,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(width: 1, color: AppColor.bgScreen3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Upcoming Deduction:", style: AppStyle.pageTitleWhite),
                        Text(
                          getTotalDeduction(applicantDashboardBaseModel),
                          style: AppStyle.pageTitleWhite,
                          textAlign: TextAlign.right,
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          size: 32,
                          color: AppColor.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

  }
}
