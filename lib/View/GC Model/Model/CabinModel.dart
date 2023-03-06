class CabinModel {
  int? houseId;
  String? houseNo;
  String? cabinNo;

  CabinModel({this.houseId, this.houseNo, this.cabinNo});

  CabinModel.fromJson(Map<String, dynamic> json) {
    houseId = json['house_id'];
    houseNo = json['house_no'];
    cabinNo = json['cabin_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['house_id'] = houseId;
    data['house_no'] = houseNo;
    data['cabin_no'] = cabinNo;
    return data;
  }
}