class SubscriptionDetailsModel {
  dynamic status;
  bool? success;
  String? error;
  String? message;
  List<SubscriptionList>? data;

  SubscriptionDetailsModel({this.status, this.success, this.error, this.message, this.data});

  SubscriptionDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SubscriptionList>[];
      json['data'].forEach((v) {
        data!.add(new SubscriptionList.fromJson(v));
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

class SubscriptionList {
  String? sId;
  String? name;
  String? type;
  int? price;
  int? members;
  bool? unlimitedCall;
  bool? twoWayAudioVideoCall;
  bool? qrScanAlert;
  bool? visitorHistory;
  bool? visitorPhotoCapture;
  bool? smartMonthMisReport;
  bool? active;
  bool? deleted;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? qrGeneration;

  SubscriptionList(
      {this.sId,
      this.name,
      this.type,
      this.price,
      this.members,
      this.unlimitedCall,
      this.twoWayAudioVideoCall,
      this.qrScanAlert,
      this.visitorHistory,
      this.visitorPhotoCapture,
      this.smartMonthMisReport,
      this.active,
      this.deleted,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.qrGeneration});

  SubscriptionList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    type = json['type'];
    price = json['price'];
    members = json['members'];
    unlimitedCall = json['unlimitedCall'];
    twoWayAudioVideoCall = json['twoWayAudioVideoCall'];
    qrScanAlert = json['qrScanAlert'];
    visitorHistory = json['visitorHistory'];
    visitorPhotoCapture = json['visitorPhotoCapture'];
    smartMonthMisReport = json['smartMonthMisReport'];
    active = json['active'];
    deleted = json['deleted'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    qrGeneration = json['qrGeneration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['price'] = this.price;
    data['members'] = this.members;
    data['unlimitedCall'] = this.unlimitedCall;
    data['twoWayAudioVideoCall'] = this.twoWayAudioVideoCall;
    data['qrScanAlert'] = this.qrScanAlert;
    data['visitorHistory'] = this.visitorHistory;
    data['visitorPhotoCapture'] = this.visitorPhotoCapture;
    data['smartMonthMisReport'] = this.smartMonthMisReport;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['qrGeneration'] = this.qrGeneration;
    return data;
  }
}
