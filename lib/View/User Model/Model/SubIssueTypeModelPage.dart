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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_issue_id'] = subIssueId;
    data['sub_issue'] = subIssue;
    data['category_issue_id'] = categoryIssueId;
    return data;
  }
}