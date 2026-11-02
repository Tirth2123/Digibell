class PaymentModel {
  dynamic status;
  String? error;
  bool? success;
  String? message;
  Data? data;

  PaymentModel({this.status, this.error, this.success, this.message, this.data});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.error;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? paymentStatus;
  String? transectionId;
  String? razorpayPaymentId;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.paymentStatus,
      this.transectionId,
      this.razorpayPaymentId,
      this.active,
      this.deleted,
      this.createdBy,
      this.updatedBy,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    paymentStatus = json['paymentStatus'];
    transectionId = json['transectionId'];
    razorpayPaymentId = json['razorpay_payment_id'];

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
    data['paymentStatus'] = this.paymentStatus;
    data['transectionId'] = this.transectionId;
    data['razorpay_payment_id'] = this.razorpayPaymentId;

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
