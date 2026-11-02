class AddQRDetailsModel {
  dynamic status;
  bool? success;
  String? error;
  String? message;
  QRDetails? data;

  AddQRDetailsModel({this.status, this.success, this.error, this.message, this.data});

  AddQRDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? new QRDetails.fromJson(json['data']) : null;
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

class QRDetails {
  String? type;
  String? name;
  List<Members>? members;
  String? address;
  String? state;
  String? city;
  String? pincode;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  QRDetails(
      {this.type,
      this.name,
      this.members,
      this.address,
      this.state,
      this.city,
      this.pincode,
      this.active,
      this.deleted,
      this.createdBy,
      this.updatedBy,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  QRDetails.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    }
    address = json['address'];
    state = json['state'];
    city = json['city'];
    pincode = json['pincode'];
    active = json['active'];
    deleted = json['deleted'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    data['address'] = this.address;
    data['state'] = this.state;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Members {
  String? userName;
  String? id;

  Members({this.userName, this.id});

  Members.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['id'] = this.id;
    return data;
  }
}
