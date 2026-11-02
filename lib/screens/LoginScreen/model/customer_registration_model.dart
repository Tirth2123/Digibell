class CustomerRegisterationModel {
  bool? success;
  String? accessToken;
  String? tokenType;
  String? message;
  Error? error;
  int? expiresIn;
  Customer? customer;
  Device? device;
  int? statusCode;

  CustomerRegisterationModel(
      {this.success,
        this.message,
        this.error,
        this.accessToken,
        this.tokenType,
        this.expiresIn,
        this.customer,
        this.device,
        this.statusCode});

  CustomerRegisterationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    accessToken = json['access_token'];
    message = json['message'];
    error = json['error'] != null ? new Error.fromJson(json['error']) : null;
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    customer =
    json['customer'] != null ? new Customer.fromJson(json['customer']) : null;
    device =
    json['device'] != null ? new Device.fromJson(json['device']) : null;
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['error'] = this.error;
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    if (this.error != null) {
      data['error'] = this.error!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.device != null) {
      data['device'] = this.device!.toJson();
    }
    data['status_code'] = this.statusCode;
    return data;
  }
}

class Error {
  List<dynamic>? email;
  List<dynamic>? phone;

  Error({ this.email,  this.phone});

  Error.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}

class Customer {
  String? fullName;
  String? email;
  int? deletedAt;
  String? phoneNumber;
  String? updatedAt;
  String? createdAt;
  String? profile;
  int? id;

  Customer(
      {this.fullName,
      this.deletedAt,
        this.email,
        this.phoneNumber,
        this.updatedAt,
        this.createdAt,
        this.profile,
        this.id});

  Customer.fromJson(Map<String, dynamic> json) {
    deletedAt = json['deleted_at'];
    profile = json['profile'];
    fullName = json['full_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['profile'] = this.profile;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

class Device {
  int? id;
  int? customerId;
  String? deviceId;
  String? fcmToken;
  String? voipToken;
  String? deviceCompany;
  String? deviceName;
  String? os;
  String? appVersion;
  String? osVersion;
  String? createdAt;
  String? updatedAt;

  Device(
      {this.id,
        this.customerId,
        this.deviceId,
        this.fcmToken,
        this.voipToken,
        this.deviceCompany,
        this.deviceName,
        this.os,
        this.appVersion,
        this.osVersion,
        this.createdAt,
        this.updatedAt});

  Device.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    deviceId = json['device_id'];
    fcmToken = json['fcm_token'];
    voipToken = json['voip_token'];
    deviceCompany = json['device_company'];
    deviceName = json['device_name'];
    os = json['os'];
    appVersion = json['app_version'];
    osVersion = json['os_version'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['device_id'] = this.deviceId;
    data['fcm_token'] = this.fcmToken;
    data['voip_token'] = this.voipToken;
    data['device_company'] = this.deviceCompany;
    data['device_name'] = this.deviceName;
    data['os'] = this.os;
    data['app_version'] = this.appVersion;
    data['os_version'] = this.osVersion;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }}