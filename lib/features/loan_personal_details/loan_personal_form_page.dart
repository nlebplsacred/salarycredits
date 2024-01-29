import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salarycredits/services/loan_handler.dart';
import 'package:salarycredits/utility/custom_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/loan/loan_model.dart';
import '../../models/loan/master_data_model.dart';
import '../../models/loan/personal_data_base_model.dart';
import '../../models/login/login_response_model.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';
import '../loan_address_details/loan_address_form_page.dart';

class LoanPersonalFormPage extends StatefulWidget {
  final LoanModel loanModel;

  const LoanPersonalFormPage({required this.loanModel, super.key});

  @override
  State<LoanPersonalFormPage> createState() => _LoanPersonalFormPageState();
}

class _LoanPersonalFormPageState extends State<LoanPersonalFormPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController personalEmailController = TextEditingController();
  TextEditingController aadhaarController = TextEditingController();
  TextEditingController panCardController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController joiningDateController = TextEditingController();
  TextEditingController rentAmountController = TextEditingController();

  LoanHandler loanHandler = LoanHandler();
  LoginResponseModel user = LoginResponseModel();
  LoanModel loanApplicationModel = LoanModel();
  PersonalDataModel applicantDataMasterData = PersonalDataModel();
  late Future<PersonalDataModel> futureApplicantDataMasterData = Future(() => PersonalDataModel());

  DateFormat outputFormatDate2 = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  DateFormat outputFormatDate = DateFormat('dd/MMM/yyyy');
  DateFormat outputFormatMonth = DateFormat('MMMM');

  bool isLoading = false,
      showHidePersonalEmail = true,
      showHideAadhaar = true,
      showHidePanCard = true,
      showHideDateOfBirth = true,
      showHideGender = true,
      showHideJoiningDate = true,
      showHideRentAmount = false;

  String errorMessage = "";
  String? genderValue;
  String? maritalStatusValue;
  String? dependentValue;
  String? educationValue;
  String? experienceValue;
  String? residentTypeValue;
  String selectedDOJDate = "";
  String selectedDOBDate = "";

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isLoading = false;

        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));

        futureApplicantDataMasterData = getApplicantDetailsAndMasterData(user.applicantId!);
      });
    });

    loanApplicationModel = widget.loanModel;
  }

  String getMonthName(String date) {
    String lDate = "N/A";
    try {
      if (date != "") {
        lDate = outputFormatMonth.format(DateTime.parse(date));
      }
    } on FormatException catch (_) {}

    return lDate;
  }

  Future<PersonalDataModel> getApplicantDetailsAndMasterData(int applicantId) async {
    return await loanHandler.getApplicantAndMasterData(applicantId);
  }

  void bindMasterListData(PersonalDataModel model) {
    loanApplicationModel.setApplicant = model.getApplicant;
    loanApplicationModel.setBankAccount = model.getBankAccount;

    String lPersonalEmail = model.getApplicant.getPersonalEmailId;
    String lAadhaarNumber = model.getApplicant.getAadhaar;
    String lPANNumber = model.getApplicant.getPancard;
    String lDateOfBirth = model.getApplicant.getDOB;
    String lJoiningDate = model.getApplicant.getWorkingSince; //DOJ
    String lRentAmount = loanApplicationModel.getApplicant.getResidenceRentAmount.toString();

    if (lPersonalEmail.isNotEmpty) {
      personalEmailController.text = lPersonalEmail;
      showHidePersonalEmail = false;
    }

    if (lAadhaarNumber.isNotEmpty) {
      aadhaarController.text = lAadhaarNumber;
      showHideAadhaar = false;
    }

    if (lPANNumber.isNotEmpty) {
      panCardController.text = lPANNumber.toUpperCase();
      showHidePanCard = false;
    }

    if (lDateOfBirth.isNotEmpty) {
      if (lDateOfBirth.contains("0001-01-01")) {
        lDateOfBirth = "";
      }
    }

    if (lDateOfBirth.isNotEmpty) {
      if (selectedDOBDate.isNotEmpty) {
        dateOfBirthController.text = outputFormatDate.format(DateTime.parse(selectedDOBDate));
      } else {
        if (lDateOfBirth.length < 13) {
          dateOfBirthController.text = lDateOfBirth;
        } else {
          dateOfBirthController.text = outputFormatDate.format(DateTime.parse(lDateOfBirth));
        }
      }

      showHideDateOfBirth = false;
    }

    if (lJoiningDate.isNotEmpty) {
      if (lJoiningDate.contains("0001-01-01")) {
        lJoiningDate = "";
      }
    }

    if (lJoiningDate.isNotEmpty) {
      if (selectedDOJDate.isNotEmpty) {
        joiningDateController.text = outputFormatDate.format(DateTime.parse(selectedDOJDate));
      } else {
        if (lJoiningDate.length < 13) {
          joiningDateController.text = lJoiningDate;
        } else {
          joiningDateController.text = outputFormatDate.format(DateTime.parse(lJoiningDate));
        }
      }

      showHideJoiningDate = false;
    }

    if (model.getApplicant.getResidenceTypeId == 1) {
      showHideRentAmount = true;
      if (lRentAmount.isNotEmpty) {
        rentAmountController.text = double.parse(lRentAmount).round().toString();
      }
    }

    if (model.getApplicant.getGenderTypeId > 0) {
      genderValue = model.getApplicant.getGenderTypeId.toString();
      showHideGender = false;
    }

    if (model.getApplicant.getMaritalStatusId > 0) {
      maritalStatusValue = model.getApplicant.getMaritalStatusId.toString();
    }

    if (model.getApplicant.getNoOfDependants > 0) {
      dependentValue = model.getApplicant.getNoOfDependants.toString();
    }

    if (model.getApplicant.getEducationId > 0) {
      educationValue = model.getApplicant.getEducationId.toString();
    }

    if (model.getApplicant.getTotalExperience > 0) {
      experienceValue = model.getApplicant.getTotalExperience.toString();
    }

    if (model.getApplicant.getResidenceTypeId > 0) {
      residentTypeValue = model.getApplicant.getResidenceTypeId.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
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
          "Confirm Personal Details",
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
          padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
          child: FutureBuilder<PersonalDataModel>(
            future: futureApplicantDataMasterData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    applicantDataMasterData = snapshot.data!;
                  }
                }
                return getPersonalDetailsForm(applicantDataMasterData);
              } else if (snapshot.hasError) {
                // Handle the error
                return Center(child: Text('${snapshot.error}'));
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CustomLoader()),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Column getPersonalDetailsForm(PersonalDataModel model) {
    bindMasterListData(model); //set/rre-fill the values

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text("1/4", style: AppStyle.linkLightBlue2, textAlign: TextAlign.end)]),
        const Text("Personal Details", style: AppStyle.formTitleBlue),
        Form(
          key: formKey,
          child: Column(
            children: [
              Visibility(
                visible: showHidePersonalEmail,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    controller: personalEmailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "* Personal email is required";
                      } else {
                        return Global.validateEmail(value);
                      }
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColor.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: 'Personal email id',
                      labelText: "Personal email id",
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showHideAadhaar,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    controller: aadhaarController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "* Aadhaar number is required";
                      } else {
                        return Global.isValidAadhaar(value);
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColor.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Aadhaar Number",
                      labelText: "Aadhaar Number",
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showHidePanCard,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    controller: panCardController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "* PAN number is required";
                      } else {
                        return Global.isValidPAN(value);
                      }
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColor.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: 'PAN Number',
                      labelText: "PAN Number",
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showHideDateOfBirth,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    controller: dateOfBirthController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "* Date of birth is required";
                      } else {
                        DateTime myTime = DateTime.now();
                        Duration diff = myTime.difference(DateTime.parse(selectedDOBDate));
                        int diffYears = diff.inDays ~/ 365;

                        if (diffYears < 16) {
                          return 'Please enter valid DOB';
                        } else {
                          return Global.isValidDOB(value);
                        }
                      }
                    },
                    autofocus: false,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 70),
                        lastDate: DateTime(DateTime.now().year + 2),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          selectedDOBDate = selectedDate.toString();
                          dateOfBirthController.text = outputFormatDate.format(DateTime.parse(selectedDOBDate));
                        }
                      });
                    },
                    maxLines: 1,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColor.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Date of birth",
                      labelText: "Date of birth",
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showHideJoiningDate,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    controller: joiningDateController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "* Date of joining is required";
                      } else {
                        return Global.isValidDOJ(value);
                      }
                    },
                    autofocus: false,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 50),
                        lastDate: DateTime(DateTime.now().year + 2),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          selectedDOJDate = selectedDate.toString();
                          joiningDateController.text = outputFormatDate.format(DateTime.parse(selectedDOJDate));
                        }
                      });
                    },
                    maxLines: 1,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColor.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Joining date",
                      labelText: "Joining date",
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showHideGender,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: DropdownButtonFormField<String>(
                    value: genderValue,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "* Gender is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColor.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Choose gender type",
                      labelText: "Choose gender type",
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        genderValue = newValue!;
                      });
                    },
                    items: model.getMasterData.genders.map((SelectListItem item) {
                      return DropdownMenuItem<String>(
                        value: item.value,
                        child: Text(item.text),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: maritalStatusValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "* Marital status is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColor.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  hintText: "Choose marital status",
                  labelText: "Choose marital status",
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    maritalStatusValue = newValue!;
                  });
                },
                items: model.getMasterData.maritalStatus.map((SelectListItem item) {
                  return DropdownMenuItem<String>(
                    value: item.value,
                    child: Text(item.text),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: dependentValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "* People dependent is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColor.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  hintText: "Choose people dependent",
                  labelText: "Choose people dependent",
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dependentValue = newValue!;
                  });
                },
                items: model.getMasterData.dependents.map((SelectListItem item) {
                  return DropdownMenuItem<String>(
                    value: item.value,
                    child: Text(item.text),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: educationValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "* Education is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColor.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  hintText: "Choose education",
                  labelText: "Choose education",
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    educationValue = newValue!;
                  });
                },
                items: model.getMasterData.educations.map((SelectListItem item) {
                  return DropdownMenuItem<String>(
                    value: item.value,
                    child: Text(item.text),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: experienceValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "* Total experience is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColor.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  hintText: "Choose total experience",
                  labelText: "Choose total experience",
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    experienceValue = newValue!;
                  });
                },
                items: model.getMasterData.experiences.map((SelectListItem item) {
                  return DropdownMenuItem<String>(
                    value: item.value,
                    child: Text(item.text),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: residentTypeValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "* Resident type is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColor.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  hintText: "Choose resident type",
                  labelText: "Choose resident type",
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    residentTypeValue = newValue!;

                    if (residentTypeValue == "1") {
                      showHideRentAmount = true;
                    } else {
                      showHideRentAmount = false;
                    }
                  });
                },
                items: model.getMasterData.residents.map((SelectListItem item) {
                  return DropdownMenuItem<String>(
                    value: item.value,
                    child: Text(item.text),
                  );
                }).toList(),
              ),
              Visibility(
                visible: showHideRentAmount,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    controller: rentAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColor.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Rent Amount(\u20b9)",
                      labelText: "Rent Amount(\u20b9)",
                    ),
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
                            setState(() {
                              isLoading = true;
                            });

                            //create model to send further

                            Applicant applicant = Applicant();
                            applicant = loanApplicationModel.getApplicant;

                            applicant.setPersonalEmailId = personalEmailController.text;
                            applicant.setAadhaar = aadhaarController.text;
                            applicant.setPancard = panCardController.text;
                            applicant.setDOB = dateOfBirthController.text;
                            applicant.setWorkingSince = joiningDateController.text;
                            applicant.setGenderTypeId = int.parse(genderValue!);
                            applicant.setMaritalStatusId = int.parse(maritalStatusValue!);
                            applicant.setNoOfDependants = int.parse(dependentValue!);
                            applicant.setEducationId = int.parse(educationValue!);
                            applicant.setTotalExperience = int.parse(experienceValue!);
                            applicant.setResidenceTypeId = int.parse(residentTypeValue!);

                            if (rentAmountController.text.isNotEmpty) {
                              applicant.setResidenceRentAmount = double.parse(rentAmountController.text);
                            }

                            loanApplicationModel.setApplicant = applicant;

                            Future.delayed(const Duration(seconds: 1), () {
                              setState(() {
                                isLoading = false;
                              });
                            });

                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return LoanAddressFormPage(loanModel: loanApplicationModel, masterDataModel: model);
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
      ],
    );
  }
}
