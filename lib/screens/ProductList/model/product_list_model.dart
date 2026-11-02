class ProductListModel {
  ProductListModel({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  ProductListModel.fromJson(dynamic json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ProductList.fromJson(v));
      });
    }
  }
  dynamic status;
  bool? success;
  String? message;
  List<ProductList>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ProductList {
  ProductList({
    this.id,
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
    this.v,
  });

  ProductList.fromJson(dynamic json) {
    id = json['_id'];
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
    v = json['__v'];
  }
  String? id;
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
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['image'] = image;
    map['productName'] = productName;
    map['description'] = description;
    map['price'] = price;
    map['active'] = active;
    map['deleted'] = deleted;
    map['createdBy'] = createdBy;
    map['updatedBy'] = updatedBy;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}
