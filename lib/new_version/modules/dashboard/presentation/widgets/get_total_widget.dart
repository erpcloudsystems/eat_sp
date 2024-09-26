import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../bloc/dasboard_bloc.dart';
import '../bloc/total_bloc/total_bloc.dart';
import '../../../../core/utils/request_state.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../../widgets/new_widgets/icome_widget.dart';
import '../../data/models/get_total_sales_invoice_filters.dart';
import '../../../../../widgets/new_widgets/test_text_field.dart';

class GetTotalWidget extends StatelessWidget {
  const GetTotalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final totalBloc = BlocProvider.of<TotalBloc>(context);
    final dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    totalBloc.add(
      GetTotalEvent(
        totalSalesInvoiceFilters: TotalFilters(
          fromDate: DateTime.now().formatDateYMD(),
          toDate: DateTime.now().formatDateYMD(),
        ),
      ),
    );

    return BlocConsumer<TotalBloc, TotalState>(
      listener: (context, state) {
        if (state.getTotalState == RequestState.error) {
          // showDialog(
          //   context: context,
          //   builder: (context) => ErrorDialog(
          //     errorMessage: state.getDashboardMessage,
          //   ),
          // );
        }
      },
      builder: (context, state) {
        var fromDate = DateTime.now();
        var toDate = DateTime.now();
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    'Filter'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          insetPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.4,
                          ),
                          content: SizedBox(
                            height: 240,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                //____________________________________ Start Date______________________________________________
                                Flexible(
                                  child: DatePickerTest(
                                    'from',
                                    'From Date',
                                    initialValue: null,
                                    onChanged: (value) {
                                      var date = DateTime.parse(value);
                                      fromDate = date;
                                    },
                                  ),
                                ),
                                //____________________________________End Date______________________________________________
                                Flexible(
                                  child: DatePickerTest(
                                    'to',
                                    'TO Date',
                                    onChanged: (value) {
                                      var date = DateTime.parse(value);
                                      toDate = date;
                                    },
                                    initialValue: null,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    dashboardBloc.add(GetDashboardDataEvent(
                                      dateFilter: TotalFilters(
                                        fromDate: fromDate.toString(),
                                        toDate: toDate.toString(),
                                      ),
                                    ));

                                    totalBloc.add(GetTotalEvent(
                                      totalSalesInvoiceFilters: TotalFilters(
                                        fromDate: fromDate.toString(),
                                        toDate: toDate.toString(),
                                      ),
                                    ));

                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Apply'.tr(),
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.sort,
                      size: 25,
                    ),
                  )
                ],
              ),
            ),
            Wrap(
              children: [
                IncomeWidget(
                  docType: DocTypesName.salesInvoice,
                  title: DocTypesName.salesInvoice.tr(),
                  count: state.totalEntity.paidSalesInvoiceEntity['count'],
                  arrowIcon: Icons.arrow_upward,
                  color: Colors.green,
                  total: (state.totalEntity.paidSalesInvoiceEntity?['total'] ??
                          0.00)
                      .toStringAsFixed(2),
                ),
                IncomeWidget(
                  docType: 'Return',
                  title: StringsManager.returns.tr(),
                  total:
                      (state.totalEntity.returnedSalesInvoiceEntity?['total'] ??
                              0.00)
                          .toStringAsFixed(2),
                  count:
                      state.totalEntity.returnedSalesInvoiceEntity['count'] ??
                          0,
                  arrowIcon: Icons.arrow_downward,
                  color: Colors.red,
                ),
                IncomeWidget(
                  docType: DocTypesName.paymentEntry,
                  title: 'DocType.${DocTypesName.paymentEntry}'.tr(),
                  count: state.totalEntity.paymentEntriesEntity['count'] ?? 0,
                  arrowIcon: Icons.arrow_upward,
                  color: Colors.green,
                  total:
                      (state.totalEntity.paymentEntriesEntity?['total'] ?? 0.00)
                          .toStringAsFixed(2),
                ),
                IncomeWidget(
                  docType: DocTypesName.address,
                  title: 'DocType.${DocTypesName.address}'.tr(),
                  count: state.totalEntity.addressEntries['count'] ?? 0,
                  arrowIcon: Icons.arrow_upward,
                  color: Colors.green,
                  isCounted: true,
                ),
                IncomeWidget(
                  docType: DocTypesName.customer,
                  title: 'DocType.${DocTypesName.customer}'.tr(),
                  count: state.totalEntity.addressEntries['count'] ?? 0,
                  arrowIcon: Icons.arrow_upward,
                  color: Colors.green,
                  isCounted: true,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
