class SubIssueTypeModel {
  dynamic subIssueId;
  dynamic subIssue;
  dynamic categoryIssueId;

  SubIssueTypeModel({this.subIssueId, this.subIssue, this.categoryIssueId});

  SubIssueTypeModel.fromJson(Map<String, dynamic> json) {
    subIssueId = json['sub_issue_id'];
    subIssue = json['sub_issue'];
    categoryIssueId = json['category_issue_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub_issue_id'] = this.subIssueId;
    data['sub_issue'] = this.subIssue;
    data['category_issue_id'] = this.categoryIssueId;
    return data;
  }
}