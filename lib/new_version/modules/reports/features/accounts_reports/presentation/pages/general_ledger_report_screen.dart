import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/resources/routes.dart';
import '../../data/models/general_ledger_filter.dart';
import '../../../../../../core/utils/error_dialog.dart';
import '../../../../../../core/utils/request_state.dart';
import '../../../../../../../widgets/custom_loading.dart';
import '../bloc/general_ledger_bloc/general_ledger_bloc.dart';
import '../bloc/general_ledger_bloc/general_ledger_state.dart';
import '../../../../common/GeneralReports/presentation/widget/report_table.dart';
import '../../../../common/GeneralReports/presentation/widget/right_hand_data_table.dart';

class GeneralLedgerReportScreen extends StatelessWidget {
  const GeneralLedgerReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GeneralLedgerBloc>(context);
    bloc.add(const ResetGeneralLedgerEvent());

    final generalLedgerFilters =
        ModalRoute.of(context)!.settings.arguments as GeneralLedgerFilters;

    bloc.add(GetGeneralLedgerEvent(
      generalLedgerFilters: generalLedgerFilters,
    ));

    return Scaffold(
      body: BlocConsumer<GeneralLedgerBloc, GeneralLedgerState>(
        listenWhen: (previous, current) =>
            previous.getGeneralLedgerReportsState !=
            current.getGeneralLedgerReportsState,
        listener: (context, state) {
          if (state.getGeneralLedgerReportsState == RequestState.error) {
            Navigator.of(context).pushReplacementNamed(Routes.noDataScreen);
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                errorMessage: state.getGeneralLedgerReportMessage,
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.getGeneralLedgerReportData !=
            current.getGeneralLedgerReportData,
        builder: (context, state) {
          if (state.getGeneralLedgerReportsState == RequestState.loading) {
            return const CustomLoadingWithImage();
          }
          if (state.getGeneralLedgerReportsState == RequestState.success) {
            Widget _generateRightHandSideColumnRow(
                BuildContext context, int index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RightHandDetailWidgets(
                      text: state.getGeneralLedgerReportData[index].account!),
                  RightHandDetailWidgets(
                      text: state.getGeneralLedgerReportData[index].partyType
                          .toString()),
                  RightHandDetailWidgets(
                      text: state.getGeneralLedgerReportData[index].party
                          .toString()),
                  RightHandDetailWidgets(
                      text:
                          state.getGeneralLedgerReportData[index].costCenter!),
                  RightHandDetailWidgets(
                      text: state.getGeneralLedgerReportData[index].debit
                          .toString()),
                  RightHandDetailWidgets(
                      text: state.getGeneralLedgerReportData[index].credit
                          .toString()),
                  RightHandDetailWidgets(
                      text: state.getGeneralLedgerReportData[index].against!),
                  RightHandDetailWidgets(
                      text: state.getGeneralLedgerReportData[index]
                          .againstVoucherType!),
                  RightHandDetailWidgets(
                      text: state
                          .getGeneralLedgerReportData[index].againstVoucher!),
                  RightHandDetailWidgets(
                      text: state.getGeneralLedgerReportData[index].voucherNo
                          .toString()),
                  RightHandDetailWidgets(
                      text: state.getGeneralLedgerReportData[index].project!),
                  RightHandDetailWidgets(
                      text: state.getGeneralLedgerReportData[index].remarks!),
                  RightHandDetailWidgets(
                      text: state
                          .getGeneralLedgerReportData[index].accountCurrency!),
                  RightHandDetailWidgets(
                      text: state.getGeneralLedgerReportData[index].company!),
                  RightHandDetailWidgets(
                      text: state.getGeneralLedgerReportData[index].balance!),
                ],
              );
            }

            return Scaffold(
              body: ReportTable(
                tableWidth: 1500.w,
                appBarName: 'General Ledger',
                mainRowList: const [
                  'Posting Date',
                  'Account',
                  'Party Type',
                  'Party',
                  'Cost Center',
                  'Debit',
                  'Credit',
                  'Against',
                  'Against Voucher Type',
                  'Against Voucher',
                  'Against No',
                  'Project',
                  'Remarks',
                  'Account Currency',
                  'Company',
                  'Balance',
                ],
                leftColumnData: (index) =>
                    state.getGeneralLedgerReportData[index].postingDate!,
                table: state.getGeneralLedgerReportData,
                refreshFun: () =>
                    BlocProvider.of<GeneralLedgerBloc>(context).add(
                  GetGeneralLedgerEvent(
                    generalLedgerFilters: generalLedgerFilters,
                  ),
                ),
                tableWidget: _generateRightHandSideColumnRow,
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
