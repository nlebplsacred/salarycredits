import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:salarycredits/values/styles.dart';

import '../../services/user_handler.dart';
import '../../values/colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  final UserHandler userHandler = UserHandler();
  bool showMobileLogin = true;
  bool showSearchEmployer = false;
  bool isLoading = false;
  String errorMsg = "";
  bool isError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  forgotPassword() async {
    setState(() {
      isLoading = true;
      errorMsg = '';
    });

    await userHandler
        .forgotPassword(emailController.text.toString())
        .then((value) {
      setState(() {
        isLoading = false;
        var data = jsonDecode(value);

        //String statusId = data['StatusId'].toString();
        String message = data['Message'].toString();

        if (message == "success") {
          errorMsg = "An email has been sent to you";
        } else {
          errorMsg = message;
        }
        isError = true;
      });
    }).catchError((error, stackTrace) {
      setState(() {
        isLoading = false;
        errorMsg = userHandler.errorMessage;
        isError = true;
      });
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
          "Forgot Password",
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
          padding: const EdgeInsets.only(top: 42, left: 16.0, right: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    child: Image.asset("assets/logo_favicon.png",
                        width: 72, height: 72),
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "What's My Password?",
                    style: AppStyle.heading32,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 32.0, right: 32.0),
                      child: Text(
                        "If you have forgotten your password you can get it here.",
                        style: TextStyle(
                          color: AppColor.lightBlack,
                          fontSize: 15.0,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 32.0, right: 32.0),
                        child: TextFormField(
                          controller: emailController,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "* Required"),
                            EmailValidator(errorText: "Enter valid email id"),
                          ]).call,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            hintText: 'Enter your email id',
                            labelText: "Enter your email id",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      isError
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 45.0, right: 45.0),
                              child: Text(
                                errorMsg,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 13.0),
                              ),
                            )
                          : const Text(""),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 32.0, right: 32.0),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.lightBlue,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8)), // <-- Radius
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                forgotPassword();
                              }
                            },
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    backgroundColor: AppColor.white,
                                    color: AppColor.lightBlue,
                                  )
                                : const Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: AppColor.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
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
    );
  }
}
