import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../../models/login/login_response_model.dart';
import '../../services/user_handler.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';
import '../dashboard/dashboard_page.dart';
import '../nominate_employer/nominate_my_employer_page.dart';
import '../one_time_password/one_time_password.dart';

class FindMyAccount extends StatefulWidget {
  const FindMyAccount({super.key});

  @override
  State<FindMyAccount> createState() => _FindMyAccountState();
}

class _FindMyAccountState extends State<FindMyAccount> {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController emailOTPController = TextEditingController();
  LoginResponseModel loginModel = LoginResponseModel();
  final UserHandler userHandler = UserHandler();
  bool showEmailLogin = true, showHideSearchAccount = true, showHideVerifyAccount = false;
  bool showSearchEmployer = false, showHideLink = false;
  bool isLoading = false;
  String error = '';
  String randOTPNumber = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    emailOTPController.dispose();
  }

  sendEmailOTP(int applicantId, String email) async {
    setState(() {
      isLoading = true;
    });

    randOTPNumber = Global.getRandomNumber();

    userHandler.sendEmailOTP(applicantId, email, randOTPNumber).then((value) {
      setState(() {
        isLoading = false;
        error = 'OTP sent on mail';
      });
    });
  }

  findAccountByEmail(String emailId) async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      await userHandler.fetchUser2(emailId).then((LoginResponseModel result) {
        setState(() {
          isLoading = false;
          loginModel = result;

          if (userHandler.errorMessage.isNotEmpty) {
            error = userHandler.errorMessage;
          } else {
            //in case account is found send OTP on email to verify account
            if (loginModel.applicantId! > 0) {
              sendEmailOTP(loginModel.applicantId!, loginModel.userEmail!); //send OTP on email for verification

              showHideVerifyAccount = true;
              showHideSearchAccount = false;
              showHideLink = false;
            }
            else{
              Global.showAlertDialog(context, "The provided email is not in our records; kindly enter a different email address.");
              showHideLink = true;
            }
          }
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoading = false;
          error = userHandler.errorMessage;
        });
      });
    } catch (ex) {
      setState(() {
        isLoading = false;
        error = userHandler.errorMessage;
      });
    }
  }

  verifyAccount(int aid, String otp) async {
    setState(() {
      isLoading = true;
      error = '';
    });

    if (otp == randOTPNumber) {
      userHandler.updateUserSession(aid).then((value) {
        setState(() {
          isLoading = false;
          loginModel = value;
        });

        //redirect to dashboard if mobile is verified or open a new screen to verify mobile number
        if (loginModel.isMobileVerified!) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return const DashboardPage();
          }));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return OneTimePasswordPage(user: loginModel);
          }));
        }
      });
    } else {
      setState(() {
        error = 'Please enter valid OTP';
        isLoading = false;
      });
    }
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
        title: const Text(
          "Find Your Login Account",
          style: TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0, bottom: 0.0),
              decoration: const BoxDecoration(color: AppColor.lightBlue2, borderRadius: BorderRadius.all(Radius.circular(12))),
              child: const Padding(
                padding: EdgeInsets.only(top: 20.0, left: 12.0, right: 12.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Apologies, but we couldn't locate your SalaryCredits account using the provided credentials.", style: AppStyle.pageTitle),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text("Important Note:", style: AppStyle.pageTitle3),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text("\u2022 SalaryCredits exclusively serves employees whose employers are already registered on the platform.",
                        style: AppStyle.lightBlack14),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text("\u2022 SalaryCredits does not provide direct registration on the platform.", style: AppStyle.lightBlack14),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                        "\u2022 If you believe your employer has already joined SalaryCredits, you can locate your account by entering your Personal or Official EmailId.",
                        style: AppStyle.lightBlack14),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
            ),
            //add more widget here
            const SizedBox(height: 20.0),
            Visibility(
              visible: showHideSearchAccount,
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Search SalaryCredits Account",
                        style: TextStyle(
                          color: AppColor.lightBlack,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2, height: 24.0, color: AppColor.grey2, indent: 80, endIndent: 80),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Form(
                      key: formKey1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0),
                            child: TextFormField(
                              controller: emailController,
                              validator: MultiValidator([
                                RequiredValidator(errorText: "* Required"),
                                EmailValidator(errorText: "Enter valid email id"),
                              ]).call,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                hintText: 'Enter your personal or official email id',
                                labelText: "Enter your personal or official email id",
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                            child: Center(
                              child: Text(
                                error,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0),
                            child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.lightBlue,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ), // <-- Radius
                                  ),
                                ),
                                onPressed: () {
                                  if (formKey1.currentState!.validate()) {
                                    findAccountByEmail(emailController.text.toString());
                                  }
                                },
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        backgroundColor: AppColor.white,
                                        color: AppColor.lightBlue,
                                      )
                                    : const Text(
                                        'Search',
                                        style: TextStyle(color: AppColor.white, fontSize: 16.0, fontWeight: FontWeight.w500),
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
            Visibility(
              visible: showHideVerifyAccount,
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Verify SalaryCredits Account",
                        style: TextStyle(
                          color: AppColor.lightBlack,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2, height: 24.0, color: AppColor.grey2, indent: 80, endIndent: 80),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Form(
                      key: formKey2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center(child: Text("Email Id: ${Global.getMaskedEmail(emailController.text.toString())}")),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 26.0, left: 72.0, right: 72.0),
                            child: TextFormField(
                              controller: emailOTPController,
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
                              decoration: const InputDecoration(
                                floatingLabelAlignment: FloatingLabelAlignment.center,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: "Enter OTP sent on email",
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                            child: Center(
                              child: Text(
                                error,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0),
                            child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.lightBlue,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ), // <-- Radius
                                  ),
                                ),
                                onPressed: () {
                                  if (formKey2.currentState!.validate()) {
                                    verifyAccount(loginModel.applicantId!, emailOTPController.text.toString());
                                  }
                                },
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        backgroundColor: AppColor.white,
                                        color: AppColor.lightBlue,
                                      )
                                    : const Text(
                                        'Verify',
                                        style: TextStyle(color: AppColor.white, fontSize: 16.0, fontWeight: FontWeight.w500),
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
            Visibility(
              visible: showHideLink,
              child: InkWell(
                onTap: () {
                  //redirect to dashboard if mobile is verified or open a new screen to verify mobile number
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const NominateMyEmployerActivity();
                  }));
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 26.0, bottom: 4.0),
                  child: Center(
                    child: Text("Want to tell your employer about SalaryCredits?", style: AppStyle.linkDarkBlue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
