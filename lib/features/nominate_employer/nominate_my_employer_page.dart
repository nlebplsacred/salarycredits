import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salarycredits/models/login/employer_info.dart';

import '../../services/user_handler.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';

class NominateMyEmployerActivity extends StatefulWidget {
  const NominateMyEmployerActivity({super.key});

  @override
  State<NominateMyEmployerActivity> createState() =>
      _NominateMyEmployerActivityState();
}

class _NominateMyEmployerActivityState
    extends State<NominateMyEmployerActivity> {
  final formKey = GlobalKey<FormState>();
  TextEditingController yourCompanyController = TextEditingController();
  TextEditingController hrManagerController = TextEditingController();
  TextEditingController phoneHrManagerController = TextEditingController();
  TextEditingController emailHrManagerController = TextEditingController();
  TextEditingController yourFullNameController = TextEditingController();
  TextEditingController yourEmailController = TextEditingController();
  final UserHandler userHandler = UserHandler();
  NominateEmployer nominateEmployerResponse = NominateEmployer();
  bool isLoading = false;
  String errorMessage = '';
  bool autoValidate = false;
  bool showNominateForm = true;
  bool showNominateResult = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    yourCompanyController.dispose();
    hrManagerController.dispose();
    phoneHrManagerController.dispose();
    emailHrManagerController.dispose();
    yourFullNameController.dispose();
    yourEmailController.dispose();
  }

  nominateEmployer() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });


    NominateEmployer requestModel = NominateEmployer(
        companyName: yourCompanyController.text.toString(),
        hRManagerName: hrManagerController.text.toString(),
        hRManagerPhone: phoneHrManagerController.text.toString(),
        hRManagerEmail: emailHrManagerController.text.toString(),
        employeeFullName: yourFullNameController.text.toString(),
        employeeEmail: yourEmailController.text.toString(),
        nominatedFrom: Platform.operatingSystem);

    await userHandler.nominateEmployer(requestModel).then((value) {
      setState(() {
        isLoading = false;
        nominateEmployerResponse = value;

        if (nominateEmployerResponse.id != null) {
          if (nominateEmployerResponse.id! > 0) {
            showNominateForm = false;
            showNominateResult = true;
          } else {
            errorMessage = AppText.somethingWentWrong;
          }
        } else {
          errorMessage = AppText.somethingWentWrong;
        }
      });
    }).catchError((error, stackTrace) {
      setState(() {
        isLoading = false;
        errorMessage = error;
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
          "Nominate Your Employer",
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
            padding: const EdgeInsets.only(top: 25.0, left: 16.0, right: 16.0),
            child: Column(
              children: [
                Visibility(
                    visible: showNominateForm,
                    child: getNominateEmployerForm()),
                Visibility(visible: showNominateResult, child: getResultForm()),
              ],
            )),
      ),
    );
  }

  Column getNominateEmployerForm() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Tell your employer about SalaryCredits", style: AppStyle.pageTitle),
        ),
        const SizedBox(height: 20.0),
        Text(AppText.nominateEmployerDescription, style: AppStyle.splashDesc2),
        const SizedBox(height: 20.0),
        const Divider(
          color: AppColor.lightGrey,
          height: 2.0,
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: yourCompanyController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* Required.";
                    } else {
                      return Global.validateCommonName(
                          value, "Company Name", 4);
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: 'Name of your Company',
                    labelText: "Name of your Company",
                  ),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: hrManagerController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* Required.";
                    } else {
                      return Global.validateCommonName(value, "HR Manager", 3);
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: 'Name of HR Head/Manager or CFO/Finance Head',
                    labelText: "Name of HR Head/Manager or CFO/Finance Head",
                  ),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: phoneHrManagerController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* Required.";
                    } else {
                      return Global.validateMobile(value);
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: 'Phone no. of the above nominated person',
                    labelText: "Phone no. of the above nominated person",
                  ),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: emailHrManagerController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* Required.";
                    } else {
                      return Global.validateEmail(value);
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: 'Official Email ID of the nominated person',
                    labelText: "Official Email ID of the nominated person",
                  ),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: yourFullNameController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* Required.";
                    } else {
                      return Global.validateCommonName(value, "Full Name", 5);
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: 'Your Full Name',
                    labelText: "Your Full Name",
                  ),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: yourEmailController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* Required.";
                    } else {
                      return Global.validateEmail(value);
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: 'Your Email Id',
                    labelText: "Your Email Id",
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 0.0, right: 0.0),
                  child: Center(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, left: 16.0, right: 16.0, bottom: 20.0),
                  child: SizedBox(
                    height: 50.0,
                    width: 200.0,
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
                          nominateEmployer();
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
    );
  }

  Padding getResultForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        children: [
          Text(
            AppText.yourResponseSubmitted,
            style: AppStyle.splashDesc2,
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("What Happens next?", style: AppStyle.splashHeading3),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            AppText.weWillReachYourOrganization,
            style: AppStyle.splashDesc2,
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            AppText.writeToUs,
            style: AppStyle.splashDesc2,
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 50.0,
            width: 200.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.lightBlue,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(8)), // <-- Radius
                ),
              ),
              onPressed: () {
                SystemNavigator.pop(); //exit the app
              },
              child: const Text(
                'Exit SalaryCredits',
                style: TextStyle(
                    color: AppColor.white, fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }
}
