class GuestUserModel {
  dynamic status;
  bool? success;
  String? message;
  Data? data;
  String? token;

  GuestUserModel({this.status, this.success, this.message, this.data, this.token});

  GuestUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class Data {
  String? name;
  String? mobileNumber;
  bool? allowNotification;
  String? role;
  bool? isSocialLogin;
  bool? isInCall;
  bool? active;
  bool? deleted;
  bool? withoutLogin;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.name,
      this.mobileNumber,
      this.allowNotification,
      this.role,
      this.isSocialLogin,
      this.isInCall,
      this.active,
      this.deleted,
      this.withoutLogin,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobileNumber = json['mobileNumber'];
    allowNotification = json['allowNotification'];
    role = json['role'];
    isSocialLogin = json['isSocialLogin'];
    isInCall = json['isInCall'];
    active = json['active'];
    deleted = json['deleted'];
    withoutLogin = json['withoutLogin'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobileNumber'] = this.mobileNumber;
    data['allowNotification'] = this.allowNotification;
    data['role'] = this.role;
    data['isSocialLogin'] = this.isSocialLogin;
    data['isInCall'] = this.isInCall;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['withoutLogin'] = this.withoutLogin;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
