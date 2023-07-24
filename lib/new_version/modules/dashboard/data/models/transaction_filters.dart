import 'package:equatable/equatable.dart';

class TransactionFilterModel extends Equatable {
  final String docTypes, fromDate, toDate;

  const TransactionFilterModel( {
    required this.docTypes,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [
    docTypes,
    fromDate,
    toDate,
  ];
}
