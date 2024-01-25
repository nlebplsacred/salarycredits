class EmailLoginRequestModel {
  String? emailId;
  String? password;
  bool? remember;

  EmailLoginRequestModel(String email, String pass, bool rem){
    emailId = email;
    password = pass;
    remember = rem;
  }

  EmailLoginRequestModel.fromJson(Map<String, dynamic> json) {
    emailId = json["EmailId"];
    password = json["Password"];
    remember = json["RememberMe"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['EmailId'] = emailId;
    data['Password'] = password;
    data['RememberMe'] = remember;

    return data;
  }
}

class MobileLoginRequestModel {
  String? phoneNumber;
  bool? remember;

  MobileLoginRequestModel(String phoneNo, bool rem){
    phoneNumber = phoneNo;
    remember = rem;
  }

  MobileLoginRequestModel.fromJson(Map<String, dynamic> json) {
    phoneNumber = json["PhoneNumber"];
    remember = json["RememberMe"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['PhoneNumber'] = phoneNumber;
    data['RememberMe'] = remember;

    return data;
  }
}
