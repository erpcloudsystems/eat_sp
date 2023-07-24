import 'package:equatable/equatable.dart';

class TotalFilters extends Equatable {
  final String fromDate, toDate;

  const TotalFilters( {
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [
    fromDate,
    toDate,
  ];
}
