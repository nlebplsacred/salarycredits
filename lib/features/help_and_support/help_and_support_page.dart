import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salarycredits/models/support/ask_query_request_model.dart';
import 'package:salarycredits/services/user_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/login/login_response_model.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController remarkController = TextEditingController();
  UserHandler userHandler = UserHandler();
  LoginResponseModel user = LoginResponseModel();

  bool isLoading = false, showHideError = false, showHideForm = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));
      });
    });
  }

  void askQueryRequest(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      AskQueryModel askQueryModel = AskQueryModel();
      askQueryModel.setApplicantId = user.applicantId!;
      askQueryModel.setMessage = query;

      await userHandler.askQueryRequest(askQueryModel).then((value) {
        setState(() {
          var data = json.decode(value);
          isLoading = false;

          String statusId = "";
          String message = "";

          if (data.containsKey('StatusId')) {
            statusId = data['StatusId'].toString();
          }

          if (data.containsKey('Message')) {
            message = data['Message'].toString();
          }

          if (statusId == "1") {
            showHideForm = false;
            showHideError = true;
            errorMessage = message;
          } else {
            Global.showAlertDialog(context, message);
          }
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoading = false;
          errorMessage = userHandler.errorMessage;
          Global.showAlertDialog(context, errorMessage);
        });
      });
    } catch (ex) {
      setState(() {
        isLoading = false;
        errorMessage = userHandler.errorMessage;
        Global.showAlertDialog(context, errorMessage);
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
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColor.white, // <-- SEE HERE
          statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        title: const Text(
          "Help & Support",
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
            Visibility(
              visible: showHideForm,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextFormField(
                          controller: remarkController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please describe your query";
                            }
                            return null;
                          },
                          maxLines: 4,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColor.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                            hintText: 'Please describe your query...',
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
                                    askQueryRequest(remarkController.text.toString());
                                  }
                                },
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        backgroundColor: AppColor.white,
                                        color: AppColor.lightBlue,
                                      )
                                    : const Text(
                                        'Submit',
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
            Visibility(
              visible: showHideError,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0, bottom: 20.0),
                      child: Text(errorMessage, style: const TextStyle(color: AppColor.green, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0,),
            const Text("Mail us: support@salarycredits.com", style: AppStyle.pageTitle),
            // const SizedBox(height: 8.0,),
            // const Text("Call: +91-925-046-6666", style: AppStyle.pageTitle2),
          ],
        ),
      ),
    );
  }
}
