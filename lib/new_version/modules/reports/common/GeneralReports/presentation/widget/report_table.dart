import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';

import '../../../../../../../core/constants.dart';
import '../../../../../../core/resources/app_values.dart';
import '../../../../../../core/utils/request_state.dart';
import '../../../../features/stockReports/presentation/bloc/stock_warehouse_report/stockreports_bloc.dart';

final double mainTableBlockWidth = DoublesManager.d_100.w;
final double mainTableBlockHeight = DoublesManager.d_52.h;

class ReportTable extends StatelessWidget {
  const ReportTable({
    Key? key,
    required this.table,
    required this.refreshFun,
    required this.mainRowList,
    required this.appBarName,
    required this.tableWidget,
    required this.leftColumnData,
    required this.tableWidth,
  }) : super(key: key);
  final String appBarName;
  final List table;
  final VoidCallback refreshFun;
  final List<String> mainRowList;
  final Widget Function(BuildContext, int) tableWidget;
  final String Function(int index) leftColumnData;
  final double tableWidth;

  @override
  Widget build(BuildContext context) {
    final isHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final _hdtRefreshController = HDTRefreshController();

    /// Rotate Table
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);

    void onRefresh() {
      refreshFun();
      _hdtRefreshController.loadComplete();
      _hdtRefreshController.refreshCompleted();
    }

    return BlocListener<StockReportsBloc, StockReportsState>(
      listener: (context, state) {
        if (state.hasReachedMax) _hdtRefreshController.loadComplete();
        switch (state.getWarehouseReportsState) {
          case RequestState.stable:
            break;
          case RequestState.loading:
            _hdtRefreshController.requestLoading();
            break;
          case RequestState.success:
            _hdtRefreshController.loadComplete();
            _hdtRefreshController.refreshCompleted();
            break;
          case RequestState.error:
            _hdtRefreshController.loadFailed();
            _hdtRefreshController.refreshFailed();
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarName,
          ),
        ),
        body: HorizontalDataTable(
          leftHandSideColumnWidth: 100.w,
          rightHandSideColumnWidth: tableWidth,
          headerWidgets: _getTitleWidget(),
          leftSideItemBuilder: _generateFirstColumnRow,
          rightSideItemBuilder: tableWidget,
          itemCount: table.length,
          rowSeparatorWidget: const Divider(
            color: Colors.black54,
            height: DoublesManager.d_1,
          ),
          horizontalScrollPhysics:
              isHorizontal ? NeverScrollableScrollPhysics() : null,
          leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
          rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
          htdRefreshController: _hdtRefreshController,
          onLoad: onRefresh,
          onRefresh: refreshFun,
          enablePullToLoadNewData: true,
          enablePullToRefresh: false,
          loadIndicator: ClassicFooter(),
          refreshIndicator: ClassicHeader(),
          isFixedHeader: true,
        ),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return mainRowList.map((i) => _getTitleItemWidget(i)).toList();
  }

  Widget _getTitleItemWidget(String label) {
    return Container(
      child: Text(
        label,
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.bold,
          color: APPBAR_COLOR,
        ),
      ),
      width: mainTableBlockWidth,
      height: DoublesManager.d_56.h,
      padding: EdgeInsets.only(
        left: DoublesManager.d_5,
      ),
      alignment: Alignment.center,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(
        leftColumnData(index),
      ),
      width: mainTableBlockWidth,
      height: mainTableBlockHeight,
      padding: EdgeInsets.only(left: DoublesManager.d_20),
      alignment: Alignment.centerLeft,
    );
  }
}
