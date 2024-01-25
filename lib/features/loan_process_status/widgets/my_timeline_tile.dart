import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salarycredits/features/loan_process_pending/loan_process_pending_page.dart';
import 'package:salarycredits/features/my_application_details/my_application_details_page.dart';
import 'package:salarycredits/models/loan/loan_status_model.dart';
import 'package:salarycredits/values/colors.dart';
import 'package:salarycredits/values/styles.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../models/loan/applicant_dashboard_base_model.dart';
import '../../../models/loan/short_loan_details.dart';

class MyTimeLineTile extends StatefulWidget {
  final LoanStatusModel statusModel;
  final ShortLoanDetails shortLoanModel;

  const MyTimeLineTile({required this.statusModel, required this.shortLoanModel, super.key});

  @override
  State<MyTimeLineTile> createState() => _MyTimeLineTileState();
}

class _MyTimeLineTileState extends State<MyTimeLineTile> {
  LoanStatusModel loanStatusModel = LoanStatusModel();
  ApplicantDashboardBaseModel userBaseDashboard = ApplicantDashboardBaseModel();
  ShortLoanDetails shortLoan = ShortLoanDetails();
  DateFormat outputFormatDate = DateFormat("dd, MMM yyyy HH:mm aa");

  bool isFirst = false;
  bool isLast = false;
  bool isPast = false;
  bool isActive = false;
  bool showHideTimeLine = true;
  bool showHideStatusInfo = false;
  double maxHeight = 80.0;
  double indicatorXY = 0.1;

  String statusTitle = "";
  String applicationId = "";
  String statusRemarks = "";
  String statusDescription = "";
  String actionTitle = "View Application Details";
  String actionDate = "";

