import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/loan/active_salary_account_model.dart';
import '../../models/login/login_response_model.dart';
import '../../services/loan_handler.dart';
import '../../utility/custom_loader.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';

class ActiveSalaryAccountPage extends StatefulWidget {
  const ActiveSalaryAccountPage({super.key});

  @override
  State<ActiveSalaryAccountPage> createState() => _ActiveSalaryAccountPageState();
}

class _ActiveSalaryAccountPageState extends State<ActiveSalaryAccountPage> {
  LoanHandler loanHandler = LoanHandler();
  LoginResponseModel user = LoginResponseModel();

  ActiveSalaryAccountModel activeSalaryAccount = ActiveSalaryAccountModel();
  Future<ActiveSalaryAccountModel> futureActiveSalaryAccount = Future(() => ActiveSalaryAccountModel());

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));
        futureActiveSalaryAccount = getActiveSalaryAccount(user.applicantId!);
      });
    });
  }

  Future<ActiveSalaryAccountModel> getActiveSalaryAccount(int applicantId) async {
    return await loanHandler.getActiveSalaryAccount(applicantId);
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
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColor.white, // <-- SEE HERE
          statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        title: const Text(
          "Active Salary Account",
          style: TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<ActiveSalaryAccountModel>(
          future: futureActiveSalaryAccount,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  activeSalaryAccount = snapshot.data!;
                }
              }
              return getAccountDetailsScreen(activeSalaryAccount);
            } else if (snapshot.hasError) {
              // Handle the error
              return Center(child: Text('${snapshot.error}'));
            } else {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CustomLoader()),
              );
            }
          },
        ),
      ),
    );
  }

  Padding getAccountDetailsScreen(ActiveSalaryAccountModel model) {
    return Padding(
      padding: const EdgeInsets.only(top:16.0, left: 12.0, right: 12.0, bottom: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            height: 210.0,
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
                      const Text("Beneficiary Name", style: AppStyle.pageTitle2White),
                      Text(model.getAccountHolderName, style: AppStyle.pageTitle2White),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Beneficiary Account", style: AppStyle.pageTitle2White),
                      Text(model.getAccountNumber, style: AppStyle.pageTitle2White),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("IFSC Code", style: AppStyle.pageTitle2White),
                      Text(model.getIFSCCode, style: AppStyle.pageTitle2White),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Bank Name", style: AppStyle.pageTitle2White),
                      Text(model.getBankName == "" ? "NA":model.getBankName, style: AppStyle.pageTitle2White),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Account Type", style: AppStyle.pageTitle2White),
                      Text(model.getAccountType, style: AppStyle.pageTitle2White),
                    ],
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
