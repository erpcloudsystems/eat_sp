import '../list_model.dart';

class WorkflowListModel extends ListModel<WorkflowItemModel> {
  WorkflowListModel(List<WorkflowItemModel>? list) : super(list);

  factory WorkflowListModel.fromJson(Map<String, dynamic> json) {
    var _list = <WorkflowItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new WorkflowItemModel.fromJson(v));
      });
    }
    return WorkflowListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}


class WorkflowItemModel {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? docstatus;
  int? idx;
  String? workflowName;
  String? documentType;
  int? isActive;
  int? overrideStatus;
  int? sendEmailAlert;
  String? workflowStateField;
  String? doctype;
  List<dynamic>? transitions;
  List<dynamic>? states;

  WorkflowItemModel(
      {this.name,
        this.owner,
        this.creation,
        this.modified,
        this.modifiedBy,
        this.docstatus,
        this.idx,
        this.workflowName,
        this.documentType,
        this.isActive,
        this.overrideStatus,
        this.sendEmailAlert,
        this.workflowStateField,
        this.doctype,
        this.transitions,
        this.states});

  WorkflowItemModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    workflowName = json['workflow_name'];
    documentType = json['document_type'];
    isActive = json['is_active'];
    overrideStatus = json['override_status'];
    sendEmailAlert = json['send_email_alert'];
    workflowStateField = json['workflow_state_field'];
    doctype = json['doctype'];
    transitions = json['transitions']?? [];
    states = json['states']?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    data['owner'] = this.owner;
    data['creation'] = this.creation;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    data['docstatus'] = this.docstatus;
    data['idx'] = this.idx;
    data['workflow_name'] = this.workflowName;
    data['document_type'] = this.documentType;
    data['is_active'] = this.isActive;
    data['override_status'] = this.overrideStatus;
    data['send_email_alert'] = this.sendEmailAlert;
    data['workflow_state_field'] = this.workflowStateField;
    data['doctype'] = this.doctype;
    data['transitions'] = this.transitions;
    data['states'] = this.transitions;
    return data;
  }
}
