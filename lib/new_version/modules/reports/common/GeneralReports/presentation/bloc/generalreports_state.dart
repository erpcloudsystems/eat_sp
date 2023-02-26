part of 'generalreports_bloc.dart';

class GeneralReportsState extends Equatable {
  final RequestState getReportsState;
  final String getReportsMessage;
  final List<ReportEntity> getReportData;

  const GeneralReportsState({
    this.getReportsState = RequestState.loading,
    this.getReportsMessage = '',
    this.getReportData = const [],
  });

  GeneralReportsState copyWith({
    RequestState? getReportsState,
    String? getReportsMessage,
    List<ReportEntity>? getReportData,
  }) =>
      GeneralReportsState(
        getReportsState: getReportsState ?? this.getReportsState,
        getReportsMessage: getReportsMessage ?? this.getReportsMessage,
        getReportData: getReportData ?? this.getReportData,
      );

  @override
  List<Object> get props => [
        getReportsState,
        getReportsMessage,
        getReportData,
      ];
}
