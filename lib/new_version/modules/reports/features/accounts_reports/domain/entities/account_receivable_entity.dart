import 'package:equatable/equatable.dart';

class AccountReceivableReportEntity extends Equatable {
  final String customerName, salesPerson, date;
  final double outstandingAmount;
  final String  customerCode;
  const AccountReceivableReportEntity({
    required this.customerName,
    required this.salesPerson,
    required this.date,
    required this.customerCode,
    required this.outstandingAmount,
  });

  @override
  List<Object?> get props => [
        customerName,
        salesPerson,
        date,
        customerCode,
        outstandingAmount,
      ];
}
