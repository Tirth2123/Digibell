class AddMemberModel {
  dynamic status;
  bool? success;
  String? error;
  String? message;

  AddMemberModel({this.status, this.success, this.error, this.message});

  AddMemberModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['error'] = this.error;
    data['message'] = this.message;
    return data;
  }
}
