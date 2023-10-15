import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../bloc/dasboard_bloc.dart';
import '../bloc/total_bloc/total_bloc.dart';
import '../../../../../core/constants.dart';
import '../../../../../test/icome_widget.dart';
import '../../../../core/utils/error_dialog.dart';
import '../../../../../test/test_text_field.dart';
import '../../../../core/utils/request_state.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../data/models/get_total_sales_invoice_filters.dart';
import '../../../../core/extensions/date_time_extension.dart';

class GetTotalWidget extends StatelessWidget {
  const GetTotalWidget({Key? key}) : super(key: key);

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
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              errorMessage: state.getDashboardMessage,
            ),
          );
        }
      },
      builder: (context, state) {
        var fromDate = DateTime.now();
        var toDate = DateTime.now();
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
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
              child: Container(
                width: 90,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                margin: const EdgeInsets.only(bottom: 8, right: 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.filter_alt_outlined,
                      size: 20,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 290,
              child: GridView.count(
                scrollDirection: Axis.horizontal,
                crossAxisCount: 2,
                childAspectRatio: .9,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  IncomeWidget(
                    docType: DocTypesName.customerVisit,
                    isCounted: true,
                    title: 'DocType.${DocTypesName.customerVisit}'.tr(),
                    arrowIcon: Icons.person_outline_rounded,
                    color: APPBAR_COLOR,
                    total: state.totalEntity.customerVisitEntity['count']
                        .toString(),
                  ),
                  IncomeWidget(
                    docType: DocTypesName.salesInvoice,
                    title: StringsManager.sales.tr(),
                    count: state.totalEntity.paidSalesInvoiceEntity['count']
                        .toString(),
                    arrowIcon: Icons.arrow_upward,
                    color: Colors.green,
                    total: state.totalEntity.paidSalesInvoiceEntity['total']
                        .toString(),
                  ),
                  IncomeWidget(
                    docType: DocTypesName.quotation,
                    title: 'DocType.${StringsManager.quotation}'.tr(),
                    arrowIcon: Icons.money,
                    color: Colors.green,
                    total:
                        state.totalEntity.quotationsEntity['total'].toString(),
                    count:
                        state.totalEntity.quotationsEntity['count'].toString(),
                  ),
                  IncomeWidget(
                    docType: DocTypesName.salesInvoice,
                    filters: const {
                      'filter1': 'Return',
                    },
                    title: StringsManager.returns.tr(),
                    total: state.totalEntity.returnedSalesInvoiceEntity['total']
                        .toString(),
                    count: state.totalEntity.returnedSalesInvoiceEntity['count']
                        .toString(),
                    arrowIcon: Icons.arrow_downward,
                    color: Colors.red,
                  ),
                  IncomeWidget(
                    docType: DocTypesName.salesOrder,
                    title: 'DocType.${DocTypesName.salesOrder}'.tr(),
                    total:
                        state.totalEntity.salesOrderEntity['total'].toString(),
                    count:
                        state.totalEntity.salesOrderEntity['count'].toString(),
                    arrowIcon: Icons.request_quote_outlined,
                    color: APPBAR_COLOR,
                  ),
                  IncomeWidget(
                    docType: DocTypesName.paymentEntry,
                    title: 'DocType.${DocTypesName.paymentEntry}'.tr(),
                    count: state.totalEntity.paymentEntriesEntity['count']
                        .toString(),
                    arrowIcon: Icons.arrow_upward,
                    color: Colors.green,
                    total: state.totalEntity.paymentEntriesEntity['total']
                        .toString(),
                  ),
                  IncomeWidget(
                    docType: DocTypesName.stockEntry,
                    isCounted: true,
                    title: 'DocType.${DocTypesName.stockEntry}'.tr(),
                    arrowIcon: Icons.input,
                    color: APPBAR_COLOR,
                    total: state.totalEntity.stockEntries['count'].toString(),
                  ),
                  IncomeWidget(
                    docType: DocTypesName.deliveryNote,
                    title: 'DocType.${DocTypesName.deliveryNote}'.tr(),
                    arrowIcon: Icons.money,
                    color: Colors.green,
                    total: state.totalEntity.deliveryNotes['total'].toString(),
                    count: state.totalEntity.deliveryNotes['count'].toString(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
