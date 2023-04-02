import '../list_model.dart';

class TimesheetListModel extends ListModel<TimesheetModel> {
  TimesheetListModel(List<TimesheetModel>? list) : super(list);

  factory TimesheetListModel.fromJson(Map<String, dynamic> json) {
    var _list = <TimesheetModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new TimesheetModel.fromJson(v));
      });
    }
    return TimesheetListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class TimesheetModel {
  String? name;
  String? customer;
  String? currency;
  double? exchangeRate;
  String? salesInvoice;
  String? salarySlip;
  String? status;

  String? parentProject;
  String? employeeDetail;
  String? department;
  String? user;

  DateTime? startDate;
  DateTime? endDate;

  double? totalHours;
  double? totalBillableHours;
  double? baseTotalBillableAmount;
  double? baseTotalBilledAmount;
  double? baseTotalCostingAmount;
  double? totalBilledHours;
  double? totalBillableAmount;
  double? totalCostingAmount;
  double? perBilled;

  List<dynamic>? timeLogs;
  List<dynamic>? attachments;
  List<dynamic>? comments;

  TimesheetModel({
    this.name,
    this.customer,
    this.currency,
    this.exchangeRate,
    this.salesInvoice,
    this.salarySlip,
    this.status,
    this.parentProject,
    this.employeeDetail,
    this.department,
    this.user,
    this.startDate,
    this.endDate,
    this.totalHours,
    this.totalBillableHours,
    this.baseTotalBillableAmount,
    this.baseTotalBilledAmount,
    this.baseTotalCostingAmount,
    this.totalBilledHours,
    this.totalBillableAmount,
    this.totalCostingAmount,
    this.perBilled,
    this.timeLogs,
    this.attachments,
    this.comments,
  });

  TimesheetModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? 'none';
    customer = json['customer'] ?? 'none';
    currency = json['currency'] ?? 'none';
    exchangeRate = json['exchange_rate'] ?? 'none';
    salesInvoice = json['sales_invoice'] ?? 'none';
    salarySlip = json['salary_slip'] ?? 'none';
    status = json['status'] ?? 'none';
    parentProject = json['parent_project'] ?? 'none';
    employeeDetail = json['employee_detail'] ?? 'none';
    department = json['department'] ?? 'none';
    user = json['user'] ?? 'none';
    startDate = DateTime.parse(json['start_date']  ?? "2001-01-01");
    endDate =  DateTime.parse(json['end_date']  ?? "2001-01-01");
    totalHours = json['total_hours'] ?? 'none';
    totalBillableHours = json['total_billable_hours'] ?? 'none';
    baseTotalBillableAmount = json['base_total_billable_amount'] ?? 'none';
    baseTotalBilledAmount = json['base_total_billed_amount'] ?? 'none';
    baseTotalCostingAmount = json['base_total_costing_amount'] ?? 'none';
    totalBilledHours = json['total_billed_hours'] ?? 'none';
    totalBillableAmount = json['total_billable_amount'] ?? 'none';
    totalCostingAmount = json['total_costing_amount'] ?? 'none';
    perBilled = json['per_billed'] ?? 'none';
    timeLogs = json['time_logs'] ?? [];
    attachments = json['attachments'] ?? [];
    comments = json['comments'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['customer'] = this.customer;
    data['currency'] = this.currency;
    data['exchange_rate'] = this.exchangeRate;
    data['sales_invoice'] = this.salesInvoice;
    data['salary_slip'] = this.salarySlip;
    data['status'] = this.status;
    data['parent_project'] = this.parentProject;
    data['employee_detail'] = this.employeeDetail;
    data['department'] = this.department;
    data['user'] = this.user;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['total_hours'] = this.totalHours;
    data['total_billable_hours'] = this.totalBillableHours;
    data['base_total_billable_amount'] = this.baseTotalBillableAmount;
    data['base_total_billed_amount'] = this.baseTotalBilledAmount;
    data['base_total_costing_amount'] = this.baseTotalCostingAmount;
    data['total_billed_hours'] = this.totalBilledHours;
    data['total_billable_amount'] = this.totalBillableAmount;
    data['total_costing_amount'] = this.totalCostingAmount;
    data['per_billed'] = this.perBilled;
    data['time_logs'] = this.timeLogs;
    data['attachments'] = this.attachments;
    data['comments'] = this.comments;
    return data;
  }
}
