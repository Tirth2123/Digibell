class IncomeCallModel {
  String? receiverId;
  String? callerId;
  String? callId;
  int? userCount;
  String? type;
  String? callerName;
  String? channelName;
  String? token;
  List<dynamic>? members;

  IncomeCallModel({this.receiverId, this.userCount, this.callId, this.type, this.callerName, this.channelName, this.token, this.callerId, this.members});

  IncomeCallModel.fromJson(Map<String, dynamic> json) {
    members = json['members'];
    receiverId = json['receiverId'];
    channelName = json['channelName'];
    userCount = json['userCount'];
    callId = json['callId'];
    token = json['token'];
    type = json['type'];
    callerName = json['callerName'];
    callerId = json['callerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['members'] = this.members;
    data['receiverId'] = this.receiverId;
    data['userCount'] = this.userCount;
    data['callId'] = this.callId;
    data['callerId'] = this.callerId;
    data['token'] = this.token;
    data['channelName'] = this.channelName;
    data['type'] = this.type;
    data['callerName'] = this.callerName;
    return data;
  }
}
