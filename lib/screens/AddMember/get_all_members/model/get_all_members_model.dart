class GetAllMembersModel {
  dynamic status;
  bool? success;
  String? error;
  String? message;
  List<Data>? data;

  GetAllMembersModel({this.status, this.success, this.error, this.message, this.data});

  GetAllMembersModel.fromJson(Map<String, dynamic> json) {
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
  MemberDetails? memberDetails;
  MemberDetails? userDetails;

  Data(
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
      this.iV,
      this.memberDetails,
      this.userDetails});

  Data.fromJson(Map<String, dynamic> json) {
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
    memberDetails = json['memberDetails'] != null ? new MemberDetails.fromJson(json['memberDetails']) : null;
    userDetails = json['userDetails'] != null ? new MemberDetails.fromJson(json['userDetails']) : null;
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
    if (this.memberDetails != null) {
      data['memberDetails'] = this.memberDetails!.toJson();
    }
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class MemberDetails {
  String? sId;
  String? name;
  String? mobileNumber;
  String? userImage;
  String? email;

  MemberDetails({this.sId, this.name, this.mobileNumber, this.email, this.userImage});

  MemberDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    mobileNumber = json['mobileNumber'];
    userImage = json['userImage'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['mobileNumber'] = this.mobileNumber;
    data['userImage'] = this.userImage;
    data['email'] = this.email;
    return data;
  }
}
