class BattalionListModel {
  List<Message>? message;

  BattalionListModel({this.message});

  BattalionListModel.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  String? battalion;
  int? pending;

  Message({this.battalion, this.pending});

  Message.fromJson(Map<String, dynamic> json) {
    battalion = json['battalion'];
    pending = json['pending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['battalion'] =battalion;
    data['pending'] = pending;
    return data;
  }
}
