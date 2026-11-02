class ForcefullyUpdateModel {
  dynamic status;
  bool? success;
  String? error;
  Data? data;

  ForcefullyUpdateModel({this.status, this.success, this.error, this.data});

  ForcefullyUpdateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    error = json['error'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Android? android;
  Android? ios;
  String? sId;
  String? key;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data({this.android, this.ios, this.sId, this.key, this.createdBy, this.createdAt, this.updatedAt, this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    android = json['android'] != null ? new Android.fromJson(json['android']) : null;
    ios = json['ios'] != null ? new Android.fromJson(json['ios']) : null;
    sId = json['_id'];
    key = json['key'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.android != null) {
      data['android'] = this.android!.toJson();
    }
    if (this.ios != null) {
      data['ios'] = this.ios!.toJson();
    }
    data['_id'] = this.sId;
    data['key'] = this.key;
    data['createdBy'] = this.createdBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Android {
  String? version;
  bool? forcefullyUpdate;
  String? title;
  String? message;

  Android({this.version, this.forcefullyUpdate, this.title, this.message});

  Android.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    forcefullyUpdate = json['forcefullyUpdate'];
    title = json['title'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['forcefullyUpdate'] = this.forcefullyUpdate;
    data['title'] = this.title;
    data['message'] = this.message;
    return data;
  }
}
