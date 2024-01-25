import 'package:flutter/foundation.dart';
import 'package:salarycredits/models/login/login_response_model.dart';

class UserProvider extends ChangeNotifier {
  LoginResponseModel _user = LoginResponseModel();

  LoginResponseModel get user => _user;

  void setUser(LoginResponseModel user) {
    _user = user;
    notifyListeners();
  }

  LoginResponseModel getUser() {
    return _user;
  }
}