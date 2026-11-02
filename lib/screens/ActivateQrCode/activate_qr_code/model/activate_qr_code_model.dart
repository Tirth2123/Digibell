class ActivateQRCodeModel {
  dynamic status;
  bool? success;
  String? error;
  String? message;
  Data? data;

  ActivateQRCodeModel({this.status, this.success, this.error, this.message, this.data});

  ActivateQRCodeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
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

  Data(
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
      this.uniqueIdentifier});

  Data.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
