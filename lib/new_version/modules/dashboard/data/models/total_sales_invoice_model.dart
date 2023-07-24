import 'package:NextApp/new_version/modules/dashboard/domain/entities/sealse_invoice_entity.dart';

class TotalSalesInvoiceModel extends SalesInvoiceEntity {
  const TotalSalesInvoiceModel({
    required super.total,
    required super.count,
  });

  factory TotalSalesInvoiceModel.fromJson(Map<String, dynamic> json) =>
      TotalSalesInvoiceModel(
        total:  json['total'] ?? 'none',
        count: json['count'] ?? 'none',
      );
}
