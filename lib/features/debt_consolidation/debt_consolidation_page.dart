import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:salarycredits/features/loan_personal_details/loan_personal_form_page.dart';
import 'package:salarycredits/models/loan/loan_eligibility_request_model.dart';
import 'package:salarycredits/services/loan_handler.dart';
import 'package:salarycredits/utility/custom_loader.dart';
import 'package:salarycredits/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/loan/action_tag_details_model.dart';
import '../../models/loan/applicant_dashboard_base_model.dart';
import '../../models/loan/coupon_details_model.dart';
import '../../models/loan/debt_consolidation_model.dart';
import '../../models/loan/loan_model.dart';
import '../../models/login/login_response_model.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../loan_process_pending/loan_process_pending_page.dart';
import '../loan_process_status/loan_process_status_page.dart';

class DebtConsolidationPage extends StatefulWidget {
  final ApplicantDashboardBaseModel dashboardBaseModel;
  final ProductList product;

  const DebtConsolidationPage({required this.product, required this.dashboardBaseModel, super.key});

  @override
  State<DebtConsolidationPage> createState() => _DebtConsolidationPageState();
}

class _DebtConsolidationPageState extends State<DebtConsolidationPage> {
  final formKey = GlobalKey<FormState>();
  LoanModel loanApplicationModel = LoanModel();
  TextEditingController promoController = TextEditingController();
  ApplicantDashboardBaseModel userBaseDashboard = ApplicantDashboardBaseModel();
  ProductList productList = ProductList();
  final LoanHandler loanHandler = LoanHandler();
  LoginResponseModel user = LoginResponseModel();

  ActionTagDetails actionTagDetails = ActionTagDetails();
  late Future<ActionTagDetails> futureActionTagDetails = Future(() => ActionTagDetails());
  late Future<DebtConsolidationModel> futureDebtConsolidationModel = Future(() => DebtConsolidationModel());

  DebtConsolidationModel debtConsolidationModel = DebtConsolidationModel();
  LoanEligibilityResponseModel loanEligibilityResponseModel = LoanEligibilityResponseModel();

  CouponDetailsModel couponDetailsModel = CouponDetailsModel();
  DateFormat outputFormatDate = DateFormat('dd MMM, yyyy');
  DateFormat outputFormatMonth = DateFormat('MMM-yyyy');

  int _valueAmount = 0;
  int _valueTenure = 0;
  double minAmount = 0;
  double maxAmount = 0;
  bool isLoading = false, isLoadingPromo = false;
  bool showHideSliderBox = true;
  bool showHideOfferMsg = false;
  bool showHidePromoForm = false;
  bool showHidePromoApplied = false;
  bool showHideMainBtn = false;
  bool isEligibilityLoading = false;
  bool showHideReadyToClose = false;
  bool showHideSummary = true;
  String errorEligibility = "";
  String errorMessage = "", promoHeading = "Promo code", promoMessage = "NA";

  bool isSliding = true;

