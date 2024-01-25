class CouponDetailsModel {
  String message = "";
  int status = 0;
  int id = 0;
  int employerId = 0;
  int applicationTypeId = 0;
  String discountCategory = "";
  String discountCoupon = "";
  double discountAmount = 0;
  String description = "";
  String validFrom = "";
  String validTo = "";
  bool isActive = false;
  String createdOn = "";

  CouponDetailsModel(
      {message,
      status,
      id,
      employerId,
      applicationTypeId,
      discountCategory,
      discountCoupon,
      discountAmount,
      description,
      validFrom,
      validTo,
      isActive,
      createdOn});

  CouponDetailsModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    id = json['Id'];
    employerId = json['EmployerId'];
    applicationTypeId = json['ApplicationTypeId'];
    discountCategory = json['DiscountCategory'];
    discountCoupon = json['DiscountCoupon'];
    discountAmount = json['DiscountAmount'];
    description = json['Description'];
    validFrom = json['ValidFrom'];
    validTo = json['ValidTo'];
    isActive = json['IsActive'];
    createdOn = json['CreatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Message'] = message;
    data['Status'] = status;
    data['Id'] = id;
    data['EmployerId'] = employerId;
    data['ApplicationTypeId'] = applicationTypeId;
    data['DiscountCategory'] = discountCategory;
    data['DiscountCoupon'] = discountCoupon;
    data['DiscountAmount'] = discountAmount;
    data['Description'] = description;
    data['ValidFrom'] = validFrom;
    data['ValidTo'] = validTo;
    data['IsActive'] = isActive;
    data['CreatedOn'] = createdOn;
    return data;
  }
}
