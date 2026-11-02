class SendOtp {
  SendOtp({
      this.status, 
      this.success, 
      this.message, 
      this.data,});

  SendOtp.fromJson(dynamic json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? status;
  bool? success;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.otp, 
      this.mobileNumber, 
      this.expiresAt, 
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  Data.fromJson(dynamic json) {
    otp = json['otp'];
    mobileNumber = json['mobileNumber'];
    expiresAt = json['expiresAt'];
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  int? otp;
  String? mobileNumber;
  String? expiresAt;
  String? id;
  String? createdAt;
  String? updatedAt;
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otp'] = otp;
    map['mobileNumber'] = mobileNumber;
    map['expiresAt'] = expiresAt;
    map['_id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}