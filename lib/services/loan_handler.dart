import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salarycredits/models/document/document_model.dart';
import 'package:salarycredits/models/loan/active_salary_account_model.dart';
import 'package:salarycredits/models/loan/application_request_model.dart';
import 'package:salarycredits/models/loan/faqs_model.dart';
import 'package:salarycredits/models/loan/lender_consent_model.dart';
import 'package:salarycredits/utility/api_helper.dart';
import 'package:salarycredits/utility/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/loan/action_tag_details_model.dart';
import '../models/loan/city_pincode_model.dart';
import '../models/loan/coupon_details_model.dart';
import '../models/loan/debt_consolidation_model.dart';
import '../models/loan/emi_calculator_base_model.dart';
import '../models/loan/external_loan_process_model.dart';
import '../models/loan/lender_agreement_model.dart';
import '../models/loan/loan_cancel_request.dart';
import '../models/loan/loan_details_model.dart';
import '../models/loan/loan_eligibility_request_model.dart';
import '../models/loan/loan_process_pending.dart';
import '../models/loan/loan_status_history_model.dart';
import '../models/loan/master_data_model.dart';
import '../models/loan/personal_data_base_model.dart';
import '../models/loan/personal_reference_model.dart';
import '../models/loan/short_loan_model.dart';

class LoanHandler {
  bool isError = false;
  String errorMessage = "";

  Future<ActionTagDetails> getRunningApplicationStatus(int applicantId, int loanTypeId) async {
    ActionTagDetails actionTagDetails = ActionTagDetails();
    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.getAppPendingStatus}$applicantId&ltid=$loanTypeId"));

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token'};
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();

        if (jsonBody.isNotEmpty) {
          var data = json.decode(jsonBody); //jsonDecode(jsonBody);

          if (data.containsKey('Message')) {
            errorMessage = data['Message'].toString();
          } else {
            actionTagDetails = ActionTagDetails.fromJson(json.decode(jsonBody));
          }
        } else {
          errorMessage = response.reasonPhrase.toString();
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return actionTagDetails;
  }

