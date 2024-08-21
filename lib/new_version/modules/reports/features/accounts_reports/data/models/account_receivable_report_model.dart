import '../../domain/entities/account_receivable_entity.dart';

class AccountReceivableReportModel extends AccountReceivableReportEntity {
  const AccountReceivableReportModel({
    required super.customerName,
    required super.salesPerson,
    required super.date,
    required super.customerCode,
    required super.outstandingAmount,
  });

  factory AccountReceivableReportModel.fromJson(Map<String, dynamic> json) =>
      AccountReceivableReportModel(
        customerName: json['customer_name'] ?? 'none',
        salesPerson: json['sales_person'] ?? 'none',
        date: json['date'] ?? 'none',
        customerCode: json['customer_code'].toString(),
        outstandingAmount: json['outstanding_balance'] ?? 0.0,
      );

  @override
  List<Object?> get props => [
        customerName,
        salesPerson,
        date,
        customerCode,
        outstandingAmount,
      ];
}
