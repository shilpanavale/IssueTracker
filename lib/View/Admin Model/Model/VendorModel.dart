class VendorModelClass {
  String? vendorId;
  String? vendorName;
  String? vendorEmail;
  String? vendoreContact;
  String? createdOn;

  VendorModelClass(
      {this.vendorId,
        this.vendorName,
        this.vendorEmail,
        this.vendoreContact,
        this.createdOn});

  VendorModelClass.fromJson(Map<String, dynamic> json) {
    vendorId = json['vendor_id'];
    vendorName = json['vendor_name'];
    vendorEmail = json['vendor_email'];
    vendoreContact = json['vendore_contact'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vendor_id'] = vendorId;
    data['vendor_name'] = vendorName;
    data['vendor_email'] = vendorEmail;
    data['vendore_contact'] = vendoreContact;
    data['created_on'] = createdOn;
    return data;
  }
}