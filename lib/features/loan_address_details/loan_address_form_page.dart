import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:salarycredits/features/loan_account_details/loan_account_form_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/loan/city_pincode_model.dart';
import '../../models/loan/loan_model.dart';
import '../../models/loan/master_data_model.dart';
import '../../models/loan/personal_data_base_model.dart';
import '../../models/login/login_response_model.dart';
import '../../services/loan_handler.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';

class LoanAddressFormPage extends StatefulWidget {
  final LoanModel loanModel;
  final PersonalDataModel masterDataModel;

  const LoanAddressFormPage({required this.loanModel, required this.masterDataModel, super.key});

  @override
  State<LoanAddressFormPage> createState() => _LoanAddressFormPageState();
}

class _LoanAddressFormPageState extends State<LoanAddressFormPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController currentAdd1Controller = TextEditingController();
  TextEditingController currentAdd2Controller = TextEditingController();
  TextEditingController currentPINController = TextEditingController();

  TextEditingController permanentAdd1Controller = TextEditingController();
  TextEditingController permanentAdd2Controller = TextEditingController();
  TextEditingController permanentPINController = TextEditingController();

  LoanHandler loanHandler = LoanHandler();
  LoginResponseModel user = LoginResponseModel();
  LoanModel loanApplicationModel = LoanModel();
  PersonalDataModel applicantDataMasterData = PersonalDataModel();

  bool isLoading = false, isPinLoading = false, showHidePASameAsCurrent = true, isPASameAsCurrent = false;

  String errorMessage = "";
  String? currentCityValue;
  String? permanentCityValue;
  String? livingHereValue;

  String currentCityValueNew = "";
  String currentPINValueNew = "";

  String permanentCityValueNew = "";
  String permanentPINValueNew = "";

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

  void bindAddressDetails(PersonalDataModel model) {
    if (model.getApplicant.getApplicantId > 0) {
      String lCurrentAddress1 = model.getApplicant.getCurrentAddress;
      String lCurrentAddress2 = model.getApplicant.getCurrentAddress2;
      int lCurrentCityId = model.getApplicant.getCityId;
      String lCurrentPincode = model.getApplicant.getPincode;
      String lTotalStabilityId = loanApplicationModel.getApplicant.getResidingSinceOnCurrentAddress;

      String lPermanentAddress1 = model.getApplicant.getPermanentAddress;
      String lPermanentAddress2 = model.getApplicant.getPermanentAddress2;
      int lPermanentCityId = model.getApplicant.getPermanentCityId;
      String lPermanentPincode = model.getApplicant.getPermanentPincode;

      if (model.getApplicant.getPermanentAddressSameAsLocalAddress) {
        lPermanentAddress1 = lCurrentAddress1;
        lPermanentAddress2 = lCurrentAddress2;
        lPermanentCityId = lCurrentCityId;
        lPermanentPincode = lCurrentPincode;

        if (isPASameAsCurrent) {
          showHidePASameAsCurrent = false;
        }
      }

      if (lCurrentAddress1.isNotEmpty) {
        currentAdd1Controller.text = lCurrentAddress1;
      }

      if (lCurrentAddress2.isNotEmpty) {
        currentAdd2Controller.text = lCurrentAddress2;
      }

      if (lCurrentPincode.isNotEmpty) {
        if (lCurrentPincode != "0") {
          if (currentPINValueNew.isNotEmpty) {
            currentPINController.text = currentPINValueNew;
          } else {
            currentPINController.text = lCurrentPincode;
          }
        }
      }

      if (lCurrentCityId > 0) {
        if (currentCityValueNew.isNotEmpty) {
          currentCityValue = currentCityValueNew;
        } else {
          currentCityValue = lCurrentCityId.toString();
        }
      }

      if (lTotalStabilityId.isNotEmpty) {
        if (lTotalStabilityId != "0") {
          livingHereValue = lTotalStabilityId;
        }
      }

      if (lPermanentAddress1.isNotEmpty) {
        permanentAdd1Controller.text = lPermanentAddress1;
      }

      if (lPermanentAddress2.isNotEmpty) {
        permanentAdd2Controller.text = lPermanentAddress2;
      }

      if (lPermanentPincode.isNotEmpty) {
        if (lPermanentPincode != "0") {
          if (permanentPINValueNew.isNotEmpty) {
            permanentPINController.text = permanentPINValueNew;
          } else {
            permanentPINController.text = lPermanentPincode;
          }
        }
      }

      if (lPermanentCityId > 0) {
        if (permanentCityValueNew.isNotEmpty) {
          permanentCityValue = permanentCityValueNew;
        } else {
          permanentCityValue = lPermanentCityId.toString();
        }
      }
    }
  }

  void getCityNameByPincode(String pincode, String fieldType) async {
    isPinLoading = true;
    try {
      await loanHandler.getCityNameByPincode(pincode).then((value) {
        setState(() {
          CityNameByPIN cityNameByPIN = value;

          if (cityNameByPIN.getPinId > 0) {
            if (cityNameByPIN.getPinCity.isNotEmpty) {

              if (fieldType == "CurrentPIN") {

                String textValue = Global.getValueByItemText(applicantDataMasterData.getMasterData.cities, cityNameByPIN.getPinCity);

                if (textValue.isNotEmpty) {
                  currentCityValueNew = textValue;
                  currentPINValueNew = pincode;
                }
              } else if (fieldType == "PermanentPIN") {

                String textValue = Global.getValueByItemText(applicantDataMasterData.getMasterData.cities, cityNameByPIN.getPinCity);

                if (textValue.isNotEmpty) {
                  permanentCityValueNew = textValue;
                  permanentPINValueNew = pincode;
                }
              }
            } else {
              Global.showAlertDialog(context, "City not available");
            }
          } else {
            Global.showAlertDialog(context, "City not available");
          }

          isPinLoading = false;
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isPinLoading = false;
          Global.showAlertDialog(context, loanHandler.errorMessage);
        });
      });
    } catch (ex) {
      setState(() {
        isPinLoading = false;
        Global.showAlertDialog(context, 'Network not available');
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    currentAdd1Controller.dispose();
    currentAdd2Controller.dispose();
    currentPINController.dispose();

    permanentAdd1Controller.dispose();
    permanentAdd2Controller.dispose();
    permanentPINController.dispose();

  }

  callback(bool value) {
    setState(() {});
  }

  bool filterLongEnough(String pincode) {
    return pincode.length > 5;
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
          "Confirm Address Details",
          style: TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0), child: getAddressDetailsForm(applicantDataMasterData)),
      ),
    );
  }

  Column getAddressDetailsForm(PersonalDataModel model) {
    bindAddressDetails(model); //set/rre-fill the values

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text("2/4", style: AppStyle.linkLightBlue2, textAlign: TextAlign.end)]),
        Stack(
          children: [
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Current Address Details", style: AppStyle.formTitleBlue),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: currentAdd1Controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "* Current Address1 is required";
                        } else if (value.length > 40) {
                          return "Current Address1 should not exceed to 40 chars";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: AppColor.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        hintText: 'Current Address1',
                        labelText: "Current Address1",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextFormField(
                      controller: currentAdd2Controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "* Current Address2 is required";
                        } else if (value.length > 40) {
                          return "Current Address2 should not exceed to 40 chars";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: AppColor.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        hintText: "Current Address2",
                        labelText: "Current Address2",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextFormField(
                      onChanged: (text) {
                        if (filterLongEnough(text)) {
                          getCityNameByPincode(text, "CurrentPIN");
                        }
                      },
                      keyboardType: TextInputType.number,
                      controller: currentPINController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "* Current pin code is required";
                        } else {
                          return Global.isValidPincode(value);
                        }
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: AppColor.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        hintText: 'Current pin code',
                        labelText: "Current pin code",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: DropdownButtonFormField<String>(
                      value: currentCityValue,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "* Current city is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: AppColor.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        hintText: "Choose current city",
                        labelText: "Current city",
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          currentCityValue = newValue!;
                        });
                      },
                      items: model.getMasterData.cities.map((SelectListItem item) {
                        return DropdownMenuItem<String>(
                          value: item.value,
                          child: Text(item.text),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: livingHereValue,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "* Stability is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColor.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Choose month",
                      labelText: "Living here for",
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        livingHereValue = newValue!;
                      });
                    },
                    items: model.getMasterData.stability.map((SelectListItem item) {
                      return DropdownMenuItem<String>(
                        value: item.value,
                        child: Text(item.text),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16.0),
                  const Text("Permanent Address Details", style: AppStyle.formTitleBlue),
                  Visibility(
                      visible: showHidePASameAsCurrent,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              controller: permanentAdd1Controller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "* Permanent Address1 is required";
                                } else if (value.length > 40) {
                                  return "Permanent Address1 should not exceed to 40 chars";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: AppColor.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                hintText: 'Permanent address1',
                                labelText: "Permanent address1",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: TextFormField(
                              controller: permanentAdd2Controller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "* Permanent Address 2 is required";
                                } else if (value.length > 40) {
                                  return "Permanent Address2 should not exceed to 40 chars";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: AppColor.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                hintText: "Permanent address2",
                                labelText: "Permanent address2",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: TextFormField(
                              onChanged: (text) {
                                if (filterLongEnough(text)) {
                                  getCityNameByPincode(text, "PermanentPIN");
                                }
                              },
                              controller: permanentPINController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "* Permanent pin code is required";
                                } else {
                                  return Global.isValidPincode(value);
                                }
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: AppColor.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                hintText: 'Permanent pin code',
                                labelText: "Permanent pin code",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: DropdownButtonFormField<String>(
                              value: permanentCityValue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "* Permanent city is required";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: AppColor.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                hintText: "Choose permanent city",
                                labelText: "Permanent city",
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  permanentCityValue = newValue!;
                                });
                              },
                              items: model.getMasterData.cities.map((SelectListItem item) {
                                return DropdownMenuItem<String>(
                                  value: item.value,
                                  child: Text(item.text),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListTileTheme(
                      horizontalTitleGap: 0,
                      child: CheckboxListTile(
                        title: const Text(
                          "Permanent address is same as current",
                          style: TextStyle(color: AppColor.grey, fontSize: 15.0),
                        ),
                        value: isPASameAsCurrent,
                        onChanged: (newValue) {
                          setState(() {
                            isPASameAsCurrent = newValue ?? false;
                            showHidePASameAsCurrent = !isPASameAsCurrent;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
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

                                Applicant applicant = Applicant();
                                applicant = loanApplicationModel.getApplicant;

                                applicant.setCurrentAddress = currentAdd1Controller.text;
                                applicant.setCurrentAddress2 = currentAdd2Controller.text;
                                applicant.setPincode = currentPINController.text;
                                applicant.setCityId = int.parse(currentCityValue!);
                                applicant.setResidingSinceOnCurrentAddress = livingHereValue!;

                                if(!isPASameAsCurrent) {
                                  applicant.setPermanentAddress = permanentAdd1Controller.text;
                                  applicant.setPermanentAddress2 = permanentAdd2Controller.text;
                                  applicant.setPermanentPincode = permanentPINController.text;
                                  applicant.setPermanentCityId = int.parse(permanentCityValue!);
                                }
                                applicant.setCurrentAddressSameAsKycAddress = false;
                                applicant.setPermanentAddressSameAsLocalAddress = isPASameAsCurrent;

                                loanApplicationModel.setApplicant = applicant;

                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });

                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return LoanAccountFormPage(loanModel: loanApplicationModel, masterDataModel: model);
                                }));
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
            isPinLoading ? const Center(child: CircularProgressIndicator()) : const Text("")
          ],
        ),
      ],
    );
  }
}
