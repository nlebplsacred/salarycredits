class EmployerInfo {
  int employerId = 0;
  String employerName = "";

  EmployerInfo(this.employerId, this.employerName);

  EmployerInfo.fromJson(Map<String, dynamic> json) {
    employerId = json["EmployerId"];
    employerName = json["EmployerName"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["EmployerId"] = employerId;
    data["EmployerName"] = employerName;

    return data;
  }
}

class NominateEmployer {
  int? id = 0;
  String? companyName = "";
  String? hRManagerName = "";
  String? hRManagerPhone = "";
  String? hRManagerEmail = "";
  String? employeeFullName = "";
  String? employeeEmail = "";
  String? nominatedFrom = "";

  NominateEmployer(
      {id,
      this.companyName,
      this.hRManagerName,
      this.hRManagerPhone,
      this.hRManagerEmail,
      this.employeeFullName,
      this.employeeEmail,
      this.nominatedFrom});

  NominateEmployer.fromJson(Map<String, dynamic> json) {
    id = json["Id"];
    companyName = json["CompanyName"];
    hRManagerName = json["HRManagerName"];
    hRManagerPhone = json["HRManagerPhone"];
    hRManagerEmail = json["HRManagerEmail"];
    employeeFullName = json["EmployeeFullName"];
    employeeEmail = json["EmployeeEmail"];
    nominatedFrom = json["NominatedFrom"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["Id"] = id;
    data["CompanyName"] = companyName;
    data["HRManagerName"] = hRManagerName;
    data["HRManagerPhone"] = hRManagerPhone;
    data["HRManagerEmail"] = hRManagerEmail;
    data["EmployeeFullName"] = employeeFullName;
    data["EmployeeEmail"] = employeeEmail;
    data["NominatedFrom"] = nominatedFrom;

    return data;
  }
}
