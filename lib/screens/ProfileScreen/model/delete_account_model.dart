class DeleteAccountModel {
  DeleteAccountModel({
    this.status,
    this.success,
    this.message,
  });

  DeleteAccountModel.fromJson(dynamic json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
  }
  dynamic status;
  bool? success;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['success'] = success;
    map['message'] = message;
    return map;
  }
}
