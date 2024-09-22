import 'package:NextApp/new_version/modules/dashboard/domain/entities/counter_entity.dart';

class CounterModel extends CounterEntity {
  const CounterModel({
    required super.paidSalesInvoiceEntity,
    required super.returnedSalesInvoiceEntity,
    required super.customerVisitEntity,
    required super.paymentEntriesEntity,
    required super.quotationsEntity,
    required super.salesOrderEntity,
    required super.deliveryNotes,
    required super.stockEntries,
    required super.addressEntries,
  });

  factory CounterModel.fromJson(Map<String, dynamic> json) => CounterModel(
        paidSalesInvoiceEntity: json['sales_invoices'],
        returnedSalesInvoiceEntity: json['returned_sales_invoices'],
        customerVisitEntity: json['customer_visits'],
        paymentEntriesEntity: json['payment_entries'],
        quotationsEntity: json['quotations'],
        salesOrderEntity: json['sales_orders'],
        deliveryNotes: json['delivery_notes'],
        stockEntries: json['stock_entries'],
        addressEntries: json['address'],
      );
}
