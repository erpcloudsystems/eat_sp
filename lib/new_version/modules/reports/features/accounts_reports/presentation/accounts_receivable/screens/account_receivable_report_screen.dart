import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../widgets/custom_loading.dart';
import '../../../../../../../core/resources/routes.dart';
import '../../../../../../../core/resources/strings_manager.dart';
import '../../../../../../../core/utils/error_dialog.dart';
import '../../../../../../../core/utils/request_state.dart';
import '../../../../../common/GeneralReports/presentation/widget/report_table.dart';
import '../../../../../common/GeneralReports/presentation/widget/right_hand_data_table.dart';
import '../../../data/models/accounts_receivable_filters.dart';
import '../bloc/accounts_receivable_bloc_bloc.dart';

class AccountReceivableReportScreen extends StatelessWidget {
  const AccountReceivableReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AccountsReceivableBloc>(context);
    bloc.add(const ResetAccountReceivableReportEvent());

    final accountReceivableFilters =
        ModalRoute.of(context)!.settings.arguments as AccountReceivableFilters;

    bloc.add(
        GetAccountReceivableReportEvent(filters: accountReceivableFilters));

    return Scaffold(
      body: BlocConsumer<AccountsReceivableBloc, AccountsReceivableState>(
        listenWhen: (previous, current) =>
            previous.accountsReceivableReportState !=
            current.accountsReceivableReportState,
        listener: (context, state) {
          if (state.accountsReceivableReportState == RequestState.error) {
            Navigator.of(context).pushReplacementNamed(Routes.noDataScreen);
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                  errorMessage: state.accountReceivableReportMessage),
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.accountReceivableReportData !=
            current.accountReceivableReportData,
        builder: (context, state) {
          if (state.accountsReceivableReportState == RequestState.loading) {
            return const CustomLoadingWithImage();
          }
          if (state.accountsReceivableReportState == RequestState.success) {
            Widget generateRightHandSideColumnRow(
                BuildContext context, int index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RightHandDetailWidgets(
                      text: state
                          .accountReceivableReportData[index].customerCode
                          .toString()),
                  RightHandDetailWidgets(
                      text: state
                          .accountReceivableReportData[index].outstandingAmount
                          .toString()),
                  RightHandDetailWidgets(
                      text:
                          state.accountReceivableReportData[index].salesPerson),
                  RightHandDetailWidgets(
                      text: state.accountReceivableReportData[index].date),
                ],
              );
            }

            return Scaffold(
              body: ReportTable(
                tableWidth: 400.w,
                appBarName: StringsManager.accountsReceivable.tr(),
                mainRowList: const [
                  StringsManager.customerName,
                  StringsManager.customerCode,
                  StringsManager.outstandingAmount,
                  StringsManager.salesPerson,
                  StringsManager.date,
                ],
                leftColumnData: (index) =>
                    state.accountReceivableReportData[index].customerName,
                table: state.accountReceivableReportData,
                refreshFun: () =>
                    BlocProvider.of<AccountsReceivableBloc>(context).add(
                        GetAccountReceivableReportEvent(
                            filters: accountReceivableFilters)),
                tableWidget: generateRightHandSideColumnRow,
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
