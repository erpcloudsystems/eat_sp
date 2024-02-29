import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/modules/new_item/presentation/pages/add_items.dart';
import '../../../provider/user/user_provider.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import '../../../widgets/inherited_widgets/select_items_list.dart';
import '../../list/otherLists.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../models/page_models/stock_page_model/stock_entry_page_model.dart';

const List<String> stockEntryType = [
  'Material Issue',
  'Material Receipt',
  'Material Transfer'
];

class StockEntryForm extends StatefulWidget {
  const StockEntryForm({Key? key}) : super(key: key);

  @override
  _StockEntryFormState createState() => _StockEntryFormState();
}

class _StockEntryFormState extends State<StockEntryForm> {
  final List<ItemQuantity> _items = [];

  Map<String, dynamic> data = {
    "doctype": "Stock Entry",
    'stock_entry_type': stockEntryType[0],
    "posting_date": DateTime.now().toIso8601String(),
  };
  double totalAmount = 0;

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) return;

    if (provider.newItemList.isEmpty) {
      showSnackBar('Please add an item at least', context);
      return;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeAmendingFunction(context, data);

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    data['docstatus'] = 0;
    data['items'] = [];
    // for (var element in _items) {
    //   data['items'].add(element.toJson);
    // }

    /// New Item Set list of item in data item and post request,
    for (var element in provider.newItemList) {
      data['items'].add(element);
    }

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Stock Entry');

    final server = APIService();

    for (var k in data.keys) {
      print("$k: ${data[k]}");
    }
    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(STOCK_ENTRY_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['stock_entry'] != null) {
        context.read<ModuleProvider>().pushPage(res['message']['stock_entry']);
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
  }

  Future<String?> _getActualQty(String warehouse, String itemCode) async {
    try {
      final res = Map<String, dynamic>.from(await APIService().genericGet(
                  'method/ecs_mobile.general.get_actual_qty?warehouse=$warehouse&item_code=$itemCode'))[
              'message']['actual_qty']
          .toString();
      if (res != 'null') {
        return res;
      }
    } catch (e) {
      print('Can\'t get warehouse actual qty because : $e');
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

        final items = StockEntryPageModel(data).items;
        //New Item
        for (var element in items) {
          provider.setItemToList(element);
        }
        // for (var element in items) {
        //   final item = ItemSelectModel.fromJson(element);
        //   _items.add(ItemQuantity(item, qty: item.qty));
        // }

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
        // for (var element in data['items']) {
        //   final item = ItemSelectModel.fromJson(element);
        //   _items.add(ItemQuantity(item, qty: item.qty));
        // }

        /// New Item
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
        print('sdfsdfsd${data['items']}');
        setState(() {});
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    context.read<ModuleProvider>().resetCreationForm();
    // InheritedForm.of(context).items.clear();
  }

  @override
  Widget build(BuildContext context) {
    for (var item in _items) {
      totalAmount += item.total;
    }
    return WillPopScope(
      onWillPop: () async {
        bool? isGoBack = await checkDialog(context, 'Are you sure to go back?');
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
                            data['stock_entry_type'] ?? stockEntryType[0],
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
                    if (data['stock_entry_type'] != stockEntryType[1])
                      CustomTextFieldTest(
                          'from_warehouse', 'Source Warehouse'.tr(),
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['from_warehouse'],
                          clearButton: true,
                          onClear: () {
                            data['from_warehouse'] = null;
                          },
                          onPressed: () async {
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        warehouseScreen(data['to_warehouse'])));
                            if (res != null) data['from_warehouse'] = res;

                            // to update Actual Qty for each item
                            for (var value in _items) {
                              final actualQty = await _getActualQty(
                                  data['from_warehouse'].toString(),
                                  value.itemCode);
                              value.actualQty = actualQty.toString();
                              print('Actual Qty (at source/target) $actualQty');
                            }
                            setState(() {});

                            return res;
                          }),
                    if (data['stock_entry_type'] != stockEntryType[0])
                      CustomTextFieldTest(
                          'to_warehouse', 'Target Warehouse'.tr(),
                          initialValue: data['to_warehouse'],
                          clearButton: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () async {
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => warehouseScreen(
                                        data['from_warehouse'])));
                            if (res != null) data['to_warehouse'] = res;
                            return res;
                          }),
                    CustomTextFieldTest(
                      'project',
                      'Project'.tr(),
                      initialValue: data['project'],
                      disableValidation: true,
                      clearButton: true,
                      onSave: (key, value) => data[key] = value,
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => projectScreen(),
                          ),
                        );
                        return res['name'];
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
               AddItemsWidget(
                haveRate: false,
                 priceList: data['selling_price_list'] ??
                    context.read<UserProvider>().defaultSellingPriceList,
              ),
              // ListView(
              //   children: [
              //     Card(
              //       elevation: 1,
              //       margin: const EdgeInsets.symmetric(
              //           horizontal: 10, vertical: 10),
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(12)),
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(
              //             horizontal: 8.0, vertical: 8),
              //         child: Column(
              //           children: [
              //             Padding(
              //               padding: const EdgeInsets.symmetric(horizontal: 16),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   const Text(
              //                     'Items',
              //                     style: TextStyle(
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w600,
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     width: 40,
              //                     child: ElevatedButton(
              //                       style: ElevatedButton.styleFrom(
              //                           padding: EdgeInsets.zero),
              //                       onPressed: () async {
              //                         final res = await Navigator.of(context)
              //                             .push(MaterialPageRoute(
              //                                 builder: (_) =>
              //                                     itemListScreen('')));

              //                         final actualQty = await _getActualQty(
              //                             data['from_warehouse'].toString(),
              //                             res.itemCode);

              //                         print(
              //                             'Actual Qty (at source/target) $actualQty');

              //                         if (res != null &&
              //                             !_items.contains(res)) {
              //                           setState(() => _items.add(ItemQuantity(
              //                               res,
              //                               actualQty: actualQty.toString())));
              //                         }
              //                       },
              //                       child: const Icon(Icons.add,
              //                           size: 25, color: Colors.white),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             const Divider(),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 ListTitle(
              //                     title: 'Total', value: currency(totalAmount)),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //       child: ConstrainedBox(
              //         constraints: BoxConstraints(
              //             maxHeight: MediaQuery.of(context).size.height * 0.55),
              //         child: _items.isEmpty
              //             ? const Center(
              //                 child: Text('no items added',
              //                     style: TextStyle(
              //                         color: Colors.grey,
              //                         fontStyle: FontStyle.italic,
              //                         fontSize: 16)))
              //             : ListView.builder(
              //                 physics: const BouncingScrollPhysics(),
              //                 padding: const EdgeInsets.only(bottom: 12),
              //                 itemCount: _items.length,
              //                 itemBuilder: (context, index) => Padding(
              //                       padding: const EdgeInsets.symmetric(
              //                           horizontal: 8.0),
              //                       child: Stack(
              //                         alignment: Alignment.bottomCenter,
              //                         children: [
              //                           Container(
              //                             decoration: BoxDecoration(
              //                                 color: Colors.white,
              //                                 borderRadius:
              //                                     const BorderRadius.vertical(
              //                                         bottom:
              //                                             Radius.circular(8)),
              //                                 border: Border.all(
              //                                     color: Colors.blue)),
              //                             margin: const EdgeInsets.only(
              //                                 bottom: 8.0, left: 16, right: 16),
              //                             padding: const EdgeInsets.only(
              //                                 left: 16, right: 16),
              //                             child: Row(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.spaceAround,
              //                               mainAxisSize: MainAxisSize.min,
              //                               children: [
              //                                 Expanded(
              //                                   child: CustomTextField(
              //                                     '${_items[index].itemCode}Quantity',
              //                                     'Quantity',
              //                                     initialValue:
              //                                         _items[index].qty == 0
              //                                             ? null
              //                                             : _items[index]
              //                                                 .qty
              //                                                 .toString(),
              //                                     validator: (value) =>
              //                                         numberValidationToast(
              //                                             value, 'Quantity',
              //                                             isInt: true),
              //                                     keyboardType:
              //                                         TextInputType.number,
              //                                     disableError: true,
              //                                     onSave: (_, value) =>
              //                                         _items[index].qty =
              //                                             int.parse(value),
              //                                     onChanged: (value) {
              //                                       _items[index].qty =
              //                                           int.parse(value);
              //                                       _items[index].total =
              //                                           _items[index].qty *
              //                                               _items[index].rate;
              //                                       Future.delayed(
              //                                           const Duration(
              //                                               seconds: 1),
              //                                           () => setState(() {}));
              //                                     },
              //                                   ),
              //                                 ),
              //                                 Expanded(
              //                                   child: CustomTextField(
              //                                     'uom',
              //                                     'UOM',
              //                                     disableError: true,
              //                                     initialValue:
              //                                         _items[index].stockUom,
              //                                     onPressed: () async {
              //                                       final res =
              //                                           await Navigator.of(
              //                                                   context)
              //                                               .push(
              //                                         MaterialPageRoute(
              //                                           builder: (_) =>
              //                                               filteredUOMListScreen(
              //                                             _items[index]
              //                                                 .itemCode
              //                                                 .toString(),
              //                                           ),
              //                                         ),
              //                                       );

              //                                       if (res != null) {
              //                                         _items[index].stockUom =
              //                                             res['uom'];

              //                                         setState(() {});
              //                                       }
              //                                       return null;
              //                                     },
              //                                     onSave: (_, value) =>
              //                                         _items[index].stockUom =
              //                                             value,
              //                                     onChanged: (value) {
              //                                       _items[index].stockUom =
              //                                           value;
              //                                       Future.delayed(
              //                                           const Duration(
              //                                               seconds: 1),
              //                                           () => setState(() {}));
              //                                     },
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),
              //                           ),
              //                           Padding(
              //                             padding:
              //                                 const EdgeInsets.only(bottom: 62),
              //                             child: Dismissible(
              //                               key: Key(_items[index].itemCode),
              //                               direction:
              //                                   DismissDirection.endToStart,
              //                               onDismissed: (_) => setState(
              //                                   () => _items.removeAt(index)),
              //                               background: Container(
              //                                 decoration: BoxDecoration(
              //                                     borderRadius:
              //                                         BorderRadius.circular(12),
              //                                     color: Colors.red),
              //                                 child: const Align(
              //                                   alignment:
              //                                       Alignment.centerRight,
              //                                   child: Padding(
              //                                     padding: EdgeInsets.all(16),
              //                                     child: Icon(
              //                                       Icons.delete_forever,
              //                                       color: Colors.white,
              //                                       size: 30,
              //                                     ),
              //                                   ),
              //                                 ),
              //                               ),
              //                               child: ItemCard(
              //                                   names: const [
              //                                     'Code',
              //                                     'Group',
              //                                     'UoM',
              //                                     'Actual Qty'
              //                                   ],
              //                                   values: [
              //                                     _items[index].itemName,
              //                                     _items[index].itemCode,
              //                                     _items[index].group,
              //                                     _items[index].stockUom,
              //                                     _items[index].actualQty
              //                                   ],
              //                                   imageUrl:
              //                                       _items[index].imageUrl),
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     )),
              //       ),
              //     )
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
