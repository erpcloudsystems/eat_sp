part of 'dasboard_bloc.dart';

@immutable
class DashboardState extends Equatable {
  final RequestState getDashboardState;
  final RequestState getTotalPaidState;
  final RequestState getTotalReturnState;
  final String getDashboardMessage;
  final DashboardEntity dashboardEntity;
  final SalesInvoiceEntity paidSalesInvoiceEntity;
  final SalesInvoiceEntity returnSalesInvoiceEntity;

  const DashboardState({
    this.getDashboardState = RequestState.loading,
    this.getTotalPaidState = RequestState.loading,
    this.getTotalReturnState = RequestState.loading,
    this.getDashboardMessage = '',
    this.dashboardEntity = const DashboardEntity(
        userImage: '',
        userFullName: '',
        barChart: [],
),
    this.paidSalesInvoiceEntity = const SalesInvoiceEntity(
      total: 0,
      count: 0,
    ),
    this.returnSalesInvoiceEntity = const SalesInvoiceEntity(
      total: 0,
      count: 0,
    ),
  });

  DashboardState copyWith({
    RequestState? getDashboardState,
    RequestState? getTotalPaidState,
    RequestState? getTotalReturnState,
    String? getDashboardMessage,
    DashboardEntity? dashboardEntity,
    SalesInvoiceEntity? returnSalesInvoiceEntity,
    SalesInvoiceEntity? paidSalesInvoiceEntity,
  }) =>
      DashboardState(
        getDashboardState: getDashboardState ?? this.getDashboardState,
        getTotalPaidState: getTotalPaidState ?? this.getTotalPaidState,
        getTotalReturnState: getTotalReturnState ?? this.getTotalReturnState,
        getDashboardMessage: getDashboardMessage ?? this.getDashboardMessage,
        dashboardEntity: dashboardEntity ?? this.dashboardEntity,
        returnSalesInvoiceEntity:
            returnSalesInvoiceEntity ?? this.returnSalesInvoiceEntity,
        paidSalesInvoiceEntity:
            paidSalesInvoiceEntity ?? this.paidSalesInvoiceEntity,
      );

  @override
  List<Object?> get props => [
        getDashboardState,
        getTotalPaidState,
        getTotalReturnState,
        getDashboardMessage,
        dashboardEntity,
        paidSalesInvoiceEntity,
        returnSalesInvoiceEntity,
      ];
}
