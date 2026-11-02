class GetMyOrderModel {
  dynamic status;
  bool? success;
  String? error;
  String? message;
  List<Data>? data;

  GetMyOrderModel({this.status, this.success, this.error, this.message, this.data});

  GetMyOrderModel.fromJson(Map<String, dynamic> json) {
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
  List<String>? cartIds;
  List<String>? productIds;
  int? totalQuantity;
  int? totalPrice;
  dynamic finalPrice;
  String? expectedDeliveryDate;
  String? deliveryAddress;
  bool? isOrderConfirmed;
  bool? isOrderReject;
  String? deliveryStatus;
  bool? isVoucherCodeApplied;
  String? voucherCode;
  int? discount;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<ProductDetails>? productDetails;
  List<CartDetails>? cartDetails;
  List<QrDetails>? qrDetails;
  String? qrId;
  String? deliveryDate;

  Data(
      {this.sId,
      this.cartIds,
      this.productIds,
      this.totalQuantity,
      this.totalPrice,
      this.finalPrice,
      this.expectedDeliveryDate,
      this.deliveryAddress,
      this.isOrderConfirmed,
      this.deliveryDate,
      this.isOrderReject,
      this.deliveryStatus,
      this.isVoucherCodeApplied,
      this.voucherCode,
      this.discount,
      this.active,
      this.deleted,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.productDetails,
      this.cartDetails,
      this.qrDetails,
      this.qrId});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    cartIds = json['cartIds'].cast<String>();
    productIds = json['productIds'].cast<String>();
    totalQuantity = json['totalQuantity'];
    totalPrice = json['totalPrice'];
    finalPrice = json['finalPrice'];
    expectedDeliveryDate = json['expectedDeliveryDate'];
    deliveryAddress = json['deliveryAddress'];
    isOrderConfirmed = json['isOrderConfirmed'];
    isOrderReject = json['isOrderReject'];
    deliveryStatus = json['deliveryStatus'];
    isVoucherCodeApplied = json['isVoucherCodeApplied'];
    voucherCode = json['voucherCode'];
    discount = json['discount'];
    active = json['active'];
    deleted = json['deleted'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deliveryDate = json['deliveryDate'];
    iV = json['__v'];
    if (json['productDetails'] != null) {
      productDetails = <ProductDetails>[];
      json['productDetails'].forEach((v) {
        productDetails!.add(new ProductDetails.fromJson(v));
      });
    }
    if (json['cartDetails'] != null) {
      cartDetails = <CartDetails>[];
      json['cartDetails'].forEach((v) {
        cartDetails!.add(new CartDetails.fromJson(v));
      });
    }
    if (json['qrDetails'] != null) {
      qrDetails = <QrDetails>[];
      json['qrDetails'].forEach((v) {
        qrDetails!.add(new QrDetails.fromJson(v));
      });
    }
    qrId = json['qrId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['cartIds'] = this.cartIds;
    data['productIds'] = this.productIds;
    data['totalQuantity'] = this.totalQuantity;
    data['totalPrice'] = this.totalPrice;
    data['finalPrice'] = this.finalPrice;
    data['expectedDeliveryDate'] = this.expectedDeliveryDate;
    data['deliveryAddress'] = this.deliveryAddress;
    data['isOrderConfirmed'] = this.isOrderConfirmed;
    data['isOrderReject'] = this.isOrderReject;
    data['deliveryStatus'] = this.deliveryStatus;
    data['isVoucherCodeApplied'] = this.isVoucherCodeApplied;
    data['voucherCode'] = this.voucherCode;
    data['discount'] = this.discount;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['deliveryDate'] = this.deliveryDate;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.productDetails != null) {
      data['productDetails'] = this.productDetails!.map((v) => v.toJson()).toList();
    }
    if (this.cartDetails != null) {
      data['cartDetails'] = this.cartDetails!.map((v) => v.toJson()).toList();
    }
    if (this.qrDetails != null) {
      data['qrDetails'] = this.qrDetails!.map((v) => v.toJson()).toList();
    }
    data['qrId'] = this.qrId;
    return data;
  }
}

class ProductDetails {
  String? sId;
  String? image;
  String? productName;
  String? description;
  int? price;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ProductDetails(
      {this.sId,
      this.image,
      this.productName,
      this.description,
      this.price,
      this.active,
      this.deleted,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    productName = json['productName'];
    description = json['description'];
    price = json['price'];
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
    data['image'] = this.image;
    data['productName'] = this.productName;
    data['description'] = this.description;
    data['price'] = this.price;
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

class CartDetails {
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

  CartDetails(
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

  CartDetails.fromJson(Map<String, dynamic> json) {
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

class QrDetails {
  String? sId;
  String? type;
  String? name;
  String? hotelName;
  int? hotelContactNumber;
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

  QrDetails(
      {this.sId,
      this.type,
      this.name,
      this.hotelName,
      this.hotelContactNumber,
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

  QrDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    name = json['name'];
    hotelName = json['hotelName'];
    hotelContactNumber = json['hotelContactNumber'];
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
    data['hotelName'] = this.hotelName;
    data['hotelContactNumber'] = this.hotelContactNumber;
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
