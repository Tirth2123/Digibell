class GetAllAddressModel {
  dynamic status;
  bool? success;
  String? error;
  String? message;
  List<Data>? data;

  GetAllAddressModel({this.status, this.success, this.error, this.message, this.data});

  GetAllAddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? sId;
  String? house;
  String? landmark;
  String? area;
  String? city;
  String? pinCode;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isDefaultAddress;

  Data(
      {this.sId,
      this.house,
      this.landmark,
      this.area,
      this.city,
      this.pinCode,
      this.active,
      this.deleted,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.isDefaultAddress});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    house = json['house'];
    landmark = json['landmark'];
    area = json['area'];
    city = json['city'];
    pinCode = json['pinCode'];
    active = json['active'];
    deleted = json['deleted'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isDefaultAddress = json['isDefaultAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['house'] = this.house;
    data['landmark'] = this.landmark;
    data['area'] = this.area;
    data['city'] = this.city;
    data['pinCode'] = this.pinCode;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['isDefaultAddress'] = this.isDefaultAddress;
    return data;
  }
}
