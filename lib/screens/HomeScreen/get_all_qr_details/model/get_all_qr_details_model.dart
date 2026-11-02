class GetAllQRDetailsModel {
  dynamic status;
  bool? success;
  String? error;
  String? message;
  List<GetAllQRList>? data;

  GetAllQRDetailsModel({this.status, this.success, this.error, this.message, this.data});

  GetAllQRDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetAllQRList>[];
      json['data'].forEach((v) {
        data!.add(new GetAllQRList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetAllQRList {
  String? sId;
  String? type;
  String? name;
  int? contactNumber;
  List<String>? members;
  String? address;
  String? state;
  String? city;
  String? pincode;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? validUpto;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? qrImage;
  String? uniqueIdentifier;
  UserDetails? userDetails;
  String? carNumber;
  String? otherDetails;
  String? hotelName;
  int? hotelContactNumber;
  int? remainingDay;
  String? subscriptionId;
  SubscriptionDetails? subscriptionDetails;

  GetAllQRList(
      {this.sId,
      this.type,
      this.name,
      this.contactNumber,
      this.members,
      this.address,
      this.state,
      this.city,
      this.pincode,
      this.active,
      this.deleted,
      this.createdBy,
      this.updatedBy,
      this.validUpto,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.qrImage,
      this.uniqueIdentifier,
      this.userDetails,
      this.carNumber,
      this.otherDetails,
      this.hotelName,
      this.hotelContactNumber,
      this.subscriptionId,
      this.subscriptionDetails,
        this.remainingDay
      });

  GetAllQRList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    name = json['name'];
    contactNumber = json['contactNumber'];
    members = json['members'].cast<String>();
    address = json['address'];
    state = json['state'];
    city = json['city'];
    pincode = json['pincode'];
    active = json['active'];
    deleted = json['deleted'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    validUpto = json['validUpto'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    qrImage = json['qrImage'];
    uniqueIdentifier = json['uniqueIdentifier'];
    userDetails = json['userDetails'] != null ? new UserDetails.fromJson(json['userDetails']) : null;
    carNumber = json['carNumber'];
    otherDetails = json['otherDetails'];
    hotelName = json['hotelName'];
    hotelContactNumber = json['hotelContactNumber'];
    subscriptionId = json['subscriptionId'];
    remainingDay = json['remainingDay'];
    subscriptionDetails = json['subscriptionDetails'] != null ? new SubscriptionDetails.fromJson(json['subscriptionDetails']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['name'] = this.name;
    data['contactNumber'] = this.contactNumber;
    data['members'] = this.members;
    data['address'] = this.address;
    data['state'] = this.state;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['validUpto'] = this.validUpto;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['qrImage'] = this.qrImage;
    data['uniqueIdentifier'] = this.uniqueIdentifier;
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    data['carNumber'] = this.carNumber;
    data['otherDetails'] = this.otherDetails;
    data['hotelName'] = this.hotelName;
    data['hotelContactNumber'] = this.hotelContactNumber;
    data['subscriptionId'] = this.subscriptionId;
    data['remainingDay'] = this.remainingDay;
    if (this.subscriptionDetails != null) {
      data['subscriptionDetails'] = this.subscriptionDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  String? sId;
  String? mobileNumber;
  bool? allowNotification;
  String? role;
  bool? isSocialLogin;
  bool? active;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? address;
  String? dob;
  String? email;
  String? name;

  UserDetails(
      {this.sId,
      this.mobileNumber,
      this.allowNotification,
      this.role,
      this.isSocialLogin,
      this.active,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.address,
      this.dob,
      this.email,
      this.name});

  UserDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobileNumber = json['mobileNumber'];
    allowNotification = json['allowNotification'];
    role = json['role'];
    isSocialLogin = json['isSocialLogin'];
    active = json['active'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    address = json['address'];
    dob = json['dob'];
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['mobileNumber'] = this.mobileNumber;
    data['allowNotification'] = this.allowNotification;
    data['role'] = this.role;
    data['isSocialLogin'] = this.isSocialLogin;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['address'] = this.address;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['name'] = this.name;
    return data;
  }
}

class SubscriptionDetails {
  String? sId;
  String? name;
  String? type;
  int? price;
  int? members;
  bool? unlimitedCall;
  bool? twoWayAudioVideoCall;
  bool? qrScanAlert;
  bool? visitorHistory;
  bool? visitorPhotoCapture;
  bool? smartMonthMisReport;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SubscriptionDetails(
      {this.sId,
      this.name,
      this.type,
      this.price,
      this.members,
      this.unlimitedCall,
      this.twoWayAudioVideoCall,
      this.qrScanAlert,
      this.visitorHistory,
      this.visitorPhotoCapture,
      this.smartMonthMisReport,
      this.active,
      this.deleted,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.iV});

  SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    type = json['type'];
    price = json['price'];
    members = json['members'];
    unlimitedCall = json['unlimitedCall'];
    twoWayAudioVideoCall = json['twoWayAudioVideoCall'];
    qrScanAlert = json['qrScanAlert'];
    visitorHistory = json['visitorHistory'];
    visitorPhotoCapture = json['visitorPhotoCapture'];
    smartMonthMisReport = json['smartMonthMisReport'];
    active = json['active'];
    deleted = json['deleted'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['price'] = this.price;
    data['members'] = this.members;
    data['unlimitedCall'] = this.unlimitedCall;
    data['twoWayAudioVideoCall'] = this.twoWayAudioVideoCall;
    data['qrScanAlert'] = this.qrScanAlert;
    data['visitorHistory'] = this.visitorHistory;
    data['visitorPhotoCapture'] = this.visitorPhotoCapture;
    data['smartMonthMisReport'] = this.smartMonthMisReport;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
