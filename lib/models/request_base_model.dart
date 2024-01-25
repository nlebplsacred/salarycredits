
//not in use
class RequestBaseModel {
  String endUrl = "";
  String accessToken = "";
  String jsonBody = "";

  RequestBaseModel(String url, String token, String body) {
    endUrl = url;
    accessToken = token;
    jsonBody = body;
  }
}

