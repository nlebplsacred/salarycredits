class MasterData {
  MasterData();

  List<SelectListItem> cities = List.empty();
  List<SelectListItem> states = List.empty();
  List<SelectListItem> educations = List.empty();
  List<SelectListItem> maritalStatus = List.empty();
  List<SelectListItem> genders = List.empty();
  List<SelectListItem> residents = List.empty();
  List<SelectListItem> stability = List.empty();
  List<SelectListItem> dependents = List.empty();
  List<SelectListItem> experiences = List.empty();
  List<SelectListItem> purposes = List.empty();

  MasterData.fromJson(Map<String, dynamic> json) {
    if (json['Cities'] != null) {
      cities = <SelectListItem>[];
      json['Cities'].forEach((v) {
        cities.add(SelectListItem.fromJson(v));
      });
    }
    if (json['States'] != null) {
      states = <SelectListItem>[];
      json['States'].forEach((v) {
        states.add(SelectListItem.fromJson(v));
      });
    }
    if (json['Educations'] != null) {
      educations = <SelectListItem>[];
      json['Educations'].forEach((v) {
        educations.add(SelectListItem.fromJson(v));
      });
    }
    if (json['MaritalStatus'] != null) {
      maritalStatus = <SelectListItem>[];
      json['MaritalStatus'].forEach((v) {
        maritalStatus.add(SelectListItem.fromJson(v));
      });
    }
    if (json['Genders'] != null) {
      genders = <SelectListItem>[];
      json['Genders'].forEach((v) {
        genders.add(SelectListItem.fromJson(v));
      });
    }
    if (json['Residents'] != null) {
      residents = <SelectListItem>[];
      json['Residents'].forEach((v) {
        residents.add(SelectListItem.fromJson(v));
      });
    }
    if (json['Stability'] != null) {
      stability = <SelectListItem>[];
      json['Stability'].forEach((v) {
        stability.add(SelectListItem.fromJson(v));
      });
    }
    if (json['Dependents'] != null) {
      dependents = <SelectListItem>[];
      json['Dependents'].forEach((v) {
        dependents.add(SelectListItem.fromJson(v));
      });
    }
    if (json['Experiences'] != null) {
      experiences = <SelectListItem>[];
      json['Experiences'].forEach((v) {
        experiences.add(SelectListItem.fromJson(v));
      });
    }
    if (json['Purposes'] != null) {
      purposes = <SelectListItem>[];
      json['Purposes'].forEach((v) {
        purposes.add(SelectListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Cities'] = cities.map((v) => v.toJson()).toList();
    data['States'] = states.map((v) => v.toJson()).toList();
    data['Educations'] = educations.map((v) => v.toJson()).toList();
    data['MaritalStatus'] = maritalStatus.map((v) => v.toJson()).toList();
    data['Genders'] = genders.map((v) => v.toJson()).toList();
    data['Residents'] = residents.map((v) => v.toJson()).toList();
    data['Stability'] = stability.map((v) => v.toJson()).toList();
    data['Dependents'] = dependents.map((v) => v.toJson()).toList();
    data['Experiences'] = experiences.map((v) => v.toJson()).toList();
    data['Purposes'] = purposes.map((v) => v.toJson()).toList();
    return data;
  }
}

class SelectListItem {
  bool disabled = false;
  bool selected = false;
  String text = "";
  String value = "";

  SelectListItem({disabled, selected, text, value});

  SelectListItem.fromJson(Map<String, dynamic> json) {
    disabled = json['Disabled'];
    selected = json['Selected'];
    text = json['Text'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Disabled'] = disabled;
    data['Selected'] = selected;
    data['Text'] = text;
    data['Value'] = value;
    return data;
  }
}
