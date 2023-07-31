import '../list_model.dart';

class JobCardListModel extends ListModel<JobCardItemModel> {
  JobCardListModel(List<JobCardItemModel>? list) : super(list);

  factory JobCardListModel.fromJson(Map<String, dynamic> json) {
    List<JobCardItemModel> list = [];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        list.add(JobCardItemModel.fromJson(v));
      });
    }
    return JobCardListModel(list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class JobCardItemModel {
  final String name, itemName, project, forOperation;
  final double forQuantity;

  JobCardItemModel({
    required this.forOperation,
    required this.forQuantity,
    required this.itemName,
    required this.project,
    required this.name,
   
   });

  factory JobCardItemModel.fromJson(Map<String, dynamic> json) => JobCardItemModel(
        forOperation: json['for_operation'] ?? 'none',
        forQuantity: json['for_quantity'] ?? 1.0,
        itemName: json['item_name'] ?? 'none',
        project: json['project'] ?? 'none',
        name: json['name'] ?? 'none',
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['for_operation'] = forOperation;
    data['for_quantity'] = forQuantity;
    data['item_name'] = itemName;
    data['project'] = project;
    data['name'] = name;
    return data;
  }
}
