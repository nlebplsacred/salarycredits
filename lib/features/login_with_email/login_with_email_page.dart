import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:salarycredits/features/dashboard/dashboard_page.dart';
import 'package:salarycredits/features/login_find_account/find_my_account.dart';
import 'package:salarycredits/features/one_time_password/one_time_password.dart';
import 'package:salarycredits/services/user_handler.dart';
import 'package:salarycredits/values/colors.dart';
import 'package:salarycredits/values/strings.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:salarycredits/values/styles.dart';
import '../../models/login/login_request_model.dart';
import '../../models/login/login_response_model.dart';
import '../forgot_password/forgot_password_page.dart';

class LoginWithEmailPage extends StatefulWidget {
  const LoginWithEmailPage({super.key});

  @override
  State<LoginWithEmailPage> createState() => _LoginWithEmailPageState();
}

class _LoginWithEmailPageState extends State<LoginWithEmailPage> {
  final formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool privacyAccepted = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginResponseModel loginModel = LoginResponseModel();
  final UserHandler userHandler = UserHandler();
  bool showEmailLogin = true;
  bool showSearchEmployer = false;
  bool showHideFindAccount = false;
  bool isLoading = false;
  String error = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  loginWithEmail() async {
    EmailLoginRequestModel loginRequest = EmailLoginRequestModel(emailController.text.toString(), passwordController.text.toString(), false);

    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      await userHandler.loginWithEmail(context, loginRequest).then((String result) {
        setState(() {
          isLoading = false;
          loginModel = LoginResponseModel.fromJson(json.decode(result));

          if (loginModel.applicantId! > 0) {
            showHideFindAccount = false;
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
          } else {
            error = loginModel.message!;
            if (loginModel.statusId! == 2) {
              showHideFindAccount = true;
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

  void goBack() {
    setState(() {
      showEmailLogin = true;
      showSearchEmployer = false;
    });
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
          "Login With Email",
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
          padding: const EdgeInsets.only(top: 42.0),
          child: Column(
            children: [
              Visibility(visible: showEmailLogin, child: getLoginScreen()),
            ],
          ),
        ),
      ),
    );
  }

  Column getLoginScreen() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              child: Image.asset("assets/logo_favicon.png", width: 72, height: 72),
            ),
          ],
        ),
        const SizedBox(height: 25.0),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello again!",
              style: TextStyle(
                color: AppColor.lightBlack,
                fontSize: 36.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to SalaryCredits",
              style: TextStyle(
                color: AppColor.lightBlack,
                fontSize: 25.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Form(
            key: formKey,
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
                      hintText: 'Enter your email id',
                      labelText: "Enter your email id",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 32.0, right: 32.0),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "* Required";
                      }
                      return null;
                    },
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Enter your password",
                      labelText: "Enter your password",
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(
                            () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                      alignLabelWithHint: false,
                      filled: false,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 5.0, right: 10.0),
                  child: ListTileTheme(
                    horizontalTitleGap: 0,
                    child: CheckboxListTile(
                      title: Text(
                        AppText.termsConditions,
                        style: const TextStyle(color: AppColor.grey, fontSize: 13.0),
                      ),
                      //    <-- label
                      value: privacyAccepted,
                      onChanged: (newValue) {
                        setState(() {
                          privacyAccepted = newValue ?? false;
                        });
                      },
                      subtitle: !privacyAccepted
                          ? const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                '* Required.',
                                style: TextStyle(color: Colors.red, fontSize: 12.0),
                              ),
                            )
                          : null,
                      controlAffinity: ListTileControlAffinity.leading,
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
                Visibility(
                  visible: showHideFindAccount,
                  child: InkWell(
                    onTap: () {
                      //redirect to find my account page
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const FindMyAccount();
                      }));
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 4.0),
                      child: Center(
                        child: Text("Want to search account?", style: AppStyle.linkDarkBlue1),
                      ),
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
                        if (formKey.currentState!.validate()) {
                          // Navigate the user to the Home page
                          if (privacyAccepted) {
                            loginWithEmail(); //login with email
                          }
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator(
                              backgroundColor: AppColor.white,
                              color: AppColor.lightBlue,
                            )
                          : const Text(
                              'Log In',
                              style: TextStyle(color: AppColor.white, fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ForgotPasswordPage();
                }));
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 32, left: 16.0, right: 16.0),
                child: Text(
                  "Forgot Password?",
                  style: AppStyle.linkLightBlue,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
