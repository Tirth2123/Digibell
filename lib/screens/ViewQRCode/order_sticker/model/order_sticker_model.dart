class OrderStickerModel {
  dynamic status;
  bool? success;
  String? error;
  String? message;
  Data? data;

  OrderStickerModel({this.status, this.success, this.error, this.message, this.data});

  OrderStickerModel.fromJson(Map<String, dynamic> json) {
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
  List<String>? cartIds;
  List<String>? productIds;
  int? totalQuantity;
  String? qrId;
  int? totalPrice;
  String? expectedDeliveryDate;
  String? deliveryAddress;
  bool? isOrderConfirmed;
  bool? isOrderReject;
  String? deliveryStatus;
  bool? isVoucherCodeApplied;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.cartIds,
      this.productIds,
      this.totalQuantity,
      this.qrId,
      this.totalPrice,
      this.expectedDeliveryDate,
      this.isVoucherCodeApplied,
      this.deliveryAddress,
      this.isOrderConfirmed,
      this.isOrderReject,
      this.deliveryStatus,
      this.active,
      this.deleted,
      this.createdBy,
      this.updatedBy,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    cartIds = json['cartIds'].cast<String>();
    productIds = json['productIds'].cast<String>();
    totalQuantity = json['totalQuantity'];
    qrId = json['qrId'];
    totalPrice = json['totalPrice'];
    isVoucherCodeApplied = json['isVoucherCodeApplied'];
    expectedDeliveryDate = json['expectedDeliveryDate'];
    deliveryAddress = json['deliveryAddress'];
    isOrderConfirmed = json['isOrderConfirmed'];
    isOrderReject = json['isOrderReject'];
    deliveryStatus = json['deliveryStatus'];
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
    data['cartIds'] = this.cartIds;
    data['productIds'] = this.productIds;
    data['totalQuantity'] = this.totalQuantity;
    data['qrId'] = this.qrId;
    data['totalPrice'] = this.totalPrice;
    data['expectedDeliveryDate'] = this.expectedDeliveryDate;
    data['deliveryAddress'] = this.deliveryAddress;
    data['isOrderConfirmed'] = this.isOrderConfirmed;
    data['isOrderReject'] = this.isOrderReject;
    data['deliveryStatus'] = this.deliveryStatus;
    data['isVoucherCodeApplied'] = this.isVoucherCodeApplied;
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
