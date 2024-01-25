import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:salarycredits/features/my_application_details/my_application_details_page.dart';
import 'package:salarycredits/utility/custom_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/loan/short_loan_model.dart';
import '../../models/login/login_response_model.dart';
import '../../services/loan_handler.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';

class MyApplicationsPage extends StatefulWidget {
  const MyApplicationsPage({super.key});

  @override
  State<MyApplicationsPage> createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
  LoanHandler loanHandler = LoanHandler();
  LoginResponseModel user = LoginResponseModel();
  ShortLoanModel shortLoanModel = ShortLoanModel();
  Future<ShortLoanModel> futureShortLoanModel = Future(() => ShortLoanModel());
  DateFormat outputFormatDate = DateFormat('dd-MMM-yyyy');
  DateFormat outputFormatMonth = DateFormat('MMM-yyyy');

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));
        futureShortLoanModel = getMyApplications(user.applicantId!);
      });
    });
  }

  Future<ShortLoanModel> getMyApplications(int applicantId) async {
    return await loanHandler.getMyApplications(applicantId);
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
    } on FormatException catch (_, ex) {}

    return lDate;
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
          "My Applications",
          style: TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<ShortLoanModel>(
          future: futureShortLoanModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  shortLoanModel = snapshot.data!;
                }
              }
              return shortLoanModel.getShortLoanList.isEmpty
                  ? Padding(
                    padding: const EdgeInsets.only(top:16.0, left: 16.0, right: 16.0),
                    child: Center(child:  getMessageBox("Currently, no applications are available")),
                  )
                  : getMyApplicationView(shortLoanModel);
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

  Padding getMyApplicationView(ShortLoanModel model) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true, // use it
              physics: const NeverScrollableScrollPhysics(),
              itemCount: model.getShortLoanList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getDate(model.getShortLoanList[index].getAppliedOn, outputFormatDate), style: AppStyle.smallGrey),
                          Text(model.getShortLoanList[index].getLoanStatus, style: AppStyle.smallGrey),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(width: 1, color: AppColor.grey2),
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return MyApplicationDetailsPage(applicationId: model.getShortLoanList[index].getApplicationId);
                            }));
                          });
                        },
                        horizontalTitleGap: 8.0,
                        dense: false,
                        title: Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model.getShortLoanList[index].getApplicationType,
                                    style: AppStyle.pageTitle2,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    "Application Id- ${model.getShortLoanList[index].getApplicationId}",
                                    style: AppStyle.smallGrey,
                                  )
                                ],
                              ),
                              Text(
                                "\u20b9${model.getShortLoanList[index].getLoanAmount}",
                                style: AppStyle.pageTitle2,
                              ),
                            ],
                          ),
                        ),
                        leading: SizedBox.fromSize(
                          size: const Size(42, 42),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            child: Material(
                              color: AppColor.lightBlue,
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: Image.asset(Global.getIconName(model.getShortLoanList[index].getApplicationTypeId), color: AppColor.white),
                              ),
                            ),
                          ),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right, color: AppColor.lightBlue, size: 24),
                      ),
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }

  SizedBox getMessageBox(String message) {
    return SizedBox(
      height: 80.0,
      width: double.maxFinite,
      child: Center(
        child: Card(
          elevation: 4,
          color: AppColor.bgDefault2,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: AppStyle.pageTitle2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
