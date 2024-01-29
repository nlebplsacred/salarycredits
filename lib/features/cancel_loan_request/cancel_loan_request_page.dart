import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:salarycredits/models/loan/loan_cancel_request.dart';
import 'package:salarycredits/models/loan/short_loan_details.dart';
import 'package:salarycredits/utility/custom_loader.dart';
import 'package:salarycredits/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/loan/short_loan_model.dart';
import '../../models/login/login_response_model.dart';
import '../../services/loan_handler.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';

class CancelLoanRequestPage extends StatefulWidget {
  const CancelLoanRequestPage({super.key});

  @override
  State<CancelLoanRequestPage> createState() => _CancelLoanRequestPageState();
}

class _CancelLoanRequestPageState extends State<CancelLoanRequestPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController remarkController = TextEditingController();
  LoanHandler loanHandler = LoanHandler();
  LoginResponseModel user = LoginResponseModel();
  DateFormat outputFormatDate = DateFormat('dd-MMM-yyyy');
  DateFormat outputFormatMonth = DateFormat('MMM-yyyy');
  ShortLoanModel shortLoanModel = ShortLoanModel();
  ShortLoanDetails shortLoanDetails = ShortLoanDetails();
  Future<ShortLoanModel> futureShortLoanModel = Future(() => ShortLoanModel());
  String errorMessage = "", messageReceived = "No records available";
  bool isLoading = false, showHideLoanDetails = false, showHideLoanCancelForm = false, showHideError = false;
  String? cancelReasonValue;

  List<DropdownMenuItem<String>> get cancelReasonList {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Requirement full-filled", child: Text("Requirement full-filled")),
      const DropdownMenuItem(value: "Not required for now", child: Text("Not required for now")),
      const DropdownMenuItem(value: "I will apply later", child: Text("I will apply later")),
      const DropdownMenuItem(value: "Not happy with the offer", child: Text("Not happy with the offer"))
    ];
    return menuItems;
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));
        futureShortLoanModel = getLoanUnderProcessStatus(user.applicantId!);
      });
    });
  }

  Future<ShortLoanModel> getLoanUnderProcessStatus(int applicantId) async {
    return await loanHandler.getLoanUnderProcessStatus(applicantId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void cancelLoanRequest(LoanCancelRequestModel requestModel) {
    setState(() {
      isLoading = true;
    });

    loanHandler.cancelLoanRequest(requestModel).then((value) {
      setState(() {
        isLoading = false;

        if (value.isNotEmpty) {
          var data = jsonDecode(value);

          int statusId = 0;
          String message = "";

          if (data.containsKey('StatusId')) {
            statusId = int.parse(data['StatusId'].toString());
          }

          if (data.containsKey('Message')) {
            message = data['Message'].toString();
          }

          if (statusId == 1) {
            messageReceived = message;
            showHideError = true;

            futureShortLoanModel = getLoanUnderProcessStatus(user.applicantId!);
          } else {
            showHideError = true;

            if (message.isNotEmpty) {
              messageReceived = message;
            } else {
              messageReceived = AppText.somethingWentWrong;
            }
          }
        } else {
          Global.showAlertDialog(context, loanHandler.errorMessage);
        }
      });
    }).catchError((err, stackTrace) {
      setState(() {
        isLoading = false;
        errorMessage = loanHandler.errorMessage;
        Global.showAlertDialog(context, errorMessage);
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
          "Cancel Advance Request",
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
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: SafeArea(
            child: FutureBuilder<ShortLoanModel>(
              future: futureShortLoanModel,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    shortLoanModel = snapshot.data!;
                    shortLoanDetails = shortLoanModel.getShortLoanList[0];
                  }
                  return getCancelRequestScreen(shortLoanDetails);
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                } else {
                  return const CustomLoader();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Column getCancelRequestScreen(ShortLoanDetails model) {
    if (model.getApplicationId > 0) {
      if (model.getStatusId == 1 || model.getStatusId == 2 || model.getStatusId == 4) {
        showHideLoanDetails = true;
        showHideLoanCancelForm = true;
      } else {
        showHideError = true;
        showHideLoanDetails = false;
        showHideLoanCancelForm = false;
      }
    } else {
      showHideError = true;
      showHideLoanDetails = false;
      showHideLoanCancelForm = false;
    }

    return Column(
      children: [
        Visibility(
          visible: showHideLoanDetails,
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                height: 250.0,
                decoration: const BoxDecoration(
                  color: AppColor.white,
                  boxShadow: [
                    BoxShadow(color: AppColor.grey2, blurRadius: 3.0),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 12.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Image.asset("assets/sa_blue.png", width: 32, height: 32, color: AppColor.lightBlue),
                          ),
                          const SizedBox(width: 8.0),
                          SizedBox(
                            child: Text(Global.getApplicationType(model.getApplicationTypeId), style: AppStyle.pageTitle2),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1.0),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Application Id", style: AppStyle.pageTitle2grey),
                          Text(model.getApplicationId.toString(), style: AppStyle.pageTitle2),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Loan Amount", style: AppStyle.pageTitle2grey),
                          Text("\u20b9${model.getLoanAmount}", style: AppStyle.pageTitle2),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Apply Date", style: AppStyle.pageTitle2grey),
                          Text(getDate(model.getAppliedOn, outputFormatDate), style: AppStyle.pageTitle2),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1.0),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Current Status", style: AppStyle.pageTitle),
                          Text(model.getLoanStatus, style: const TextStyle(fontSize: 15.0, color: AppColor.green, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: showHideLoanCancelForm,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12.0),
                width: double.maxFinite,
                height: 380.0,
                decoration: const BoxDecoration(
                  color: AppColor.white,
                  boxShadow: [
                    BoxShadow(color: AppColor.grey2, blurRadius: 3.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: DropdownButtonFormField<String>(
                            value: cancelReasonValue,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "* Cancellation Reason is required";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColor.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                              hintText: "Choose Cancellation Reason",
                              labelText: "Cancellation Reason",
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                cancelReasonValue = newValue!;
                              });
                            },
                            items: cancelReasonList,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextFormField(
                            controller: remarkController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColor.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                              hintText: 'Please describe cancellation (optional)',
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0, left: 0.0, right: 0.0, bottom: 16.0),
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.lightBlue,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8)), // <-- Radius
                                    ),
                                  ),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      //create model to send further

                                      String selectedValueRemarks = cancelReasonValue!;
                                      String lOtherRemarks = remarkController.text.toString();

                                      if (lOtherRemarks.isNotEmpty) {
                                        selectedValueRemarks = "$cancelReasonValue ($lOtherRemarks)";
                                      }

                                      LoanCancelRequestModel request = LoanCancelRequestModel();
                                      request.setApplicationId = model.getApplicationId;
                                      request.setApplicantId = user.applicantId!;
                                      request.setBankId = model.getBankId;
                                      request.setRemarks = selectedValueRemarks;

                                      cancelLoanRequest(request);
                                    }
                                  },
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          backgroundColor: AppColor.white,
                                          color: AppColor.lightBlue,
                                        )
                                      : const Text(
                                          'Continue',
                                          style: AppStyle.buttonText,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: showHideError,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 68.0,
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
                child: Center(
                  child:
                      Text(messageReceived, textAlign: TextAlign.center, style: const TextStyle(color: AppColor.green, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
