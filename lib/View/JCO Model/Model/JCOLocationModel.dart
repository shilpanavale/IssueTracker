class JCOLocationModel {
  List<JCOLocationData>? data;

  JCOLocationModel({this.data});

  JCOLocationModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <JCOLocationData>[];
      json['data'].forEach((v) {
        data!.add(new JCOLocationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JCOLocationData {
  String? houseLocation;

  JCOLocationData({this.houseLocation});

  JCOLocationData.fromJson(Map<String, dynamic> json) {
    houseLocation = json['house_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['house_location'] = this.houseLocation;
    return data;
  }
}