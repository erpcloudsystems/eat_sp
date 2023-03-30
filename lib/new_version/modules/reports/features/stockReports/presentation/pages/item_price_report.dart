import '../../data/models/item_price_filters.dart';
import '../bloc/item_price_bloc/item_price_bloc.dart';
import '../bloc/item_price_bloc/item_price_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../widgets/custom_loading.dart';
import '../../../../../../core/resources/routes.dart';
import '../../../../../../core/utils/error_dialog.dart';
import '../../../../../../core/utils/request_state.dart';
import '../../../../common/GeneralReports/presentation/widget/report_table.dart';
import '../../../../common/GeneralReports/presentation/widget/right_hand_data_table.dart';

class ItemPriceReport extends StatelessWidget {
  const ItemPriceReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ItemPriceBloc>(context);
    bloc.add(ResetItemPriceEvent());

    final itemPriceFilters =
        ModalRoute.of(context)!.settings.arguments as ItemPriceFilters;
    bloc.add(GetItemPriceEvent(
      itemPriceFilters: itemPriceFilters,
    ));
    return Scaffold(
      body: BlocConsumer<ItemPriceBloc, ItemPriceState>(
        listenWhen: (previous, current) =>
            previous.getItemPriceReportsState !=
            current.getItemPriceReportsState,
        listener: (context, state) {
          if (state.getItemPriceReportsState == RequestState.error) {
            Navigator.of(context).pushReplacementNamed(Routes.noDataScreen);
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                errorMessage: state.getItemPriceReportMessage,
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.getItemPriceReportData != current.getItemPriceReportData,
        builder: (context, state) {
          if (state.getItemPriceReportsState == RequestState.loading) {
            return CustomLoadingWithImage();
          }
          if (state.getItemPriceReportsState == RequestState.success) {
            Widget _generateRightHandSideColumnRow(
                BuildContext context, int index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RightHandDetailWidgets(
                      text: state.getItemPriceReportData[index].itemName),
                  RightHandDetailWidgets(
                      text: double.parse(
                              state.getItemPriceReportData[index].priceListRate)
                          .toStringAsFixed(2)),
                  RightHandDetailWidgets(
                      text: state.getItemPriceReportData[index].currency),
                  RightHandDetailWidgets(
                      text: state.getItemPriceReportData[index].priceList),
                ],
              );
            }

            return Scaffold(
              body: ReportTable(
                tableWidth: 400.w,
                appBarName: 'Item Price',
                mainRowList: [
                  'Item Code',
                  'Item Name',
                  'Rate',
                  'Currency',
                  'Price List',
                ],
                leftColumnData: (index) =>
                    state.getItemPriceReportData[index].itemCode,
                table: state.getItemPriceReportData,
                refreshFun: () => BlocProvider.of<ItemPriceBloc>(context).add(
                  GetItemPriceEvent(
                    itemPriceFilters: itemPriceFilters,
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
