part of 'total_bloc.dart';

@immutable
class TotalState extends Equatable {
  final RequestState getTotalState;
  final String getDashboardMessage;
  final CounterEntity totalEntity;

  const TotalState({
    this.getTotalState = RequestState.loading,
    this.getDashboardMessage = '',
    this.totalEntity = const CounterEntity(
      paidSalesInvoiceEntity: {},
      returnedSalesInvoiceEntity: {},
      customerVisitEntity: {},
      paymentEntriesEntity: {},
      quotationsEntity: {},
      salesOrderEntity: {},
      deliveryNotes: {},
      stockEntries: {},
    ),
  });

  TotalState copyWith({
    RequestState? getDashboardState,
    RequestState? getTotalState,
    String? getDashboardMessage,
    CounterEntity? totalEntity,
  }) =>
      TotalState(
        getTotalState: getTotalState ?? this.getTotalState,
        getDashboardMessage: getDashboardMessage ?? this.getDashboardMessage,
        totalEntity: totalEntity ?? this.totalEntity,
      );

  @override
  List<Object?> get props => [
        getTotalState,
        getDashboardMessage,
        totalEntity,
      ];
}
