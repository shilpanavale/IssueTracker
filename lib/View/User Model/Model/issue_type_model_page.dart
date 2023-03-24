class IssueTypeModel {
  dynamic issueId;
  String? issue;

  IssueTypeModel({this.issueId, this.issue});

  IssueTypeModel.fromJson(Map<String, dynamic> json) {
    issueId = json['issue_id'];
    issue = json['issue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['issue_id'] = issueId;
    data['issue'] = issue;
    return data;
  }
}