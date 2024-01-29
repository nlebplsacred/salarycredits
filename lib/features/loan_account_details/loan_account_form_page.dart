import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:salarycredits/features/loan_document_details/loan_document_form_page.dart';
import 'package:salarycredits/models/loan/application_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/loan/loan_model.dart';
import '../../models/loan/master_data_model.dart';
import '../../models/loan/personal_data_base_model.dart';
import '../../models/login/login_response_model.dart';
import '../../services/loan_handler.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';

class LoanAccountFormPage extends StatefulWidget {
  final LoanModel loanModel;
  final PersonalDataModel masterDataModel;

  const LoanAccountFormPage({required this.loanModel, required this.masterDataModel, super.key});

  @override
  State<LoanAccountFormPage> createState() => _LoanAccountFormPageState();
}

class _LoanAccountFormPageState extends State<LoanAccountFormPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountHolderNameController = TextEditingController();
  TextEditingController currentPINController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();

  LoanHandler loanHandler = LoanHandler();
  LoginResponseModel user = LoginResponseModel();
  LoanModel loanApplicationModel = LoanModel();
  PersonalDataModel applicantDataMasterData = PersonalDataModel();

  bool isLoading = false, showHidePASameAsCurrent = true, isPASameAsCurrent = false;

  String errorMessage = "";
  String? accountTypeValue;
  String? purposeValue;

  List<DropdownMenuItem<String>> get accountTypeList {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "1", child: Text("Saving")),
      const DropdownMenuItem(value: "2", child: Text("Current"))
    ];
    return menuItems;
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));
      });
    });

    loanApplicationModel = widget.loanModel;
    applicantDataMasterData = widget.masterDataModel;
  }

  void bindAccountDetails(PersonalDataModel model) {
    if (model.getApplicant.getApplicantId > 0) {
      if (loanApplicationModel.getBankAccount.getAccountNumber.isNotEmpty) {
        String lAccountNumber = loanApplicationModel.getBankAccount.getAccountNumber;
        String lAccountHolderName = loanApplicationModel.getBankAccount.getAccountHolderName;
        String lIFSCCode = loanApplicationModel.getBankAccount.getIFSCCode;

        if (lAccountNumber.isNotEmpty) {
          if (lAccountNumber != "0") {
            accountNumberController.text = lAccountNumber;
          }
        }

        if (lAccountHolderName.isNotEmpty) {
          accountHolderNameController.text = lAccountHolderName;
        }

        if (lIFSCCode.isNotEmpty) {
          ifscCodeController.text = lIFSCCode;
        }

        accountTypeValue = "1";
      }
    }
  }

  void createApplicationRequest(LoanModel model) async {
    setState(() {
      isLoading = true;
    });

    LoanRequestModel loanRequestModel = LoanRequestModel();

    //Application data
    loanRequestModel.setApplicantId = model.getApplicant.getApplicantId;
    loanRequestModel.setApplicationTypeId = model.getApplicationTypeId;
    loanRequestModel.setApplicationId = 0;
    loanRequestModel.setEmployerId = user.employerId!;
    loanRequestModel.setDOB = model.getApplicant.getDOB;
    loanRequestModel.setCityId = model.getApplicant.getCityId;
    loanRequestModel.setLoanAmount = model.getLoanAmount;
    loanRequestModel.setTenure = model.getTenure;
    loanRequestModel.setInterstRate = model.getInterstRate;
    loanRequestModel.setProcessingFee = model.getProcessingFee;
    loanRequestModel.setEMI = model.getEMI;
    loanRequestModel.setBankId = model.getBankId;
    loanRequestModel.setDiscountCoupon = model.getDiscountCoupon;
    loanRequestModel.setMoratoriumPeriod = model.getMoratoriumPeriod;
    loanRequestModel.setDssgIds = model.getDssgIds;
    loanRequestModel.setLoanPurposeId = model.getLoanPurposeId;

    //Applicant data
    loanRequestModel.setApplicant = model.getApplicant;

    //Bank Account data
    loanRequestModel.setBankAccount = model.getBankAccount;

    await loanHandler.createApplicationRequest(loanRequestModel).then((value) {
      setState(() {
        isLoading = false;

        LoanResponseModel loanResponseModel = value;

        if (loanResponseModel.getApplicationId > 0) {
          loanApplicationModel.setApplicationId = loanResponseModel.getApplicationId;

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoanDocumentsFormPage(loanModel: loanApplicationModel);
          }));
        } else {
          if (loanResponseModel.getMessage.isNotEmpty) {
            Global.showAlertDialog(context, loanResponseModel.getMessage);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    accountHolderNameController.dispose();
    accountNumberController.dispose();
    ifscCodeController.dispose();
  }

  callback(bool value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgDefault1,
      appBar: AppBar(
        elevation: 1.0,
        toolbarHeight: 60.0,
        titleSpacing: 2.0,
        title: const Text(
          "Confirm Salary Account Details",
          style: TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0), child: getAccountDetailsForm(applicantDataMasterData)),
      ),
    );
  }

  Column getAccountDetailsForm(PersonalDataModel model) {
    bindAccountDetails(model); //set/rre-fill the values

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text("3/4", style: AppStyle.linkLightBlue2, textAlign: TextAlign.end)]),
        Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Salary Account Details", style: AppStyle.formTitleBlue),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextFormField(
                  controller: accountNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* Account Number is required";
                    } else {
                      return Global.isValidAccountNumber(value);
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppColor.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: 'Account number',
                    labelText: "Account number",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextFormField(
                  controller: accountHolderNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* Account Holder Name is required";
                    } else if (value.length < 3) {
                      return "Please enter valid account holder name";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppColor.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: "Account holder name",
                    labelText: "Account holder name",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextFormField(
                  controller: ifscCodeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* IFSC Code is required";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppColor.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: 'IFSC code',
                    labelText: "IFSC code",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: DropdownButtonFormField<String>(
                  value: accountTypeValue,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* Account Type is required";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppColor.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: "Choose account type",
                    labelText: "Account type",
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      accountTypeValue = newValue!;
                    });
                  },
                  items: accountTypeList,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text("Purpose of Loan", style: AppStyle.formTitleBlue),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: DropdownButtonFormField<String>(
                  value: purposeValue,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* Purpose is required";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppColor.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: "Choose Purpose",
                    labelText: "Purpose of Loan",
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      purposeValue = newValue!;
                    });
                  },
                  items: model.getMasterData.purposes.map((SelectListItem item) {
                    return DropdownMenuItem<String>(
                      value: item.value,
                      child: Text(item.text),
                    );
                  }).toList(),
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

                            BankAccount bankAccount = BankAccount();
                            bankAccount.setAccountNumber = accountNumberController.text;
                            bankAccount.setAccountHolderName = accountHolderNameController.text;
                            bankAccount.setIFSCCode = ifscCodeController.text;
                            bankAccount.setAccountType = accountTypeValue!;

                            loanApplicationModel.setBankAccount = bankAccount;
                            loanApplicationModel.setLoanPurposeId = int.parse(purposeValue!);

                            createApplicationRequest(loanApplicationModel);
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
      ],
    );
  }
}
