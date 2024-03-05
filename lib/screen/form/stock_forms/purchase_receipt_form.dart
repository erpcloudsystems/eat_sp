import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/modules/new_item/presentation/pages/add_items.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import '../../list/otherLists.dart';
import '../../../core/constants.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../provider/user/user_provider.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/page_models/model_functions.dart';
import '../../../new_version/core/resources/strings_manager.dart';
import '../../../widgets/inherited_widgets/select_items_list.dart';
import '../../../models/page_models/stock_page_model/purchase_receipt_page_model.dart';

const List<String> grandTotalList = ['Grand Total', 'Net Total'];

class PurchaseReceiptForm extends StatefulWidget {
  const PurchaseReceiptForm({Key? key}) : super(key: key);

  @override
  _PurchaseReceiptFormState createState() => _PurchaseReceiptFormState();
}

class _PurchaseReceiptFormState extends State<PurchaseReceiptForm> {
  String? _terms;

  Map<String, dynamic> data = {
    "doctype": "Purchase Receipt",
    "posting_date": DateTime.now().toIso8601String(),
    "is_return": 0,
    'is_subcontracted': 0,
    // 'bill_no': '',
  };

  Map<String, dynamic> selectedSupplierData = {
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

    // data['docstatus'] = 0;
    data['items'] = [];
    data['taxes'] =
        (provider.isEditing) ? [] : context.read<UserProvider>().defaultTax;

    // InheritedForm.of(context).items.forEach((element) {
    //   if (data['is_return'] == 1) element.qty = element.qty * -1;
    //   data['items'].add(element.toJson);
    // });
    for (var element in provider.newItemList) {
      data['items'].add(element);
    }

    // if (data['items'][0]['rate'] == 0.0 || data['items'][0]['rate'] == "") {
    //   showSnackBar('net rate is Zero', context);
    //   return;
    // }

    //DocFromPage Mode from Sales Order
    // data['items'].forEach((element) {
    //   element['purchase_invoice'] = data['purchase_invoice'];
    // });

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Purchase Receipt');

    final server = APIService();

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(PURCHASE_RECEIPT_POST, {'data': data}),
        context);

