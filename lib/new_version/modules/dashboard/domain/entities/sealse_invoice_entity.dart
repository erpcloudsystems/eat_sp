import 'package:equatable/equatable.dart';

class SalesInvoiceEntity extends Equatable {
  final dynamic total;
  final dynamic count;

  const SalesInvoiceEntity({
    required this.total,
    required this.count,
  });

  @override
  List<Object?> get props => [
    total,
    count,
  ];
}
