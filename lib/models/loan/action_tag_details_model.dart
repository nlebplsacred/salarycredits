class ActionTagDetails {
  int tagId = 0;
  String tagName = "";
  int paidEMICount = 0;
  int currentStatusId = 0;
  String reApplyDate = "";
  int actionId = 0;
  int applicationId = 0;
  int userTypeId = 0;
  int statusId = 0;
  String statusName = "";
  String remarks = "";
  int actionById = 0;
  String actionOn = "";
  bool isActive = false;

  ActionTagDetails(
      {tagId,
      tagName,
      paidEMICount,
      currentStatusId,
      reApplyDate,
      actionId,
      applicationId,
      userTypeId,
      statusId,
      statusName,
      remarks,
      actionById,
      actionOn,
      isActive});

  ActionTagDetails.fromJson(Map<String, dynamic> json) {
    tagId = json['TagId'];
    tagName = json['TagName'];
    paidEMICount = json['PaidEMICount'];
    currentStatusId = json['CurrentStatusId'];
    reApplyDate = json['ReApplyDate'];
    actionId = json['ActionId'];
    applicationId = json['ApplicationId'];
    userTypeId = json['UserTypeId'];
    statusId = json['StatusId'];
    statusName = json['StatusName'];
    remarks = json['Remarks'];
    actionById = json['ActionById'];
    actionOn = json['ActionOn'];
    isActive = json['IsActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TagId'] = tagId;
    data['TagName'] = tagName;
    data['PaidEMICount'] = paidEMICount;
    data['CurrentStatusId'] = currentStatusId;
    data['ReApplyDate'] = reApplyDate;
    data['ActionId'] = actionId;
    data['ApplicationId'] = applicationId;
    data['UserTypeId'] = userTypeId;
    data['StatusId'] = statusId;
    data['StatusName'] = statusName;
    data['Remarks'] = remarks;
    data['ActionById'] = actionById;
    data['ActionOn'] = actionOn;
    data['IsActive'] = isActive;
    return data;
  }
}
