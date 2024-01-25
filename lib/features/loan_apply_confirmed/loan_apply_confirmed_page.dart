import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salarycredits/features/dashboard/dashboard_page.dart';
import 'package:salarycredits/features/loan_process_status/widgets/my_timeline_tile.dart';
import 'package:salarycredits/values/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/loan/applicant_dashboard_base_model.dart';
import '../../models/loan/loan_model.dart';
import '../../models/loan/loan_status_model.dart';
import '../../models/loan/short_loan_details.dart';
import '../../models/login/login_response_model.dart';
import '../../utility/global.dart';
import '../../values/styles.dart';

class LoanApplyConfirmedPage extends StatefulWidget {
  final LoanModel loanModel;

  const LoanApplyConfirmedPage({required this.loanModel, super.key});

  @override
  State<LoanApplyConfirmedPage> createState() => _LoanApplyConfirmedPageState();
}

class _LoanApplyConfirmedPageState extends State<LoanApplyConfirmedPage> {
  LoginResponseModel user = LoginResponseModel();
  LoanModel loanApplicationModel = LoanModel();
  ApplicantDashboardBaseModel userBaseDashboard = ApplicantDashboardBaseModel();
  ShortLoanDetails shortLoan = ShortLoanDetails();
  List<LoanStatusModel> timeLineCollection = [];

  @override
  void initState() {
    super.initState();
    loanApplicationModel = widget.loanModel;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));

        ShortLoanDetails shortLoanList = ShortLoanDetails();
        shortLoanList.setApplicationId = loanApplicationModel.getApplicationId;
        shortLoanList.setIsProcessDone = false;

        if (loanApplicationModel.getApplicationTypeId == 13) {
          shortLoanList.setStatusId = 2;
        } else {
          shortLoanList.setStatusId = 4;
        }
        shortLoanList.setLoanAmount = loanApplicationModel.getLoanAmount;
        shortLoanList.setEMI = loanApplicationModel.getEMI;

        userBaseDashboard.shortLoanDetails = shortLoanList;
        shortLoan = userBaseDashboard.shortLoanDetails;

        initializeStatusList();
      });
    });
  }

  void initializeStatusList() {
    setState(() {
      LoanStatusModel model0 = LoanStatusModel();
      model0.setStatusId = 1;
      model0.setStatusName = "Applied";
      model0.setIsActive = true;
      timeLineCollection.add(model0);

      LoanStatusModel model1 = LoanStatusModel();
      model1.setStatusId = 4;
      model1.setStatusName = "HR Approval";
      if (loanApplicationModel.getApplicationTypeId == 13) {
        model1.setIsActive = true;
      } else {
        model1.setIsActive = false;
      }
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
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColor.grey2,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                height: 130.0,
                decoration: const BoxDecoration(color: AppColor.grey2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                     Global.getApplicationType(loanApplicationModel.getApplicationTypeId),
                      style: AppStyle.pageTitleLarge2,
                    ),
                    const SizedBox(height: 18.0),
                    Text("INR ${loanApplicationModel.getLoanAmount}", style: AppStyle.pageTitleLarge1),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
                child: Text("Your Advance application has been submitted for HR Approval", style: AppStyle.pageTitle, textAlign: TextAlign.center),
              ),
              const SizedBox(height: 18.0),
              const Text("Advance Expected in 60 minutes", style: AppStyle.pageTitle2grey, textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
                child: SizedBox(
                  height: 420.0,
                  child: ListView.builder(
                    //physics: const NeverScrollableScrollPhysics(),
                    itemCount: timeLineCollection.length,
                    itemBuilder: (context, index) {
                      return MyTimeLineTile(statusModel: timeLineCollection[index], shortLoanModel: shortLoan);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0, bottom: 16.0),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)), // <-- Radius
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return const DashboardPage();
                      }));
                    },
                    child: const Text('Home', style: AppStyle.buttonText),
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
