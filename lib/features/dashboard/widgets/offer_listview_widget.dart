import 'package:flutter/material.dart';
import 'package:salarycredits/features/custom_advance/custom_advance_page.dart';
import 'package:salarycredits/features/debt_consolidation/debt_consolidation_page.dart';
import 'package:salarycredits/features/earned_wage_access/ewa_page.dart';
import 'package:salarycredits/features/fast_pay/fast_pay_page.dart';
import 'package:salarycredits/features/salary_advance/salary_advance_page.dart';
import 'package:salarycredits/values/styles.dart';
import '../../../models/loan/applicant_dashboard_base_model.dart';
import '../../../values/colors.dart';
import '../../personal_loan/personal_loan_page.dart';

class OfferListView extends StatefulWidget {
  final ApplicantDashboardBaseModel dashboardBaseModel;

  const OfferListView(this.dashboardBaseModel, {super.key});

  @override
  State<OfferListView> createState() => _OfferListViewState();
}

class _OfferListViewState extends State<OfferListView> {
  ApplicantDashboardBaseModel userBaseDashboard = ApplicantDashboardBaseModel();
  List<ProductList> productList = [];

  @override
  void initState() {
    super.initState();
    productList = widget.dashboardBaseModel.productBaseModel.productList;
    userBaseDashboard = widget.dashboardBaseModel;
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getSubTitle(ProductList model) {
    double roundMaxAmount = model.maxLoanAmount;
    String lMonths = model.maxTenure > 1 ? '${model.maxTenure} months' : '${model.maxTenure} month';
    String lLoanShortDetails = "Max Amt: \u20B9${roundMaxAmount.round()} | Max Tenure: $lMonths";
    return lLoanShortDetails;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // use it
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productList.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(width: 1, color: AppColor.grey2),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0),
            onTap: () {
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  if (productList[index].applicationTypeId == 13) {
                    return EWAPage(product: productList[index], dashboardBaseModel: userBaseDashboard);
                  } else if (productList[index].applicationTypeId == 9) {
                    return FastPayPage(product: productList[index], dashboardBaseModel: userBaseDashboard);
                  } else if (productList[index].applicationTypeId == 6) {
                    return SalaryAdvancePage(product: productList[index], dashboardBaseModel: userBaseDashboard);
                  } else if (productList[index].applicationTypeId == 5) {
                    return CustomAdvancePage(product: productList[index], dashboardBaseModel: userBaseDashboard);
                  } else if (productList[index].applicationTypeId == 3) {
                    return DebtConsolidationPage(product: productList[index], dashboardBaseModel: userBaseDashboard);
                  } else if (productList[index].applicationTypeId == 1) {
                    return PersonalLoanPage(product: productList[index], dashboardBaseModel: userBaseDashboard);
                  } else {
                    return SalaryAdvancePage(product: productList[index], dashboardBaseModel: userBaseDashboard);
                  }
                }));
              });
            },
            horizontalTitleGap: 6.0,
            dense: false,
            //visualDensity: VisualDensity(vertical: -3), // to compact
            title: Text(
              productList[index].applicationType,
              style: AppStyle.pageTitle2,
            ),
            subtitle: Text(
              getSubTitle(productList[index]),
              style: AppStyle.smallGrey,
            ),
            leading: SizedBox.fromSize(
              size: const Size(42, 42),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Material(
                  color: AppColor.white,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Image.network(productList[index].applicationIconPath, color: AppColor.lightBlue),
                  ),
                ),
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_right, color: AppColor.lightBlue, size: 32),
          ),
        );
      },
    );
  }
}
