import 'dart:developer';

import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../test/custom_page_view_form.dart';
import '../../../test/test_text_field.dart';
import '../../list/otherLists.dart';
import '../../page/generic_page.dart';
import '../../../core/constants.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../provider/user/user_provider.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/page_models/model_functions.dart';
import '../../../widgets/inherited_widgets/select_items_list.dart';
import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../models/page_models/buying_page_model/purchase_order_page_model.dart';

const List<String> grandTotalList = ['Grand Total', 'Net Total'];

class PurchaseOrderForm extends StatefulWidget {
  const PurchaseOrderForm({Key? key}) : super(key: key);

  @override
  _PurchaseOrderFormState createState() => _PurchaseOrderFormState();
}

class _PurchaseOrderFormState extends State<PurchaseOrderForm> {
  String? _terms;

  Map<String, dynamic> data = {
    "doctype": "Purchase Order",
    "transaction_date": DateTime.now().toIso8601String(),
    "is_return": 0,
    'conversion_rate': 1,
    'is_subcontracted': 0,
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

    if (InheritedForm.of(context).items.isEmpty) {
      showSnackBar('Please add an item at least', context);
      return;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeAmendingFunction(context, data);

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    data['docstatus'] = 0;
    data['purchase_order_items'] = null;
    data['child_purchase_taxes_and_charges'] = null;

    data['items'] = [];
    data['taxes'] =
        (provider.isEditing) ? [] : context.read<UserProvider>().defaultTax;

    InheritedForm.of(context)
        .items
        .forEach((element) => data['items'].add(element.toJson));

    //DocFromPage Mode from Sales Order
    data['items'].forEach((element) {
      element['sales_order'] = data['sales_order'];
    });

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Purchase Order');

    final server = APIService();

    for (var k in data.keys) {
      log("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(PURCHASE_ORDER_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['purchase_order_name'] != null) {
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['purchase_order_name']);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['purchase_order_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['purchase_order_name']);
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
    final provider = context.read<ModuleProvider>();
    super.initState();
    //Editing Mode
    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        print(
            '--------------------isAmendingMode------------------------------------');
        data = context.read<ModuleProvider>().updateData;
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

        final items = PurchaseOrderPageModel(context, data).items;

        for (var element in items) {
          InheritedForm.of(context)
              .items
              .add(ItemSelectModel.fromJson(element));
        }
        InheritedForm.of(context).data['buying_price_list'] =
            data['buying_price_list'];

        setState(() {});
      });
    }
    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      print(
          '---------------------------isCreateFromPage--------------------------');
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;
        InheritedForm.of(context).items.clear();
        data['items'].forEach((element) {
          InheritedForm.of(context)
              .items
              .add(ItemSelectModel.fromJson(element));
        });
        InheritedForm.of(context).data['selling_price_list'] =
            data['selling_price_list'];
        data['doctype'] = "Purchase Order";
        data['posting_date'] = DateTime.now().toIso8601String();
        data['is_return'] = 0;
        data['update_stock'] = 1;
        data['latitude'] = 0.0;
        data['longitude'] = 0.0;
        data['conversion_rate'] = 1;

        // from Sales Order
        if (data['doctype'] == 'Sales Order') {
          data['sales_order'] = data['name'];
          data['project'] = data['project'];
        }
        //Supplier Quotation
        if (data['doctype'] == 'Supplier Quotation') {
          data['supplier'] = data['name'];
          data['transaction_date'] = data['transaction_date'];
          data['schedule_date'] = data['valid_till'];
        }

        //Material Request
        if (data['doctype'] == DocTypesName.materialRequest) {
          data['supplier'] = data['name'];
          data['transaction_date'] = data['transaction_date'];
          data['schedule_date'] = data['schedule_date'];
        }
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

        _getSupplierData(data['supplier']).then((value) => setState(() {
              data['due_date'] = DateTime.now()
                  .add(Duration(
                      days: int.parse((selectedSupplierData['credit_days'] ?? 0)
                          .toString())))
                  .toIso8601String();

              // data['currency'] = selectedSupplierData['default_currency'];
              // data['price_list_currency'] =
              //     selectedSupplierData['default_currency'];
              data['payment_terms_template'] =
                  selectedSupplierData['payment_terms'];
              data['transaction_date'] = data['transaction_date'];
              data['schedule_date'] = data['valid_till'];
              // data['customer_address'] =
              // selectedSupplierData["customer_primary_address"];
              // data['contact_person'] =
              // selectedSupplierData["customer_primary_contact"];
            }));

        print('sdfsdfsd${data['items']}');
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
        InheritedForm.of(context).data['selling_price_list'] = null;
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
                    CustomTextFieldTest(
                      'supplier',
                      'Supplier',
                      initialValue: data['supplier'],
                      onSave: (id, value) => data[id] = value,
                      onChanged: (value) {
                        setState(() {
                          data['supplier'] = value;
                        });
                      },
                      onPressed: () async {
                        String? id;
                        final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => selectSupplierScreen()));
                        if (res != null) {
                          id = res['name'];
                          await _getSupplierData(res['name']);

                          setState(() {
                            // data['name'] = res['name'];
                            data['supplier'] = res['name'];
                            data['supplier_name'] =
                                selectedSupplierData['supplier_name'];
                            data['tax_id'] = selectedSupplierData["tax_id"];
                            data['supplier_address'] = selectedSupplierData[
                                "supplier_primary_address"];
                            data['contact_person'] = selectedSupplierData[
                                "supplier_primary_contact"];
                            data['contact_mobile'] =
                                selectedSupplierData["mobile_no"];
                            data['contact_email'] =
                                selectedSupplierData["email_id"];

                            if (!context
                                .read<ModuleProvider>()
                                .isCreateFromPage) {
                              data['currency'] =
                                  selectedSupplierData['currency'];

                              if (data['buying_price_list'] !=
                                  selectedSupplierData['default_price_list']) {
                                data['buying_price_list'] =
                                    selectedSupplierData['default_price_list'];
                                InheritedForm.of(context).items.clear();
                                InheritedForm.of(context)
                                        .data['buying_price_list'] =
                                    selectedSupplierData['default_price_list'];
                              }
                            }
                            data['schedule_date'] = DateTime.now()
                                .add(Duration(
                                    days: int.parse(
                                        selectedSupplierData["credit_days"]
                                            .toString())))
                                .toIso8601String();
                          });
                        }
                        return id;
                      },
                    ),
                    Row(children: [
                      Flexible(
                          child: DatePickerTest(
                        'transaction_date',
                        'Date'.tr(),
                        initialValue: data['transaction_date'],
                        onChanged: (value) =>
                            setState(() => data['transaction_date'] = value),
                      )),
                      const SizedBox(width: 10),
                      Flexible(
                          child: DatePickerTest(
                        'schedule_date',
                        'Required By Date',
                        disableValidation: true,
                        onChanged: (value) =>
                            setState(() => data['schedule_date'] = value),
                        initialValue: data['schedule_date'] ??
                            ((selectedSupplierData['name'].toString() !=
                                    'noName')
                                ? DateTime.now()
                                    .add(Duration(
                                        days: int.parse(
                                            selectedSupplierData["credit_days"]
                                                .toString())))
                                    .toIso8601String()
                                : null),
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
                              if (selectedSupplierData['address_line1'] != null)
                                ListTile(
                                  trailing: const Icon(Icons.location_on),
                                  title: Text(
                                      selectedSupplierData['address_line1'] ??
                                          ''),
                                ),
                              if (selectedSupplierData['city'] != null)
                                ListTile(
                                  trailing: const Icon(Icons.location_city),
                                  title:
                                      Text(selectedSupplierData['city'] ?? ''),
                                ),
                              if (selectedSupplierData['country'] != null)
                                ListTile(
                                  trailing: const Icon(Icons.flag),
                                  title: Text(
                                      selectedSupplierData['country'] ?? ''),
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
                                  res['contact_person'];
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
                                title: Text('Phone :  ' +
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
                        initialValue: data['cost_center'],
                        disableValidation: true,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => costCenterScreen()))),
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
                    CustomTextFieldTest(
                      'currency',
                      'Currency',
                      initialValue:
                          data['currency'] ?? userProvider.defaultCurrency,
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => currencyListScreen(),
                        ),
                      ),
                    ),
                    CustomTextFieldTest(
                      'conversion_rate',
                      'Exchange Rate'.tr(),
                      initialValue: '${data['conversion_rate'] ?? '1'}',
                      hintText: 'ex:1.0',
                      clearButton: true,
                      disableValidation: true,
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
                      hintText: 'ex:1.0',
                      clearButton: true,
                      disableValidation: true,
                      validator: (value) =>
                          numberValidation(value, allowNull: true),
                      keyboardType: TextInputType.number,
                      onSave: (key, value) =>
                          data[key] = double.tryParse(value) ?? 1,
                    ),
                    CustomTextFieldTest('buying_price_list', 'Price List'.tr(),
                        initialValue: data['buying_price_list'] ??
                            userProvider.defaultBuyingPriceList,
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
                      return null;
                    }),
                    CustomTextFieldTest(
                      'price_list_currency',
                      'Price List Currency',
                      initialValue: data['price_list_currency'],
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => currencyListScreen(),
                        ),
                      ),
                    ),
                    CheckBoxWidget('ignore_pricing_rule', 'Ignore Pricing Rule',
                        initialValue:
                            data['ignore_pricing_rule'] == 1 ? true : false,
                        onChanged: (id, value) =>
                            setState(() => data[id] = value ? 1 : 0)),
                    CustomTextFieldTest(
                      'set_warehouse',
                      'Set Source Warehouse'.tr(),
                      initialValue: data['set_warehouse'],
                      disableValidation: false,
                      onChanged: (value) => setState(() {
                        data['set_warehouse'] = value;
                      }),
                      onSave: (key, value) => data[key] = value,
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => warehouseScreen()),
                        );
                        data['set_warehouse'] = res;
                        return res;
                      },
                    ),
                    if (data['update_stock'] != null)
                      CheckBoxWidget('update_stock', 'Update Stock',
                          initialValue:
                              data['update_stock'] == 1 ? true : false,
                          onChanged: (id, value) =>
                              setState(() => data[id] = value ? 1 : 0)),
                  ],
                ),
              ),

              Group(
                  child: ListView(
                children: [
                  //if (data['payment_terms_template'] != null)
                  CustomTextFieldTest(
                      'payment_terms_template', 'Payment Terms Template'.tr(),
                      initialValue: data['payment_terms_template'],
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => paymentTermsScreen()))),
                  //if (data['tc_name'] != null)
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

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 13),
                child: SelectedItemsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