  @override
  void initState() {
    super.initState();
    productList = widget.product;
    userBaseDashboard = widget.dashboardBaseModel;

    setState(() {
      _valueAmount = productList.minLoanAmount.toInt();
      _valueTenure = productList.minTenure.toInt();

      minAmount = productList.minLoanAmount;
      maxAmount = productList.maxLoanAmount;
    });

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));

        futureActionTagDetails = getApplicationPending(user.applicantId!);

        futureDebtConsolidationModel = getDcAvailabilityWithObligations(user.applicantId!); //default loading
      });
    });
  }

  startRedirectTime() async {
    var duration = const Duration(milliseconds: 500);
    return Timer(duration, decideRoute);
  }

  decideRoute() {
    if (userBaseDashboard.shortLoanDetails.getStatusId == 2) {
      if (userBaseDashboard.shortLoanDetails.getIsProcessDone) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return LoanProcessStatusPage(loanType: productList.applicationType, loanId: userBaseDashboard.shortLoanDetails.getApplicationId);
        }));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return LoanProcessPendingPage(shortLoanDetails: userBaseDashboard.shortLoanDetails, );
        }));
      }
    } else if (userBaseDashboard.shortLoanDetails.getStatusId == 1 || userBaseDashboard.shortLoanDetails.getStatusId == 4) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoanProcessStatusPage(loanType: productList.applicationType, loanId: userBaseDashboard.shortLoanDetails.getApplicationId);
      }));
    } else {
      if (actionTagDetails.statusId == 1) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return LoanProcessStatusPage(loanType: productList.applicationType, loanId: userBaseDashboard.shortLoanDetails.getApplicationId);
        }));
      }
    }
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

  //load running application status
  Future<ActionTagDetails> getApplicationPending(int applicantId) async {
    return loanHandler.getRunningApplicationStatus(applicantId, productList.applicationTypeId);
  }

  //load available limits for DC on getDcAvailabilityWithObligations
  Future<DebtConsolidationModel> getDcAvailabilityWithObligations(int applicantId) async {
    return loanHandler.getDcAvailabilityWithObligations(applicantId);
  }

  //load available limits for DC on getDcAvailability
  Future<DebtConsolidationModel> getDcAvailability(int applicantId, double amount, int tenure) async {
    return loanHandler.getDcAvailability(applicantId, amount, tenure);
  }

  //load available limits for DC on markForeclosure
  Future<DebtConsolidationModel> markForeclosure(String applicationList) async {
    DCForeclosureRequest requestDCModel = DCForeclosureRequest();
    requestDCModel.setApplicantId = user.applicantId!;
    requestDCModel.setJsonData = applicationList;

    return loanHandler.markForeclosure(requestDCModel);
  }

  String getApplicationList(List<LoanHistories> loanHistories) {
    StringBuffer lApplicationIds = StringBuffer();
    lApplicationIds.write("[");

    for (int i = 0; i < loanHistories.length; i++) {
      if (loanHistories[i].getIsOptedForDC) {
        lApplicationIds.write("{'ApplicationId':");
        lApplicationIds.write(loanHistories[i].getApplicationId);
        lApplicationIds.write(",'IsRequest':");
        lApplicationIds.write(true);
        lApplicationIds.write("},");
      } else {
        lApplicationIds.write("{'ApplicationId':");
        lApplicationIds.write(loanHistories[i].getApplicationId);
        lApplicationIds.write(",'IsRequest':");
        lApplicationIds.write(false);
        lApplicationIds.write("},");
      }
    }

    String lApplicationIdsTemp = lApplicationIds.toString().substring(0, lApplicationIds.toString().lastIndexOf(","));
    lApplicationIdsTemp += "]";

    return lApplicationIdsTemp;
  }

  getPromoCodeDetails(String promoCode) async {
    setState(() {
      isLoadingPromo = true;
    });

    try {
      await loanHandler.getPromoCodeDetails(user.applicantId!, productList.applicationTypeId, user.employerId!, promoCode).then((value) {
        setState(() {
          isLoadingPromo = false;
          couponDetailsModel = value;

          if (couponDetailsModel.status != 0) {
            if (couponDetailsModel.status == 2) {
              Global.showAlertDialog(context, couponDetailsModel.message);
            } else {
              showHidePromoForm = false;
              showHidePromoApplied = true;

              loanApplicationModel.setDiscountCoupon = couponDetailsModel.discountCoupon;
              loanApplicationModel.setIsCouponActive = couponDetailsModel.isActive;

              double lMaxDiscount = 0;
              String lHTMLString = "";

              promoHeading = "${"Promo code <strong><i>${couponDetailsModel.discountCoupon}"}</i></strong> applied";

              if (couponDetailsModel.discountCategory == "PF") {
                lMaxDiscount = loanEligibilityResponseModel.getProcessingFeeWithGST;

                if (lMaxDiscount >= couponDetailsModel.discountAmount) {
                  lMaxDiscount = couponDetailsModel.discountAmount;
                }

                if (lMaxDiscount < couponDetailsModel.discountAmount) {
                  lHTMLString =
                      "<p style=\"color:#319b0c;font-size:14px;clear:both;\">Congrats! You have got zero transaction fee EWA.</p><p><i>INR.$lMaxDiscount/- ${couponDetailsModel.description}, max discount up to ${couponDetailsModel.discountAmount}/- *T&C Apply.</i></p>";
                } else {
                  lHTMLString =
                      "<p style=\"clear:both;\"><i>INR.$lMaxDiscount/- ${couponDetailsModel.description}, max discount up to ${couponDetailsModel.discountAmount}/- *T&C Apply.</i></p>";
                }

                promoMessage = lHTMLString;
              } else if (couponDetailsModel.discountCategory == "ROI") {
                lMaxDiscount = (loanEligibilityResponseModel.getNetPayableAmount - loanEligibilityResponseModel.getLoanAmount);

                if (lMaxDiscount >= couponDetailsModel.discountAmount) {
                  lMaxDiscount = couponDetailsModel.discountAmount;
                }

                if (lMaxDiscount < couponDetailsModel.discountAmount) {
                  lHTMLString =
                      "<p style=\"color:319b0c;font-size:14px;clear:both;\">Congrats! You have got interest free EWA.</h5><p><i>INR.$lMaxDiscount/- ${couponDetailsModel.description}, max discount up to ${couponDetailsModel.discountAmount}/- *T&C Apply.</i></p>";
                } else {
                  lHTMLString =
                      "<p style=\"clear:both;\"><i>INR.$lMaxDiscount/- ${couponDetailsModel.description}, max discount up to ${couponDetailsModel.discountAmount}/- *T&C Apply.</i></p>";
                }

                promoMessage = lHTMLString;
              }
            }
          } else {
            Global.showAlertDialog(context, "Something went wrong, please try again");
          }
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoadingPromo = false;
          Global.showAlertDialog(context, loanHandler.errorMessage);
        });
      });
    } catch (ex) {
      setState(() {
        isLoadingPromo = false;
        Global.showAlertDialog(context, 'Network not available');
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
        title: Text(
          "${productList.applicationType} Request",
          style: const TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 26.0, left: 12.0, right: 12.0),
          child: Column(
            children: [
              FutureBuilder<ActionTagDetails>(
                future: futureActionTagDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        actionTagDetails = snapshot.data!;
                      }
                    }
                    return loadMainScreen(actionTagDetails);
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
            ],
          ),
        ),
      ),
    );
  }

  Column loadMainScreen(ActionTagDetails actionTagDetails) {
    startRedirectTime();

    return Column(
      children: [
        FutureBuilder<DebtConsolidationModel>(
          future: futureDebtConsolidationModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  debtConsolidationModel = snapshot.data!;

                  if (debtConsolidationModel.getLoanHistoryBaseModel.getLoanHistories.isNotEmpty) {}
                }
              }
              return debtConsolidationModel.getIsEligibleForDC
                  ? user.netPayableSalary! >= 20000
                      ? debtConsolidationModel.getLoanHistoryBaseModel.getLoanHistories.isNotEmpty
                          ? getMainSliderScreen(debtConsolidationModel, actionTagDetails)
                          : getMessageBox("Sorry, you are not eligible for Debt Consolidation")
                      : getMessageBox("Sorry, basic minimum eligibility of salary did not meet hence you can not put request for Debt Consolidation")
                  : getMessageBox("Sorry, you are not eligible for Debt Consolidation");
            } else if (snapshot.hasError) {
              // Handle the error
              return Center(child: Text('${snapshot.error}'));
            } else {
              return const Center(child: CustomLoader());
            }
          },
        ),
      ],
    );
  }

  SizedBox getMessageBox(String message) {
    return SizedBox(
      height: 80.0,
      width: double.maxFinite,
      child: Card(
        elevation: 4,
        color: AppColor.bgDefault2,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: AppStyle.textLabel2,
            ),
          ),
        ),
      ),
    );
  }

  Column getMainSliderScreen(DebtConsolidationModel model, ActionTagDetails actionTagDetails) {
    List<LoanHistories> loanHistoriesList = [];
    for (int i = 0; i < model.getLoanHistoryBaseModel.getLoanHistories.length; i++) {
      if (model.getLoanHistoryBaseModel.getLoanHistories[i].getIsEligibleForDC) {
        loanHistoriesList.add(model.getLoanHistoryBaseModel.getLoanHistories[i]);
      }
    }

    if (loanHistoriesList.isNotEmpty) {
      showHideReadyToClose = true;
    }

    loanEligibilityResponseModel = model.getEligibilityResponseModel;

    if (isSliding) {
      _valueAmount = loanEligibilityResponseModel.getLoanAmount.toInt();
      _valueTenure = loanEligibilityResponseModel.getTenure.toInt();
    }

    if (loanEligibilityResponseModel.getStatusId == 1) {
      showHideSliderBox = true;
      showHideMainBtn = true;
      showHideSummary = true;
      showHideOfferMsg = false;

      if (loanEligibilityResponseModel.getMessage != "success") {
        showHideOfferMsg = true;
        _valueTenure = loanEligibilityResponseModel.getTenure;
      }

      if (loanEligibilityResponseModel.getIsCouponActive) {
        if (showHidePromoApplied) {
          showHidePromoForm = false;
        } else {
          showHidePromoForm = true;
        }
      }
    } else if (loanEligibilityResponseModel.getStatusId == 2) {
      showHideSliderBox = true;
      showHideMainBtn = false;
      showHideSummary = false;
      showHidePromoForm = false;
      showHidePromoApplied = false;
      showHideOfferMsg = true;
    } else if (loanEligibilityResponseModel.getStatusId == 3) {
      showHidePromoForm = false;
      showHidePromoApplied = false;
      showHideSliderBox = false;
      showHideSummary = false;
      showHideMainBtn = false;
      showHideOfferMsg = true;
    }

    if (actionTagDetails.statusId != 0) {
      String textMessage = "";
      if (actionTagDetails.statusId == 1) {
        textMessage = "Your application is already being reviewed by Lender, please wait till you get the final updates.";
      } else if (actionTagDetails.statusId == 5 && actionTagDetails.tagId == 2) {
        textMessage = "You can apply for a loan once your probation is done.";
      } else if (actionTagDetails.statusId == 6 && actionTagDetails.currentStatusId == 2 && actionTagDetails.paidEMICount == 0) {
        textMessage = "Sorry, you are not eligible for Fast Pay for now.";
      }

      if (textMessage.isNotEmpty) {
        showHideSliderBox = false;
        showHideMainBtn = false;
        showHidePromoForm = false;
        showHideOfferMsg = true;

        loanEligibilityResponseModel.setMessage = textMessage;
      }
    }

    int customDivisions = 10;
    if (loanEligibilityResponseModel.getStatusId == 1 || loanEligibilityResponseModel.getStatusId == 2) {
      int divCount =
          int.parse((loanEligibilityResponseModel.getMaxLoanEligibility - loanEligibilityResponseModel.getMinLoanEligibility).round().toString());

      if (loanEligibilityResponseModel.getMaxLoanEligibility <= 10000) {
        customDivisions = int.parse((divCount / 100).round().toString());
      } else if (loanEligibilityResponseModel.getMaxLoanEligibility <= 50000) {
        customDivisions = int.parse((divCount / 500).round().toString());
      } else if (loanEligibilityResponseModel.getMaxLoanEligibility > 50000) {
        customDivisions = int.parse((divCount / 1000).round().toString());
      }
    }

    if (loanEligibilityResponseModel.getMinLoanEligibility > loanEligibilityResponseModel.getMaxLoanEligibility) {
      loanEligibilityResponseModel.setMaxLoanEligibility = loanEligibilityResponseModel.getMinLoanEligibility + 100;
      _valueAmount = loanEligibilityResponseModel.getMinLoanEligibility.round();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(productList.applicationType, style: AppStyle.userProfile, textAlign: TextAlign.center),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 26.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total EMI Paying Monthly", style: AppStyle.formTitleBlue2),
                  Text("\u20B9${model.getLoanHistoryBaseModel.getMonthlyEMIPaying.round()}", style: AppStyle.formTitleBlue2),
                ],
              ),
              const SizedBox(height: 4.0),
              const Divider(
                thickness: 1,
                color: AppColor.grey2,
              ),
              Visibility(
                visible: !showHideReadyToClose,
                child: const Column(
                  children: [
                    SizedBox(height: 4.0),
                    Text(
                      "You have no advances ready to foreclose",
                      style: AppStyle.pageTitle2grey,
                    ),
                    SizedBox(height: 4.0),
                  ],
                ),
              ),
              Visibility(
                visible: showHideReadyToClose,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4.0),
                    const Text(
                      "To access increased limits, you must foreclose the outstanding balances of the mentioned running advances",
                      style: AppStyle.pageTitle2grey,
                    ),
                    const SizedBox(height: 4.0),
                    ListView.builder(
                      shrinkWrap: true, // use it
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: loanHistoriesList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0, bottom: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Id- ${loanHistoriesList[index].getApplicationId}", style: AppStyle.pageTitle3),
                                  Text("Status- ${loanHistoriesList[index].getCurrentStatus}", style: AppStyle.pageTitle3),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                border: Border.all(width: 1, color: AppColor.grey2),
                              ),
                              child: ListTile(
                                dense: false,
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Checkbox(
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            visualDensity: VisualDensity.compact,
                                            value: loanHistoriesList[index].getIsOptedForDC,
                                            onChanged: (bool? newValue) {
                                              setState(() {
                                                loanHistoriesList[index].setIsOptedForDC = newValue!;

                                                String applicationList = getApplicationList(loanHistoriesList);

                                                futureDebtConsolidationModel = markForeclosure(applicationList);
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Foreclose",
                                            style: AppStyle.smallGrey,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "\u20b9${loanHistoriesList[index].getLoanAmount.round()}",
                                            style: AppStyle.pageTitle3,
                                          ),
                                          const SizedBox(height: 4.0),
                                          const Text(
                                            "Amount",
                                            style: AppStyle.smallGrey,
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "\u20b9${loanHistoriesList[index].getEMIAmount.round()}",
                                            style: AppStyle.pageTitle3,
                                          ),
                                          const SizedBox(height: 4.0),
                                          const Text(
                                            "EMI",
                                            style: AppStyle.smallGrey,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "${loanHistoriesList[index].getPaidEMICount.round()}",
                                            style: AppStyle.pageTitle3,
                                          ),
                                          const SizedBox(height: 4.0),
                                          const Text(
                                            "EMI Paid",
                                            style: AppStyle.smallGrey,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "${loanHistoriesList[index].getPendingEMICount.round()}",
                                            style: AppStyle.pageTitle3,
                                          ),
                                          const SizedBox(height: 4.0),
                                          const Text(
                                            "EMI Left",
                                            style: AppStyle.smallGrey,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                horizontalTitleGap: 0.0,
                                minLeadingWidth: 0,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Available Limits", style: AppStyle.formTitleBlue2),
                  Text("\u20B9${model.getEligibilityResponseModel.getMaxLoanEligibility.round()}", style: AppStyle.formTitleBlue2),
                ],
              ),
              const SizedBox(height: 4.0),
              const Divider(
                thickness: 1,
                color: AppColor.grey2,
              ),
            ],
          ),
        ),
        Visibility(
          visible: showHideSliderBox,
          child: Padding(
            padding: const EdgeInsets.only(top: 26.0),
            child: Container(
              padding: const EdgeInsets.only(top: 26.0, left: 16.0, right: 16.0, bottom: 16.0),
              decoration: BoxDecoration(
                  color: AppColor.bgDefault2,
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: AppColor.grey2, width: 1)),
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
                                  min: loanEligibilityResponseModel.getMinLoanEligibility,
                                  max: loanEligibilityResponseModel.getMaxLoanEligibility,
                                  activeColor: AppColor.lightBlue,
                                  inactiveColor: AppColor.lightGrey,
                                  thumbColor: AppColor.lightBlue,
                                  divisions: customDivisions,
                                  label: 'INR ${_valueAmount.round()}',
                                  onChanged: (double newValue) {
                                    setState(() {
                                      _valueAmount = newValue.round();

                                      if (newValue.round() > loanEligibilityResponseModel.getMaxLoanEligibility) {
                                        _valueAmount = loanEligibilityResponseModel.getMaxLoanEligibility.toInt();
                                      }

                                      isSliding = false;
                                    });
                                  },
                                  onChangeEnd: (double newValue) {
                                    setState(() {
                                      futureDebtConsolidationModel =
                                          getDcAvailability(user.applicantId!, double.parse(newValue.toString()), _valueTenure);
                                    });
                                  },
                                  semanticFormatterCallback: (double newValue) {
                                    return 'INR ${newValue.round()}';
                                  }),
                            )),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("INR ${loanEligibilityResponseModel.getMinLoanEligibility.round()}", style: AppStyle.pageTitle2),
                        Text("INR ${loanEligibilityResponseModel.getMaxLoanEligibility.round()}", style: AppStyle.pageTitle2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
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
                                  min: productList.minTenure.toDouble(),
                                  max: productList.maxTenure.toDouble(),
                                  activeColor: AppColor.lightBlue,
                                  inactiveColor: AppColor.lightGrey,
                                  thumbColor: AppColor.lightBlue,
                                  label: '${_valueTenure.round()} Months',
                                  onChanged: (double newValue) {
                                    setState(() {
                                      _valueTenure = newValue.round();
                                      isSliding = false;
                                    });
                                  },
                                  onChangeEnd: (double newValue) {
                                    setState(() {
                                      futureDebtConsolidationModel =
                                          getDcAvailability(user.applicantId!, double.parse(_valueAmount.toString()), newValue.toInt());
                                    });
                                  },
                                  semanticFormatterCallback: (double newValue) {
                                    return '${newValue.round()}';
                                  }),
                            )),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${productList.minTenure} Months", style: AppStyle.pageTitle2),
                        Text("${productList.maxTenure} Months", style: AppStyle.pageTitle2),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showHideSummary,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0),
                          child: Column(
                            children: [
                              const Divider(
                                thickness: 1,
                                color: AppColor.grey2,
                              ),
                              const SizedBox(height: 12.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Loan Amount", style: AppStyle.textLabelWithBG),
                                  Text("INR ${loanEligibilityResponseModel.getLoanAmount}", style: AppStyle.pageTitle2),
                                ],
                              ),
                              const Divider(
                                thickness: 1,
                                color: AppColor.grey2,
                              ),
                              const SizedBox(height: 12.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("You Receive", style: AppStyle.textLabelWithBG),
                                  Text("INR ${loanEligibilityResponseModel.getYouReceiveAmount}", style: AppStyle.pageTitle2),
                                ],
                              ),
                              const SizedBox(height: 12.0),
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Text("(This is subject to actual disbursal date)", style: AppStyle.smallGrey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                          child: Column(
                            children: [
                              const Divider(
                                thickness: 1,
                                color: AppColor.grey2,
                              ),
                              const SizedBox(height: 12.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("You Pay (EMI)", style: AppStyle.textLabelWithBG),
                                  Text("INR ${loanEligibilityResponseModel.getNewMonthlyPayment}", style: AppStyle.pageTitle2),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0, bottom: 8.0),
                          child: Column(
                            children: [
                              const Divider(
                                thickness: 1,
                                color: AppColor.grey2,
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Processing Fee:", style: AppStyle.smallGrey),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text("INR ${loanEligibilityResponseModel.getProcessingFeeWithGST}", style: AppStyle.smallGrey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Net Payable Amount:", style: AppStyle.smallGrey),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text("INR ${loanEligibilityResponseModel.getNetPayableAmount}", style: AppStyle.smallGrey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Current Monthly EMI:", style: AppStyle.smallGrey),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text("INR ${model.getLoanHistoryBaseModel.getMonthlyEMIPaying}", style: AppStyle.smallGrey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Consolidated Monthly EMI:", style: AppStyle.smallGrey),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text("INR ${loanEligibilityResponseModel.getConsolidatedMonthlyPayment}", style: AppStyle.smallGrey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("EMI Start Month:", style: AppStyle.smallGrey),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(getMonthName(loanEligibilityResponseModel.getEMIStartDate), style: AppStyle.smallGrey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: showHideOfferMsg,
          child: Container(
            margin: const EdgeInsets.only(top: 26, bottom: 0.0),
            width: double.maxFinite,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: Border.all(width: 1, color: AppColor.green),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                loanEligibilityResponseModel.getMessage,
                style: const TextStyle(color: AppColor.green, fontSize: 14.0, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        Visibility(
            visible: showHidePromoForm,
            child: Container(
              margin: const EdgeInsets.only(top: 26, bottom: 0.0),
              width: double.maxFinite,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(width: 1, color: AppColor.grey2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: const Text(
                        "Have Promo Code?",
                        style: AppStyle.pageTitle3,
                      ),
                      children: <Widget>[
                        Form(
                          key: formKey,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: SizedBox(
                                  width: 200.0,
                                  height: 55.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
                                    child: TextFormField(
                                      controller: promoController,
                                      textCapitalization: TextCapitalization.characters,
                                      style: const TextStyle(fontSize: 14.0),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                        label: Text("Enter Code"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 100.0,
                                child: TextButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      // Navigate the user to the Home page
                                      if (promoController.text.toString().isNotEmpty) {
                                        getPromoCodeDetails(promoController.text.toString());
                                      } else {
                                        Global.showAlertDialog(context, "Coupon code is required");
                                      }
                                    }
                                  },
                                  style: const ButtonStyle(
                                      padding: MaterialStatePropertyAll(EdgeInsets.all(11)),
                                      backgroundColor: MaterialStatePropertyAll(AppColor.lightBlue)),
                                  child: isLoadingPromo
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            backgroundColor: AppColor.white,
                                            color: AppColor.lightBlue,
                                          ),
                                        )
                                      : const Text("Apply", style: AppStyle.pageTitleWhite),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Visibility(
            visible: showHidePromoApplied,
            child: Container(
              margin: const EdgeInsets.only(top: 26, bottom: 0.0),
              width: double.maxFinite,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(width: 1, color: AppColor.grey2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 16.0, right: 8.0, bottom: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200.0,
                          child: Html(data: promoHeading, style: {
                            "body": Style(
                              fontSize: FontSize(15.0),
                              color: AppColor.green,
                              fontWeight: FontWeight.w500,
                            ),
                          }),
                        ),
                        SizedBox(
                          width: 50.0,
                          child: IconButton(
                            onPressed: () {
                              //delete promo code
                              setState(() {
                                showHidePromoForm = true;
                                showHidePromoApplied = false;
                              });
                            },
                            icon: const Icon(Icons.delete),
                            color: AppColor.red,
                          ),
                        ),
                      ],
                    ),
                    //Text(promoMessage, style: AppStyle.textLabel),
                    Html(data: promoMessage),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 16.0),
        Visibility(
          visible: showHideMainBtn,
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
                    //send to next screen

                    //create model to send further

                    loanApplicationModel.setApplicantId = user.applicantId!;
                    Applicant applicant = Applicant();
                    applicant.setApplicantId = user.applicantId!;
                    loanApplicationModel.setApplicant = applicant;

                    loanApplicationModel.setBankId = productList.bankId;
                    loanApplicationModel.setApplicationTypeId = productList.applicationTypeId;
                    loanApplicationModel.setLoanAmount = loanEligibilityResponseModel.getLoanAmount;
                    loanApplicationModel.setTenure = loanEligibilityResponseModel.getTenure;
                    loanApplicationModel.setProcessingFee = loanEligibilityResponseModel.getProcessingFee;
                    loanApplicationModel.setEMI = loanEligibilityResponseModel.getNewMonthlyPayment;
                    loanApplicationModel.setInterstRate = loanEligibilityResponseModel.getInterestRate;
                    loanApplicationModel.setDssgIds = user.dssgIds!;

                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return LoanPersonalFormPage(loanModel: loanApplicationModel);
                    }));
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
        Container(
          margin: const EdgeInsets.only(top: 16, bottom: 16.0),
          width: double.maxFinite,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(width: 1, color: AppColor.grey2),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("What is Debt Consolidation?", style: AppStyle.pageTitle),
                SizedBox(height: 8),
                Text(
                    "This calculator can help you find the debt consolidation plan that’s right for you. Should you consolidate your debt? This calculator is designed to help determine if debt consolidation is right for you. Foreclose your running advances. You can then see what your monthly payment would be with a consolidated advance. Try adjusting your terms and amount until you find a consolidation plan that fits your needs - and most importantly your budget!",
                    style: AppStyle.textLabel),
                SizedBox(height: 8),
                Text("How it works?", style: AppStyle.pageTitle),
                SizedBox(height: 8),
                Text("Apply:", style: AppStyle.pageTitle2),
                SizedBox(height: 4),
                Text("Submit your request for debt consolidation through our user-friendly platform.", style: AppStyle.textLabel),
                SizedBox(height: 8),
                Text("Approval:", style: AppStyle.pageTitle2),
                SizedBox(height: 4),
                Text("Quick processing and approval from our lender.", style: AppStyle.textLabel),
                SizedBox(height: 8),
                Text("Agreement:", style: AppStyle.pageTitle2),
                SizedBox(height: 4),
                Text("Complete a simple agreement process to formalize the transaction.", style: AppStyle.textLabel),
                SizedBox(height: 8),
                Text("Disbursement:", style: AppStyle.pageTitle2),
                SizedBox(height: 4),
                Text("Receive the approved amount directly into your account.", style: AppStyle.textLabel),
                SizedBox(height: 8),
                Text("Key Features", style: AppStyle.pageTitle),
                SizedBox(height: 8),
                Text("Rapid Access:", style: AppStyle.pageTitle2),
                SizedBox(height: 4),
                Text("Borrow up to 5 times your monthly salary for substantial financial support.", style: AppStyle.textLabel),
                SizedBox(height: 8),
                Text("Flexible Repayment:", style: AppStyle.pageTitle2),
                SizedBox(height: 4),
                Text("Tailor the repayment period according to your financial preferences, ranging from 3 to 18 months.",
                    style: AppStyle.textLabel),
                SizedBox(height: 8),
                Text("Foreclosure Charges:", style: AppStyle.pageTitle2),
                SizedBox(height: 4),
                Text("Enjoy the benefit of zero foreclosure charges.", style: AppStyle.textLabel),
                SizedBox(height: 8),
                Text("Applicable Charges:", style: AppStyle.pageTitle2),
                SizedBox(height: 4),
                Text("Enjoy the benefit of nominal processing fee & interest charges.", style: AppStyle.textLabel),
                SizedBox(height: 8),
                Text("Easy Process:", style: AppStyle.pageTitle2),
                SizedBox(height: 4),
                Text("Streamlined application, quick approval, and hassle-free disbursement.", style: AppStyle.textLabel),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
