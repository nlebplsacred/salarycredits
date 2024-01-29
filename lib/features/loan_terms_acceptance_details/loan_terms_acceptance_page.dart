import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:salarycredits/features/loan_apply_confirm_otp/loan_apply_otp_page.dart';
import 'package:salarycredits/features/loan_profile_picture/loan_profile_picture_page.dart';
import 'package:salarycredits/models/loan/lender_consent_model.dart';
import 'package:salarycredits/utility/custom_loader.dart';
import 'package:salarycredits/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/document/document_model.dart';
import '../../models/loan/loan_model.dart';
import '../../models/login/login_response_model.dart';
import '../../services/file_handler.dart';
import '../../services/loan_handler.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';

class LoanTermsAcceptancePage extends StatefulWidget {
  final LoanModel loanModel;

  const LoanTermsAcceptancePage({required this.loanModel, super.key});

  @override
  State<LoanTermsAcceptancePage> createState() => _LoanTermsAcceptancePageState();
}

class _LoanTermsAcceptancePageState extends State<LoanTermsAcceptancePage> {
  LoginResponseModel user = LoginResponseModel();
  LoanModel loanApplicationModel = LoanModel();
  LoanHandler loanHandler = LoanHandler();
  FileHandler fileHandler = FileHandler();
  LenderConsent lenderConsent = LenderConsent();
  LoanDocumentsModel loanDocumentsModel = LoanDocumentsModel();

  bool isLoading = true,
      isLoadingBtn = false,
      isProfilePicAdded = false,
      passwordVisible = false,
      chkBoxConsent1 = false,
      chkBoxConsent2 = false,
      chkBoxConsent3 = false;
  String errorMessage = "", chkBoxConsent3Text = AppText.consent3, termsDescription = AppText.terms;

  @override
  void initState() {
    super.initState();
    loanApplicationModel = widget.loanModel;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));
        getLenderConsentDetails(loanApplicationModel.getBankId);
      });
    });
  }

  void getLenderConsentDetails(int bankId) {
    loanHandler.getLenderConsentDetails(bankId).then((value) {
      setState(() {
        lenderConsent = value;

        //print('nitya${lenderConsent.getBankName}');

        if (lenderConsent.getBankName.isNotEmpty) {
          chkBoxConsent3Text = chkBoxConsent3Text.replaceAll("{||}", lenderConsent.getBankName);
        }

        if (lenderConsent.getConsentDescription.isNotEmpty) {
          termsDescription = lenderConsent.getConsentDescription;
        }

        getMyDocuments(user.applicantId!, "4");
      });
    });
  }

  void getMyDocuments(int applicantId, String fileTypes) async {
    try {
      await fileHandler.getMyDocuments(applicantId, fileTypes).then((value) {
        setState(() {
          loanDocumentsModel = value;
          isLoading = false;

          //fetched from server
          if (loanDocumentsModel.getDocuments.isNotEmpty) {
            for (int i = 0; i < loanDocumentsModel.getDocuments.length; i++) {
              Documents itemDoc = loanDocumentsModel.getDocuments[i];
              if (itemDoc.getFileTypeId == 4) {
                isProfilePicAdded = true;
              }
            }
          }
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoading = false;
          errorMessage = fileHandler.errorMessage;
          Global.showAlertDialog(context, errorMessage);
        });
      });
    } catch (ex) {
      setState(() {
        isLoading = false;
        errorMessage = 'Network not available';
        Global.showAlertDialog(context, errorMessage);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
          "Terms Acceptance",
          style: TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? const CustomLoader()
            : Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        height: 500,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          border: Border.all(width: 1, color: AppColor.grey2),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 16.0),
                              const Text("SalaryCredits Standard Terms (Loan Agreement)", style: AppStyle.pageTitle),
                              const SizedBox(height: 10),
                              Html(
                                data: termsDescription,
                                style: {
                                  "body": Style(
                                    fontSize: FontSize(14.0),
                                    fontWeight: FontWeight.normal,
                                    color: AppColor.lightBlack,
                                  ),
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          border: Border.all(width: 1, color: AppColor.grey2),
                        ),
                        child: Column(
                          children: [
                            ListTileTheme(
                              minLeadingWidth: 0,
                              horizontalTitleGap: 0,
                              child: CheckboxListTile(
                                title: Text(
                                  AppText.consent1,
                                  style: const TextStyle(color: AppColor.grey, fontSize: 14.0),
                                ),
                                value: chkBoxConsent1,
                                onChanged: (newValue) {
                                  setState(() {
                                    chkBoxConsent1 = newValue ?? false;
                                  });
                                },
                                subtitle: !chkBoxConsent1
                                    ? const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          '* Required.',
                                          style: TextStyle(color: Colors.red, fontSize: 12.0),
                                        ),
                                      )
                                    : null,
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: const EdgeInsets.only(top: 16.0, right: 16.0),
                              ),
                            ),
                            ListTileTheme(
                              minLeadingWidth: 0,
                              horizontalTitleGap: 0,
                              child: CheckboxListTile(
                                title: Text(
                                  AppText.consent2,
                                  style: const TextStyle(color: AppColor.grey, fontSize: 14.0),
                                ),
                                value: chkBoxConsent2,
                                onChanged: (newValue) {
                                  setState(() {
                                    chkBoxConsent2 = newValue ?? false;
                                  });
                                },
                                subtitle: !chkBoxConsent2
                                    ? const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          '* Required.',
                                          style: TextStyle(color: Colors.red, fontSize: 12.0),
                                        ),
                                      )
                                    : null,
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: const EdgeInsets.only(top: 16.0, right: 16.0),
                              ),
                            ),
                            ListTileTheme(
                              minLeadingWidth: 0,
                              horizontalTitleGap: 0,
                              child: CheckboxListTile(
                                title: Text(
                                  chkBoxConsent3Text,
                                  style: const TextStyle(color: AppColor.grey, fontSize: 14.0),
                                ),
                                value: chkBoxConsent3,
                                onChanged: (newValue) {
                                  setState(() {
                                    chkBoxConsent3 = newValue ?? false;
                                  });
                                },
                                subtitle: !chkBoxConsent3
                                    ? const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          '* Required.',
                                          style: TextStyle(color: Colors.red, fontSize: 12.0),
                                        ),
                                      )
                                    : null,
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: const EdgeInsets.only(top: 16.0, right: 16.0, bottom: 16.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
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
                            if (chkBoxConsent1 && chkBoxConsent2 && chkBoxConsent3) {
                              if (!isProfilePicAdded) {

                                //send to profile picture page
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return LoanProfilePicturePage(loanModel: loanApplicationModel);
                                }));

                              } else {

                                //send to otp confirmation page
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return LoanApplyOTPPage(loanModel: loanApplicationModel);
                                }));

                              }
                            } else {
                              Global.showAlertDialog(context, "Kindly authorise all the terms");
                            }
                          },
                          child: isLoadingBtn
                              ? const CircularProgressIndicator(
                                  backgroundColor: AppColor.white,
                                  color: AppColor.lightBlue,
                                )
                              : const Text(
                                  'Accept & Continue',
                                  style: AppStyle.buttonText,
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
}
