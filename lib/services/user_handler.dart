import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:salarycredits/models/loan/applicant_dashboard_base_model.dart';
import 'package:salarycredits/models/login/login_request_model.dart';
import 'package:salarycredits/models/profile/profile_model.dart';
import 'package:salarycredits/utility/api_helper.dart';
import 'package:salarycredits/utility/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login/employer_info.dart';
import '../models/login/login_response_model.dart';
import '../models/support/ask_query_request_model.dart';
import 'api_auth.dart';

class UserHandler {
  bool isError = false;
  String errorMessage = "";

  Future<LoginResponseModel> fetchUser1(int applicantId) async {
    LoginResponseModel loginResponseModel = LoginResponseModel();
    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.getUserInfo}$applicantId"));

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
          loginResponseModel = LoginResponseModel.fromJson(json.decode(jsonBody));
        } else {
          errorMessage = response.reasonPhrase.toString();
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = "Something went wrong";
    }

    return loginResponseModel;
  }

  Future<LoginResponseModel> fetchUser2(String email) async {
    LoginResponseModel loginResponseModel = LoginResponseModel();
    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.getUserInfo2}$email"));

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

        //print('jsonBody$jsonBody');

        if (jsonBody.isNotEmpty) {
          loginResponseModel = LoginResponseModel.fromJson(json.decode(jsonBody));
        } else {
          errorMessage = response.reasonPhrase.toString();
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = "Something went wrong";
    }

    return loginResponseModel;
  }

  Future<String> sendEmailOTP(int aid, String email, String otp) async {
    String jsonBody = "";

    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.sendOTPEmail}?aid=$aid&email=$email&otp=$otp"));

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
      errorMessage = "Network not available";
    }

    return jsonBody;
  }

  updateSession(String jsonBody) async {
    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    await prefsUser.setString('sessionUser', jsonBody); //update session
  }

  Future<LoginResponseModel> updateUserSession(int applicantId) async {
    LoginResponseModel loginResponseModel = LoginResponseModel();
    String jsonBody = "";
    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.getUserInfo}$applicantId"));

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
        await prefsUser.setString('sessionUser', jsonBody); //update session
        if (jsonBody.isNotEmpty) {
          loginResponseModel = LoginResponseModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return loginResponseModel;
  }

  Future<String> loginWithEmail(BuildContext context, EmailLoginRequestModel loginRequestModel) async {
    String jsonBody = "";
    final ApiToken apiToken = ApiToken();

    try {
      var request = http.Request('POST', Uri.parse(APIHelper.emailLogin));
      request.body = jsonEncode(loginRequestModel.toJson());

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        apiToken.getToken();
        await Future.delayed(const Duration(seconds: 2));
        token = prefsUser.getString('tokenValue');
        //print('token1: $token');
      }
      //print('token2: $token');

      var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        jsonBody = await response.stream.bytesToString();
        //store user login model in shared data for maintaining session
        await prefsUser.setString('sessionUser', jsonBody);
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = "Network not available";
    }

    return jsonBody;
  }

  Future<String> loginWithMobile(BuildContext context, MobileLoginRequestModel loginRequestModel) async {
    String jsonBody = "";
    final ApiToken apiToken = ApiToken();

    try {
      var request = http.Request('POST', Uri.parse(APIHelper.mobileLogin));
      request.body = jsonEncode(loginRequestModel.toJson());

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        apiToken.getToken();
        await Future.delayed(const Duration(seconds: 2));
        token = prefsUser.getString('tokenValue');
      }

      var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        jsonBody = await response.stream.bytesToString();
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = "Network not available";
    }

    return jsonBody;
  }

  Future<String> sendOtp(String mobile, String otp) async {
    String jsonBody = "";

    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.sendOtp}?mobile=$mobile&otp=$otp"));

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
      errorMessage = "Network not available";
    }

    return jsonBody;
  }

  Future<String> verifyMobileNumber(int applicantId) async {
    String jsonBody = "";

    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.verifyMobile}$applicantId"));

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
        await updateUserSession(applicantId);
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = "Network not available";
    }

    return jsonBody;
  }

  Future<String> updateMobileNumber(int applicantId, String mobileNumber) async {
    String jsonBody = "";

    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.updateMobileNumber}$applicantId&mobile=$mobileNumber"));

      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {
        'Authorization': 'Bearer $token',
      };

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        jsonBody = await response.stream.bytesToString();
        await updateUserSession(applicantId);
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = "Network not available";
    }

    return jsonBody;
  }

  Future<String> sendApplyOTP(String mobile, String otp) async {
    String jsonBody = "";

    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.sendOTPApply}?mobile=$mobile&otp=$otp"));

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
      errorMessage = "Network not available";
    }

    return jsonBody;
  }

  Future<String> forgotPassword(String email) async {
    String jsonBody = "";

    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.forgotPassword}$email"));

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
      errorMessage = "Network not available";
    }

    return jsonBody;
  }

  Future<EmployerInfo> searchEmployer(String name) async {
    EmployerInfo employerInfo = EmployerInfo(0, "");

    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.searchEmployer}$name"));

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
          employerInfo = EmployerInfo.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = "Network not available";
    }
    return employerInfo;
  }

  Future<NominateEmployer> nominateEmployer(NominateEmployer requestModel) async {
    NominateEmployer nominateEmployer = NominateEmployer();

    try {
      var request = http.Request('POST', Uri.parse(APIHelper.saveNominatedEmployerRequest));
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
          nominateEmployer = NominateEmployer.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = "Network not available";
    }

    return nominateEmployer;
  }

  Future<ProfileModel> getUserProfileData(int applicantId) async {
    ProfileModel profileModel = ProfileModel();

    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.profileInfo}$applicantId"));

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
          profileModel = ProfileModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = "Something went wrong";
    }

    return profileModel;
  }

  Future<ApplicantDashboardBaseModel> getDashboardInfo(int applicantId) async {
    ApplicantDashboardBaseModel applicantDashboardBaseModel = ApplicantDashboardBaseModel();

    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.getDashboardInfo}$applicantId"));

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
          applicantDashboardBaseModel = ApplicantDashboardBaseModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = "Something went wrong";
    }

    return applicantDashboardBaseModel;
  }

  Future<String> askQueryRequest(AskQueryModel requestModel) async {
    String result = "";

    try {
      var request = http.Request('POST', Uri.parse(APIHelper.askQueryRequest));
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
      errorMessage = "Something went wrong";
    }

    return result;
  }
}
