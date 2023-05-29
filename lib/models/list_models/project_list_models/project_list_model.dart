import '../list_model.dart';

class ProjectListModel extends ListModel<ProjectItemModel> {
  ProjectListModel(List<ProjectItemModel>? list) : super(list);

  factory ProjectListModel.fromJson(Map<String, dynamic> json) {
    var _list = <ProjectItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new ProjectItemModel.fromJson(v));
      });
    }
    return ProjectListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class ProjectItemModel {
  String? name;
  String? status;
  String? projectName;
  DateTime? expectedStartDate;
  DateTime? expectedEndDate;
  String? projectType;
  String? priority;
  String? isActive;
  String? department;
  String? percentCompleteMethod;
  double? percentComplete;
  String? customer;
  String? notes;
  double? actualTime;
  List<dynamic>? users;
  List<dynamic>? conn;
  List<dynamic>? attachments;
  List<dynamic>? comments;

  ProjectItemModel({
    this.name,
    this.status,
    this.projectName,
    this.expectedStartDate,
    this.expectedEndDate,
    this.projectType,
    this.priority,
    this.isActive,
    this.department,
    this.percentCompleteMethod,
    this.percentComplete,
    this.customer,
    this.notes,
    this.actualTime,
    this.users,
    this.attachments,
    this.comments,
    this.conn,
  });

  ProjectItemModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
    projectName = json['project_name'];
    expectedStartDate =
        DateTime.parse(json['expected_start_date'] ?? "2001-01-01");
    expectedEndDate = DateTime.parse(json['expected_end_date'] ?? "2001-01-01");
    projectType = json['project_type'];
    priority = json['priority'];
    isActive = json['is_active'];
    department = json['department'];
    percentCompleteMethod = json['percent_complete_method'];
    percentComplete = json['percent_complete'];
    customer = json['customer'];
    notes = json['notes'];
    actualTime = json['actual_time'];
    conn = json['conn'] ?? [];
    users = json['users'] ?? [];
    attachments = json['attachments'] ?? [];
    comments = json['comments'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['status'] = this.status;
    data['project_name'] = this.projectName;
    data['expected_start_date'] = this.expectedStartDate;
    data['expected_end_date'] = this.expectedEndDate;
    data['project_type'] = this.projectType;
    data['priority'] = this.priority;
    data['is_active'] = this.isActive;
    data['department'] = this.department;
    data['percent_complete_method'] = this.percentCompleteMethod;
    data['percent_complete'] = this.percentComplete;
    data['customer'] = this.customer;
    data['notes'] = this.notes;
    data['actual_time'] = this.actualTime;
    data['conn'] = this.conn;
    data['users'] = this.users;
    data['attachments'] = this.attachments;
    data['comments'] = this.comments;
    return data;
  }
}
