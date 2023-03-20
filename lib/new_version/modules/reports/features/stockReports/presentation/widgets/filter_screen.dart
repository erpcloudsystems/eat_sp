import 'package:NextApp/new_version/core/resources/routes.dart';
import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:NextApp/new_version/modules/reports/common/GeneralReports/presentation/widget/report_charts.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/data/models/item_price_filters.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/data/models/stock_ledger_filter.dart';
import 'package:NextApp/new_version/modules/reports/features/stockReports/data/models/warehouse_filters.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../../../../../screen/list/otherLists.dart';
import '../../../../../../../widgets/form_widgets.dart';
import '../../../../../../core/resources/app_radius.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? wareHouseName;
    String? itemCode;
    String? itemGroup;
    String? priceList;
    final reportType = ModalRoute.of(context)!.settings.arguments;
    var formKey = GlobalKey<FormState>();
    String? fromDate;
    String? toDate;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$reportType Filters',
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              /// Warehouse list
              if (reportType != AppStrings.priceList)
                Flexible(
                  child: CustomTextField(
                    'warehouse_name',
                    'Warehouse',
                    clearButton: true,
                    onSave: (key, value) {
                      print(value);
                      wareHouseName = value;
                    },
                    onPressed: () async {
                      final res = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => warehouseScreen(),
                        ),
                      );
                      print(res);
                      return res;
                    },
                  ),
                ),

              /// From date and to date in stock ledger Report
              if (reportType == AppStrings.stockLedger)
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        child: DatePicker(
                          'transaction_date',
                          'From Date'.tr(),
                          disableValidation: false,
                          clear: true,
                          onChanged: (value) {
                            fromDate = value;
                            print(fromDate);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: DatePicker(
                          'delivery_date',
                          'To Date',
                          clear: true,
                          disableValidation: false,
                          onChanged: (value) {
                            toDate = value;
                            print(toDate);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              ///Price List
              if (reportType == AppStrings.priceList)
                Flexible(
                  child: CustomTextField(
                    'price_list',
                    'Price List',
                    clearButton: true,
                    onSave: (key, value) {
                      priceList = value;
                    },
                    onPressed: () async {
                      final res = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => priceListScreen(),
                        ),
                      );
                      return res['name'];
                    },
                  ),
                ),

              /// Item code list
              Flexible(
                child: CustomTextField(
                  'item_code',
                  'Item Code',
                  disableValidation: true,
                  clearButton: true,
                  onClear: () {
                    itemCode = null;
                  },
                  onPressed: () async {
                    final ItemSelectModel res =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => itemListScreen(''),
                      ),
                    );
                    itemCode = res.itemCode;
                    return res.itemCode;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),

              /// Item group list
              if (reportType != AppStrings.wareHouseReport)
                Flexible(
                  child: CustomTextField(
                    'item_group',
                    'Item Group',
                    clearButton: true,
                    disableValidation: true,
                    onClear: () {
                      itemGroup = null;
                    },
                    onPressed: () async {
                      final res = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => itemGroupScreen(),
                        ),
                      );
                      itemGroup = res;
                      print(itemGroup);
                      return res;
                    },
                  ),
                ),
              SizedBox(
                height: 20,
              ),

              /// Apply filter button
              InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    if (reportType == AppStrings.wareHouseReport) {
                      final filters = WarehouseFilters(
                        warehouseFilter: wareHouseName!,
                        itemFilter: itemCode != null ? itemCode : null,
                      );
                      Navigator.of(context).pushNamed(
                        Routes.warehouseReportsScreen,
                        arguments: filters,
                      );
                    } else if (reportType == AppStrings.stockLedger) {
                      final filters = StockLedgerFilters(
                        warehouseFilter: wareHouseName!,
                        itemCode: itemCode != null ? itemCode : null,
                        itemGroup: itemGroup != null ? itemGroup : null,
                        fromDate: fromDate!,
                        toDate: toDate!,
                      );
                      Navigator.of(context).pushNamed(
                        Routes.stockLedgerReportScreen,
                        arguments: filters,
                      );
                    } else if (reportType == AppStrings.priceList) {
                      final filters = ItemPriceFilters(
                        priceList: priceList!,
                        itemCode: itemCode != null ? itemCode : null,
                        itemGroup: itemGroup != null ? itemGroup : null,
                      );
                      Navigator.of(context).pushNamed(
                        Routes.priceListReportScreen,
                        arguments: filters,
                      );
                    }
                  }
                },
                child: Container(
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: AppRadius.radius10,
                  ),
                  child: Center(
                    child: Text(
                      'Apply Filter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
