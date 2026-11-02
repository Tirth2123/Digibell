class UpdateAddressModel {
  UpdateAddressModel({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  UpdateAddressModel.fromJson(dynamic json) {
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
    this.house,
    this.landmark,
    this.area,
    this.city,
    this.active,
    this.deleted,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.pinCode,
  });

  Data.fromJson(dynamic json) {
    id = json['_id'];
    house = json['house'];
    landmark = json['landmark'];
    area = json['area'];
    city = json['city'];
    active = json['active'];
    deleted = json['deleted'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    pinCode = json['pinCode'];
  }
  String? id;
  String? house;
  String? landmark;
  String? area;
  String? city;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? pinCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['house'] = house;
    map['landmark'] = landmark;
    map['area'] = area;
    map['city'] = city;
    map['active'] = active;
    map['deleted'] = deleted;
    map['createdBy'] = createdBy;
    map['updatedBy'] = updatedBy;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    map['pinCode'] = pinCode;
    return map;
  }
}
