import 'package:next_app/models/list_models/list_model.dart';

class OpportunityListModel extends ListModel<OpportunityItemModel> {
  OpportunityListModel(List<OpportunityItemModel>? list) : super(list);

  factory OpportunityListModel.fromJson(Map<String, dynamic> json) {
    var _list = <OpportunityItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new OpportunityItemModel.fromJson(v));
      });
    }
    return OpportunityListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class OpportunityItemModel {
  final String id;
  final String opportunityFrom;
  final String customerName;
  final DateTime transactionDate;
  final String opportunityType;
  final String salesStage;
  final String status;

  OpportunityItemModel(
      {required this.id,
      required this.opportunityFrom,
      required this.customerName,
      required this.transactionDate,
      required this.status,
      required this.opportunityType,
      required this.salesStage});

  factory OpportunityItemModel.fromJson(Map<String, dynamic> json) {
    return OpportunityItemModel(
      id: json['name'] ?? 'none',
      opportunityFrom: json['opportunity_from'] ?? 'none',
      customerName: json['customer_name'] ?? 'none',
      transactionDate: DateTime.parse(json['transaction_date'] ?? 'none'),
      status: json['status'] ?? 'none',
      opportunityType: json['opportunity_type'] ?? 'none',
      salesStage: json['sales_stage'] ?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['opportunity_from'] = this.opportunityFrom;
    data['customer_name'] = this.customerName;
    data['transaction_date'] = this.transactionDate;
    data['status'] = this.status;
    data['opportunity_type'] = this.opportunityType;
    data['sales_stage'] = this.salesStage;
    return data;
  }
}
