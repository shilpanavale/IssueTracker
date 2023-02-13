class IssueTypeModel {
  dynamic issueId;
  String? issue;

  IssueTypeModel({this.issueId, this.issue});

  IssueTypeModel.fromJson(Map<String, dynamic> json) {
    issueId = json['issue_id'];
    issue = json['issue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['issue_id'] = this.issueId;
    data['issue'] = this.issue;
    return data;
  }
}