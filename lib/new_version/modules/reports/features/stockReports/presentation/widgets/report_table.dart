import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import '../../../../../../../core/constants.dart';
import '../../../../../../core/resources/app_values.dart';
import '../../../../../../core/utils/request_state.dart';
import '../../domain/entities/warehouse_report_entity.dart';
import '../bloc/stockreports_bloc.dart';

final double mainTableBlockWidth = DoublesManager.d_100.w;
final double mainTableBlockHeight = DoublesManager.d_52.h;

class ReportTable extends StatelessWidget {
  const ReportTable({
    Key? key,
    required this.table,
    required this.refreshFun,
  }) : super(key: key);
  final List<WarehouseReportEntity> table;
  final VoidCallback refreshFun;

  @override
  Widget build(BuildContext context) {
    final isHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final hdtRefreshController = HDTRefreshController();

    /// Rotate Table
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);

    void onRefresh() {
      refreshFun();
      hdtRefreshController.loadComplete();
      hdtRefreshController.refreshCompleted();
    }

    return BlocListener<StockReportsBloc, StockReportsState>(
      listener: (context, state) {
        if (state.hasReachedMax) hdtRefreshController.loadComplete();
        switch (state.getWarehouseReportsState) {
          case RequestState.stable:
            break;
          case RequestState.loading:
            hdtRefreshController.requestLoading();
            break;
          case RequestState.success:
            hdtRefreshController.loadComplete();
            hdtRefreshController.refreshCompleted();
            break;
          case RequestState.error:
            hdtRefreshController.loadFailed();
            hdtRefreshController.refreshFailed();
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Warehouse Stock balance',
          ),
        ),
        body: HorizontalDataTable(
          leftHandSideColumnWidth: 100.w,
          rightHandSideColumnWidth: 400.w,
          headerWidgets: _getTitleWidget(),
          leftSideItemBuilder: _generateFirstColumnRow,
          rightSideItemBuilder: _generateRightHandSideColumnRow,
          itemCount: table.length,
          rowSeparatorWidget: const Divider(
            color: Colors.black54,
            height: DoublesManager.d_1,
          ),
          horizontalScrollPhysics:
              isHorizontal ? const NeverScrollableScrollPhysics() : null,
          leftHandSideColBackgroundColor: const Color(0xFFFFFFFF),
          rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
          htdRefreshController: hdtRefreshController,
          onLoad: onRefresh,
          onRefresh: refreshFun,
          enablePullToLoadNewData: true,
          enablePullToRefresh: false,
          loadIndicator: const ClassicFooter(),
          refreshIndicator: const ClassicHeader(),
          isFixedHeader: true,
        ),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Item Code'),
      _getTitleItemWidget('Item Name'),
      _getTitleItemWidget('Actual Quantity'),
      _getTitleItemWidget('Stock UOM'),
      _getTitleItemWidget('Item Group'),
    ];
  }

  Widget _getTitleItemWidget(String label) {
    return Container(
      width: mainTableBlockWidth,
      height: DoublesManager.d_56.h,
      padding: const EdgeInsets.only(left: DoublesManager.d_5),
      alignment: Alignment.center,
      child: Text(label,
          style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold, color: APPBAR_COLOR)),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: mainTableBlockWidth,
      height: mainTableBlockHeight,
      padding: const EdgeInsets.only(left: DoublesManager.d_20),
      alignment: Alignment.centerLeft,
      child: Text(table[index].itemCode),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RightHandDetailWidgets(text: table[index].itemName),
        RightHandDetailWidgets(text: table[index].actualQty.toString()),
        RightHandDetailWidgets(text: table[index].stockUom),
        RightHandDetailWidgets(text: table[index].itemGroup),
      ],
    );
  }
}

class RightHandDetailWidgets extends StatelessWidget {
  const RightHandDetailWidgets({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mainTableBlockWidth,
      height: mainTableBlockHeight,
      padding: const EdgeInsets.only(left: DoublesManager.d_20),
      alignment: Alignment.center,
      child: Text(text),
    );
  }
}
