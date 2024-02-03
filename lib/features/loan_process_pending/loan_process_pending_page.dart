import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:salarycredits/models/loan/external_loan_process_model.dart';
import 'package:salarycredits/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/loan/applicant_dashboard_base_model.dart';
import '../../models/loan/lender_agreement_model.dart';
import '../../models/loan/loan_process_pending.dart';
import '../../models/loan/personal_reference_model.dart';
import '../../models/loan/short_loan_details.dart';
import '../../models/login/login_response_model.dart';
import '../../services/loan_handler.dart';
import '../../utility/custom_loader.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';
import '../dashboard/dashboard_page.dart';

class LoanProcessPendingPage extends StatefulWidget {
  final ShortLoanDetails shortLoanDetails;

  const LoanProcessPendingPage({required this.shortLoanDetails, super.key});

  @override
  State<LoanProcessPendingPage> createState() => _LoanProcessPendingPageState();
}

class _LoanProcessPendingPageState extends State<LoanProcessPendingPage> {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  LoanHandler loanHandler = LoanHandler();
  LoginResponseModel user = LoginResponseModel();
  ApplicantDashboardBaseModel userBaseDashboard = ApplicantDashboardBaseModel();
  ShortLoanDetails shortLoan = ShortLoanDetails();
  LoanProcessPending loanProcessPending = LoanProcessPending();
  LenderAgreementModel lenderAgreementModel = LenderAgreementModel();
  ExternalLoanProcessModel externalLoanProcessModel = ExternalLoanProcessModel();
  List<PersonalReferenceModel> personalReferenceModels = [];
  PersonalReferenceModel objRef1 = PersonalReferenceModel();
  PersonalReferenceModel objRef2 = PersonalReferenceModel();

  List<int> totalProcessCount = [];
  String? relationTypeValue;