    Navigator.pop(context);
    InheritedForm.of(context).data['buying_price_list'] = null;

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['purchase_receipt'] != null) {
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['purchase_receipt']);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['purchase_receipt'] != null) {
      provider.pushPage(res['message']['purchase_receipt']);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GenericPage()));
    }
  }

  Future<void> _getSupplierData(String supplier) async {
    selectedSupplierData = Map<String, dynamic>.from(
        await APIService().getPage(SUPPLIER_PAGE, supplier))['message'];
  }

  @override
  void initState() {
    var provider = context.read<ModuleProvider>();
    super.initState();
    //Editing Mode
    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        InheritedForm.of(context).data['buying_price_list'] =
            data['buying_price_list'];

        _getSupplierData(data['supplier']).then((value) => setState(() {
              selectedSupplierData['address_line1'] =
                  formatDescription(data['address_line1']);
              selectedSupplierData['city'] = data['city'];
              selectedSupplierData['country'] = data['country'];

              selectedSupplierData['contact_display'] = data['contact_display'];
              selectedSupplierData['mobile_no'] = data['mobile_no'];
              selectedSupplierData['phone'] = data['phone'];
              selectedSupplierData['email_id'] = data['email_id'];
            }));

        final items = PurchaseReceiptPageModel(context, data).items;

        //New Item
        for (var element in items) {
          provider.setItemToList(element);
        }
        // for (var element in items) {
        //   InheritedForm.of(context)
        //       .items
        //       .add(ItemSelectModel.fromJson(element));
        // }
      });
    }

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;

        InheritedForm.of(context).items.clear();

        data['posting_date'] = DateTime.now().toIso8601String();
        data['is_return'] = 0;
        data['is_subcontracted'] = 0;
        data['bill_no'] = '';
        data['longitude'] = 0.0;
        data['conversion_rate'] = 1;

        // From Purchase Order:
        if (data['doctype'] == DocTypesName.purchaseOrder) {
          data['purchase_invoice_item'].forEach((element) {
            provider.newItemList.add(element);
          });

          InheritedForm.of(context).data['buying_price_list'] =
              data['buying_price_list'];

          data['purchase_receipt'] = data['name'];
          data['project'] = data['project'];
        }

        // from Purchase Invoice
        if (data['doctype'] == 'Purchase Invoice') {
          // data['purchase_invoice_item'].forEach((element) {
          //   InheritedForm.of(context)
          //       .items
          //       .add(ItemSelectModel.fromJson(element));
          // });
          data['purchase_invoice_item'].forEach((element) {
            provider.newItemList.add(element);
          });
          InheritedForm.of(context).data['buying_price_list'] =
              data['buying_price_list'];

          data['purchase_invoice'] = data['name'];
          data['project'] = data['project'];
        }

        _getSupplierData(data['supplier']).then((value) => setState(() {
              // if (data['buying_price_list'] !=
              //     selectedSupplierData['default_price_list']) {
              //   data['buying_price_list'] =
              //       selectedSupplierData['default_price_list'];

              //   InheritedForm.of(context).data['buying_price_list'] =
              //       selectedSupplierData['default_price_list'];
              // }
              // data['currency'] = selectedSupplierData['default_currency'];
              // data['price_list_currency'] =
              //     selectedSupplierData['default_currency'];
              // data['payment_terms_template'] = selectedSupplierData['payment_terms'];
              // data['supplier_address'] =
              //     selectedSupplierData["customer_primary_address"];
              // data['contact_person'] =
              //     selectedSupplierData["customer_primary_contact"];
            }));

        data['doctype'] = "Purchase Receipt";
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

        if (provider.isAmendingMode) {
          data.remove('amended_to');
          data['docstatus'] = 0;
        }
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
    final userProvider = context.read<UserProvider>();
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
                    CustomTextFieldTest(
                      'supplier',
                      'Supplier',
                      initialValue: data['supplier'],
                      onPressed: () async {
                        String? id;
                        final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => selectSupplierScreen()));
                        if (res != null) {
                          id = res['name'];
                          await _getSupplierData(res['name']);
                          // selectedSupplierData = Map<String, dynamic>.from(
                          //     await APIService().getPage(
                          //         SUPPLIER_PAGE, res['name']))['message'];
                          setState(() {
                            // data['name'] = res['name'];
                            data['supplier'] = res['name'];
                            data['supplier_name'] = res['supplier_name'];
                            // data['tax_id'] = selectedSupplierData["tax_id"];
                            data['supplier_address'] = selectedSupplierData[
                                "supplier_primary_address"];
                            data['contact_person'] = selectedSupplierData[
                                "supplier_primary_contact"];
                            // data['contact_mobile'] =
                            // selectedSupplierData["mobile_no"];
                            // data['contact_email'] =
                            // selectedSupplierData["email_id"];
                            data['currency'] =
                                selectedSupplierData['default_currency'];
                            if (data['buying_price_list'] != null ||
                                data['buying_price_list'] != '') {
                              data['buying_price_list'] =
                                  selectedSupplierData['default_price_list'];
                              InheritedForm.of(context).items.clear();
                              InheritedForm.of(context)
                                      .data['buying_price_list'] =
                                  selectedSupplierData['default_price_list'];
                            }
                            data['price_list_currency'] =
                                selectedSupplierData['default_currency'];
                          });
                        }
                        return id;
                      },
                    ),
                    Row(children: [
                      Flexible(
                          child: DatePickerTest(
                        'posting_date',
                        'Date'.tr(),
                        initialValue: data['posting_date'] ?? 'none',
                        onChanged: (value) =>
                            setState(() => data['posting_date'] = value),
                      )),
                    ]),
                    CustomExpandableTile(
                      hideArrow: data['supplier'] == null,
                      title: CustomTextFieldTest(
                          'supplier_address', 'Supplier Address',
                          initialValue: data['supplier_address'],
                          disableValidation: true,
                          clearButton: false,
                          onSave: (key, value) => data[key] = value,
                          liestenToInitialValue:
                              data['supplier_address'] == null,
                          onPressed: () async {
                            if (data['supplier'] == null) {
                              return showSnackBar(
                                  'Please select a supplier to first', context);
                            }
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => customerAddressScreen(
                                        data['supplier'])));
                            setState(() {
                              data['supplier_address'] = res['name'];
                              selectedSupplierData['address_line1'] =
                                  res['address_line1'];
                              selectedSupplierData['city'] = res['city'];
                              selectedSupplierData['country'] = res['country'];
                            });
                            return res['name'];
                          }),
                      children: (data['supplier_address'] != null)
                          ? <Widget>[
                              ListTile(
                                trailing: const Icon(Icons.location_on),
                                title: Text(
                                    selectedSupplierData['address_line1'] ??
                                        ''),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.location_city),
                                title: Text(selectedSupplierData['city'] ?? ''),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.flag),
                                title:
                                    Text(selectedSupplierData['country'] ?? ''),
                              )
                            ]
                          : null,
                    ),
                    CustomExpandableTile(
                      hideArrow: data['supplier'] == null,
                      title: CustomTextFieldTest(
                          'contact_person', 'Contact Person',
                          initialValue: data['contact_person'],
                          disableValidation: true,
                          clearButton: false,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () async {
                            if (data['supplier'] == null) {
                              showSnackBar('Please select a supplier', context);
                              return null;
                            }
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        contactScreen(data['supplier'])));
                            setState(() {
                              data['contact_person'] = res['name'];
                              selectedSupplierData['contact_display'] =
                                  res['contact_display'];
                              selectedSupplierData['mobile_no'] =
                                  res['mobile_no'];
                              selectedSupplierData['phone'] = res['phone'];
                              selectedSupplierData['email_id'] =
                                  res['email_id'];
                            });
                            return res['name'];
                          }),
                      children: (data['contact_person'] != null)
                          ? <Widget>[
                              ListTile(
                                trailing: const Icon(Icons.person),
                                title: Text('' +
                                    (selectedSupplierData['contact_display'] ??
                                        '')),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.phone_iphone),
                                title: Text('Mobile :  ' +
                                    (selectedSupplierData['mobile_no'] ??
                                        'none')),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.call),
                                title: Text('Phone : ' +
                                    (selectedSupplierData['phone'] ?? 'none')),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.alternate_email),
                                title: Text('' +
                                    ((selectedSupplierData['email_id']) ??
                                        'none')),
                              )
                            ]
                          : null,
                    ),
                    CheckBoxWidget('is_return', 'Is Return',
                        initialValue: data['is_return'] == 1 ? true : false,
                        onChanged: (id, value) =>
                            setState(() => data[id] = value ? 1 : 0)),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              ///
              /// group 2
              ///
              Group(
                child: ListView(
                  children: [
                    const SizedBox(height: 8),
                    CustomTextFieldTest('cost_center', 'Cost Center',
                        disableValidation: true,
                        initialValue: data['cost_center'] ?? '',
                        onChanged: (value) => setState(() {
                              data['cost_center'] = value;
                            }),
                        onSave: (key, value) => data[key] = value,
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => costCenterScreen(),
                            ),
                          );
                          data['cost_center'] = res;
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
                        data['project'] = res['name'];
                        return res['name'];
                      },
                    ),
                    CustomTextFieldTest('currency', 'Currency',
                        initialValue:
                            data['currency'] ?? userProvider.defaultCurrency,
                        onSave: (key, value) => data[key] = value,
                        onChanged: (value) => setState(() {
                              data['currency'] = value;
                            }),
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => currencyListScreen(),
                            ),
                          );
                          data['currency'] = res;
                          return res;
                        }),
                    CustomTextFieldTest(
                      'conversion_rate',
                      'Exchange Rate'.tr(),
                      initialValue: '${data['conversion_rate'] ?? '1'}',
                      disableValidation: true,
                      hintText: 'ex:1.0',
                      clearButton: true,
                      validator: (value) =>
                          numberValidation(value, allowNull: true),
                      keyboardType: TextInputType.number,
                      onSave: (key, value) =>
                          data[key] = double.tryParse(value) ?? 1,
                    ),
                    CustomTextFieldTest(
                      'plc_conversion_rate',
                      'Price List Exchange Rate'.tr(),
                      initialValue: '${data['conversion_rate'] ?? '1'}',
                      disableValidation: true,
                      hintText: 'ex:1.0',
                      clearButton: true,
                      validator: (value) =>
                          numberValidation(value, allowNull: true),
                      keyboardType: TextInputType.number,
                      onChanged: (value) async {
                        setState(() {
                          data['conversion_rate'] = value;
                        });
                      },
                      onSave: (key, value) =>
                          data[key] = double.tryParse(value) ?? 1,
                    ),
                    CustomTextFieldTest('buying_price_list', 'Price List'.tr(),
                        initialValue: data['buying_price_list'] ??
                            userProvider.defaultBuyingPriceList,
                        onSave: (key, value) => data[key] = value,
                        onChanged: (value) {
                          setState(() {
                            data['buying_price_list'] = value;
                          });
                        },
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => buyingPriceListScreen()));
                          if (res != null && res.isNotEmpty) {
                            setState(() {
                              if (data['buying_price_list'] != res['name']) {
                                InheritedForm.of(context).items.clear();
                                InheritedForm.of(context)
                                    .data['buying_price_list'] = res['name'];
                                data['buying_price_list'] = res['name'];
                              }
                              data['price_list_currency'] = res['currency'];
                            });
                            return res['name'];
                          }
                          return res['name'];
                        }),
                    CustomTextFieldTest(
                      'price_list_currency', 'Price List Currency',
                      initialValue: data['price_list_currency'],
                      //disableValidation: false,
                      clearButton: false,
                      enabled: false,
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) => setState(() {
                        data['price_list_currency'] = value;
                      }),
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => currencyListScreen(),
                          ),
                        );
                        data['price_list_currency'] = res;
                        return res;
                      },
                    ),

                    // if (data['update_stock'] != null)
                    //   CheckBoxWidget('update_stock', 'Update Stock',
                    //       initialValue:
                    //           data['update_stock'] == 1 ? true : false,
                    //       onChanged: (id, value) =>
                    //           setState(() => data[id] = value ? 1 : 0)),
                    // if (data['update_stock'] == 1)
                    CustomTextFieldTest(
                      'set_warehouse',
                      'Target Warehouse'.tr(),
                      initialValue: data['set_warehouse'],
                      disableValidation: false,
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) => setState(() {
                        data['set_warehouse'] = value;
                      }),
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => warehouseScreen(),
                          ),
                        );
                        data['set_warehouse'] = res;
                        return res;
                      },
                    ),
                  ],
                ),
              ),

              ///
              /// group 3
              ///
              Group(
                  child: ListView(
                children: [
                  CustomTextFieldTest('tc_name', 'Terms & Conditions'.tr(),
                      initialValue: data['tc_name'],
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => termsConditionScreen()))),
                  if (_terms != null)
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(_terms!,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black)),
                        )),
                  if (_terms != null)
                    const Divider(
                        color: Colors.grey, height: 1, thickness: 0.7),
                ],
              )),

               AddItemsWidget(
                priceList: data['buying_price_list'] ??
                    context.read<UserProvider>().defaultSellingPriceList,
               ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 13),
              //   child: SelectedItemsList(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
