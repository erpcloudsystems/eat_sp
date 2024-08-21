import 'package:equatable/equatable.dart';

class AccountReceivableFilters extends Equatable {
  final String? salesPersonName, customerName, toDate;
  final double? customerCode;
  final int? startKey;

  const AccountReceivableFilters({
    this.salesPersonName,
    this.customerCode,
    this.customerName,
    this.toDate,
    this.startKey = 0,
  });

  @override
  List<Object?> get props => [
        salesPersonName,
        customerName,
        toDate,
        startKey,
        customerCode,
      ];
}
