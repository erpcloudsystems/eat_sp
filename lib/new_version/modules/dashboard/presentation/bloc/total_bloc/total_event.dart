part of 'total_bloc.dart';

@immutable
abstract class TotalEvent extends Equatable{

  const TotalEvent();
  @override
  List<Object> get props => [];
}

class GetTotalEvent extends TotalEvent {
  final TotalFilters totalSalesInvoiceFilters;

  const GetTotalEvent({
    required this.totalSalesInvoiceFilters,
  });

  @override
  List<Object> get props => [
    totalSalesInvoiceFilters,
  ];
}

