import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salarycredits/features/dashboard/dashboard_page.dart';
import 'package:salarycredits/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/loan/applicant_dashboard_base_model.dart';
import '../../models/login/login_response_model.dart';
import '../../services/loan_handler.dart';
import '../../services/user_handler.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';

class LoanApprovedOfferPage extends StatefulWidget {
  final ApprovedOffer approvedOffer;

  const LoanApprovedOfferPage({required this.approvedOffer, super.key});

  @override
  State<LoanApprovedOfferPage> createState() => _LoanApprovedOfferPageState();
}

class _LoanApprovedOfferPageState extends State<LoanApprovedOfferPage> {
  final UserHandler userHandler = UserHandler();
  final LoanHandler loanHandler = LoanHandler();
  LoginResponseModel user = LoginResponseModel();
  ApprovedOffer approvedOfferModel = ApprovedOffer();
  DateFormat outputFormatDate = DateFormat('MMM-yyyy');
  bool isLoading = false, showHideOfferBox = true, showHideResultBox = false;
  String lPageTitle = "Accept Offer";

  @override
  void initState() {
    super.initState();

    approvedOfferModel = widget.approvedOffer;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));
        lPageTitle = "Final Offer for Application Id - ${approvedOfferModel.getApplicationId}";
      });
    });
  }

  void acceptApprovedOffer(ApprovedOffer model) async {
    setState(() {
      isLoading = true;
    });

    try {
      await loanHandler.acceptApprovedOffer(model.getApplicationId).then((value) {
        setState(() {
          isLoading = false;
          String result = value;

          if (result.isNotEmpty) {
            if (result == "success") {
              showHideResultBox = true;
              showHideOfferBox = false;
            }
          } else {
            Global.showAlertDialog(context, AppText.somethingWentWrong);
          }
        });
      });
    } catch (ex) {
      setState(() {
        isLoading = false;
        Global.showAlertDialog(context, loanHandler.errorMessage);
      });
    }
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
      backgroundColor: AppColor.bgDefault1,
      appBar: AppBar(
        centerTitle: false,
        elevation: 1.0,
        toolbarHeight: 60.0,
        titleSpacing: 2.0,
        title: Text(
          lPageTitle,
          style: const TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: showHideOfferBox,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 130.0,
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                        color: AppColor.lightBlue,
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.grey,
                            blurRadius: 2.0,
                            //spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:22.0, top: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(approvedOfferModel.getApplicationType.toString().toUpperCase(), style: AppStyle.pageTitle2White),
                                    const SizedBox(height: 20.0,),
                                    const Text("Approved Amount", style: AppStyle.smallWhite),
                                    const SizedBox(height: 4.0,),
                                    Text("\u20B9${approvedOfferModel.getLoanAmount.round()}", style: AppStyle.titleWhite),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right:20.0),
                                  child: Image.asset("assets/money-bag.png", width: 100.0, height: 100.0),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0,),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Offer Details:",style: AppStyle.pageTitle),
                          const Padding(
                            padding: EdgeInsets.only(top: 6.0, bottom: 12.0),
                            child: Divider(thickness: 1.0),
                          ),
                          const SizedBox(height: 8.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Application Id", style: AppStyle.pageTitle2grey),
                              Text('${approvedOfferModel.getApplicationId}', style: AppStyle.pageTitle2),
                            ],
                          ),
                          const SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Approved Tenure", style: AppStyle.pageTitle2grey),
                              Text(
                                  approvedOfferModel.getLoanTenure == 1
                                      ? "${approvedOfferModel.getLoanTenure} Month"
                                      : "${approvedOfferModel.getLoanTenure} Months",
                                  style: AppStyle.pageTitle2),
                            ],
                          ),
                          const SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Monthly EMI", style: AppStyle.pageTitle2grey),
                              Text("\u20b9${approvedOfferModel.getEMI.round()}", style: AppStyle.pageTitle2),
                            ],
                          ),
                          const SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("EMI Start Date", style: AppStyle.pageTitle2grey),
                              Text(getDate(approvedOfferModel.getEMIStartMonth, outputFormatDate), style: AppStyle.pageTitle2),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 12.0, bottom: 6.0),
                            child: Divider(thickness: 1.0),
                          ),
                          Text(approvedOfferModel.getMessage, style: AppStyle.lightBlack14),
                          const SizedBox(height: 20.0),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0, left: 0.0, right: 0.0, bottom: 16.0),
                              child: SizedBox(
                                height: 50,
                                width: 200.0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.darkBlue,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8)), // <-- Radius
                                    ),
                                  ),
                                  onPressed: () {
                                    //accept offer method goes here
                                    if (approvedOfferModel.getApplicationId > 0) {
                                      acceptApprovedOffer(approvedOfferModel);
                                    } else {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                        return const DashboardPage();
                                      }));
                                    }
                                  },
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                    backgroundColor: AppColor.white,
                                    color: AppColor.lightBlue,
                                  )
                                      : const Text(
                                    'Accept Offer',
                                    style: AppStyle.buttonText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: showHideResultBox,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 26.0, left: 32.0, right: 32.0),
                      child: Center(
                        child: Container(
                          width: double.maxFinite,
                          height: 120.0,
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0, bottom: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Offer has been accepted", style: AppStyle.pageTitle2),
                                const SizedBox(height: 16),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const DashboardPage();
                                    }));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.lightBlue,
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      border: Border.all(width: 1, color: AppColor.lightBlue),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                                      child: Text(
                                        "Complete Process",
                                        style: TextStyle(color: AppColor.white, fontWeight: FontWeight.w500, fontSize: 12.0),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
