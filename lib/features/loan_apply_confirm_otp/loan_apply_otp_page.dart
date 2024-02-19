import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salarycredits/features/loan_apply_confirmed/loan_apply_confirmed_page.dart';
import 'package:salarycredits/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/loan/loan_model.dart';
import '../../models/login/login_response_model.dart';
import '../../services/loan_handler.dart';
import '../../services/user_handler.dart';
import '../../utility/custom_loader.dart';
import '../../utility/global.dart';
import '../../utility/show_snack_bar.dart';
import '../../values/colors.dart';
import '../../values/strings.dart';

class LoanApplyOTPPage extends StatefulWidget {
  final LoanModel loanModel;

  const LoanApplyOTPPage({required this.loanModel, super.key});

  @override
  State<LoanApplyOTPPage> createState() => _LoanApplyOTPPageState();
}

class _LoanApplyOTPPageState extends State<LoanApplyOTPPage> {
  final UserHandler userHandler = UserHandler();
  final formKey = GlobalKey<FormState>();
  final form2Key = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool privacyAccepted = true;
  TextEditingController otpController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  LoanHandler loanHandler = LoanHandler();
  LoginResponseModel user = LoginResponseModel();
  LoanModel loanApplicationModel = LoanModel();
  String mobileNumberMasked = "Mobile Number - ";
  String mobileNumber = "";
  bool isLoading = false, isError = false;
  String errorMsg = "";
  String randOTPNumber = "";
  late Future<String> futureSendOtpData = Future(() => "");
  bool showVerifyOtp = true;
  bool showMobileUpdate = false;
  bool isMobileUpdated = false;

