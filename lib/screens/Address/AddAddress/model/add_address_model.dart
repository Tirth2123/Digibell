class AddAddressModel {
  AddAddressModel({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  AddAddressModel.fromJson(dynamic json) {
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
    this.house,
    this.landmark,
    this.area,
    this.city,
    this.pinCode,
    this.active,
    this.deleted,
    this.createdBy,
    this.updatedBy,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Data.fromJson(dynamic json) {
    house = json['house'];
    landmark = json['landmark'];
    area = json['area'];
    city = json['city'];
    pinCode = json['pinCode'];
    active = json['active'];
    deleted = json['deleted'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? house;
  String? landmark;
  String? area;
  String? city;
  String? pinCode;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? id;
  String? createdAt;
  String? updatedAt;
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['house'] = house;
    map['landmark'] = landmark;
    map['area'] = area;
    map['city'] = city;
    map['pinCode'] = pinCode;
    map['active'] = active;
    map['deleted'] = deleted;
    map['createdBy'] = createdBy;
    map['updatedBy'] = updatedBy;
    map['_id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}
