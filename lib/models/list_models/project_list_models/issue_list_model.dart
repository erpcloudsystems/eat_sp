import '../list_model.dart';

class IssueListModel extends ListModel<IssueItemModel> {
  IssueListModel(List<IssueItemModel>? list) : super(list);

  factory IssueListModel.fromJson(Map<String, dynamic> json) {
    var _list = <IssueItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new IssueItemModel.fromJson(v));
      });
    }
    return IssueListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class IssueItemModel {
  String? name;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? owner;
  int? docStatus;
  int? idx;
  String? namingSeries;
  String? subject;
  String? raisedBy;
  String? status;
  String? priority;
  String? description;
  int? responseByVariance;
  String? agreementStatus;
  int? resolutionByVariance;
  String? openingDate;
  String? openingTime;
  String? company;
  int? viaCustomerPortal;
  String? sSeen;
  String? project;

  IssueItemModel({
    this.name,
    this.creation,
    this.modified,
    this.docStatus,
    this.modifiedBy,
    this.owner,
    this.idx,
    this.namingSeries,
    this.subject,
    this.raisedBy,
    this.status,
    this.priority,
    this.description,
    this.responseByVariance,
    this.agreementStatus,
    this.resolutionByVariance,
    this.openingDate,
    this.openingTime,
    this.company,
    this.viaCustomerPortal,
    this.sSeen,
    this.project,
  });

  IssueItemModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    owner = json['owner'];
    docStatus = json['docstatus'];
    idx = json['idx'];
    namingSeries = json['naming_series'];
    subject = json['subject'];
    raisedBy = json['raised_by'];
    status = json['status'];
    priority = json['priority'];
    description = json['description'];
    responseByVariance = json['response_by_variance'];
    agreementStatus = json['agreement_status'];
    resolutionByVariance = json['resolution_by_variance'];
    openingDate = json['opening_date'];
    openingTime = json['opening_time'];
    company = json['company'];
    viaCustomerPortal = json['via_customer_portal'];
    sSeen = json['_seen'];
    project = json['project'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['creation'] = this.creation;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    data['owner'] = this.owner;
    data['docstatus'] = this.docStatus;
    data['idx'] = this.idx;
    data['naming_series'] = this.namingSeries;
    data['subject'] = this.subject;
    data['raised_by'] = this.raisedBy;
    data['status'] = this.status;
    data['priority'] = this.priority;
    data['description'] = this.description;
    data['response_by_variance'] = this.responseByVariance;
    data['agreement_status'] = this.agreementStatus;
    data['resolution_by_variance'] = this.resolutionByVariance;
    data['opening_date'] = this.openingDate;
    data['opening_time'] = this.openingTime;
    data['company'] = this.company;
    data['via_customer_portal'] = this.viaCustomerPortal;
    data['_seen'] = this.sSeen;
    data['project'] = this.project;
    return data;
  }
}
