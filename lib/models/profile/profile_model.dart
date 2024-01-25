
class ProfileModel {
  List<MyDocuments>? myDocuments;
  UserInformation? userInformation;

  ProfileModel({this.myDocuments, this.userInformation});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    if (json['myDocuments'] != null) {
      myDocuments = <MyDocuments>[];
      json['myDocuments'].forEach((v) {
        myDocuments!.add(MyDocuments.fromJson(v));
      });
    }
    userInformation = json['userInformation'] != null
        ? UserInformation.fromJson(json['userInformation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (myDocuments != null) {
      data['myDocuments'] = myDocuments!.map((v) => v.toJson()).toList();
    }
    if (userInformation != null) {
      data['userInformation'] = userInformation!.toJson();
    }
    return data;
  }
}

class MyDocuments {
  int? fileId;
  int? applicantId;
  int? applicationId;
  int? fileTypeId;
  String? fileName;
  String? filePath;
  String? filePassword;
  String? createdOn;

  MyDocuments(
      {this.fileId,
      this.applicantId,
      this.applicationId,
      this.fileTypeId,
      this.fileName,
      this.filePath,
      this.filePassword,
      this.createdOn});

  MyDocuments.fromJson(Map<String, dynamic> json) {
    fileId = json['FileId'];
    applicantId = json['ApplicantId'];
    applicationId = json['ApplicationId'];
    fileTypeId = json['FileTypeId'];
    fileName = json['FileName'];
    filePath = json['FilePath'];
    filePassword = json['FilePassword'];
    createdOn = json['CreatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FileId'] = fileId;
    data['ApplicantId'] = applicantId;
    data['ApplicationId'] = applicationId;
    data['FileTypeId'] = fileTypeId;
    data['FileName'] = fileName;
    data['FilePath'] = filePath;
    data['FilePassword'] = filePassword;
    data['CreatedOn'] = createdOn;
    return data;
  }
}

class UserInformation {
  int? applicantId;
  String? employeeId;
  String? employeeNo;
  int? employerId;
  String? mobile;
  String? firstName;
  String? lastName;
  String? officialEmailId;
  String? personalEmailId;
  int? totalExperience;
  String? designation;
  String? department;
  String? cityName;
  String? educationLevel;
  String? companyName;
  String? workingSince;
  String? dOB;
  String? genderType;
  String? profilePicture;

  UserInformation(
      {this.applicantId,
      this.employeeId,
      this.employeeNo,
      this.employerId,
      this.mobile,
      this.firstName,
      this.lastName,
      this.officialEmailId,
      this.personalEmailId,
      this.totalExperience,
      this.designation,
      this.department,
      this.cityName,
      this.educationLevel,
      this.companyName,
      this.workingSince,
      this.dOB,
      this.genderType,
      this.profilePicture});

  UserInformation.fromJson(Map<String, dynamic> json) {
    applicantId = json['ApplicantId'];
    employeeId = json['EmployeeId'];
    employeeNo = json['EmployeeNo'];
    employerId = json['EmployerId'];
    mobile = json['Mobile'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    officialEmailId = json['OfficialEmailId'];
    personalEmailId = json['PersonalEmailId'];
    totalExperience = json['TotalExperience'];
    designation = json['Designation'];
    department = json['Department'];
    cityName = json['CityName'];
    educationLevel = json['Education_level'];
    companyName = json['CompanyName'];
    workingSince = json['WorkingSince'];
    dOB = json['DOB'];
    genderType = json['GenderType'];
    profilePicture = json['ProfilePicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ApplicantId'] = applicantId;
    data['EmployeeId'] = employeeId;
    data['EmployeeNo'] = employeeNo;
    data['EmployerId'] = employerId;
    data['Mobile'] = mobile;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['OfficialEmailId'] = officialEmailId;
    data['PersonalEmailId'] = personalEmailId;
    data['TotalExperience'] = totalExperience;
    data['Designation'] = designation;
    data['Department'] = department;
    data['CityName'] = cityName;
    data['Education_level'] = educationLevel;
    data['CompanyName'] = companyName;
    data['WorkingSince'] = workingSince;
    data['DOB'] = dOB;
    data['GenderType'] = genderType;
    data['ProfilePicture'] = profilePicture;
    return data;
  }
}
