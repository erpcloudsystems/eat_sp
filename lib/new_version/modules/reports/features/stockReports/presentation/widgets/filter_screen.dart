import 'package:NextApp/provider/user/user_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../../../new_item/data/models/item_model.dart';
import '../../data/models/warehouse_filters.dart';
import '../../data/models/item_price_filters.dart';
import '../../data/models/stock_ledger_filter.dart';
import '../../../../../../core/resources/routes.dart';
import '../../../../../../../widgets/form_widgets.dart';
import '../../../../../../core/resources/app_radius.dart';
import '../../../../../../../screen/list/otherLists.dart';
import '../../../../../../core/resources/app_values.dart';
import '../../../../../../../provider/module/module_type.dart';
import '../../../../../../core/resources/strings_manager.dart';
import '../../../../../../../provider/module/module_provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? itemCode, itemGroup, priceList, fromDate, toDate, wareHouseName;
  final formKey = GlobalKey<FormState>();
  late final String reportType;
  // We put this flag due to a duplicated error.
  bool isReportTypeInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = context.read<UserProvider>();
    // Default Warehouse
    if (userProvider.warehouseList.isNotEmpty) {
      for (var warehouse in userProvider.warehouseList) {
        if (warehouse.isDefault == 1) {
          wareHouseName = warehouse.docName;
        }
      }
    }
    if (!isReportTypeInitialized) {
      reportType = ModalRoute.of(context)!.settings.arguments as String;
      isReportTypeInitialized = true;
    }
    Provider.of<ModuleProvider>(context).setCurrentModule = ModuleType.item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${reportType.tr()} ${StringsManager.filters.tr()}'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(DoublesManager.d_12),
          child: Column(
            children: [
              /// Warehouse list
              if (reportType != StringsManager.priceList)
                Flexible(
                  child: CustomTextField(
                    'warehouse_name',
                    'Warehouse',
                    clearButton: true,
                    onSave: (key, value) => wareHouseName = value,
                    initialValue: wareHouseName,
                    enabled: wareHouseName == null,
                    onPressed: () async {
                      final res = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => warehouseScreen(),
                        ),
                      );
                      wareHouseName = res;
                      return res;
                    },
                  ),
                ),

              /// From date and to date in stock ledger Report
              if (reportType == StringsManager.stockLedger)
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        child: DatePicker('transaction_date', 'From Date'.tr(),
                            disableValidation: false,
                            clear: true,
                            onChanged: (value) => fromDate = value),
                      ),
                      const SizedBox(width: DoublesManager.d_10),
                      Flexible(
                        child: DatePicker('delivery_date', 'To Date',
                            clear: true,
                            disableValidation: false,
                            onChanged: (value) => toDate = value),
                      ),
                    ],
                  ),
                ),

              ///Price List
              if (reportType == StringsManager.priceList)
                Flexible(
                  child: CustomTextField(
                    'price_list',
                    'Price List',
                    clearButton: true,
                    onSave: (key, value) => priceList = value,
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
                    final NewItemModel res = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => newItemsScreen(),
                      ),
                    );
                    itemCode = res.itemCode;
                    return res.itemCode;
                  },
                ),
              ),
              const SizedBox(height: DoublesManager.d_10),

              /// Item group list
              if (reportType != StringsManager.wareHouseReport)
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
                      return res;
                    },
                  ),
                ),
              const SizedBox(height: DoublesManager.d_20),

              /// Apply filter button
              InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    if (reportType == StringsManager.wareHouseReport) {
                      final filters = WarehouseFilters(
                        warehouseFilter: wareHouseName!,
                        itemFilter: itemCode,
                      );
                      Navigator.of(context).pushNamed(
                        Routes.warehouseReportsScreen,
                        arguments: filters,
                      );
                    } else if (reportType == StringsManager.stockLedger) {
                      final filters = StockLedgerFilters(
                        warehouseFilter: wareHouseName!,
                        itemCode: itemCode,
                        itemGroup: itemGroup,
                        fromDate: fromDate!,
                        toDate: toDate!,
                      );
                      Navigator.of(context).pushNamed(
                        Routes.stockLedgerReportScreen,
                        arguments: filters,
                      );
                    } else if (reportType == StringsManager.priceList) {
                      final filters = ItemPriceFilters(
                        priceList: priceList!,
                        itemCode: itemCode,
                        itemGroup: itemGroup,
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
                      StringsManager.applyFilters.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: DoublesManager.d_10),
            ],
          ),
        ),
      ),
    );
  }
}