  Future<LoanEligibilityResponseModel> getLoanEligibility(LoanEligibilityRequestModel requestModel) async {
    LoanEligibilityResponseModel loanEligibilityResponseModel = LoanEligibilityResponseModel();
    try {
      var request = http.Request('POST', Uri.parse(APIHelper.getLoanAvailability));
      request.body = jsonEncode(requestModel.toJson());

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();

        if (jsonBody.isNotEmpty) {
          var data = jsonDecode(jsonBody);

          String statusId = data['StatusId'].toString();
          String message = data['Message'].toString();

          if (statusId != "0") {
            loanEligibilityResponseModel = LoanEligibilityResponseModel.fromJson(json.decode(jsonBody));
          } else {
            errorMessage = message;
          }
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return loanEligibilityResponseModel;
  }

  Future<CouponDetailsModel> getPromoCodeDetails(int applicantId, int loanTypeId, int employerId, String promoCode) async {
    CouponDetailsModel couponDetailsModel = CouponDetailsModel();
    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.applyPromoCode}$applicantId&eid=$employerId&ltid=$loanTypeId&coupon=$promoCode"));

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token'};
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();

        if (jsonBody.isNotEmpty) {
          couponDetailsModel = CouponDetailsModel.fromJson(json.decode(jsonBody));
        } else {
          errorMessage = response.reasonPhrase.toString();
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return couponDetailsModel;
  }

  Future<PersonalDataModel> getPersonalData(int applicantId) async {
    PersonalDataModel loanModel = PersonalDataModel();
    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.getPersonalData}$applicantId"));

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token'};
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();

        if (jsonBody.isNotEmpty) {
          var data = json.decode(jsonBody); //jsonDecode(jsonBody);

          if (data.containsKey('Message')) {
            errorMessage = data['Message'].toString();
          } else {
            loanModel = PersonalDataModel.fromJson(json.decode(jsonBody));
          }
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return loanModel;
  }

  Future<MasterData> getMasterData() async {
    MasterData masterData = MasterData();
    try {
      var request = http.Request('GET', Uri.parse(APIHelper.getMasterData));

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token'};
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();

        if (jsonBody.isNotEmpty) {
          masterData = MasterData.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return masterData;
  }

  Future<PersonalDataModel> getApplicantAndMasterData(int applicantId) async {
    PersonalDataModel applicantDataMasterData = PersonalDataModel();

    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.getPersonalDataMasterData}$applicantId"));

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token'};
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();

        if (jsonBody.isNotEmpty) {
          applicantDataMasterData = PersonalDataModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return applicantDataMasterData;
  }

  Future<CityNameByPIN> getCityNameByPincode(String pincode) async {
    CityNameByPIN cityNameByPIN = CityNameByPIN();

    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.getCityByPIN}$pincode"));

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token'};
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();

        if (jsonBody.isNotEmpty) {
          cityNameByPIN = CityNameByPIN.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return cityNameByPIN;
  }

  Future<LoanResponseModel> createApplicationRequest(LoanRequestModel requestModel) async {
    LoanResponseModel loanResponseModel = LoanResponseModel();

    try {
      var request = http.Request('POST', Uri.parse(APIHelper.createLoan));
      request.body = jsonEncode(requestModel.toJson());

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();

        //print('nitya-$jsonBody');

        if (jsonBody.isNotEmpty) {
          var data = json.decode(jsonBody); //jsonDecode(jsonBody);

          String statusId = "";
          String message = "";
          int applicationId = 0;

          if (data.containsKey('ApplicationId')) {
            applicationId = int.parse(data['ApplicationId'].toString());
          }

          if (data.containsKey('StatusId')) {
            statusId = data['StatusId'].toString();
          }

          if (data.containsKey('Message')) {
            message = data['Message'].toString();
          }

          if (statusId.isNotEmpty) {
            loanResponseModel.setStatusId = statusId;
          }

          if (message.isNotEmpty) {
            loanResponseModel.setMessage = message;
          }

          if (applicationId > 0) {
            loanResponseModel.setApplicationId = applicationId;
          }
        } else {
          errorMessage = "Something went wrong, please try again";
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return loanResponseModel;
  }

  Future<LenderConsent> getLenderConsentDetails(int bankId) async {
    LenderConsent lenderConsent = LenderConsent();

    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.getConsentDetails}$bankId"));

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token'};
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();

        if (jsonBody.isNotEmpty) {
          lenderConsent = LenderConsent.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return lenderConsent;
  }

  Future<String> applyConfirm(int applicationId) async {
    String jsonBody = "";

    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.applyConfirm}$applicationId"));

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token'};
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        jsonBody = await response.stream.bytesToString();
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return jsonBody;
  }

  Future<ShortLoanModel> getLoanUnderProcessStatus(int applicantId) async {
    ShortLoanModel shortLoanModel = ShortLoanModel();
    var request = http.Request('GET', Uri.parse("${APIHelper.getPendingLoanDetails}$applicantId"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          errorMessage = data['Message'].toString();
        } else {
          shortLoanModel = ShortLoanModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }

    return shortLoanModel;
  }

  Future<LoanStatusHistoryModel> getLoanStatusHistoryList(int applicationId) async {
    LoanStatusHistoryModel loanStatusHistoryModel = LoanStatusHistoryModel();

    var request = http.Request('GET', Uri.parse("${APIHelper.getLoanStatusHistory}$applicationId"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          errorMessage = data['Message'].toString();
        } else {
          loanStatusHistoryModel = LoanStatusHistoryModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }

    return loanStatusHistoryModel;
  }

  Future<LoanProcessPending> getLoanProcessPending(int applicantId, int applicationId) async {
    LoanProcessPending loanProcessPending = LoanProcessPending();
    var request = http.Request('GET', Uri.parse("${APIHelper.getLoanProcessPending}$applicantId&appid=$applicationId"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          errorMessage = data['Message'].toString();
        } else {
          loanProcessPending = LoanProcessPending.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }

    return loanProcessPending;
  }

  Future<LenderAgreementModel> getLoanAgreementData(int applicantId, int applicationId, String otp) async {
    LenderAgreementModel lenderAgreementModel = LenderAgreementModel();
    var request = http.Request('GET', Uri.parse("${APIHelper.getLoanAgreement}$applicantId&appid=$applicationId&otp=$otp"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          errorMessage = data['Message'].toString();
        } else {
          lenderAgreementModel = LenderAgreementModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }
    return lenderAgreementModel;
  }

  Future<String> resendLoanAgreementOTP(int applicantId, String otp) async {
    String result = "";

    var request = http.Request('GET', Uri.parse("${APIHelper.getLoanAgreementGenerateOTP}$applicantId&otp=$otp"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          result = data['Message'].toString();
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }

    return result;
  }

  Future<String> acceptLoanAgreement(LenderAgreementModel requestModel) async {
    String result = "";

    try {
      var request = http.Request('POST', Uri.parse(APIHelper.acceptLoanAgreement));
      request.body = jsonEncode(requestModel.toJson());

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();

        if (jsonBody.isNotEmpty) {
          result = jsonBody;
        } else {
          errorMessage = "Something went wrong, please try again";
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return result;
  }

  Future<String> addLoanPersonalReference(PersonalReferenceBaseModel requestModel) async {
    String result = "";

    try {
      var request = http.Request('POST', Uri.parse(APIHelper.addPersonalReference));
      request.body = jsonEncode(requestModel.toJson());

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();

        if (jsonBody.isNotEmpty) {
          result = jsonBody;
        } else {
          errorMessage = "Something went wrong, please try again";
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return result;
  }

  Future<ExternalLoanProcessModel> getLoanNACHInfo(int applicantId) async {
    ExternalLoanProcessModel externalLoanProcessModel = ExternalLoanProcessModel();
    var request = http.Request('GET', Uri.parse("${APIHelper.getLoanNACHInfo}$applicantId"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          errorMessage = data['Message'].toString();
        } else {
          externalLoanProcessModel = ExternalLoanProcessModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }
    return externalLoanProcessModel;
  }

  Future<LoanDetailsModel> getApplicationDetails(int applicationId) async {
    LoanDetailsModel loanDetailsModel = LoanDetailsModel();
    var request = http.Request('GET', Uri.parse("${APIHelper.getApplicationDetails}$applicationId"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          errorMessage = data['Message'].toString();
        } else {
          loanDetailsModel = LoanDetailsModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }
    return loanDetailsModel;
  }

  Future<ShortLoanModel> getMyApplications(int applicantId) async {
    ShortLoanModel shortLoanModel = ShortLoanModel();
    var request = http.Request('GET', Uri.parse("${APIHelper.getMyShortLoanList}$applicantId"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          errorMessage = data['Message'].toString();
        } else {
          shortLoanModel = ShortLoanModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }
    return shortLoanModel;
  }

  Future<ShortLoanModel> getMyShortApplications(int applicantId, String loanType) async {
    ShortLoanModel shortLoanModel = ShortLoanModel();
    var request = http.Request('GET', Uri.parse("${APIHelper.getMyShortLoanList}$applicantId&ltid=$loanType"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          errorMessage = data['Message'].toString();
        } else {
          shortLoanModel = ShortLoanModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }
    return shortLoanModel;
  }

  Future<String> cancelLoanRequest(LoanCancelRequestModel requestModel) async {
    String result = "";

    try {
      var request = http.Request('POST', Uri.parse(APIHelper.cancelLoanRequest));
      request.body = jsonEncode(requestModel.toJson());

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();

        if (jsonBody.isNotEmpty) {
          result = jsonBody;
        } else {
          errorMessage = "Something went wrong, please try again";
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return result;
  }

  Future<ActiveSalaryAccountModel> getActiveSalaryAccount(int applicantId) async {
    ActiveSalaryAccountModel activeSalaryAccountModel = ActiveSalaryAccountModel();
    var request = http.Request('GET', Uri.parse("${APIHelper.getActiveSalaryAccount}$applicantId"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          errorMessage = data['Message'].toString();
        } else {
          activeSalaryAccountModel = ActiveSalaryAccountModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }
    return activeSalaryAccountModel;
  }

  Future<FAQBaseModel> getFaqsList(String lang) async {
    FAQBaseModel faqBaseModel = FAQBaseModel();
    var request = http.Request('GET', Uri.parse("${APIHelper.getFaqList}$lang"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          errorMessage = data['Message'].toString();
        } else {
          faqBaseModel = FAQBaseModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }
    return faqBaseModel;
  }

  Future<Documents> getFilePath(int applicationId, fileType) async {
    Documents documents = Documents();
    var request = http.Request('GET', Uri.parse("${APIHelper.getFile}$applicationId&ft=$fileType"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          errorMessage = data['Message'].toString();
        } else {
          documents = Documents.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }
    return documents;
  }

  Future<DebtConsolidationModel> getDcAvailabilityWithObligations(int applicantId) async {
    DebtConsolidationModel debtConsolidationModel = DebtConsolidationModel();
    var request = http.Request('GET', Uri.parse("${APIHelper.getDcAvailabilityWithObligations}$applicantId"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          errorMessage = data['Message'].toString();
        } else {
          debtConsolidationModel = DebtConsolidationModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }
    return debtConsolidationModel;
  }

  Future<DebtConsolidationModel> getDcAvailability(int applicantId, double amount, int tenure) async {
    DebtConsolidationModel debtConsolidationModel = DebtConsolidationModel();
    var request = http.Request('GET', Uri.parse("${APIHelper.getDcAvailability}$applicantId&amount=$amount&tenure=$tenure"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          errorMessage = data['Message'].toString();
        } else {
          debtConsolidationModel = DebtConsolidationModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }
    return debtConsolidationModel;
  }

  Future<DebtConsolidationModel> markForeclosure(DCForeclosureRequest requestModel) async {
    DebtConsolidationModel debtConsolidationModel = DebtConsolidationModel();

    try {
      var request = http.Request('POST', Uri.parse(APIHelper.saveDcConsolidationRequest));
      request.body = jsonEncode(requestModel.toJson());

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();

        if (jsonBody.isNotEmpty) {
          var data = json.decode(jsonBody); //jsonDecode(jsonBody);

          if (data.containsKey('Message')) {
            errorMessage = data['Message'].toString();
          } else {
            debtConsolidationModel = DebtConsolidationModel.fromJson(json.decode(jsonBody));
          }
        } else {
          errorMessage = "Something went wrong, please try again";
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return debtConsolidationModel;
  }

  Future<EMICalculatorBaseModel> calculateEMI(EMICalculatorRequestModel requestModel) async {
    EMICalculatorBaseModel emiCalculatorBaseModel = EMICalculatorBaseModel();

    try {
      var request = http.Request('POST', Uri.parse(APIHelper.calculateEMI));
      request.body = jsonEncode(requestModel.toJson());

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();

        if (jsonBody.isNotEmpty) {
          var data = json.decode(jsonBody); //jsonDecode(jsonBody);

          if (data.containsKey('Message')) {
            errorMessage = data['Message'].toString();
          } else {
            emiCalculatorBaseModel = EMICalculatorBaseModel.fromJson(json.decode(jsonBody));
          }
        } else {
          errorMessage = "Something went wrong, please try again";
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return emiCalculatorBaseModel;
  }

  Future<String> acceptApprovedOffer(int applicationId,) async {
    String result = "";

    var request = http.Request('GET', Uri.parse("${APIHelper.acceptApprovedOffer}$applicationId"));

    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    String? token = prefsUser.getString('tokenValue');

    if (token == null) {
      Global.getReToken();
      token = prefsUser.getString('tokenValue');
    }
    var headers = {'Authorization': 'Bearer $token'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonBody = await response.stream.bytesToString();

      if (jsonBody.isNotEmpty) {
        var data = json.decode(jsonBody); //jsonDecode(jsonBody);

        if (data.containsKey('Message')) {
          result = data['Message'].toString();
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } else {
      errorMessage = response.reasonPhrase.toString();
    }

    return result;
  }

}
