class GetNotificationsModel {
  dynamic status;
  bool? success;
  String? message;
  String? error;
  List<Data>? data;
  int? notificationCount;


  GetNotificationsModel({this.status, this.success, this.message, this.error, this.data, this.notificationCount});

  GetNotificationsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    error = json['error'];
    notificationCount = json['notificationCount'];
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
    data['message'] = this.message;
    data['error'] = this.error;
    data['notificationCount'] = this.notificationCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? title;
  String? message;
  String? memberId;
  bool? isRead;
  String? user;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;
  MemberDetails? memberDetails;
  SenderDetails? senderDetails;
  ReceiverDetails? receiverDetails;

  Data(
      {this.sId,
      this.title,
      this.message,
      this.memberId,
      this.isRead,
      this.user,
      this.active,
      this.deleted,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.memberDetails,
      this.senderDetails,
      this.receiverDetails});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    message = json['message'];
    memberId = json['memberId'];
    isRead = json['isRead'];
    user = json['user'];
    active = json['active'];
    deleted = json['deleted'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    memberDetails = json['memberDetails'] != null ? new MemberDetails.fromJson(json['memberDetails']) : null;
    senderDetails = json['senderDetails'] != null ? new SenderDetails.fromJson(json['senderDetails']) : null;
    receiverDetails = json['receiverDetails'] != null ? new ReceiverDetails.fromJson(json['receiverDetails']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['message'] = this.message;
    data['memberId'] = this.memberId;
    data['isRead'] = this.isRead;
    data['user'] = this.user;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.memberDetails != null) {
      data['memberDetails'] = this.memberDetails!.toJson();
    }
    if (this.senderDetails != null) {
      data['senderDetails'] = this.senderDetails!.toJson();
    }
    if (this.receiverDetails != null) {
      data['receiverDetails'] = this.receiverDetails!.toJson();
    }
    return data;
  }
}

class MemberDetails {
  String? sId;
  String? userId;
  bool? isAcceptInvitation;
  bool? isRejectInvitation;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MemberDetails(
      {this.sId,
      this.userId,
      this.isAcceptInvitation,
      this.isRejectInvitation,
      this.active,
      this.deleted,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.iV});

  MemberDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    isAcceptInvitation = json['isAcceptInvitation'];
    isRejectInvitation = json['isRejectInvitation'];
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
    data['userId'] = this.userId;
    data['isAcceptInvitation'] = this.isAcceptInvitation;
    data['isRejectInvitation'] = this.isRejectInvitation;
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
  String? createdBy;
  String? updatedBy;
  String? referralCode;
  String? userImage;

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
      this.name,
      this.createdBy,
      this.updatedBy,
      this.referralCode,
      this.userImage});

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
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    referralCode = json['referralCode'];
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
    data['referralCode'] = this.referralCode;
    data['userImage'] = this.userImage;
    return data;
  }
}

class ReceiverDetails {
  String? sId;
  String? mobileNumber;
  String? role;
  bool? active;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? address;
  String? dob;
  String? email;
  String? name;
  bool? allowNotification;
  String? userImage;
  String? createdBy;
  String? updatedBy;
  bool? isSocialLogin;

  ReceiverDetails(
      {this.sId,
      this.mobileNumber,
      this.role,
      this.active,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.address,
      this.dob,
      this.email,
      this.name,
      this.allowNotification,
      this.userImage,
      this.createdBy,
      this.updatedBy,
      this.isSocialLogin});

  ReceiverDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobileNumber = json['mobileNumber'];
    role = json['role'];
    active = json['active'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    address = json['address'];
    dob = json['dob'];
    email = json['email'];
    name = json['name'];
    allowNotification = json['allowNotification'];
    userImage = json['userImage'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    isSocialLogin = json['isSocialLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['mobileNumber'] = this.mobileNumber;
    data['role'] = this.role;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['address'] = this.address;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['name'] = this.name;
    data['allowNotification'] = this.allowNotification;
    data['userImage'] = this.userImage;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['isSocialLogin'] = this.isSocialLogin;
    return data;
  }
}
