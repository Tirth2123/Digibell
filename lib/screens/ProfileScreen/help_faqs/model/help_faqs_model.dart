class HelpFaqsModel {
  bool? success;
  String? error;
  List<Data>? data;
  int? statusCode;

  HelpFaqsModel({this.success, this.error, this.data, this.statusCode});

  HelpFaqsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status_code'] = this.statusCode;
    return data;
  }
}

class Data {
  int? id;
  String? question;
  String? answer;
  String? createdAt;
  String? updatedAt;
  bool? isExpanded;

  Data({this.id, this.question, this.answer, this.createdAt, this.updatedAt, this.isExpanded});

  Data.fromJson(Map<String, dynamic> json) {
    isExpanded = json['isExpanded'];
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isExpanded'] = this.isExpanded;
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}