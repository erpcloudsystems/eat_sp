import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../widgets/custom_loading.dart';
import '../../../../../../core/resources/routes.dart';
import '../../../../../../core/utils/error_dialog.dart';
import '../../../../../../core/utils/request_state.dart';
import '../../../../common/GeneralReports/presentation/widget/report_table.dart';
import '../../../../common/GeneralReports/presentation/widget/right_hand_data_table.dart';
import '../../data/models/warehouse_filters.dart';
import '../bloc/stock_warehouse_report/stockreports_bloc.dart';

class WarehouseReports extends StatelessWidget {
  const WarehouseReports({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StockReportsBloc>(context);
    bloc.add(ResetWarehouseEvent());

    final wareHouseFilter =
        ModalRoute.of(context)!.settings.arguments as WarehouseFilters;
    bloc.add(GetWarehouseEvent(
      warehouseFilters: wareHouseFilter,
    ));

    return Scaffold(
      body: BlocConsumer<StockReportsBloc, StockReportsState>(
        listenWhen: (previous, current) =>
            previous.getWarehouseReportsState !=
            current.getWarehouseReportsState,
        listener: (context, state) {
          if (state.getWarehouseReportsState == RequestState.error) {
            Navigator.of(context).pushReplacementNamed(Routes.noDataScreen);
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                errorMessage: state.getWarehouseReportMessage,
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.getWarehouseReportData != current.getWarehouseReportData,
        builder: (context, state) {
          if (state.getWarehouseReportsState == RequestState.loading) {
            return CustomLoadingWithImage();
          }
          if (state.getWarehouseReportsState == RequestState.success) {
            Widget _generateRightHandSideColumnRow(
                BuildContext context, int index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RightHandDetailWidgets(
                      text: state.getWarehouseReportData[index].itemName),
                  RightHandDetailWidgets(
                      text: state.getWarehouseReportData[index].actualQty
                          .toString()),
                  RightHandDetailWidgets(
                      text: state.getWarehouseReportData[index].stockUom),
                  RightHandDetailWidgets(
                      text: state.getWarehouseReportData[index].itemGroup),
                ],
              );
            }

            return Scaffold(
              body: ReportTable(
                tableWidth: 400.w,
                appBarName: 'Warehouse Stock balance',
                mainRowList: [
                  'Item Code',
                  'Item Name',
                  'Actual Quantity',
                  'Stock UOM',
                  'Item Group',
                ],
                leftColumnData: (index) =>
                    state.getWarehouseReportData[index].itemCode,
                table: state.getWarehouseReportData,
                refreshFun: () =>
                    BlocProvider.of<StockReportsBloc>(context).add(
                  GetWarehouseEvent(
                    warehouseFilters: wareHouseFilter,
                  ),
                ),
                tableWidget: _generateRightHandSideColumnRow,
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
