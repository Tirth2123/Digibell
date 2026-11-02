class UserDetailsModel {
  UserDetailsModel({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  UserDetailsModel.fromJson(dynamic json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  dynamic status;
  bool? success;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    this.id,
    this.mobileNumber,
    this.role,
    this.active,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.address,
    this.dob,
    this.email,
    this.name,
    this.allowNotification,
    this.userImage,
    this.createdBy,
    this.updatedBy,
  });

  Data.fromJson(dynamic json) {
    id = json['_id'];
    mobileNumber = json['mobileNumber'];
    role = json['role'];
    active = json['active'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    address = json['address'];
    dob = json['dob'];
    email = json['email'];
    name = json['name'];
    allowNotification = json['allowNotification'];
    userImage = json['userImage'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
  }
  String? id;
  String? mobileNumber;
  String? role;
  bool? active;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? address;
  String? dob;
  String? email;
  String? name;
  bool? allowNotification;
  String? userImage;
  String? createdBy;
  String? updatedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['mobileNumber'] = mobileNumber;
    map['role'] = role;
    map['active'] = active;
    map['deleted'] = deleted;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    map['address'] = address;
    map['dob'] = dob;
    map['email'] = email;
    map['name'] = name;
    map['allowNotification'] = allowNotification;
    map['userImage'] = userImage;
    map['createdBy'] = createdBy;
    map['updatedBy'] = updatedBy;
    return map;
  }
}