  List<DropdownMenuItem<String>> get relationTypeList {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "1", child: Text("Spouse")),
      const DropdownMenuItem(value: "2", child: Text("Brother")),
      const DropdownMenuItem(value: "3", child: Text("Mother")),
      const DropdownMenuItem(value: "4", child: Text("Father")),
      const DropdownMenuItem(value: "5", child: Text("Friend")),
      const DropdownMenuItem(value: "6", child: Text("Colleague"))
    ];
    return menuItems;
  }

  bool isLoadingAgreement = false, isAgreementAccepted = false;
  bool isLoading = false, isLoadingReferences = false, isLoadingNACH = false;
  bool isReferenceAdded = false, isNachAdded = false;
  bool showHideContinueBtn = false, showHideSaveReferenceBtn = false, showHideReference1Delete = false, showHideReference2Delete = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();

    shortLoan = widget.shortLoanDetails;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));

        //check which loan process is pending on page load
        if (shortLoan.getApplicationId > 0) {
          getLoanProcessPending(user.applicantId!, shortLoan.getApplicationId);
        } else {
          Global.showAlertDialog(context, AppText.somethingWentWrong);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  //method to get pending loan process of an application
  void getLoanProcessPending(int applicantId, int applicationId) async {
    setState(() {
      isLoading = true;
    });

    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    //
    // if (Platform.operatingSystem == "android") {
    //   // Android
    //   AndroidDeviceInfo info = await deviceInfo.androidInfo;
    //   print(info.version);
    //   print(info.brand);
    //   print(info.device);
    // } else {
    //   // iOS
    //
    //   IosDeviceInfo info = await deviceInfo.iosInfo;
    //   print(info.name);
    //   print(info.systemName);
    //   print(info.systemVersion);
    //   print(info.name);
    //   print(info.model);
    // }

    try {
      await loanHandler.getLoanProcessPending(applicantId, applicationId).then((value) {
        setState(() {
          isLoading = false;
          loanProcessPending = value;

          //for agreement
          if (loanProcessPending.getLoanAgreement.isNotEmpty) {
            if (loanProcessPending.getLoanAgreement.toLowerCase() == "active") {
              isAgreementAccepted = true;
              totalProcessCount.add(1);
            } else if (loanProcessPending.getLoanAgreement.toLowerCase() == "inactive") {
              getLoanAgreementData(applicantId, applicationId);
            }
          }

          //for references
          if (shortLoan.getApplicationTypeId == 9 || shortLoan.getApplicationTypeId == 13) {
            isReferenceAdded = true;
            totalProcessCount.add(2);
          } else {
            if (loanProcessPending.getLoanReference.isNotEmpty) {
              if (loanProcessPending.getLoanReference.toLowerCase() == "active") {
                isReferenceAdded = true;
                totalProcessCount.add(2);
              }
            }
          }

          //for ECS/NACH
          if (loanProcessPending.getLoanECS.isNotEmpty) {
            if (loanProcessPending.getLoanECS.toLowerCase() == "active") {
              isNachAdded = true;
              totalProcessCount.add(3);
            } else {
              if (shortLoan.getApplicationTypeId == 9 || shortLoan.getApplicationTypeId == 13) {
                isNachAdded = true;
                totalProcessCount.add(3);
              }
            }
          } else {
            if (shortLoan.getApplicationTypeId == 9 || shortLoan.getApplicationTypeId == 13) {
              isNachAdded = true;
              totalProcessCount.add(3);
            }
          }

          if (totalProcessCount.length >= 3) {
            showHideContinueBtn = true;
          }
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoading = false;
          errorMessage = loanHandler.errorMessage;
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

  //get loan agreement and send OTP
  void getLoanAgreementData(int applicantId, int applicationId) async {
    setState(() {
      isLoadingAgreement = true;
    });

    try {
      String otp = Global.getRandomNumber();
      await loanHandler.getLoanAgreementData(applicantId, applicationId, otp).then((value) {
        setState(() {
          isLoadingAgreement = false;
          lenderAgreementModel = value;
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoadingAgreement = false;
          errorMessage = loanHandler.errorMessage;
          Global.showAlertDialog(context, errorMessage);
        });
      });
    } catch (ex) {
      setState(() {
        isLoadingAgreement = false;
        errorMessage = loanHandler.errorMessage;
        Global.showAlertDialog(context, errorMessage);
      });
    }
  }

  void resendLoanAgreementOTP(int applicantId) async {
    setState(() {
      isLoadingAgreement = true;
    });

    try {
      String otp = Global.getRandomNumber();
      await loanHandler.resendLoanAgreementOTP(applicantId, otp).then((value) {
        setState(() {
          isLoadingAgreement = false;
          if (value.isNotEmpty) {
            if (value == "Success") {
              Global.showAlertDialog(context, "OTP sent to your mobile number");
            } else {
              Global.showAlertDialog(context, value);
            }
          } else {
            Global.showAlertDialog(context, loanHandler.errorMessage);
          }
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoadingAgreement = false;
          errorMessage = 'Network not available';
          Global.showAlertDialog(context, errorMessage);
        });
      });
    } catch (ex) {
      setState(() {
        isLoadingAgreement = false;
        errorMessage = loanHandler.errorMessage;
        Global.showAlertDialog(context, errorMessage);
      });
    }
  }

  //verify/accept loan agreement
  void acceptLoanAgreement(LenderAgreementModel request) async {
    setState(() {
      isLoadingAgreement = true;
    });

    try {
      await loanHandler.acceptLoanAgreement(request).then((value) {
        setState(() {
          isLoadingAgreement = false;
          var data = json.decode(value);

          String statusId = "";
          String message = "";

          if (data.containsKey('StatusId')) {
            statusId = data['StatusId'].toString();
          }

          if (data.containsKey('Message')) {
            message = data['Message'].toString();
          }

          if (statusId == "1") {
            isAgreementAccepted = true;
            getLoanProcessPending(user.applicantId!, shortLoan.getApplicationId);
          } else {
            Global.showAlertDialog(context, message);
          }
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoadingAgreement = false;
          errorMessage = loanHandler.errorMessage;
          Global.showAlertDialog(context, errorMessage);
        });
      });
    } catch (ex) {
      setState(() {
        isLoadingAgreement = false;
        errorMessage = loanHandler.errorMessage;
        Global.showAlertDialog(context, errorMessage);
      });
    }
  }

  //add 2 personal references
  void savePersonalReferences() async {
    setState(() {
      isLoadingReferences = true;
    });

    PersonalReferenceBaseModel personalReferenceBaseModel = PersonalReferenceBaseModel();
    personalReferenceBaseModel.setApplicationId = shortLoan.getApplicationId;
    personalReferenceBaseModel.setPersonalRef = personalReferenceModels;

    try {
      await loanHandler.addLoanPersonalReference(personalReferenceBaseModel).then((value) {
        setState(() {
          var data = json.decode(value);
          isLoadingReferences = false;

          String statusId = "";
          String message = "";

          if (data.containsKey('StatusId')) {
            statusId = data['StatusId'].toString();
          }

          if (data.containsKey('Message')) {
            message = data['Message'].toString();
          }

          if (statusId == "1") {
            isReferenceAdded = true;

            getLoanProcessPending(user.applicantId!, shortLoan.getApplicationId);
          } else {
            Global.showAlertDialog(context, message);
          }
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoadingReferences = false;
          errorMessage = loanHandler.errorMessage;
          Global.showAlertDialog(context, errorMessage);
        });
      });
    } catch (ex) {
      setState(() {
        isLoadingReferences = false;
        errorMessage = loanHandler.errorMessage;
        Global.showAlertDialog(context, errorMessage);
      });
    }
  }

  //get ECS link details
  void getLoanNACH() async {
    setState(() {
      isLoadingNACH = true;
    });

    try {
      await loanHandler.getLoanNACHInfo(user.applicantId!).then((value) {
        setState(() {
          isLoadingNACH = false;
          externalLoanProcessModel = value;
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoadingNACH = false;
          errorMessage = loanHandler.errorMessage;
          Global.showAlertDialog(context, errorMessage);
        });
      });
    } catch (ex) {
      setState(() {
        isLoadingNACH = false;
        errorMessage = loanHandler.errorMessage;
        Global.showAlertDialog(context, errorMessage);
      });
    }
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
          "Complete Pending Process",
          style: TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
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
                    Container(
                      width: double.maxFinite,
                      height: 120.0,
                      decoration: const BoxDecoration(color: AppColor.grey2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            shortLoan.getApplicationType,
                            style: AppStyle.pageTitleLarge2,
                          ),
                          const SizedBox(height: 18.0),
                          Text("INR ${shortLoan.getLoanAmount}", style: AppStyle.pageTitleLarge1),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 26, bottom: 16.0, left: 16.0, right: 16.0),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(width: 1, color: AppColor.grey2),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          onExpansionChanged: (value) {
                            if (!isAgreementAccepted) {
                              getLoanAgreementData(user.applicantId!, shortLoan.getApplicationId);
                            }
                          },
                          title: const Text(
                            "Loan Agreement",
                            style: AppStyle.pageTitle,
                          ),
                          initiallyExpanded: true,
                          leading: SizedBox.fromSize(
                            size: const Size(38, 38),
                            child: const ClipOval(
                              child: Material(
                                color: AppColor.darkBlue,
                                child: Center(
                                  child: Text(
                                    "1",
                                    style: AppStyle.pageTitle2White,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          children: <Widget>[
                            Visibility(
                              visible: isAgreementAccepted,
                              child: const Padding(
                                padding: EdgeInsets.only(top: 0.0, left: 12.0, right: 12.0, bottom: 32.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.done,
                                      size: 32,
                                      color: AppColor.lightBlue,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Accepted",
                                      style: AppStyle.pageTitle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            isLoadingAgreement
                                ? const Center(child: SizedBox(height: 300.0, child: Center(child: CircularProgressIndicator())))
                                : Visibility(
                                    visible: !isAgreementAccepted,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        children: [
                                          const Text(
                                            "We request you to kindly read and accept the loan agreement.",
                                            style: AppStyle.textLabel2,
                                          ),
                                          SizedBox(
                                            height: 310.0,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0, bottom: 0.0),
                                              child: Form(
                                                key: formKey1,
                                                child: Column(
                                                  children: [
                                                    const Text(
                                                      "Please Read & Accept Loan Agreement",
                                                      style: AppStyle.pageTitle2,
                                                    ),
                                                    const SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        if (lenderAgreementModel.getAgreementLink.isNotEmpty) {
                                                          final Uri url = Uri.parse(lenderAgreementModel.getAgreementLink);
                                                          Global.launchURL(url);
                                                        } else {
                                                          Global.showAlertDialog(context, "Agreement link is not available");
                                                        }
                                                      },
                                                      child: const Text(
                                                        "Click Here >>",
                                                        style: AppStyle.linkLightBlue,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0),
                                                      child: TextFormField(
                                                        controller: otpController,
                                                        validator: (value) {
                                                          if (value == null || value.isEmpty) {
                                                            return "* Required.";
                                                          } else if (value.length < 6) {
                                                            return "Invalid OTP";
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        maxLength: 6,
                                                        maxLines: 1,
                                                        keyboardType: TextInputType.number,
                                                        autofocus: true,
                                                        textAlign: TextAlign.center,
                                                        decoration: InputDecoration(
                                                          floatingLabelAlignment: FloatingLabelAlignment.center,
                                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                                          labelText: AppText.oneTimePassword,
                                                        ),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(top: 12.0, left: 26.0, right: 26.0),
                                                      child: Text(
                                                        "OTP has been sent to registered mobile number",
                                                        style: TextStyle(color: Colors.green, fontSize: 12.0),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 20.0, left: 72.0, right: 72.0),
                                                      child: SizedBox(
                                                        height: 40,
                                                        width: double.infinity,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(8)), // <-- Radius
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            if (formKey1.currentState!.validate()) {
                                                              //verify
                                                              setState(() async {
                                                                String publicIPAddress = "0.0.0.0";
                                                                String modelName = "";
                                                                String deviceName = "";
                                                                String browserName = "SalaryCredits Android App";

                                                                try {
                                                                  var ipAddress = IpAddress(type: RequestType.text);
                                                                  publicIPAddress = await ipAddress.getIpAddress();

                                                                  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

                                                                  if (Platform.operatingSystem == "android") {
                                                                    // Android
                                                                    AndroidDeviceInfo info = await deviceInfo.androidInfo;
                                                                    modelName = info.brand;
                                                                    deviceName = info.device;
                                                                  } else {
                                                                    // iOS
                                                                    browserName = "SalaryCredits ios App";
                                                                    IosDeviceInfo info = await deviceInfo.iosInfo;
                                                                    modelName = info.model;
                                                                    deviceName = info.name;
                                                                  }
                                                                } catch (ex) {
                                                                  //
                                                                }

                                                                LenderAgreementModel agreementRequest = LenderAgreementModel();
                                                                agreementRequest.setApplicationId = shortLoan.getApplicationId;
                                                                agreementRequest.setAccepted = true;
                                                                agreementRequest.setBankId = lenderAgreementModel.getBankId;

                                                                TermsAcceptanceProof termsAcceptanceProof = TermsAcceptanceProof();
                                                                termsAcceptanceProof.setApplicationId = shortLoan.getApplicationId;
                                                                termsAcceptanceProof.setIPAddress = publicIPAddress;
                                                                termsAcceptanceProof.setComputerName = "$modelName - $deviceName";
                                                                termsAcceptanceProof.setBrowserName = browserName;
                                                                termsAcceptanceProof.setAccessedUrl = "";
                                                                termsAcceptanceProof.setScreenshotUrl = "";
                                                                termsAcceptanceProof.setOSName = Platform.operatingSystem;
                                                                termsAcceptanceProof.setBankId = lenderAgreementModel.getBankId;
                                                                agreementRequest.setTermsAcceptanceProof = termsAcceptanceProof;

                                                                acceptLoanAgreement(agreementRequest);
                                                              });
                                                            }
                                                          },
                                                          child: const Text(
                                                            'Accept',
                                                            style: TextStyle(color: AppColor.white, fontSize: 16.0, fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        resendLoanAgreementOTP(user.applicantId!);
                                                      },
                                                      child: const Padding(
                                                        padding: EdgeInsets.only(top: 16.0),
                                                        child: Text(
                                                          "Resend OTP",
                                                          style: AppStyle.linkLightBlue2,
                                                        ),
                                                      ),
                                                    )
                                                  ],
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
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16.0, left: 16.0, right: 16.0),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(width: 1, color: AppColor.grey2),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: const Text(
                            "Personal Reference",
                            style: AppStyle.pageTitle,
                          ),
                          initiallyExpanded: isReferenceAdded,
                          leading: SizedBox.fromSize(
                            size: const Size(38, 38),
                            child: const ClipOval(
                              child: Material(
                                color: AppColor.darkBlue,
                                child: Center(
                                  child: Text(
                                    "2",
                                    style: AppStyle.pageTitle2White,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          children: <Widget>[
                            Visibility(
                              visible: isReferenceAdded,
                              child: const Padding(
                                padding: EdgeInsets.only(top: 0.0, left: 12.0, right: 12.0, bottom: 16.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.done,
                                      size: 32,
                                      color: AppColor.lightBlue,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Added",
                                      style: AppStyle.pageTitle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            isLoadingReferences
                                ? const Center(child: SizedBox(height: 130.0, child: Center(child: CircularProgressIndicator())))
                                : Visibility(
                                    visible: !isReferenceAdded,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0, bottom: 26.0),
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Add personal references from Friends/Family/Colleagues.",
                                            style: AppStyle.textLabel2,
                                          ),
                                          SizedBox(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0, bottom: 0.0),
                                              child: Column(
                                                children: [
                                                  Visibility(
                                                    visible: showHideReference1Delete,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          child: Column(
                                                            children: [
                                                              Text("1. ${objRef1.getName.isNotEmpty ? objRef1.getName : "NA"}",
                                                                  style: AppStyle.pageTitle),
                                                              const SizedBox(
                                                                height: 4.0,
                                                              ),
                                                              Text(" ${objRef1.getMobile.isNotEmpty ? objRef1.getMobile : "NA"}",
                                                                  style: AppStyle.smallGrey),
                                                            ],
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            //delete reference
                                                            setState(() {
                                                              showHideReference1Delete = false;
                                                              objRef1 = PersonalReferenceModel();
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            size: 32,
                                                            color: AppColor.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: !showHideReference1Delete,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const SizedBox(
                                                          child: Text("1. Add Personal Reference", style: AppStyle.pageTitle),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            //show popup
                                                            popupAddPersonalReference('1. Add Personal Reference', 1);
                                                          },
                                                          icon: const Icon(
                                                            Icons.add_circle_sharp,
                                                            size: 32,
                                                            color: AppColor.lightBlue,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(
                                                    height: 10.0,
                                                    color: AppColor.grey2,
                                                    thickness: 2,
                                                  ),
                                                  Visibility(
                                                    visible: showHideReference2Delete,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          child: Column(
                                                            children: [
                                                              Text("2. ${objRef2.getName.isNotEmpty ? objRef2.getName : "NA"}",
                                                                  style: AppStyle.pageTitle),
                                                              const SizedBox(
                                                                height: 4.0,
                                                              ),
                                                              Text(" ${objRef2.getMobile.isNotEmpty ? objRef2.getMobile : "NA"}",
                                                                  style: AppStyle.smallGrey),
                                                            ],
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            //delete reference
                                                            setState(() {
                                                              showHideReference2Delete = false;
                                                              objRef2 = PersonalReferenceModel();
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            size: 32,
                                                            color: AppColor.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: !showHideReference2Delete,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const SizedBox(
                                                          child: Text("2. Add Personal Reference", style: AppStyle.pageTitle),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            //show popup
                                                            popupAddPersonalReference('2. Add Personal Reference', 2);
                                                          },
                                                          icon: const Icon(
                                                            Icons.add_circle_sharp,
                                                            size: 32,
                                                            color: AppColor.lightBlue,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: showHideSaveReferenceBtn,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 20.0, left: 72.0, right: 72.0),
                                                      child: SizedBox(
                                                        height: 40,
                                                        width: double.infinity,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(8)), // <-- Radius
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            //save two personal references here
                                                            if (personalReferenceModels.isNotEmpty) {
                                                              if (personalReferenceModels.length == 2) {
                                                                if (objRef1.getMobile == objRef2.getMobile) {
                                                                  Global.showAlertDialog(context, "Mobile number can not be the same");
                                                                } else {
                                                                  //call api to save personal references
                                                                  savePersonalReferences();
                                                                }
                                                              }
                                                            }
                                                          },
                                                          child: const Text(
                                                            'Save',
                                                            style: TextStyle(color: AppColor.white, fontSize: 16.0, fontWeight: FontWeight.w600),
                                                          ),
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
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16.0, left: 16.0, right: 16.0),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(width: 1, color: AppColor.grey2),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          onExpansionChanged: (value) {
                            if (!isNachAdded) {
                              getLoanNACH();
                            }
                          },
                          title: const Text(
                            "ECS Authorization",
                            style: AppStyle.pageTitle,
                          ),
                          initiallyExpanded: isNachAdded,
                          leading: SizedBox.fromSize(
                            size: const Size(38, 38),
                            child: const ClipOval(
                              child: Material(
                                color: AppColor.darkBlue,
                                child: Center(
                                  child: Text(
                                    "3",
                                    style: AppStyle.pageTitle2White,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          children: <Widget>[
                            Visibility(
                              visible: isNachAdded,
                              child: const Padding(
                                padding: EdgeInsets.only(top: 0.0, left: 12.0, right: 12.0, bottom: 16.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.done,
                                      size: 32,
                                      color: AppColor.lightBlue,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Accepted",
                                      style: AppStyle.pageTitle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            isLoadingNACH
                                ? const Center(child: SizedBox(height: 130.0, child: Center(child: CircularProgressIndicator())))
                                : Visibility(
                                    visible: !isNachAdded,
                                    child: Form(
                                      key: formKey3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            const Text("Kindly complete e-NACH/ECS Mandate."),
                                            const SizedBox(height: 16.0),
                                            InkWell(
                                              onTap: () {
                                                //open link in browser
                                                if (externalLoanProcessModel.getECSLink.isNotEmpty) {
                                                  final Uri url = Uri.parse(externalLoanProcessModel.getECSLink);
                                                  Global.launchURL(url);
                                                } else {
                                                  Global.showAlertDialog(context, "ECS/NACH link is not added, it should be available soon");
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColor.white,
                                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                  border: Border.all(width: 1, color: AppColor.darkBlue),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.only(top: 6.0, bottom: 6.0, left: 16.0, right: 16.0),
                                                  child: Text(
                                                    "Activate",
                                                    style: TextStyle(color: AppColor.darkBlue, fontSize: 13.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: showHideContinueBtn,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
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
                              child: const Text('Continue', style: AppStyle.buttonText),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void popupAddPersonalReference(String title, int number) {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(8.0),
          actionsAlignment: MainAxisAlignment.center,
          title: Text(title),
          content: SingleChildScrollView(
            child: Container(
              height: 450.0,
              width: double.maxFinite,
              decoration: const BoxDecoration(
                color: AppColor.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: formKey2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              controller: fullNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "* Full Name is required";
                                } else {
                                  return Global.validateCommonName(value, "Name", 3);
                                }
                              },
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: AppColor.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                hintText: 'Enter Full name',
                                labelText: "Enter Full name",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: TextFormField(
                              controller: mobileNumberController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "* Mobile Number is required";
                                } else if (value.length < 3) {
                                  return "Please enter valid mobile number";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: AppColor.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                hintText: "Enter Mobile Number",
                                labelText: "Enter Mobile Number",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: DropdownButtonFormField<String>(
                              value: relationTypeValue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "* Relation is required";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: AppColor.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                hintText: "Choose Relation",
                                labelText: "Choose Relation",
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  relationTypeValue = newValue!;
                                });
                              },
                              items: relationTypeList,
                            ),
                          ),
                          const SizedBox(
                            height: 32.0,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
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
                                  if (formKey2.currentState!.validate()) {
                                    //create model to send further

                                    setState(() {
                                      if (number == 1) {
                                        showHideReference1Delete = true;

                                        objRef1.setApplicationId = shortLoan.getApplicationId;
                                        objRef1.setName = fullNameController.text.toString();
                                        objRef1.setMobile = mobileNumberController.text.toString();
                                        objRef1.setRelationId = int.parse(relationTypeValue!);

                                        personalReferenceModels.add(objRef1);
                                      } else if (number == 2) {
                                        showHideReference2Delete = true;

                                        objRef2.setApplicationId = shortLoan.getApplicationId;
                                        objRef2.setName = fullNameController.text.toString();
                                        objRef2.setMobile = mobileNumberController.text.toString();
                                        objRef2.setRelationId = int.parse(relationTypeValue!);

                                        personalReferenceModels.add(objRef2);
                                      }

                                      if (personalReferenceModels.length == 2) {
                                        showHideSaveReferenceBtn = true;
                                      }
                                    });

                                    Navigator.of(context).pop(); //Close the dialog
                                  }
                                },
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        backgroundColor: AppColor.white,
                                        color: AppColor.lightBlue,
                                      )
                                    : const Text(
                                        'Add',
                                        style: AppStyle.buttonText,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 0.0, right: 0.0),
                      child: Center(
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); //Close the dialog
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Close",
                  style: AppStyle.pageTitle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
