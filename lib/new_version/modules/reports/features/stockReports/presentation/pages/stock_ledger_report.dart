import 'package:NextApp/new_version/modules/reports/features/stockReports/data/models/stock_ledger_filter.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/presentation/bloc/stock_ledger_bloc/stock_ledger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../widgets/custom_loading.dart';
import '../../../../../../core/resources/routes.dart';
import '../../../../../../core/utils/error_dialog.dart';
import '../../../../../../core/utils/request_state.dart';
import '../../../../common/GeneralReports/presentation/widget/report_table.dart';
import '../../../../common/GeneralReports/presentation/widget/right_hand_data_table.dart';

class StockLedgerReport extends StatelessWidget {
  const StockLedgerReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StockLedgerBloc>(context);
    bloc.add(const ResetStockLedgerEvent());

    final stockLedgerFilter =
        ModalRoute.of(context)!.settings.arguments as StockLedgerFilters;
    bloc.add(GetStockLedgerEvent(
      stockLedgerFilters: stockLedgerFilter,
    ));

    return Scaffold(
      body: BlocConsumer<StockLedgerBloc, StockLedgerState>(
        listenWhen: (previous, current) =>
            previous.getStockLedgerReportsState !=
            current.getStockLedgerReportsState,
        listener: (context, state) {
          if (state.getStockLedgerReportsState == RequestState.error) {
            Navigator.of(context).pushReplacementNamed(Routes.noDataScreen);
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                errorMessage: state.getStockLedgerReportMessage,
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.getStockLedgerReportData !=
            current.getStockLedgerReportData,
        builder: (context, state) {
          if (state.getStockLedgerReportsState == RequestState.loading) {
            return const CustomLoadingWithImage();
          }
          if (state.getStockLedgerReportsState == RequestState.success) {
            /// Waiting..............
            Widget _generateRightHandSideColumnRow(
                BuildContext context, int index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RightHandDetailWidgets(
                      text: state.getStockLedgerReportData[index].date),
                  RightHandDetailWidgets(
                      text: state.getStockLedgerReportData[index].itemName
                          .toString()),
                  RightHandDetailWidgets(
                      text: state.getStockLedgerReportData[index].stockUom
                          .toString()),
                  RightHandDetailWidgets(
                      text: state.getStockLedgerReportData[index].itemGroup),
                  RightHandDetailWidgets(
                      text: state.getStockLedgerReportData[index].inQty
                          .toString()),
                  RightHandDetailWidgets(
                      text: state.getStockLedgerReportData[index].outQty
                          .toString()),
                  RightHandDetailWidgets(
                      text: state
                          .getStockLedgerReportData[index].qtyAfterTransaction
                          .toString()),
                  RightHandDetailWidgets(
                      text: state.getStockLedgerReportData[index].voucherNo
                          .toString()),
                  RightHandDetailWidgets(
                      text: state.getStockLedgerReportData[index].warehouse),
                ],
              );
            }

            return Scaffold(
              body: ReportTable(
                tableWidth: 910.w,
                appBarName: 'Stock Ledger',
                mainRowList: const [
                  'Item Code',
                  'Date',
                  'Item Name',
                  'Stock UOM',
                  'Item Group',
                  'In Qty',
                  'Out Qty',
                  'Balance Qty',
                  'Voucher No',
                  'Warehouse',
                ],
                leftColumnData: (index) =>
                    state.getStockLedgerReportData[index].itemCode,
                table: state.getStockLedgerReportData,
                refreshFun: () => BlocProvider.of<StockLedgerBloc>(context).add(
                  GetStockLedgerEvent(
                    stockLedgerFilters: stockLedgerFilter,
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
