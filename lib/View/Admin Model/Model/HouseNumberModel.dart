class HouseNumberModelClass {
  dynamic houseId;
  dynamic houseType;
  dynamic houseNo;
  dynamic houseLocation;

  HouseNumberModelClass(
      {this.houseId, this.houseType, this.houseNo, this.houseLocation});

  HouseNumberModelClass.fromJson(Map<String, dynamic> json) {
    houseId = json['house_id'];
    houseType = json['house_type'];
    houseNo = json['house_no'];
    houseLocation = json['house_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['house_id'] = this.houseId;
    data['house_type'] = this.houseType;
    data['house_no'] = this.houseNo;
    data['house_location'] = this.houseLocation;
    return data;
  }
}