  @override
  void initState() {
    super.initState();
    loanStatusModel = widget.statusModel;
    shortLoan = widget.shortLoanModel;

    setState(() {
      if (loanStatusModel.getStatusId != 1) {
        statusTitle = loanStatusModel.getStatusName;
        applicationId = "Application number: ${shortLoan.getApplicationId}";

        if (loanStatusModel.getStatusId == 3) {
          statusRemarks = "Your Application has been rejected by Lender.";
          statusDescription = "Lender Remarks: ${loanStatusModel.getRemarks}";
        } else if (loanStatusModel.getStatusId == 5) {
          statusRemarks = "Your Application has been rejected by HR.";
          statusDescription = "HR Remarks: ${loanStatusModel.getRemarks}";
        } else if (loanStatusModel.getStatusId == 7) {
          statusRemarks = "This Application has been canceled.";
          statusDescription = "Your Remarks: ${loanStatusModel.getRemarks}";
        } else if (loanStatusModel.getStatusId == 4) {
          if (loanStatusModel.getIsActive) {
            statusRemarks = "Your Application has been approved by HR.";
          } else {
            statusRemarks = "Your Application has been submitted for HR Approval.";
          }

          statusDescription = "Generally, HR approves applications within 24 Hrs. If your Application isn’t approved within 24 Hrs, contact your HR.";
        } else if (loanStatusModel.getStatusId == 2) {
          if (loanStatusModel.getIsActive) {
            statusRemarks = "Your Application has been Approved by Lender.";
            statusDescription = "Complete the application process to quickly disburse money in your account.";
          } else {
            statusRemarks = "Your Application has been forwarded for Lender Approval.";
            statusDescription =
                "Now our team will verify your details and approve your Advance request. This process will take a maximum of 30–45 minutes.";
          }
        } else if (loanStatusModel.getStatusId == 21) {
          if (loanStatusModel.getIsActive) {
            if (shortLoan.getIsProcessDone) {
              statusRemarks = "Transferring money into your account.";
              statusDescription =
                  "Congratulations, You have completed the application process. We are now transferring the amount to your Bank Account. You will be receiving money anytime soon.";
            } else {
              statusRemarks = "Your Application has been Approved by Lender.";
              statusDescription = "Complete the application process to quickly disburse money in your account.";
            }
          } else {
            statusRemarks = "Your Application has been Approved by Lender.";
            statusDescription = "Complete the application process to quickly disburse money in your account.";
          }
        } else if (loanStatusModel.getStatusId == 6) {
          if (loanStatusModel.getIsActive) {
            statusRemarks = "Money transferred into your account.";
            statusDescription = "Congratulations, we have transferred Rs.${shortLoan.getDisbursalAmount} in your account.";
          } else {
            statusRemarks = "Transferring money into your account.";
            statusDescription =
                "Congratulations, You have completed the application process. We are now transferring the amount to your Bank Account. You will be receiving money anytime soon.";
          }
        }

        if (loanStatusModel.getIsActive) {
          //for every last status in of Status Active
          if (loanStatusModel.getStatusId == 3 || loanStatusModel.getStatusId == 5 || loanStatusModel.getStatusId == 7) {
            isActive = true;
            showHideStatusInfo = true;
          } else {
            isActive = false;
            isPast = true;
            showHideTimeLine = true;

            if (!shortLoan.getIsProcessDone && loanStatusModel.getStatusId == 6) {
              isActive = true;
            }
          }
        } else {
          if (loanStatusModel.getStatusId == shortLoan.getStatusId) {
            isActive = true;
            if (loanStatusModel.getStatusId == 21) {
              actionTitle = "Complete Agreement";
            }
          } else {
            isActive = false;
          }
        }
      } else {
        showHideTimeLine = false;
      }

      if (loanStatusModel.getStatusId == 4) {
        isFirst = true;
      }

      //for every last status in case of Status inActive
      if (loanStatusModel.getStatusId == 3 ||
          loanStatusModel.getStatusId == 5 ||
          loanStatusModel.getStatusId == 6 ||
          loanStatusModel.getStatusId == 7) {
        isLast = true;

        if (isActive) {
          isLast = false;
          maxHeight = 240.0;
          indicatorXY = 0.3;
          showHideStatusInfo = true;

          if (shortLoan.getIsProcessDone) {
            isActive = true;
            isPast = false;
          } else {
            isActive = false;
            isPast = true;
          }
        }
      } else {
        if (isActive) {
          maxHeight = 220.0;
          indicatorXY = 0.3;
          showHideStatusInfo = true;
        }
      }

      if (isPast) {
        actionDate = outputFormatDate.format(DateTime.parse(loanStatusModel.getActionOn));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showHideTimeLine,
      child: SizedBox(
        height: maxHeight,
        child: TimelineTile(
          alignment: TimelineAlign.start,
          isFirst: isFirst,
          isLast: isLast,
          //decorate the line
          beforeLineStyle: LineStyle(
              color: isPast
                  ? AppColor.darkBlue
                  : isActive
                      ? AppColor.darkBlue
                      : AppColor.grey2),
          //decorate the icon
          indicatorStyle: IndicatorStyle(
            width: 26,
            indicatorXY: 0,
            color: isPast
                ? AppColor.darkBlue
                : isActive
                    ? AppColor.darkBlue
                    : AppColor.grey2,
            iconStyle: isActive
                ? IconStyle(iconData: Icons.pending, color: AppColor.white)
                : IconStyle(
                    iconData: Icons.done,
                    color: isPast
                        ? AppColor.white
                        : isActive
                            ? AppColor.darkBlue
                            : AppColor.grey2),
          ),
          endChild: Container(
            margin: const EdgeInsets.only(top: 2.0, left: 16.0, right: 20.0),
            decoration: const BoxDecoration(color: AppColor.white),
            child: getTimelineData(loanStatusModel),
          ),
        ),
      ),
    );
  }

  Column getTimelineData(LoanStatusModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          statusTitle,
          style: AppStyle.pageTitle,
        ),
        Visibility(
          visible: isPast,
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(actionDate, style: AppStyle.smallGrey),
          ),
        ),
        Visibility(
          visible: showHideStatusInfo,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Text(statusRemarks, style: AppStyle.pageTitle3),
              const SizedBox(height: 8.0),
              Text(applicationId, style: AppStyle.textLabel),
              const SizedBox(height: 8.0),
              Text(statusDescription, style: AppStyle.textLabel),
              const SizedBox(height: 12.0),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    if (loanStatusModel.getStatusId == 21) {
                      return LoanProcessPendingPage(shortLoanDetails: shortLoan);
                    } else {
                      return MyApplicationDetailsPage(applicationId: shortLoan.getApplicationId);
                    }
                  }));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(width: 1, color: AppColor.darkBlue),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 6.0, left: 16.0, right: 16.0),
                    child: Text(
                      actionTitle,
                      style: const TextStyle(color: AppColor.darkBlue, fontSize: 13.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
