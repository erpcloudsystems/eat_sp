part of 'accounts_receivable_bloc_bloc.dart';

abstract class AccountsReceivableEvent extends Equatable {
  const AccountsReceivableEvent();

  @override
  List<Object> get props => [];
}

class GetAccountReceivableReportEvent extends AccountsReceivableEvent{
  final AccountReceivableFilters filters;

  const GetAccountReceivableReportEvent({required this.filters});

  @override
  List<Object> get props => [filters];
}

class ResetAccountReceivableReportEvent extends AccountsReceivableEvent{
  const ResetAccountReceivableReportEvent();
}
