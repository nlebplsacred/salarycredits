import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/loan/loan_details_model.dart';
import '../../../models/login/login_response_model.dart';
import '../../../values/colors.dart';

class ViewInstallmentsPage extends StatefulWidget {
  final LoanDetailsModel loanDetails;

  const ViewInstallmentsPage({required this.loanDetails, super.key});

  @override
  State<ViewInstallmentsPage> createState() => _ViewInstallmentsPageState();
}

class _ViewInstallmentsPageState extends State<ViewInstallmentsPage> {
  LoginResponseModel user = LoginResponseModel();
  LoanDetailsModel loanDetailsModel = LoanDetailsModel();
  DateFormat outputFormatDate = DateFormat('dd-MMM-yyyy');
  DateFormat outputFormatMonth = DateFormat('MMM-yyyy');

  @override
  void initState() {
    super.initState();

    loanDetailsModel = widget.loanDetails;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));
      });
    });
  }

  String getDate(String date, DateFormat format) {
    String lDate = "N/A";
    try {
      if (date != "") {
        lDate = format.format(DateTime.parse(date));
      }
    } on FormatException catch (_) {}

    return lDate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgDefault1,
      appBar: AppBar(
        elevation: 1.0,
        toolbarHeight: 60.0,
        titleSpacing: 2.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColor.white, // <-- SEE HERE
          statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        title: const Text(
          "View Installment Status",
          style: TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            decoration: const BoxDecoration(color: AppColor.white),
            child: DataTable(
              border: TableBorder.all(color: AppColor.grey2, width: 1),
              columnSpacing: 25.0,
              columns: const [
                DataColumn(
                  label: Text('Month', style: TextStyle(color: AppColor.lightBlack)),
                ),
                DataColumn(
                  label: Text('EMI Month', style: TextStyle(color: AppColor.lightBlack)),
                ),
                DataColumn(
                  label: Text('EMI Amount', style: TextStyle(color: AppColor.lightBlack)),
                ),
                DataColumn(
                  label: Text('Status', style: TextStyle(color: AppColor.lightBlack)),
                ),
              ],
              rows: loanDetailsModel.getRepaymentDetails // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(element.getMonths.toString(), style: const TextStyle(color: AppColor.black))),
                            //Extracting from Map element the value
                            DataCell(
                                Text(getDate(element.getPayDate, outputFormatMonth), style: const TextStyle(fontSize: 13.0, color: AppColor.black))),
                            DataCell(Text(element.getTotalRepayment.toString(), style: const TextStyle(fontSize: 13.0, color: AppColor.black))),
                            DataCell(Text(
                                element.getStatus == true
                                    ? "Paid"
                                    : loanDetailsModel.getCurrentStatusId == 1
                                        ? "-"
                                        : loanDetailsModel.getCurrentStatusId == 4
                                            ? "-"
                                            : "Pending",
                                style: const TextStyle(fontSize: 13.0, color: AppColor.black))),
                          ],
                        )),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
