import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/modules/new_item/presentation/pages/add_items.dart';
import '../../../provider/user/user_provider.dart';
import '../../../test/custom_page_view_form.dart';
import '../../../test/test_text_field.dart';
import '../../list/otherLists.dart';
import '../../../core/constants.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/inherited_widgets/select_items_list.dart';
import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../models/page_models/stock_page_model/material_request_page_model.dart';

const List<String> purposeType = [
  'Purchase',
  'Material Transfer',
  'Material Issue',
  'Manufacture',
  'Customer Provided',
];

class MaterialRequestForm extends StatefulWidget {
  const MaterialRequestForm({Key? key}) : super(key: key);

  @override
  _MaterialRequestFormState createState() => _MaterialRequestFormState();
}

class _MaterialRequestFormState extends State<MaterialRequestForm> {
  final List<ItemQuantity> _items = [];

  Map<String, dynamic> data = {
    "doctype": "Material Request",
    'material_request_type': purposeType[0],
    "transaction_date": DateTime.now().toIso8601String(),
  };
  double totalAmount = 0;

  Map<String, dynamic> selectedCstData = {
    'name': 'noName',
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) {
      showSnackBar(KFillRequiredSnackBar, context);
      return;
    }
    if (provider.newItemList.isEmpty) {
      showSnackBar('Please add an item at least', context);
      return;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeAmendingFunction(context, data);

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    data['items'] = [];

    // for (var element in _items) {
    //   data['items'].add(element.toJson);
    // }
    for (var element in provider.newItemList) {
      data['items'].add(element);
    }

    final server = APIService();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Material Request');

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(MATERIAL_REQUEST_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['material_request_name'] != null) {
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['material_request_name']);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['material_request_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['material_request_name']);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GenericPage()));
    }
  }

  Future<void> _getCustomerData(String customer) async {
    selectedCstData = Map<String, dynamic>.from(
        await APIService().getPage(CUSTOMER_PAGE, customer))['message'];
  }

