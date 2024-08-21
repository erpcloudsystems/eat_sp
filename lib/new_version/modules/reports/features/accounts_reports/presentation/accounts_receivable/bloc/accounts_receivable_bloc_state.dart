part of 'accounts_receivable_bloc_bloc.dart';

class AccountsReceivableState extends Equatable {
  final RequestState accountsReceivableReportState;
  final String accountReceivableReportMessage;
  final List<AccountReceivableReportEntity> accountReceivableReportData;
  final bool hasReachedMax;

  const AccountsReceivableState({
    this.accountReceivableReportData = const [],
    this.accountReceivableReportMessage = '',
    this.accountsReceivableReportState = RequestState.loading,
    this.hasReachedMax = false,
  });

  AccountsReceivableState copyWith({
    RequestState? accountsReceivableReportState,
    String? accountReceivableReportMessage,
    List<AccountReceivableReportEntity>? accountReceivableReportData,
    bool? hasReachedMax,
  }) =>
      AccountsReceivableState(
        accountReceivableReportData:
            accountReceivableReportData ?? this.accountReceivableReportData,
        accountReceivableReportMessage: accountReceivableReportMessage ??
            this.accountReceivableReportMessage,
        accountsReceivableReportState:
            accountsReceivableReportState ?? this.accountsReceivableReportState,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );

  @override
  List<Object> get props => [
        accountReceivableReportData,
        accountReceivableReportMessage,
        accountsReceivableReportState,
        hasReachedMax,
      ];
}
