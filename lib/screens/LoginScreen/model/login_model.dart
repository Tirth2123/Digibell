class LoginModel {
  dynamic status;
  bool? success;
  String? message;
  Data? data;
  String? token;

  LoginModel({this.status, this.success, this.message, this.data, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? mobileNumber;
  String? role;
  bool? active;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? address;
  String? dob;
  String? email;
  String? name;
  bool? allowNotification;
  String? userImage;
  String? createdBy;
  String? updatedBy;

  Data(
      {this.sId,
      this.mobileNumber,
      this.role,
      this.active,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.address,
      this.dob,
      this.email,
      this.name,
      this.allowNotification,
      this.userImage,
      this.createdBy,
      this.updatedBy});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobileNumber = json['mobileNumber'];
    role = json['role'];
    active = json['active'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    address = json['address'];
    dob = json['dob'];
    email = json['email'];
    name = json['name'];
    allowNotification = json['allowNotification'];
    userImage = json['userImage'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['mobileNumber'] = this.mobileNumber;
    data['role'] = this.role;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['address'] = this.address;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['name'] = this.name;
    data['allowNotification'] = this.allowNotification;
    data['userImage'] = this.userImage;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    return data;
  }
}
