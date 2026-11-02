class GetVouchersModel {
  dynamic status;
  bool? success;
  String? message;
  String? error;
  List<Data>? data;

  GetVouchersModel({this.status, this.success, this.message, this.error, this.data});

  GetVouchersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    error = json['error'];
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
    data['message'] = this.message;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? voucherCode;
  String? expiryDate;
  int? discount;
  bool? forAllUser;
  List<String>? users;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.voucherCode,
      this.expiryDate,
      this.discount,
      this.forAllUser,
      this.users,
      this.active,
      this.deleted,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    voucherCode = json['voucherCode'];
    expiryDate = json['expiryDate'];
    discount = json['discount'];
    forAllUser = json['forAllUser'];
    users = json['users'].cast<String>();
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
    data['voucherCode'] = this.voucherCode;
    data['expiryDate'] = this.expiryDate;
    data['discount'] = this.discount;
    data['forAllUser'] = this.forAllUser;
    data['users'] = this.users;
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
