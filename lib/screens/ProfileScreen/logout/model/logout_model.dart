class LogoutModel {
  dynamic status;
  bool? success;
  String? message;
  String? error;

  LogoutModel({this.status, this.success, this.message, this.error});

  LogoutModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    data['error'] = this.error;
    return data;
  }
}
