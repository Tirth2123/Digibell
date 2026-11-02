class GetQRMemberModel {
  dynamic status;
  bool? success;
  String? message;
  List<String>? data;

  GetQRMemberModel({this.status, this.success, this.message, this.data});

  GetQRMemberModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}