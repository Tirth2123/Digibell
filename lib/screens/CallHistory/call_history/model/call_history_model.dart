class CallHistoryModel {
  dynamic status;
  bool? success;
  String? error;
  String? message;
  List<CallData>? data;

  CallHistoryModel({this.status, this.success, this.error, this.message, this.data});

  CallHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CallData>[];
      json['data'].forEach((v) {
        data!.add(new CallData.fromJson(v));
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

class CallData {
  String? sId;
  String? receiver;
  String? type;
  String? callerName;
  String? callAction;
  String? channel;
  bool? active;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<RecieverDetails>? recieverDetails;
  List<SenderDetails>? senderDetails;

  CallData(
      {this.sId,
      this.receiver,
      this.type,
      this.callerName,
      this.callAction,
      this.channel,
      this.active,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.recieverDetails,
      this.senderDetails});

  CallData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    receiver = json['receiver'];
    type = json['type'];
    callerName = json['callerName'];
    callAction = json['callAction'];
    channel = json['channel'];
    active = json['active'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['recieverDetails'] != null) {
      recieverDetails = <RecieverDetails>[];
      json['recieverDetails'].forEach((v) {
        recieverDetails!.add(new RecieverDetails.fromJson(v));
      });
    }
    if (json['senderDetails'] != null) {
      senderDetails = <SenderDetails>[];
      json['senderDetails'].forEach((v) {
        senderDetails!.add(new SenderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['receiver'] = this.receiver;
    data['type'] = this.type;
    data['callerName'] = this.callerName;
    data['callAction'] = this.callAction;
    data['channel'] = this.channel;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.recieverDetails != null) {
      data['recieverDetails'] = this.recieverDetails!.map((v) => v.toJson()).toList();
    }
    if (this.senderDetails != null) {
      data['senderDetails'] = this.senderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecieverDetails {
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

  RecieverDetails(
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
      this.name});

  RecieverDetails.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class SenderDetails {
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

  SenderDetails(
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
      this.name});

  SenderDetails.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
