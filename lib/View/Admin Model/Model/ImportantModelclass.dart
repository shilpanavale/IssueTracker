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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['house_complaint_id'] = houseComplaintId;
    data['cat_issue_id'] = catIssueId;
    data['sub_issue_id'] = subIssueId;
    data['house_id'] = houseId;
    data['issue_created_on'] = issueCreatedOn;
    data['image_url'] = imageUrl;
    data['description'] = description;
    data['user_complaint_id'] = userComplaintId;
    data['status'] = status;
    data['vendor_id'] = vendorId;
    data['created_on'] = createdOn;
    data['issue'] = issue;
    data['escalation_1'] = escalation1;
    data['sub_issue'] = subIssue;
    data['house_no'] = houseNo;
    data['Escalation'] = escalation;
    return data;
  }
}