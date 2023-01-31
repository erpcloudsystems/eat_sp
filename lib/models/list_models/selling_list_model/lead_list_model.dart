import '../list_model.dart';

class LeadListModel extends ListModel<LeadItemModel> {
  LeadListModel(List<LeadItemModel>? list) : super(list);

  factory LeadListModel.fromJson(Map<String, dynamic> json) {
    var _list = <LeadItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new LeadItemModel.fromJson(v));
      });
    }
    return LeadListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class LeadItemModel {
  final String id;
  final String name;
  final String companyName;
  final String territory;
  final String source;
  final String marketSegment;
  final String status;

  LeadItemModel(
      {required this.id,
      required this.name,
      required this.companyName,
      required this.status,
      required this.territory,
      required this.source,
      required this.marketSegment});

  factory LeadItemModel.fromJson(Map<String, dynamic> json) {
    return LeadItemModel(
      id: json['name'] ?? 'none',
      name: json['lead_name'] ?? 'none',
      companyName: json['company_name'] ?? 'none',
      status: json['status'] ?? 'none',
      territory: json['territory'] ?? 'none',
      marketSegment: json['market_segment'] ?? 'none',
      source: json['source'] ?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['lead_name'] = this.name;
    data['company_name'] = this.companyName;
    data['status'] = this.status;
    data['territory'] = this.territory;
    data['market_segment'] = this.marketSegment;
    data['source'] = this.source;
    return data;
  }
}
