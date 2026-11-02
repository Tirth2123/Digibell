class GetCartItemsModel {
  dynamic status;
  String? error;
  bool? success;
  String? message;
  List<Data>? data;

  GetCartItemsModel({this.status, this.error, this.success, this.message, this.data});

  GetCartItemsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    success = json['success'];
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
    data['error'] = this.error;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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
  ProductDetails? productDetails;
  UserDetails? userDetails;

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
      this.iV,
      this.productDetails,
      this.userDetails});

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
    productDetails = json['productDetails'] != null ? new ProductDetails.fromJson(json['productDetails']) : null;
    userDetails = json['userDetails'] != null ? new UserDetails.fromJson(json['userDetails']) : null;
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
    if (this.productDetails != null) {
      data['productDetails'] = this.productDetails!.toJson();
    }
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
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

class UserDetails {
  String? sId;
  String? mobileNumber;
  bool? allowNotification;
  String? role;
  bool? isSocialLogin;
  bool? active;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? address;
  String? dob;
  String? email;
  String? name;
  String? createdBy;
  String? updatedBy;
  String? userImage;

  UserDetails(
      {this.sId,
      this.mobileNumber,
      this.allowNotification,
      this.role,
      this.isSocialLogin,
      this.active,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.address,
      this.dob,
      this.email,
      this.name,
      this.createdBy,
      this.updatedBy,
      this.userImage});

  UserDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobileNumber = json['mobileNumber'];
    allowNotification = json['allowNotification'];
    role = json['role'];
    isSocialLogin = json['isSocialLogin'];
    active = json['active'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    address = json['address'];
    dob = json['dob'];
    email = json['email'];
    name = json['name'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    userImage = json['userImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['mobileNumber'] = this.mobileNumber;
    data['allowNotification'] = this.allowNotification;
    data['role'] = this.role;
    data['isSocialLogin'] = this.isSocialLogin;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['address'] = this.address;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['name'] = this.name;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['userImage'] = this.userImage;
    return data;
  }
}
