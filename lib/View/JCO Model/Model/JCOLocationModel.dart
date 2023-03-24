class JCOLocationModel {
  List<JCOLocationData>? data;

  JCOLocationModel({this.data});

  JCOLocationModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <JCOLocationData>[];
      json['data'].forEach((v) {
        data!.add( JCOLocationData.fromJson(v));
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

class JCOLocationData {
  String? houseLocation;

  JCOLocationData({this.houseLocation});

  JCOLocationData.fromJson(Map<String, dynamic> json) {
    houseLocation = json['house_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['house_location'] = houseLocation;
    return data;
  }
}