  @override
  void initState() {
    super.initState();

    final provider = context.read<ModuleProvider>();

    //Editing Mode
    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = provider.updateData;

        final items = MaterialRequestPageModel(context, data).items;
        //New Item
        for (var element in items) {
          provider.setItemToList(element);
        }

        for (var element in items) {
          final item = ItemSelectModel.fromJson(element);
          _items.add(ItemQuantity(item, qty: item.qty));
        }

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
        data = provider.createFromPageData;
        InheritedForm.of(context).items.clear();

        // data['items'].forEach((element) {
        //   InheritedForm.of(context)
        //       .items
        //       .add(ItemSelectModel.fromJson(element));
        // });
        data['items'].forEach((element) {
          provider.newItemList.add(element);
        });

        data['doctype'] = "Material Request";
        data['material_request_type'] = purposeType[0];

        data['transaction_date'] = DateTime.now().toIso8601String();

        // from Sales Order
        data['sales_order'] = data['name'];

        _getCustomerData(data['customer_name'])
            .then((value) => setState(() {}));

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
        print('${data['items']}');
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
    InheritedForm.of(context).data['selling_price_list'] = '';
    for (var item in _items) {
      totalAmount += item.total;
    }
    return WillPopScope(
      onWillPop: () async {
        bool? isGoBack =
            await checkDialog(context, 'Are you sure to go back?'.tr());
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
                    CustomDropDown('material_request_type', 'Purpose'.tr(),
                        items: purposeType,
                        defaultValue:
                            data['material_request_type'] ?? purposeType[0],
                        onChanged: (value) => setState(() {
                              data['material_request_type'] = value;
                              data['set_from_warehouse'] = null;
                              data['set_warehouse'] = null;
                            })),
                    const Divider(
                        color: Colors.grey, height: 1, thickness: 0.7),
                    if (data['material_request_type'] == purposeType[4])
                      CustomTextFieldTest(
                        'customer',
                        'Customer',
                        initialValue: data['customer'],
                        onPressed: () async {
                          String? id;
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      selectCustomerScreen()));
                          if (res != null) {
                            id = res['name'];
                            setState(() {
                              data['customer'] = res['name'];
                            });
                          }

                          return id;
                        },
                      ),
                    Row(children: [
                      Flexible(
                          child: DatePickerTest(
                        'transaction_date',
                        'Transaction Date'.tr(),
                        initialValue: data['transaction_date'],
                        onChanged: (value) =>
                            setState(() => data['transaction_date'] = value),
                      )),
                      const SizedBox(width: 10),
                      Flexible(
                          child: DatePickerTest(
                        'schedule_date',
                        'Required By Date'.tr(),
                        onChanged: (value) =>
                            setState(() => data['schedule_date'] = value),
                        initialValue: data['schedule_date'],
                        disableValidation: false,
                      )),
                    ]),
                    if (data['material_request_type'] == purposeType[1])
                      CustomTextFieldTest(
                          'set_from_warehouse', 'Source Warehouse'.tr(),
                          initialValue: data['set_from_warehouse'],
                          liestenToInitialValue: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () async {
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => warehouseScreen(
                                        data['set_warehouse'])));
                            if (res != null) data['set_from_warehouse'] = res;
                            return res;
                          }),
                    CustomTextFieldTest(
                        'set_warehouse', 'Target Warehouse'.tr(),
                        initialValue: data['set_warehouse'],
                        liestenToInitialValue: true,
                        disableValidation: true,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => warehouseScreen(
                                      data['set_from_warehouse'])));
                          if (res != null) data['set_warehouse'] = res;
                          return res;
                        }),
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
              //                   const Text('Items',
              //                       style: TextStyle(
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w600)),
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
              //                         if (res != null &&
              //                             !_items.contains(res)) {
              //                           setState(() =>
              //                               _items.add(ItemQuantity(res)));
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
              //                                   MainAxisAlignment.spaceEvenly,
              //                               children: [
              //                                 Expanded(
              //                                     child: CustomTextField(
              //                                   '${_items[index].itemCode}Quantity',
              //                                   'Quantity',
              //                                   initialValue:
              //                                       _items[index].qty == 0
              //                                           ? null
              //                                           : _items[index]
              //                                               .qty
              //                                               .toString(),
              //                                   validator: (value) =>
              //                                       numberValidationToast(
              //                                           value, 'Quantity',
              //                                           isInt: true),
              //                                   keyboardType:
              //                                       TextInputType.number,
              //                                   disableError: true,
              //                                   onSave: (_, value) =>
              //                                       _items[index].qty =
              //                                           int.parse(value),
              //                                   onChanged: (value) {
              //                                     _items[index].qty =
              //                                         int.parse(value);
              //                                     _items[index].total =
              //                                         _items[index].qty *
              //                                             _items[index].rate;
              //                                     Future.delayed(
              //                                         const Duration(
              //                                             seconds: 1),
              //                                         () => setState(() {}));
              //                                   },
              //                                 )),
              //                                 const SizedBox(width: 12),
              //                                 Expanded(
              //                                     child: CustomTextField(
              //                                   'uom',
              //                                   'UOM',
              //                                   disableError: true,
              //                                   initialValue: _items[index]
              //                                       .stockUom
              //                                       .toString(),
              //                                   onPressed: () async {
              //                                     final res = await Navigator
              //                                             .of(context)
              //                                         .push(MaterialPageRoute(
              //                                             builder: (_) =>
              //                                                 filteredUOMListScreen(
              //                                                     _items[index]
              //                                                         .itemCode
              //                                                         .toString())));
              //                                     print(res['uom']);
              //                                     _items[index].stockUom =
              //                                         res['uom'];
              //                                     return res['uom'];
              //                                   },
              //                                 )),
              //                                 const SizedBox(width: 12),
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
              //                                     'UoM'
              //                                   ],
              //                                   values: [
              //                                     _items[index].itemName,
              //                                     _items[index].itemCode,
              //                                     _items[index].group,
              //                                     _items[index].stockUom
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
