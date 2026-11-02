class RegisterModel {
  RegisterModel({
    this.status,
    this.success,
    this.message,
    this.data,
    this.token,
  });

  RegisterModel.fromJson(dynamic json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    token = json['token'];
  }
  dynamic status;
  bool? success;
  String? message;
  Data? data;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['token'] = token;
    return map;
  }
}

class Data {
  Data({
    this.mobileNumber,
    this.allowNotification,
    this.role,
    this.active,
    this.deleted,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Data.fromJson(dynamic json) {
    mobileNumber = json['mobileNumber'];
    allowNotification = json['allowNotification'];
    role = json['role'];
    active = json['active'];
    deleted = json['deleted'];
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? mobileNumber;
  bool? allowNotification;
  String? role;
  bool? active;
  bool? deleted;
  String? id;
  String? createdAt;
  String? updatedAt;
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobileNumber'] = mobileNumber;
    map['allowNotification'] = allowNotification;
    map['role'] = role;
    map['active'] = active;
    map['deleted'] = deleted;
    map['_id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}