  @override
  void initState() {
    super.initState();
    loanApplicationModel = widget.loanModel;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));

        mobileNumber = user.mobile.toString() == 'null' ? "" : user.mobile.toString();

        if (mobileNumber != "") {
          mobileNumberMasked = "Mobile Number - ${Global.getMaskedMobile(mobileNumber)}";
          futureSendOtpData = sendApplyOtp();
        } else {
          mobileNumberMasked = "Mobile Number - XXXX";
          showVerifyOtp = false;
          showMobileUpdate = true;
        }
      });
    });
  }

  Future<String> sendApplyOtp() async {
    randOTPNumber = Global.getRandomNumber();
    return userHandler.sendApplyOTP(mobileNumber, randOTPNumber);
  }

  void applyConfirm() {
    setState(() {
      isLoading = true;
    });

    try {
      loanHandler.applyConfirm(loanApplicationModel.getApplicationId).then((value) {
        setState(() {
          isLoading = false;

          var data = jsonDecode(value);
          String message = data['Message'].toString();

          if (message == "Success") {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return LoanApplyConfirmedPage(loanModel: loanApplicationModel);
            }));
          } else {
            Global.showAlertDialog(context, message);
          }
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoading = false;
          errorMsg = loanHandler.errorMessage;
          Global.showAlertDialog(context, errorMsg);
        });
      });
    } catch (ex) {
      setState(() {
        isLoading = false;
        errorMsg = 'Network not available';
        Global.showAlertDialog(context, errorMsg);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog.
        bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Are you sure you want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );

        // Perform cleanup logic if the user confirms the exit.
        if (confirm == true) {
          SystemNavigator.pop();
        }
        // Return the result of the confirmation dialog.
        return confirm;
      },
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Stack(
          children: <Widget>[
            FutureBuilder<String>(
              future: futureSendOtpData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    if (snapshot.data != 'null' || snapshot.data != 'null') {
                      var data = jsonDecode(snapshot.data!);
                      //int statusId = data['StatusId'];
                      String message = data['Message'].toString();

                      isError = true;
                      errorMsg = message;
                    }
                  }
                  return buildOTPForm();
                } else if (snapshot.hasError) {
                  // Handle the error
                  return Center(child: Text('${snapshot.error}'));
                } else {
                  return const CustomLoader();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildOTPForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 130.0, left: 16.0, right: 16.0),
        child: Column(
          children: [
            Visibility(visible: showVerifyOtp, child: verifyOtpScreen()),
            Visibility(visible: showMobileUpdate, child: updateMobileScreen()),
          ],
        ),
      ),
    );
  }

  Column verifyOtpScreen() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              child: Image.asset("assets/images/logo_favicon.png", width: 72, height: 72),
            ),
          ],
        ),
        const SizedBox(height: 25.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppText.confirmOTP,
              style: const TextStyle(
                color: AppColor.lightBlack,
                fontSize: 32.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                AppText.oneTimePasswordDesc,
                style: const TextStyle(
                  color: AppColor.lightBlack,
                  fontSize: 15.0,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
        const SizedBox(height: 25.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mobileNumberMasked,
              style: const TextStyle(
                color: AppColor.lightBlack,
                fontSize: 15.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 72.0, right: 72.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
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
              ],
            ),
          ),
        ),
        isError
            ? Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
                child: Text(
                  errorMsg,
                  style: const TextStyle(color: Colors.red, fontSize: 13.0),
                ),
              )
            : const Text(""),
        Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 72.0, right: 72.0),
          child: SizedBox(
            height: 45,
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
                  //verify
                  //verifyMobile();
                  if (user.applicantId! > 0) {
                    if (otpController.text.toString() == randOTPNumber) {
                      setState(() {
                        isLoading = true;
                      });

                      userHandler.verifyMobileNumber(user.applicantId!).then((String result) {
                        setState(() {
                          isLoading = false;
                        });

                        if (result.isNotEmpty) {
                          var data = jsonDecode(result);
                          //String status = data['Status'].toString();
                          String message = data['Message'].toString();

                          if (message == "Mobile Verified") {
                            setState(() {
                              user.isMobileVerified = true;
                            });

                            if (isMobileUpdated) {
                              userHandler.updateMobileNumber(user.applicantId!, mobileNumber).then((String result) {
                                setState(() {
                                  isLoading = false;
                                });

                                var data = jsonDecode(result);
                                String message = data['Message'].toString();

                                if (message == "success") {
                                  setState(() {
                                    user.isMobileVerified = true;
                                    user.mobile = mobileController.text.toString();
                                  });

                                  applyConfirm();
                                } else {
                                  Global.showAlertDialog(context, message);
                                }
                              }).catchError((err, stackTrace) {
                                Global.showAlertDialog(context, err.toString());
                              });
                            } else {
                              applyConfirm();
                            }
                          } else {
                            Global.showAlertDialog(context, message);
                          }
                        } else {
                          Global.showAlertDialog(context, "Network not available");
                        }
                      }).catchError((err, stackTrace) {
                        Global.showAlertDialog(context, err.toString());
                      });
                    } else {
                      Global.showAlertDialog(context, "Invalid OTP");
                    }
                  } else {
                    Global.showAlertDialog(context, "Something went wrong, please try again");
                  }
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                      backgroundColor: AppColor.white,
                      color: AppColor.lightBlue,
                    )
                  : const Text(
                      'Verify',
                      style: TextStyle(color: AppColor.white, fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ),
        Column(
          children: [
            InkWell(
              onTap: () {
                //resend OTP
                setState(() {
                  futureSendOtpData = sendApplyOtp();
                });
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 32, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Resend OTP",
                      style: TextStyle(color: AppColor.lightBlue, fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                    Icon(Icons.refresh, size: 24.0, color: AppColor.lightBlue)
                  ],
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            InkWell(
              onTap: () {
                //show update mobile screen
                setState(() {
                  showMobileUpdate = true;
                  showVerifyOtp = false;
                });
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 32, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Update Mobile Number",
                      style: TextStyle(color: AppColor.darkBlue, fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                    Icon(Icons.update, size: 24.0, color: AppColor.darkBlue)
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column updateMobileScreen() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              child: Image.asset("assets/images/icon_logo_192_192.png", width: 72, height: 72),
            ),
          ],
        ),
        const SizedBox(height: 25.0),
        const Text(
          "Update Mobile Number",
          style: TextStyle(
            color: AppColor.lightBlack,
            fontSize: 28.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16.0),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add your latest mobile number",
              style: TextStyle(
                color: AppColor.lightBlack,
                fontSize: 15.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 40.0, right: 40.0),
          child: Form(
            key: form2Key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: mobileController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* Required.";
                    } else {
                      return Global.validateMobile(value);
                    }
                  },
                  maxLength: 10,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: const InputDecoration(
                    prefix: Text("+91 "),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: 'Enter your phone number',
                    labelText: "Enter your phone number",
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0, left: 45.0, right: 45.0),
          child: SizedBox(
            height: 45,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.lightBlue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)), // <-- Radius
                ),
              ),
              onPressed: () {
                if (form2Key.currentState!.validate()) {
                  //update mobile
                  if (user.applicantId! > 0) {
                    setState(() {
                      user.mobile = mobileController.text.toString();
                      mobileNumber = mobileController.text.toString();
                      showVerifyOtp = true;
                      showMobileUpdate = false;
                      isMobileUpdated = true;
                      futureSendOtpData = sendApplyOtp();
                      mobileNumberMasked = "Mobile Number - ${Global.getMaskedMobile(mobileNumber)}";
                    });
                  } else {
                    showSnackBar(context, "Something went wrong, please try again");
                  }
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                      backgroundColor: AppColor.white,
                      color: AppColor.lightBlue,
                    )
                  : const Text(
                      'Update Mobile',
                      style: TextStyle(color: AppColor.white, fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: InkWell(onTap: () {
            setState(() {
              showVerifyOtp= true;
              showMobileUpdate = false;
            });
          }, child: const Text("Go Back", style: AppStyle.linkLightBlue)),
        ),
      ],
    );
  }
}
