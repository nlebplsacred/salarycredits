class CityNameByPIN {
  CityNameByPIN();

  int _pinId  =0;
  int _pinCode =0;
  String _pinCity = "";
  String _pinState = "";
  bool _isNegative = false;


  int get getPinId => _pinId;

  set setPinId(int value) {
    _pinId = value;
  }

  int get getPinCode => _pinCode;

  set setPinCode(int value) {
    _pinCode = value;
  }

  String get getPinCity => _pinCity;

  set pinCity(String value) {
    _pinCity = value;
  }

  String get pinState => _pinState;

  set setPinState(String value) {
    _pinState = value;
  }

  bool get getIsNegative => _isNegative;

  set setIsNegative(bool value) {
    _isNegative = value;
  }

  CityNameByPIN.fromJson(Map<String, dynamic> json) {
    _pinId = json['pin_id'];
    _pinCode = json['pin_code'];
    _pinCity = json['pin_city'];
    _pinState = json['pin_state'];
    _isNegative = json['is_negative'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pin_id'] = _pinId;
    data['pin_code'] = _pinCode;
    data['pin_city'] = _pinCity;
    data['pin_state'] = _pinState;
    data['is_negative'] = _isNegative;
    return data;
  }

}
