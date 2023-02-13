class LocationModelClass {
  String? houseLocation;

  LocationModelClass({this.houseLocation});

  LocationModelClass.fromJson(Map<String, dynamic> json) {
    houseLocation = json['house_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['house_location'] = houseLocation;
    return data;
  }
}
class AccommodationModel {
  String? houseId;
  String? houseType;
  String? houseNo;

  AccommodationModel({this.houseId, this.houseType, this.houseNo});

  AccommodationModel.fromJson(Map<String, dynamic> json) {
    houseId = json['house_id'];
    houseType = json['house_type'];
    houseNo = json['house_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['house_id'] = this.houseId;
    data['house_type'] = this.houseType;
    data['house_no'] = this.houseNo;
    return data;
  }
}
class HouseNumberModel {

  dynamic houseId;
  dynamic houseNo;

  HouseNumberModel({this.houseNo,this.houseId});

  HouseNumberModel.fromJson(Map<String, dynamic> json) {
    houseId = json['house_id'];
    houseNo = json['house_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['house_id'] = this.houseId;
    data['house_no'] = this.houseNo;
    return data;
  }
}