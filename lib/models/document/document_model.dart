class DocumentRequestModel {
  int? applicantId;
  String? filePassword;
  String? loanId;
  String? fileName;
  String? fileTypeId;
  String? filePath;

  DocumentRequestModel(this.applicantId, this.filePassword, this.loanId, this.fileName, this.fileTypeId, this.filePath);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['applicantId'] = applicantId;
    data['filePassword'] = filePassword;
    data['loanId'] = loanId;
    data['fileName'] = fileName;
    data['fileTypeId'] = fileTypeId;
    data['filePath'] = filePath;

    return data;
  }
}

class Documents {
  Documents();

  int _fileId = 0;
  int _applicantId = 0;
  int _applicationId = 0;
  int _fileTypeId = 0;
  String _fileName = "";
  String _filePath = "";
  String _filePassword = "";
  String _createdOn = "";

  int get getFileId => _fileId;

  set setFileId(int value) {
    _fileId = value;
  }

  int get getApplicantId => _applicantId;

  set setApplicantId(int value) {
    _applicantId = value;
  }

  int get getApplicationId => _applicationId;

  set setApplicationId(int value) {
    _applicationId = value;
  }

  int get getFileTypeId => _fileTypeId;

  set setFileTypeId(int value) {
    _fileTypeId = value;
  }

  String get getFileName => _fileName;

  set setFileName(String value) {
    _fileName = value;
  }

  String get getFilePath => _filePath;

  set setFilePath(String value) {
    _filePath = value;
  }

  String get getFilePassword => _filePassword;

  set setFilePassword(String value) {
    _filePassword = value;
  }

  String get getCreatedOn => _createdOn;

  set setCreatedOn(String value) {
    _createdOn = value;
  }

  Documents.fromJson(Map<String, dynamic> json) {
    _fileId = json['FileId'];
    _applicantId = json['ApplicantId'];
    _applicationId = json['ApplicationId'];
    _fileTypeId = json['FileTypeId'];
    _fileName = json['FileName'];
    _filePath = json['FilePath'];
    _filePassword = json['FilePassword'];
    _createdOn = json['CreatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FileId'] = _fileId;
    data['ApplicantId'] = _applicantId;
    data['ApplicationId'] = _applicationId;
    data['FileTypeId'] = _fileTypeId;
    data['FileName'] = _fileName;
    data['FilePath'] = _filePath;
    data['FilePassword'] = _filePassword;
    data['CreatedOn'] = _createdOn;
    return data;
  }
}

class LoanDocumentsModel {
  LoanDocumentsModel();

  int _fileId = 0;
  int _fileTypeId = 0;
  String _fileName = "";
  String _filePath = "";
  String _password = "";
  bool _uploaded = false;
  List<Documents> _documents = List.empty();

  int get getFileId => _fileId;

  set setFileId(int value) {
    _fileId = value;
  }

  int get getFileTypeId => _fileTypeId;

  set setFileTypeId(int value) {
    _fileTypeId = value;
  }

  String get getFileName => _fileName;

  set setFileName(String value) {
    _fileName = value;
  }

  String get getFilePath => _filePath;

  set setFilePath(String value) {
    _filePath = value;
  }

  String get getPassword => _password;

  set setPassword(String value) {
    _password = value;
  }

  bool get getUploaded => _uploaded;

  set setUploaded(bool value) {
    _uploaded = value;
  }

  List<Documents> get getDocuments => _documents;

  set setDocuments(List<Documents> value) {
    _documents = value;
  }

  set setDocument(Documents value) {
    _documents.add(value);
  }

  LoanDocumentsModel.fromJson(Map<String, dynamic> json) {
    if (json['Documents'] != null) {
      _documents = <Documents>[];
      json['Documents'].forEach((v) {
        _documents.add(Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Documents'] = _documents.map((v) => v.toJson()).toList();
    return data;
  }


}
