import 'package:equatable/equatable.dart';

class CounterEntity extends Equatable {
  final dynamic paidSalesInvoiceEntity;
  final dynamic returnedSalesInvoiceEntity;
  final dynamic customerVisitEntity;
  final dynamic paymentEntriesEntity;
  final dynamic quotationsEntity;
  final dynamic salesOrderEntity;
  final dynamic deliveryNotes;
  final dynamic stockEntries;
  final dynamic addressEntries;

  const CounterEntity({
    required this.paidSalesInvoiceEntity,
    required this.returnedSalesInvoiceEntity,
    required this.customerVisitEntity,
    required this.paymentEntriesEntity,
    required this.quotationsEntity,
    required this.salesOrderEntity,
    required this.deliveryNotes,
    required this.stockEntries,
    required this.addressEntries,
  });

  @override
  List<Object?> get props => [
    paidSalesInvoiceEntity,
    returnedSalesInvoiceEntity,
    customerVisitEntity,
    paymentEntriesEntity,
    quotationsEntity,
    salesOrderEntity,
    deliveryNotes,
    stockEntries,
    addressEntries,
  ];
}
