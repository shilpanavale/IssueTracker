class ImportantIssueModel {
  dynamic userId;
  dynamic houseComplaintId;
  dynamic catIssueId;
  dynamic subIssueId;
  dynamic houseId;
  dynamic issueCreatedOn;
  dynamic imageUrl;
  dynamic description;
  dynamic userComplaintId;
  dynamic status;
  dynamic vendorId;
  dynamic createdOn;
  dynamic issue;
  dynamic escalation1;
  dynamic subIssue;
  dynamic houseNo;
  dynamic escalation;

  ImportantIssueModel(
      {this.userId,
        this.houseComplaintId,
        this.catIssueId,
        this.subIssueId,
        this.houseId,
        this.issueCreatedOn,
        this.imageUrl,
        this.description,
        this.userComplaintId,
        this.status,
        this.vendorId,
        this.createdOn,
        this.issue,
        this.escalation1,
        this.subIssue,
        this.houseNo,
        this.escalation});

  ImportantIssueModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    houseComplaintId = json['house_complaint_id'];
    catIssueId = json['cat_issue_id'];
    subIssueId = json['sub_issue_id'];
    houseId = json['house_id'];
    issueCreatedOn = json['issue_created_on'];
    imageUrl = json['image_url'];
    description = json['description'];
    userComplaintId = json['user_complaint_id'];
    status = json['status'];
    vendorId = json['vendor_id'];
    createdOn = json['created_on'];
    issue = json['issue'];
    escalation1 = json['escalation_1'];
    subIssue = json['sub_issue'];
    houseNo = json['house_no'];
    escalation = json['Escalation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['house_complaint_id'] = this.houseComplaintId;
    data['cat_issue_id'] = this.catIssueId;
    data['sub_issue_id'] = this.subIssueId;
    data['house_id'] = this.houseId;
    data['issue_created_on'] = this.issueCreatedOn;
    data['image_url'] = this.imageUrl;
    data['description'] = this.description;
    data['user_complaint_id'] = this.userComplaintId;
    data['status'] = this.status;
    data['vendor_id'] = this.vendorId;
    data['created_on'] = this.createdOn;
    data['issue'] = this.issue;
    data['escalation_1'] = this.escalation1;
    data['sub_issue'] = this.subIssue;
    data['house_no'] = this.houseNo;
    data['Escalation'] = this.escalation;
    return data;
  }
}