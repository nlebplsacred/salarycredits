import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/loan/emi_calculator_base_model.dart';
import '../../models/login/login_response_model.dart';
import '../../services/loan_handler.dart';
import '../../utility/custom_loader.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';

class EMICalculatorPage extends StatefulWidget {
  const EMICalculatorPage({super.key});

  @override
  State<EMICalculatorPage> createState() => _EMICalculatorPageState();
}

class _EMICalculatorPageState extends State<EMICalculatorPage> {
  final formKey = GlobalKey<FormState>();
  final LoanHandler loanHandler = LoanHandler();
  DateFormat outputFormatMonth = DateFormat('MMM');
  LoginResponseModel user = LoginResponseModel();
  TextEditingController promoController = TextEditingController();
  EMICalculatorBaseModel emiCalculatorBaseModel = EMICalculatorBaseModel();
  Future<EMICalculatorBaseModel> futureEMICalculatorBaseModel = Future(() => EMICalculatorBaseModel());

  int _valueAmount = 10000;
  int _valueTenure = 3;

  bool isLoading = false, isLoadingPromo = false;
  bool showHideSliderBox = true;
  bool showHideOfferMsg = false;
  bool showHidePromoForm = false;
  bool showHidePromoApplied = false;
  bool showHideMainBtn = false;
  bool isEligibilityLoading = false;
  String errorEligibility = "";
  String errorMessage = "", promoMessage = "NA";

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));

        futureEMICalculatorBaseModel = getCalculatorData(_valueAmount.toDouble(), _valueTenure);
      });
    });
  }

  Future<EMICalculatorBaseModel> getCalculatorData(double amount, int tenure) {
    EMICalculatorRequestModel requestModel = EMICalculatorRequestModel();
    requestModel.setApplicantId = user.applicantId!;
    requestModel.setEmployerId = user.employerId!;
    requestModel.setNetPayableSalary = user.netPayableSalary!;
    requestModel.setLoanAmount = amount;
    requestModel.setTenure = tenure;

    return loanHandler.calculateEMI(requestModel);
  }

  @override
  void dispose() {
    super.dispose();
  }

  callback(bool value) {
    setState(() {});
  }

  String getMonthName(String date) {
    String lDate = "N/A";

    if (date != "") {
      lDate = outputFormatMonth.format(DateTime.parse(date));
    }

    return lDate;
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
          "EMI Calculator",
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
          padding: const EdgeInsets.only(top: 0.0, left: 12.0, right: 12.0),
          child: FutureBuilder<EMICalculatorBaseModel>(
            future: futureEMICalculatorBaseModel,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    emiCalculatorBaseModel = snapshot.data!;
                    //print('nitya-${loanHandler.errorMessage}');
                  }
                }
                return loadMainScreen(emiCalculatorBaseModel);
              } else if (snapshot.hasError) {
                // Handle the error
                return Center(child: Text('${snapshot.error}'));
              } else {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CustomLoader()),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Column loadMainScreen(EMICalculatorBaseModel model) {
    int customDivisions = int.parse((490000 / 1000).round().toString());

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            padding: const EdgeInsets.only(top: 26.0, left: 16.0, right: 16.0, bottom: 16.0),
            decoration: BoxDecoration(
              color: AppColor.bgDefault2,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: AppColor.grey2, width: 1),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("INR $_valueAmount", style: AppStyle.sliderTitleAmt, textAlign: TextAlign.center),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 7.0,
                            trackShape: const RoundedRectSliderTrackShape(),
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 13.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                            child: Slider(
                                value: _valueAmount.toDouble(),
                                min: 10000,
                                max: 500000,
                                activeColor: AppColor.lightBlue,
                                inactiveColor: AppColor.lightGrey,
                                thumbColor: AppColor.lightBlue,
                                divisions: customDivisions,
                                label: 'INR ${_valueAmount.round()}',
                                onChanged: (double newValue) {
                                  setState(() {
                                    _valueAmount = newValue.round();
                                  });
                                },
                                onChangeEnd: (double newValue) {
                                  setState(() {
                                    futureEMICalculatorBaseModel = getCalculatorData(double.parse(_valueAmount.toString()), _valueTenure);
                                  });
                                },
                                semanticFormatterCallback: (double newValue) {
                                  return 'INR ${newValue.round()}';
                                }),
                          )),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("INR 10000", style: AppStyle.pageTitle2),
                      Text("INR 500000", style: AppStyle.pageTitle2),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$_valueTenure Months", style: AppStyle.sliderTitleAmt, textAlign: TextAlign.center),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 7.0,
                            trackShape: const RoundedRectSliderTrackShape(),
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 13.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                            child: Slider(
                                value: _valueTenure.toDouble(),
                                min: 3,
                                max: 36,
                                //allowedInteraction: SliderInteraction.tapAndSlide,
                                activeColor: AppColor.lightBlue,
                                inactiveColor: AppColor.lightGrey,
                                thumbColor: AppColor.lightBlue,
                                label: '${_valueTenure.round()} Months',
                                onChanged: (double newValue) {
                                  setState(() {
                                    _valueTenure = newValue.round();
                                  });
                                },
                                onChangeEnd: (double newValue) {
                                  setState(() {
                                    futureEMICalculatorBaseModel = getCalculatorData(double.parse(_valueAmount.toString()), _valueTenure);
                                  });
                                },
                                semanticFormatterCallback: (double newValue) {
                                  return '${newValue.round()}';
                                }),
                          )),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 0, left: 12.0, right: 12.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("3 Months", style: AppStyle.pageTitle2),
                      Text("36 Months", style: AppStyle.pageTitle2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.only(top: 26.0, left: 8.0, right: 16.0, bottom: 26.0),
          decoration: BoxDecoration(
            color: AppColor.white,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: AppColor.grey2, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(child: CircleAvatar(backgroundColor: AppColor.bgScreen3, minRadius: 12)),
                  const SizedBox(width: 220.0, child: Text("Loan EMI", textAlign: TextAlign.start)),
                  Text("INR ${model.getEMI.round()}", textAlign: TextAlign.end),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(child: CircleAvatar(backgroundColor: AppColor.bgScreen2, minRadius: 12)),
                  const SizedBox(width: 220.0, child: Text("Interest Payable", textAlign: TextAlign.start)),
                  Text("INR ${model.getPayableInterest.round()}", textAlign: TextAlign.end),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(child: CircleAvatar(backgroundColor: AppColor.bgScreen4, minRadius: 12)),
                  const SizedBox(width: 220.0, child: Text("Total Payable (P+I)", textAlign: TextAlign.start)),
                  Text("INR ${model.getNetPayableAmount.round()}", textAlign: TextAlign.end),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        const Text(
          "Repayment Schedule",
          style: AppStyle.pageTitle2,
        ),
        const SizedBox(height: 16.0),
        Container(
          margin: const EdgeInsets.only(top: 0.0, left: 0.0, right: 8.0),
          decoration: const BoxDecoration(
            color: AppColor.white,
            shape: BoxShape.rectangle,
          ),
          child: DataTable(
            border: TableBorder.all(color: AppColor.grey2, width: 1),
            columnSpacing: 16,
            horizontalMargin: 16,
            columns: const [
              DataColumn(
                label: Text('Month', style: TextStyle(color: AppColor.lightBlack), textAlign: TextAlign.center),
              ),
              DataColumn(
                label: Text('EMI', style: TextStyle(color: AppColor.lightBlack), textAlign: TextAlign.center),
              ),
              DataColumn(
                label: Text('Interest', style: TextStyle(color: AppColor.lightBlack), textAlign: TextAlign.center),
              ),
              DataColumn(
                label: Text('Principal', style: TextStyle(color: AppColor.lightBlack), textAlign: TextAlign.center),
              ),
              DataColumn(
                label: Text('Balance', style: TextStyle(color: AppColor.lightBlack), textAlign: TextAlign.center),
              ),
            ],
            rows: model.getRepayments // Loops through dataColumnText, each iteration assigning the value to element
                .map(
                  ((element) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(getMonthName(element.getPayDate), style: const TextStyle(fontSize: 12.0, color: AppColor.lightBlack))),
                          DataCell(Text("\u20b9${element.getTotalRepayment.toString()}",
                              style: const TextStyle(fontSize: 12.0, color: AppColor.lightBlack))),
                          DataCell(
                              Text("\u20b9${element.getInterest.toString()}", style: const TextStyle(fontSize: 12.0, color: AppColor.lightBlack))),
                          DataCell(
                              Text("\u20b9${element.getPrincipal.toString()}", style: const TextStyle(fontSize: 12.0, color: AppColor.lightBlack))),
                          DataCell(
                              Text("\u20b9${element.getBalance.toString()}", style: const TextStyle(fontSize: 12.0, color: AppColor.lightBlack))),
                        ],
                      )),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
