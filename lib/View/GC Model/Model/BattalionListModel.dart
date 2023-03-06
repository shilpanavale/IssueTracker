class BattalionListModel {
  String? houseType;
  int? cCount;

  BattalionListModel({this.houseType, this.cCount});

  BattalionListModel.fromJson(Map<String, dynamic> json) {
    houseType = json['house_type'];
    cCount = json['c_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['house_type'] = this.houseType;
    data['c_count'] = this.cCount;
    return data;
  }
}
