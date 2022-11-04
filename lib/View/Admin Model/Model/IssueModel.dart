class IssueModelClass {
  String? houseComplaintId;
  String? catIssueId;
  String? subIssueId;
  String? houseId;
  String? issueCreatedOn;
  String? imageUrl;
  String? id;
  String? userComplaintId;
  String? status;
  String? vendorId;
  String? createdOn;
  int? escalation;

  IssueModelClass(
      {this.houseComplaintId,
        this.catIssueId,
        this.subIssueId,
        this.houseId,
        this.issueCreatedOn,
        this.imageUrl,
        this.id,
        this.userComplaintId,
        this.status,
        this.vendorId,
        this.createdOn,
        this.escalation});

  IssueModelClass.fromJson(Map<String, dynamic> json) {
    houseComplaintId = json['house_complaint_id'];
    catIssueId = json['cat_issue_id'];
    subIssueId = json['sub_issue_id'];
    houseId = json['house_id'];
    issueCreatedOn = json['issue_created_on'];
    imageUrl = json['image_url'];
    id = json['id'];
    userComplaintId = json['user_complaint_id'];
    status = json['status'];
    vendorId = json['vendor_id'];
    createdOn = json['created_on'];
    escalation = json['Escalation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['house_complaint_id'] = this.houseComplaintId;
    data['cat_issue_id'] = this.catIssueId;
    data['sub_issue_id'] = this.subIssueId;
    data['house_id'] = this.houseId;
    data['issue_created_on'] = this.issueCreatedOn;
    data['image_url'] = this.imageUrl;
    data['id'] = this.id;
    data['user_complaint_id'] = this.userComplaintId;
    data['status'] = this.status;
    data['vendor_id'] = this.vendorId;
    data['created_on'] = this.createdOn;
    data['Escalation'] = this.escalation;
    return data;
  }
}