class GCBattalionModel {
  List<BattalionData>? data;

  GCBattalionModel({this.data});

  GCBattalionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BattalionData>[];
      json['data'].forEach((v) {
        data!.add(BattalionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BattalionData {
  String? battalion;

  BattalionData({this.battalion});

  BattalionData.fromJson(Map<String, dynamic> json) {
    battalion = json['house_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['house_location'] = battalion;
    return data;
  }
}
