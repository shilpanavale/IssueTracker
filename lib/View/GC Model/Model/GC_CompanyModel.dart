class GCCompanyModel {
  List<CompanyData>? data;

  GCCompanyModel({this.data});

  GCCompanyModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CompanyData>[];
      json['data'].forEach((v) {
        data!.add(CompanyData.fromJson(v));
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

class CompanyData {
  String? houseId;
  String? houseType;
  String? houseNo;

  CompanyData({this.houseId, this.houseType, this.houseNo});

  CompanyData.fromJson(Map<String, dynamic> json) {
    houseId = json['house_id'];
    houseType = json['house_type'];
    houseNo = json['house_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['house_id'] = this.houseId;
    data['house_type'] = this.houseType;
    data['house_no'] = this.houseNo;
    return data;
  }
}
