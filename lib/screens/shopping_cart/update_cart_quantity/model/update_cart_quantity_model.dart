class UpdateCartQuantityModel {
  dynamic status;
  bool? success;
  String? error;
  String? message;
  Data? data;

  UpdateCartQuantityModel({this.status, this.success, this.error, this.message, this.data});

  UpdateCartQuantityModel.fromJson(Map<String, dynamic> json) {
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
  String? productId;
  int? quantity;
  int? pricePerItem;
  int? totalPrice;
  bool? isPurchased;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.productId,
      this.quantity,
      this.pricePerItem,
      this.totalPrice,
      this.isPurchased,
      this.active,
      this.deleted,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productId = json['productId'];
    quantity = json['quantity'];
    pricePerItem = json['pricePerItem'];
    totalPrice = json['totalPrice'];
    isPurchased = json['isPurchased'];
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
    data['productId'] = this.productId;
    data['quantity'] = this.quantity;
    data['pricePerItem'] = this.pricePerItem;
    data['totalPrice'] = this.totalPrice;
    data['isPurchased'] = this.isPurchased;
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
