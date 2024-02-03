import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:salarycredits/models/profile/profile_model.dart';
import 'package:salarycredits/utility/api_helper.dart';
import 'package:salarycredits/utility/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/document/document_model.dart';

class FileHandler {
  bool isError = false;
  String errorMessage = "";

  Future<Documents> uploadFile(DocumentRequestModel requestModel) async {
    Documents documents = Documents();

    try {
      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String? token = prefsUser.getString('tokenValue');

      if (token == null) {
        Global.getReToken();
        token = prefsUser.getString('tokenValue');
      }
      var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

      var request = http.MultipartRequest('POST', Uri.parse(APIHelper.uploadFile));
      request.fields.addAll({
        'loanId': '${requestModel.loanId}',
        'applicantId': '${requestModel.applicantId}',
        'fileId': '0',
        'fileTypeId': '${requestModel.fileTypeId}',
        'filePassword': '${requestModel.filePassword}',
      });

      MediaType mediaType = MediaType('image', 'jpg');

      try {
        String? fileName = requestModel.filePath?.split('/').last;
        requestModel.fileName = fileName;

        final mimeType = lookupMimeType('${requestModel.filePath}');
        if (mimeType!.startsWith("image/")) {
          mediaType = MediaType('image', 'jpg');
        } else if (mimeType.startsWith("application/")) {
          mediaType = MediaType('application', 'pdf');
        }
      } catch (err) {
        //
      }

      request.files
          .add(await http.MultipartFile.fromPath('file', '${requestModel.filePath}', contentType: mediaType, filename: '${requestModel.fileName}'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonBody = await response.stream.bytesToString();
        documents = Documents.fromJson(json.decode(jsonBody));
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return documents;
  }

  Future<LoanDocumentsModel> getMyDocuments(int applicantId, String fileTypes) async {
    LoanDocumentsModel loanDocumentsModel = LoanDocumentsModel();

    try {
      var request = http.Request('GET', Uri.parse("${APIHelper.getLoanDocuments}$applicantId&ftid=$fileTypes"));

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
          loanDocumentsModel = LoanDocumentsModel.fromJson(json.decode(jsonBody));
        }
      } else {
        errorMessage = response.reasonPhrase.toString();
      }
    } catch (ex) {
      errorMessage = ex.toString();
    }

    return loanDocumentsModel;
  }


}
