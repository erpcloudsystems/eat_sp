import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../provider/user/user_provider.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../new_version/core/resources/strings_manager.dart';
import '../../../widgets/inherited_widgets/select_items_list.dart';
import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../new_version/modules/new_item/presentation/pages/add_items.dart';
import '../../../models/page_models/stock_page_model/stock_entry_page_model.dart';

const List<String> stockEntryType = [
  'Material Issue',
  'Material Receipt',
  'Material Transfer'
];

class StockEntryForm extends StatefulWidget {
  const StockEntryForm({super.key});

  @override
  State<StockEntryForm> createState() => _StockEntryFormState();
}

class _StockEntryFormState extends State<StockEntryForm> {
  final List<ItemQuantity> _items = [];

  Map<String, dynamic> data = {
    "doctype": "Stock Entry",
    'stock_entry_type': stockEntryType[2],
    "posting_date": DateTime.now().toIso8601String(),
  };
  double totalAmount = 0;

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) return;

    if (provider.newItemList.isEmpty) {
      showSnackBar(StringsManager.addItemAtLeast.tr(), context);
      return;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeAmendingFunction(context, data);

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    data['docstatus'] = 0;
    data['items'] = [];
    for (var element in provider.newItemList) {
      data['items'].add(element);
    }

    showLoadingDialog(
        context,
        provider.isEditing
            ? '${StringsManager.updating.tr()} ${provider.pageId}'
            : '${StringsManager.creating.tr()}  ${'DocType.${DocTypesName.stockEntry}'.tr()}');

    final server = APIService();

    for (var k in data.keys) {
      log("$k: ${data[k]}");
    }
    await handleRequest(
            () async => provider.isEditing
                ? await provider.updatePage(data)
                : await server.postRequest(STOCK_ENTRY_POST, {'data': data}),
            context)
        .then((res) {
      Navigator.pop(context);

      if (provider.isEditing && res == false) {
        return;
      } else if (provider.isEditing && res == null) {
        Navigator.pop(context);
      } else if (context.read<ModuleProvider>().isCreateFromPage) {
        if (res != null && res['message']['stock_entry'] != null) {
          context
              .read<ModuleProvider>()
              .pushPage(res['message']['stock_entry']);
        }
        Navigator.of(context)
            .push(MaterialPageRoute(
              builder: (_) => const GenericPage(),
            ))
            .then((value) => Navigator.pop(context));
      } else if (res != null && res['message']['stock_entry'] != null) {
        provider.pushPage(res['message']['stock_entry']);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const GenericPage()));
      }
    });
  }

  Future<String?> _getActualQty(String warehouse, String itemCode) async {
    try {
      final res = Map<String, dynamic>.from(await APIService().genericGet(
                  'method/elkhabaz_mobile.general.get_actual_qty?warehouse=$warehouse&item_code=$itemCode'))[
              'message']['actual_qty']
          .toString();
      if (res != 'null') {
        return res;
      }
    } catch (e) {
      log('Can\'t get warehouse actual qty because : $e');
    }
    return '0';
  }

  @override
  void initState() {
    final provider = context.read<ModuleProvider>();
    super.initState();

    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = provider.updateData;

        // final items = StockEntryPageModel(data).items;
        data['items'].forEach((element) {
          provider.newItemList.add(element);
        });

        if (provider.isAmendingMode) {
          data.remove('amended_to');
          data['docstatus'] = 0;
        }

        setState(() {});
      });
    }

    //DocFromPage Mode
    if (provider.isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;
        data['doctype'] = "Stock Entry";
        InheritedForm.of(context).items.clear();

        data['items'].forEach((element) {
          provider.newItemList.add(element);
        });
        InheritedForm.of(context).data['selling_price_list'] =
            data['selling_price_list'];

        data['from_warehouse'] = data['set_from_warehouse'];
        data['to_warehouse'] = data['set_warehouse'];
        data['stock_entry_type'] = stockEntryType[2];

        data.remove('print_formats');
        data.remove('conn');
        data.remove('comments');
        data.remove('attachments');
        data.remove('docstatus');
        data.remove('name');
        data.remove('_pageData');
        data.remove('_pageId');
        data.remove('_availablePdfFormat');
        data.remove('_currentModule');
        data.remove('status');
        data.remove('organization_lead');
        log('${data['items']}');
        setState(() {});
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    context.read<ModuleProvider>().resetCreationForm();
  }

  @override
  Widget build(BuildContext context) {
    for (var item in _items) {
      totalAmount += item.total;
    }
    return WillPopScope(
      onWillPop: () async {
        bool? isGoBack =
            await checkDialog(context, StringsManager.areYouSureToGoBack.tr());
        if (isGoBack != null) {
          if (isGoBack) {
            return Future.value(true);
          } else {
            return Future.value(false);
          }
        }
        return Future.value(false);
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: CustomPageViewForm(
            submit: () => submit(),
            widgetGroup: [
              Group(
                child: ListView(
                  children: [
                    const SizedBox(height: 4),
                    CustomDropDown('stock_entry_type', 'Stock Entry Type'.tr(),
                        items: stockEntryType,
                        defaultValue:
                            data['stock_entry_type'] ?? stockEntryType[2],
                        enable: false,
                        onChanged: (value) => setState(() {
                              data['stock_entry_type'] = value;
                              if (value == stockEntryType[1]) {
                                data['from_warehouse'] = null;
                              } else if (value == stockEntryType[0]) {
                                data['to_warehouse'] = null;
                              }
                            })),
                    const Divider(
                        color: Colors.grey, height: 1, thickness: 0.7),
                    DatePickerTest('posting_date', 'Date'.tr(),
                        initialValue: data['posting_date'],
                        onChanged: (value) =>
                            setState(() => data['posting_date'] = value)),

                    CustomDropDownFromField(
                        defaultValue: data['from_warehouse'],
                        docType: APIService.WAREHOUSE,
                        nameResponse: 'name',
                        title: 'Source Warehouse'.tr(),
                        keys: const {
                          'subTitle': 'warehouse_name',
                          'trailing': 'warehouse_type',
                        },
                        onChange: (value) async {
                          log('value $value');
                          if (value != null) {
                            data['from_warehouse'] = value['name'];
                          }

                          // to update Actual Qty for each item
                          for (var value in _items) {
                            final actualQty = await _getActualQty(
                                data['from_warehouse'].toString(),
                                value.itemCode);
                            value.actualQty = actualQty.toString();
                            log('Actual Qty (at source/target) $actualQty');
                          }
                          setState(() {});
                        }),

                    CustomDropDownFromField(
                        defaultValue: data['to_warehouse'],
                        docType: APIService.WAREHOUSE,
                        nameResponse: 'name',
                        title: 'Target Warehouse'.tr(),
                        keys: const {
                          'subTitle': 'warehouse_name',
                          'trailing': 'warehouse_type',
                        },
                        onChange: (value) async {
                          setState(() {
                            data['to_warehouse'] = value['name'];
                          });
                        }),
                    // CustomDropDownFromField(
                    //     defaultValue: data['project'],
                    //     docType: APIService.PROJECT,
                    //     nameResponse: 'name',
                    //     isValidate: false,
                    //     keys: const {
                    //       "subTitle": 'project_name',
                    //       "trailing": 'status',
                    //     },
                    //     title: 'Project'.tr(),
                    //     onChange: (value) {
                    //       setState(() {
                    //         data['project'] = value['name'];
                    //       });
                    //     }),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              AddItemsWidget(
                haveRate: false,
                priceList: data['selling_price_list'] ??
                    context.read<UserProvider>().defaultSellingPriceList,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
