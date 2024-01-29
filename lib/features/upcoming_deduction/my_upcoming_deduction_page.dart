import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:salarycredits/features/my_application_details/my_application_details_page.dart';
import 'package:salarycredits/features/my_applications/my_applications_page.dart';
import 'package:salarycredits/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/loan/applicant_dashboard_base_model.dart';
import '../../models/login/login_response_model.dart';
import '../../services/loan_handler.dart';
import '../../values/colors.dart';

class MyUpcomingDeductionPage extends StatefulWidget {
  final ActiveDeductionBase deductionBase;

  const MyUpcomingDeductionPage({required this.deductionBase, super.key});

  @override
  State<MyUpcomingDeductionPage> createState() => _MyUpcomingDeductionPageState();
}

class _MyUpcomingDeductionPageState extends State<MyUpcomingDeductionPage> {
  LoanHandler loanHandler = LoanHandler();
  LoginResponseModel user = LoginResponseModel();
  ActiveDeductionBase activeDeductionBase = ActiveDeductionBase();
  DateFormat outputFormatDate = DateFormat('dd-MMM-yyyy');
  DateFormat outputFormatMonth = DateFormat('MMM-yyyy');

  @override
  void initState() {
    super.initState();

    activeDeductionBase = widget.deductionBase;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 1.0,
        toolbarHeight: 60.0,
        titleSpacing: 2.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColor.white, // <-- SEE HERE
          statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        title: const Text(
          "My Upcoming Deduction",
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
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
          child: Column(
            children: [
              Container(
                height: 120.0,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  color: AppColor.lightBlue,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("\u20B9${activeDeductionBase.activeLoanDeductionAmount}", style: AppStyle.titleValueWhite),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Text("Upcoming Salary Deduction", style: AppStyle.pageTitleWhite),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const Text("Tip: Keep your repaying tenure shorter or foreclose your advances early to avoid paying additional interest.",
                  style: TextStyle(color: AppColor.lightBlue)),
              const SizedBox(height: 32.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("My Active Advances", style: AppStyle.pageTitle2grey),
                  Text("Upcoming Deductions", style: AppStyle.pageTitle2grey),
                ],
              ),
              const SizedBox(height: 8.0),
              const Divider(thickness: 1, color: AppColor.grey2),
              ListView.builder(
                  shrinkWrap: true, // use it
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeDeductionBase.activeDeductions.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(width: 1, color: AppColor.grey2),
                      ),
                      child: ListTile(
                        onTap: () {
                          //go to application details page
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return MyApplicationDetailsPage(applicationId: activeDeductionBase.activeDeductions[index].getApplicationId);
                          }));
                        },
                        horizontalTitleGap: 6.0,
                        dense: false,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              activeDeductionBase.activeDeductions[index].getApplicationType,
                              style: AppStyle.pageTitle2,
                            ),
                            Text("\u20B9${activeDeductionBase.activeDeductions[index].getEMI}", style: AppStyle.pageTitle2grey),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\u20B9${activeDeductionBase.activeDeductions[index].getLoanAmount} on ${getDate(activeDeductionBase.activeDeductions[index].getAppliedOn, outputFormatDate)}",
                              style: AppStyle.smallGrey,
                            ),
                            Text(getDate(activeDeductionBase.activeDeductions[index].getEMIDate, outputFormatMonth), style: AppStyle.smallGrey),
                          ],
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right, color: AppColor.lightBlue, size: 32),
                      ),
                    );
                  }),
              const SizedBox(height: 32.0),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return const MyApplicationsPage();
                  }));
                },
                child: Container(
                  height: 80.0,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0, bottom: 12.0),
                        child: SizedBox.fromSize(
                          size: const Size(36, 36),
                          child: Image.asset("assets/money_bag_blue.png", color: AppColor.darkBlue),
                        ),
                      ),
                      const SizedBox(
                        width: 220.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "View All Advances",
                              style: AppStyle.pageTitle2,
                            ),
                            SizedBox(height: 3.0),
                            Text(
                              "All your advances applied so far",
                              style: AppStyle.smallGrey,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                        child: Icon(Icons.keyboard_arrow_right, size: 28, color: AppColor.darkBlue),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
