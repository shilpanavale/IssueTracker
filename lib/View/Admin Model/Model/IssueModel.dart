class IssueModelClass {
  dynamic comment;
  dynamic rating;
  dynamic mobileNo;
  dynamic imageUrl2;
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
  dynamic subIssue;
  dynamic houseNo;
  dynamic escalation;

  IssueModelClass(
      {
        this.comment,
        this.rating,
        this.imageUrl2,
        this.mobileNo,
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
        this.subIssue,
        this.houseNo,
        this.escalation});
  IssueModelClass.fromJson(Map<String, dynamic> json) {
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
    subIssue = json['sub_issue'];
    houseNo = json['house_no'];
    escalation = json['Escalation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
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
    data['sub_issue'] = subIssue;
    data['house_no'] = houseNo;
    data['Escalation'] = escalation;
    return data;
  }
}

