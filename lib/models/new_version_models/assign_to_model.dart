class AssignToModel {
  List<String>? assignTo;
  String? date;
  String? priority;
  String? description;
  String? referenceType;
  String? referenceName;

  AssignToModel(
      {this.assignTo,
      this.date,
      this.priority,
      this.description,
      this.referenceType,
      this.referenceName});

  AssignToModel.fromJson(Map<String, dynamic> json) {
    assignTo = json['assign_to'].cast<String>();
    date = json['date'];
    priority = json['priority'];
    description = json['description'];
    referenceType = json['reference_type'];
    referenceName = json['reference_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assign_to'] = this.assignTo;
    data['date'] = this.date;
    data['priority'] = this.priority;
    data['description'] = this.description;
    data['reference_type'] = this.referenceType;
    data['reference_name'] = this.referenceName;
    return data;
  }
}
