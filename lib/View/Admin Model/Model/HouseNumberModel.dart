class HouseNumberModelClass {
  String? houseId;
  String? houseType;
  String? houseNo;
  String? houseLocation;

  HouseNumberModelClass(
      {this.houseId, this.houseType, this.houseNo, this.houseLocation});

  HouseNumberModelClass.fromJson(Map<String, dynamic> json) {
    houseId = json['house_id'];
    houseType = json['house_type'];
    houseNo = json['house_no'];
    houseLocation = json['house_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['house_id'] = houseId;
    data['house_type'] = houseType;
    data['house_no'] = houseNo;
    data['house_location'] = houseLocation;
    return data;
  }
}


