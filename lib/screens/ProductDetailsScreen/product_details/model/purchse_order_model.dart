class PurchseOrderModel {
  PurchseOrderModel({
    this.status,
    this.success,
    this.data,
  });

  PurchseOrderModel.fromJson(dynamic json) {
    status = json['status'];
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  dynamic status;
  String? success;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['success'] = success;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    this.productId,
    this.totalQuantity,
    this.totalPrice,
    this.deliveryAddress,
    this.isOrderConfirmed,
    this.isOrderReject,
    this.deliveryStatus,
    this.deliveryDate,
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
    productId = json['productId'];
    totalQuantity = json['totalQuantity'];
    totalPrice = json['totalPrice'];
    deliveryAddress = json['deliveryAddress'];
    isOrderConfirmed = json['isOrderConfirmed'];
    isOrderReject = json['isOrderReject'];
    deliveryStatus = json['deliveryStatus'];
    deliveryDate = json['deliveryDate'];
    active = json['active'];
    deleted = json['deleted'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? productId;
  int? totalQuantity;
  int? totalPrice;
  String? deliveryAddress;
  bool? isOrderConfirmed;
  bool? isOrderReject;
  String? deliveryStatus;
  String? deliveryDate;
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
    map['productId'] = productId;
    map['totalQuantity'] = totalQuantity;
    map['totalPrice'] = totalPrice;
    map['deliveryAddress'] = deliveryAddress;
    map['isOrderConfirmed'] = isOrderConfirmed;
    map['isOrderReject'] = isOrderReject;
    map['deliveryStatus'] = deliveryStatus;
    map['deliveryDate'] = deliveryDate;
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
