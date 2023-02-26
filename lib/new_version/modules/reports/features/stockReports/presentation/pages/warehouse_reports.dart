import 'package:NextApp/new_version/core/resources/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../widgets/custom_loading.dart';
import '../../../../../../core/utils/error_dialog.dart';
import '../../../../../../core/utils/request_state.dart';
import '../../data/models/warehouse_filters.dart';
import '../bloc/stockreports_bloc.dart';
import '../widgets/item_filter_button.dart';
import '../widgets/report_table.dart';

class WarehouseReports extends StatelessWidget {
  const WarehouseReports({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StockReportsBloc>(context);
    bloc.add(ResetWarehouseEvent());

    final warehouseName = ModalRoute.of(context)!.settings.arguments as String;
    final warehouseFilters = WarehouseFilters(warehouseFilter: warehouseName);
    bloc.add(GetWarehouseEvent(warehouseFilters: warehouseFilters));

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
                builder: (context) =>
                    ErrorDialog(errorMessage: state.getWarehouseReportMessage));
          }
        },
        buildWhen: (previous, current) =>
            previous.getWarehouseReportData != current.getWarehouseReportData,
        builder: (context, state) {
          if (state.getWarehouseReportsState == RequestState.loading) {
            return CustomLoadingWithImage();
          }
          if (state.getWarehouseReportsState == RequestState.success) {
            return Scaffold(
                floatingActionButton: ItemFilterButton(
                  warehouseCode: warehouseFilters.warehouseFilter,
                ),
                body: ReportTable(
                  table: state.getWarehouseReportData,
                  refreshFun: () =>
                      BlocProvider.of<StockReportsBloc>(context).add(
                    GetWarehouseEvent(
                      warehouseFilters: warehouseFilters,
                    ),
                  ),
                ));
          }
          return SizedBox();
        },
      ),
    );
  }
}
