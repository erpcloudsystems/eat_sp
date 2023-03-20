import 'package:NextApp/new_version/modules/reports/features/accounts_reports/domain/entities/general_ledger_report_entity.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../../core/utils/request_state.dart';

class GeneralLedgerState extends Equatable {
  final RequestState getGeneralLedgerReportsState;
  final String getGeneralLedgerReportMessage;
  final bool hasReachedMax;
  final bool isPartyType;
  final List<GeneralLedgerReportEntity> getGeneralLedgerReportData;

  const GeneralLedgerState({
    this.getGeneralLedgerReportsState = RequestState.loading,
    this.getGeneralLedgerReportMessage = '',
    this.getGeneralLedgerReportData = const [],
    this.hasReachedMax = false,
    this.isPartyType = false,
  });

  GeneralLedgerState copyWith({
    RequestState? getGeneralLedgerReportsState,
    String? getGeneralLedgerReportMessage,
    List<GeneralLedgerReportEntity>? getGeneralLedgerReportData,
    bool? hasReachedMax,
    bool? isPartyType,
  }) =>
      GeneralLedgerState(
        getGeneralLedgerReportsState:
            getGeneralLedgerReportsState ?? this.getGeneralLedgerReportsState,
        getGeneralLedgerReportMessage:
            getGeneralLedgerReportMessage ?? this.getGeneralLedgerReportMessage,
        getGeneralLedgerReportData:
            getGeneralLedgerReportData ?? this.getGeneralLedgerReportData,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        isPartyType: isPartyType ?? this.isPartyType,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [
        getGeneralLedgerReportsState,
        getGeneralLedgerReportMessage,
        getGeneralLedgerReportData,
        hasReachedMax,
        isPartyType,
      ];
}
