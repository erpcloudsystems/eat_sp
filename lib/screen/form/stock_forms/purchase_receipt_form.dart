import 'package:next_app/models/page_models/selling_page_model/sales_invoice_page_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:next_app/main.dart';
import 'package:next_app/service/service.dart';
import 'package:next_app/service/service_constants.dart';
import 'package:next_app/provider/module/module_provider.dart';
import 'package:next_app/provider/user/user_provider.dart';
import 'package:next_app/screen/list/otherLists.dart';
import 'package:next_app/widgets/dialog/loading_dialog.dart';
import 'package:next_app/widgets/form_widgets.dart';
import 'package:next_app/widgets/inherited_widgets/select_items_list.dart';
import 'package:next_app/widgets/snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;
import '../../../core/constants.dart';

import '../../../models/list_models/stock_list_model/item_table_model.dart';
import 'package:next_app/models/page_models/buying_page_model/purchase_invoice_page_model.dart';
import '../../../models/page_models/model_functions.dart';
import '../../../models/page_models/stock_page_model/purchase_receipt_page_model.dart';
import '../../page/generic_page.dart';

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
    'is_subcontracted': "No",
    'bill_no': '',
  };

  Map<String, dynamic> selectedSupplierData = {
    'name': 'noName',
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) {
      showSnackBar(KFillRequiredSnackBar, context);
      return;
    }

    if (InheritedForm.of(context).items.isEmpty) {
      showSnackBar('Please add an item at least', context);
      return;
    }

    final provider = context.read<ModuleProvider>();
    _formKey.currentState!.save();

    data['items'] = [];
    data['taxes'] =
        (provider.isEditing) ? [] : context.read<UserProvider>().defaultTax;

    InheritedForm.of(context).items.forEach((element) {
      if (data['is_return'] == 1) element.qty = element.qty * -1;
      data['items'].add(element.toJson);
    });

    if (data['items'][0]['rate'] == 0.0 || data['items'][0]['rate'] == "") {
      showSnackBar('net rate is Zero', context);
      return;
    }

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

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(PURCHASE_RECEIPT_POST, {'data': data}),
        context);

    Navigator.pop(context);
    InheritedForm.of(context).data['buying_price_list'] = null;

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['purchase_receipt'] != null)
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['purchase_receipt']);
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['purchase_receipt'] != null) {
      provider.pushPage(res['message']['purchase_receipt']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
    }
  }

  Future<void> _getSupplierData(String supplier) async {
    selectedSupplierData = Map<String, dynamic>.from(
        await APIService().getPage(SUPPLIER_PAGE, supplier))['message'];
  }

  @override
  void initState() {
    super.initState();
    //Editing Mode
    if (context.read<ModuleProvider>().isEditing)
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

        items.forEach((element) => InheritedForm.of(context)
            .items
            .add(ItemSelectModel.fromJson(element)));
      });

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;

        InheritedForm.of(context).items.clear();


        data['posting_date'] = DateTime.now().toIso8601String();
        data['is_return'] = 0;
        data['is_subcontracted'] = "No";
        data['bill_no'] = '';
        data['longitude'] = 0.0;
        data['conversion_rate'] = 1;

        // from Purchase Invoice
        if (data['doctype'] == 'Purchase Invoice') {
          data['purchase_invoice_item'].forEach((element) {
            InheritedForm.of(context)
                .items
                .add(ItemSelectModel.fromJson(element));
          });
          InheritedForm.of(context).data['buying_price_list'] =
          data['buying_price_list'];

          data['purchase_invoice'] = data['name'];
          data['project'] = data['project'];
        }

        _getSupplierData(data['supplier']).then((value) => setState(() {
              if (data['buying_price_list'] !=
                  selectedSupplierData['default_price_list']) {
                data['buying_price_list'] =
                    selectedSupplierData['default_price_list'];

                InheritedForm.of(context).data['buying_price_list'] =
                    selectedSupplierData['default_price_list'];
              }
              data['currency'] = selectedSupplierData['default_currency'];
              data['price_list_currency'] =
                  selectedSupplierData['default_currency'];
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
        print('sdfsdfsd${data['items']}');
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          title: (context.read<ModuleProvider>().isEditing)
              ? Text("Edit Purchase Receipt")
              : Text("Create Purchase Receipt"),
          actions: [
            Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: IconButton(
                  onPressed: submit,
                  icon: Icon(
                    Icons.check,
                    color: FORM_SUBMIT_BTN_COLOR,
                  ),
                ))
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Group(
                  child: Column(
                    children: [
                      SizedBox(height: 4),
                      CustomTextField(
                        'supplier',
                        'Supplier',
                        initialValue: data['supplier'],
                        onPressed: () async {
                          String? id;
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      selectSupplierScreen()));
                          if (res != null) {
                            id = res['name'];
                            await _getSupplierData(res['name']);
                            // selectedSupplierData = Map<String, dynamic>.from(
                            //     await APIService().getPage(
                            //         SUPPLIER_PAGE, res['name']))['message'];
                            setState(() {

                              data['name'] = res['name'];
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
                            child: DatePicker(
                          'posting_date',
                          'Date'.tr(),
                          initialValue: data['posting_date'] ?? 'none',
                          onChanged: (value) =>
                              setState(() => data['posting_date'] = value),
                        )),
                      ]),
                      CustomExpandableTile(
                        hideArrow: data['supplier'] == null,
                        title: CustomTextField(
                            'supplier_address', 'Supplier Address',
                            initialValue: data['supplier_address'],
                            disableValidation: true,
                            clearButton: false,
                            onSave: (key, value) => data[key] = value,
                            liestenToInitialValue:
                                data['supplier_address'] == null,
                            onPressed: () async {
                              if (data['supplier'] == null)
                                return showSnackBar(
                                    'Please select a supplier to first',
                                    context);
                              final res = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => customerAddressScreen(
                                          data['supplier'])));
                              setState(() {
                                data['supplier_address'] = res['name'];
                                selectedSupplierData['address_line1'] =
                                    res['address_line1'];
                                selectedSupplierData['city'] = res['city'];
                                selectedSupplierData['country'] =
                                    res['country'];
                              });
                              return res['name'];
                            }),
                        children: (data['supplier_address'] != null)
                            ? <Widget>[
                                ListTile(
                                  trailing: Icon(Icons.location_on),
                                  title: Text(
                                      selectedSupplierData['address_line1'] ??
                                          ''),
                                ),
                                ListTile(
                                  trailing: Icon(Icons.location_city),
                                  title:
                                      Text(selectedSupplierData['city'] ?? ''),
                                ),
                                ListTile(
                                  trailing: Icon(Icons.flag),
                                  title: Text(
                                      selectedSupplierData['country'] ?? ''),
                                )
                              ]
                            : null,
                      ),
                      CustomExpandableTile(
                        hideArrow: data['supplier'] == null,
                        title:
                            CustomTextField('contact_person', 'Contact Person',
                                initialValue: data['contact_person'],
                                disableValidation: true,
                                clearButton: false,
                                onSave: (key, value) => data[key] = value,
                                onPressed: () async {
                                  if (data['supplier'] == null) {
                                    showSnackBar(
                                        'Please select a supplier', context);
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
                                    selectedSupplierData['phone'] =
                                        res['phone'];
                                    selectedSupplierData['email_id'] =
                                        res['email_id'];
                                  });
                                  return res['name'];
                                }),
                        children: (data['contact_person'] != null)
                            ? <Widget>[
                                ListTile(
                                  trailing: Icon(Icons.person),
                                  title: Text('' +
                                      (selectedSupplierData[
                                              'contact_display'] ??
                                          '')),
                                ),
                                ListTile(
                                  trailing: Icon(Icons.phone_iphone),
                                  title: Text('Mobile :  ' +
                                      (selectedSupplierData['mobile_no'] ??
                                          'none')),
                                ),
                                ListTile(
                                  trailing: Icon(Icons.call),
                                  title: Text('Phone : ' +
                                      (selectedSupplierData['phone'] ??
                                          'none')),
                                ),
                                ListTile(
                                  trailing: Icon(Icons.alternate_email),
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
                      SizedBox(height: 8),
                    ],
                  ),
                ),

                ///
                /// group 2
                ///
                Group(
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      CustomTextField('cost_center', 'Cost Center',
                          disableValidation: true,
                          initialValue: data['cost_center'] ?? '',
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => costCenterScreen()))),
                      CustomTextField('project', 'Project'.tr(),
                          initialValue: data['project'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => projectScreen()))),
                      CustomTextField('currency', 'Currency',
                          initialValue: data['currency'],
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => currencyListScreen()))),
                      CustomTextField(
                        'conversion_rate',
                        'Exchange Rate'.tr(),
                        initialValue: '${data['conversion_rate'] ?? '1'}',                          disableValidation: true,

                        hintText: 'ex:1.0',
                        clearButton: true,
                        validator: (value) =>
                            numberValidation(value, allowNull: true),
                        keyboardType: TextInputType.number,
                        onSave: (key, value) =>
                            data[key] = double.tryParse(value) ?? 1,
                      ),
                      CustomTextField(
                        'plc_conversion_rate',
                        'Price List Exchange Rate'.tr(),
                        initialValue: '${data['conversion_rate'] ?? '1'}',                          disableValidation: true,

                        hintText: 'ex:1.0',
                        clearButton: true,
                        validator: (value) =>
                            numberValidation(value, allowNull: true),
                        keyboardType: TextInputType.number,
                        onSave: (key, value) =>
                            data[key] = double.tryParse(value) ?? 1,
                      ),
                      CustomTextField('buying_price_list', 'Price List'.tr(),
                          initialValue: data['buying_price_list'],
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
                      }),
                      CustomTextField(
                          'price_list_currency', 'Price List Currency',
                          initialValue: data['price_list_currency'],
                          //disableValidation: false,
                          clearButton: false,
                          enabled: false,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => currencyListScreen()))),

                      // if (data['update_stock'] != null)
                      //   CheckBoxWidget('update_stock', 'Update Stock',
                      //       initialValue:
                      //           data['update_stock'] == 1 ? true : false,
                      //       onChanged: (id, value) =>
                      //           setState(() => data[id] = value ? 1 : 0)),
                      // if (data['update_stock'] == 1)
                      CustomTextField('set_warehouse', 'Target Warehouse'.tr(),
                          initialValue: data['set_warehouse'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => warehouseScreen()))),
                    ],
                  ),
                ),

                ///
                /// group 3
                ///
                Group(
                    child: Column(
                  children: [
                    //if (data['payment_terms_template'] != null)
                    // CustomTextField(
                    //     'payment_terms_template', 'Payment Terms Template'.tr(),
                    //     initialValue: data['payment_terms_template'],
                    //     disableValidation: true,
                    //     onSave: (key, value) => data[key] = value,
                    //     onPressed: () => Navigator.of(context).push(
                    //         MaterialPageRoute(
                    //             builder: (_) => paymentTermsScreen()))),
                    //if (data['tc_name'] != null)
                    CustomTextField('tc_name', 'Terms & Conditions'.tr(),
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
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black)),
                          )),
                    if (_terms != null)
                      Divider(color: Colors.grey, height: 1, thickness: 0.7),
                  ],
                )),

                ///
                /// group 4
                ///
                // Group(
                //   child: Column(
                //     children: [
                //       CustomDropDown('apply_discount_on', 'Apply Additional Discount On',
                //           items: grandTotalList, defaultValue: grandTotalList[0], onChanged: (value) => data['apply_discount_on'] = value),
                //       Divider(color: Colors.grey, height: 1, thickness: 0.7),
                //       CustomTextField(
                //         'additional_discount_percentage',
                //         'Additional Discount Percentage',
                //         hintText: '0',
                //         disableValidation: true,
                //         keyboardType: TextInputType.number,
                //         onSave: (key, value) => data[key] = double.tryParse(value) ?? 0,
                //       ),
                //       CustomTextField(
                //         'discount_amount',
                //         'Additional Discount Amount (Company Currency)',
                //         hintText: '0',
                //         disableValidation: true,
                //         keyboardType: TextInputType.number,
                //         onSave: (key, value) => data[key] = double.tryParse(value) ?? 0,
                //       ),
                //     ],
                //   ),
                // ),

                SizedBox(height: 8),
                SelectedItemsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
