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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendor_id'] = this.vendorId;
    data['vendor_name'] = this.vendorName;
    data['vendor_email'] = this.vendorEmail;
    data['vendore_contact'] = this.vendoreContact;
    data['created_on'] = this.createdOn;
    return data;
  }
}