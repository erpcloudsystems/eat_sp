part of 'dasboard_bloc.dart';

@immutable
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class GetDashboardDataEvent extends DashboardEvent {
  final TotalFilters dateFilter;
  const GetDashboardDataEvent({
    required this.dateFilter,
  });

   @override
  List<Object> get props => [
    dateFilter,
  ];
}