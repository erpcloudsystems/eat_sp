import 'package:next_app/models/page_models/selling_page_model/sales_order_model.dart';
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
import '../../../core/constants.dart';

import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../models/page_models/model_functions.dart';
import '../../page/generic_page.dart';

const List<String> grandTotalList = ['Grand Total', 'Net Total'];

class SalesOrderForm extends StatefulWidget {
  const SalesOrderForm({Key? key}) : super(key: key);

  @override
  _SalesOrderFormState createState() => _SalesOrderFormState();
}

class _SalesOrderFormState extends State<SalesOrderForm> {
  String? _terms;

  Map<String, dynamic> data = {
    "doctype": "Sales Order",
    "transaction_date": DateTime.now().toIso8601String(),
    'order_type': orderTypeList[0],
    "update_stock": 0,
  };
  Map<String, dynamic> selectedCstData = {'name': 'noName', 'credit_days': 0};

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
    _formKey.currentState!.save();

    data['items'] = [];
    data['taxes'] = context.read<UserProvider>().defaultTax;
    InheritedForm.of(context)
        .items
        .forEach((element) => data['items'].add(element.toJson));

    //DocFromPage Mode from Sales Order
    data['items'].forEach((element) {
      element['prevdoc_docname'] = data['prevdoc_docname'];
    });

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Sales Order');

    final server = APIService();

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(SALES_ORDER_POST, {'data': data}),
        context);

    Navigator.pop(context);
    InheritedForm.of(context).data['selling_price_list'] = null;

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['sales_order'] != null)
        context.read<ModuleProvider>().pushPage(res['message']['sales_order']);
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['sales_order'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['sales_order']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
    }
  }

  Future<void> _getCustomerData(String customer) async {
    selectedCstData = Map<String, dynamic>.from(
        await APIService().getPage(CUSTOMER_PAGE, customer))['message'];
  }

  @override
  void initState() {
    super.initState();

    //Adding Mode
    if (!context.read<ModuleProvider>().isEditing) {
      data['tc_name'] =
          context.read<UserProvider>().companyDefaults['default_selling_terms'];
      setState(() {});
    }
    //Editing Mode
    if (context.read<ModuleProvider>().isEditing)
      Future.delayed(Duration.zero, () {
        print('123E4${InheritedForm.of(context).items}');
        if (InheritedForm.of(context).items.isNotEmpty)
          print('123E4${InheritedForm.of(context).items[0].netRate}');
        data = context.read<ModuleProvider>().updateData;
        print('123E5${InheritedForm.of(context).items}');
        if (InheritedForm.of(context).items.isNotEmpty)
          print('123E5${InheritedForm.of(context).items[0].netRate}');
        _getCustomerData(data['customer']).then((value) => setState(() {
              selectedCstData['address_line1'] =
                  formatDescription(data['address_line1']);
              selectedCstData['city'] = data['city'];
              selectedCstData['country'] = data['country'];
            }));

        final items = SalesOrderPageModel(context, data).items;

        items.forEach((element) => InheritedForm.of(context)
            .items
            .add(ItemSelectModel.fromJson(element)));
        InheritedForm.of(context).data['selling_price_list'] =
            data['selling_price_list'];
        print('123E6${InheritedForm.of(context).items}');
        if (InheritedForm.of(context).items.isNotEmpty)
          print('123E6${InheritedForm.of(context).items[0].netRate}');

        setState(() {});
      });

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
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

         data['posting_date'] = DateTime.now().toIso8601String();
        data['is_return'] = 0;
        data['update_stock'] = 1;
        data['latitude'] = 0.0;
        data['longitude'] = 0.0;
        data['conversion_rate'] = 1;

        // from Quotation
        if(data['doctype']=='Quotation'){
        data['prevdoc_docname'] = data['name'];
        data['customer'] = data['party_name'];
        data['customer_name'] = data['party_name'];
        }


        _getCustomerData(data['customer_name']).then((value) => setState(() {
              data['due_date'] = DateTime.now()
                  .add(Duration(
                      days: int.parse(
                          (selectedCstData['credit_days'] ?? 0).toString())))
                  .toIso8601String();

              if (data['selling_price_list'] !=
                  selectedCstData['default_price_list']) {
                data['selling_price_list'] =
                    selectedCstData['default_price_list'];

                InheritedForm.of(context).data['selling_price_list'] =
                    selectedCstData['default_price_list'];
              }
              data['currency'] = selectedCstData['default_currency'];
              data['price_list_currency'] = selectedCstData['default_currency'];
              data['customer_address'] =
                  selectedCstData["customer_primary_address"];
              data['contact_person'] =
                  selectedCstData["customer_primary_contact"];
            }));

        data['doctype'] = "Sales Order";
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
        bool? isGoBack = await checkDialog(context, 'Are you sure to go back?');
        if (isGoBack != null) {
          if (isGoBack) {
            InheritedForm.of(context).data['selling_price_list'] = null;
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
              ? Text("Edit Sales Order")
              : Text("Create Sales Order"),
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
                        'customer',
                        'Customer',
                        initialValue: data['customer'],
                        clearButton: true,
                        onPressed: () async {
                          String? id;

                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      selectCustomerScreen()));
                          if (res != null) {
                            id = res['name'];
                            await _getCustomerData(res['name']);

                            setState(() {
                              data['customer'] = res['name'];
                              data['customer_name'] = res['customer_name'];
                              data['territory'] = res['territory'];
                              data['customer_group'] = res['customer_group'];
                              data['customer_address'] =
                                  res["customer_primary_address"];
                              data['contact_person'] =
                                  res["customer_primary_contact"];
                              data['currency'] = res['default_currency'];
                              data['price_list_currency'] =
                                  res['default_currency'];
                              if (data['selling_price_list'] !=
                                  res['default_price_list']) {
                                data['selling_price_list'] =
                                    res['default_price_list'];
                                InheritedForm.of(context).items.clear();
                                InheritedForm.of(context)
                                        .data['selling_price_list'] =
                                    res['default_price_list'];
                              }
                              data['payment_terms_template'] =
                                  res['payment_terms'];
                              data['sales_partner'] =
                                  res['default_sales_partner'];
                              data['tax_id'] = res['tax_id'];
                            });
                          }

                          return id;
                        },
                      ),
                      if (data['customer_name'] != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(data['customer_name']!,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            )),
                      if (data['customer_name'] != null)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 2, right: 2),
                          child: Divider(
                              color: Colors.grey, height: 1, thickness: 0.7),
                        ),
                      Row(children: [
                        Flexible(
                            child: DatePicker(
                          'transaction_date',
                          'Date'.tr(),
                          lastDate:
                              DateTime.tryParse(data['delivery_date'] ?? ''),
                          initialValue: data['transaction_date'] ?? '',
                          onChanged: (value) =>
                              setState(() => data['transaction_date'] = value),
                        )),
                        SizedBox(width: 10),
                        Flexible(
                            child: DatePicker(
                          'delivery_date',
                          'Delivery Date',
                          onChanged: (value) =>
                              setState(() => data['delivery_date'] = value),
                          firstDate: DateTime.parse(data['transaction_date']),
                          initialValue: data['delivery_date'],

                            )),
                      ]),
                      if (data['tax_id'] != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(data['tax_id']!,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            )),
                      if (data['tax_id'] != null)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 2, right: 2),
                          child: Divider(
                              color: Colors.grey, height: 1, thickness: 0.7),
                        ),
                      CustomTextField('customer_group', 'Customer Group',
                          initialValue: data['customer_group'],
                          disableValidation: true,

                          clearButton: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => customerGroupScreen()))),
                      CustomTextField('territory', 'Territory'.tr(),
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['territory'],
                          clearButton: true,
                          disableValidation: true,

                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => territoryScreen()))),
                      // CustomTextField('customer_address', 'Customer Address',
                      //     initialValue: data['customer_address'],
                      //     onSave: (key, value) => data[key] = value,
                      //     liestenToInitialValue: data['customer_address'] == null,
                      //     onPressed: () async {
                      //       if (data['customer'] == null) return showSnackBar('Please select a customer to first', context);
                      //
                      //       final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => customerAddressScreen(data['customer'])));
                      //       data['customer_address'] = res;
                      //       return res;
                      //     }),
                      // CustomTextField('contact_person', 'Contact Person',
                      //     initialValue: data['contact_person'],
                      //     disableValidation: true,
                      //     onSave: (key, value) => data[key] = value,
                      //     onPressed: () async {
                      //       if (data['customer_name'] == null) {
                      //         showSnackBar('Please select a customer', context);
                      //         return null;
                      //       }
                      //       final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => contactScreen(data['customer'])));
                      //       return res;
                      //     }),
                      CustomExpandableTile(
                        hideArrow: data['customer'] == null,
                        title: CustomTextField(
                            'customer_address', 'Customer Address',
                            initialValue: data['customer_address'],
                            disableValidation: true,
                            clearButton: false,
                            onSave: (key, value) => data[key] = value,
                            liestenToInitialValue:
                                data['customer_address'] == null,
                            onPressed: () async {
                              if (data['customer'] == null)
                                return showSnackBar(
                                    'Please select a customer to first',
                                    context);
                              final res = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => customerAddressScreen(
                                          data['customer'])));
                              setState(() {
                                data['customer_address'] = res['name'];
                                selectedCstData['address_line1'] =
                                    res['address_line1'];
                                selectedCstData['city'] = res['city'];
                                selectedCstData['country'] = res['country'];
                              });
                              return res['name'];
                            }),
                        children: (data['customer_address'] != null)
                            ? <Widget>[
                                ListTile(
                                  trailing: Icon(Icons.location_on),
                                  title: Text(
                                      selectedCstData['address_line1'] ?? ''),
                                ),
                                ListTile(
                                  trailing: Icon(Icons.location_city),
                                  title: Text(selectedCstData['city'] ?? ''),
                                ),
                                ListTile(
                                  trailing: Icon(Icons.flag),
                                  title: Text(selectedCstData['country'] ?? ''),
                                )
                              ]
                            : null,
                      ),
                      CustomExpandableTile(
                        hideArrow: data['customer'] == null,
                        title: CustomTextField(
                            'contact_person', 'Contact Person',
                            initialValue: data['contact_person'],
                            disableValidation: true,
                            clearButton: false,
                            onSave: (key, value) => data[key] = value,
                            onPressed: () async {
                              if (data['customer'] == null) {
                                showSnackBar(
                                    'Please select a customer', context);
                                return null;
                              }
                              final res = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          contactScreen(data['customer'])));
                              setState(() {
                                data['contact_person'] = res['name'];
                                selectedCstData['contact_display'] =
                                    res['contact_display'];
                                selectedCstData['phone'] = res['phone'];
                                selectedCstData['mobile_no'] = res['mobile_no'];
                                selectedCstData['email_id'] = res['email_id'];
                              });
                              return res['name'];
                            }),
                        children: (data['contact_person'] != null)
                            ? <Widget>[
                                ListTile(
                                  trailing: Icon(Icons.person),
                                  title: Text('' +
                                      (selectedCstData['contact_display'] ??
                                          '')),
                                ),
                                ListTile(
                                  trailing: Icon(Icons.phone_iphone),
                                  title: Text('Mobile :  ' +
                                      (selectedCstData['mobile_no'] ?? 'none')),
                                ),
                                ListTile(
                                  trailing: Icon(Icons.call),
                                  title: Text('Phone :  ' +
                                      (selectedCstData['phone'] ?? 'none')),
                                ),
                                ListTile(
                                  trailing: Icon(Icons.alternate_email),
                                  title: Text('' +
                                      (selectedCstData['email_id'] ?? 'none')),
                                )
                              ]
                            : null,
                      ),
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
                      SizedBox(height: 4),

                      CustomTextField('project', 'Project'.tr(),
                          disableValidation: true,
                          clearButton: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => projectScreen()))),

                      CustomDropDown('order_type', 'Order Type'.tr(),
                          items: orderTypeList,
                          defaultValue: data['order_type'] ?? orderTypeList[0],
                          onChanged: (value) => data['order_type'] = value),
                      Divider(color: Colors.grey, height: 1, thickness: 0.7),

                      CustomTextField('currency', 'Currency'.tr(),
                          initialValue: data['currency'],
                          clearButton: true,
                          disableValidation: true,

                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => currencyListScreen()))),
                      CustomTextField(
                        'conversion_rate',
                        'Exchange Rate'.tr(),
                        disableValidation: true,

                        initialValue: '${data['conversion_rate'] ?? ''}',
                        hintText: '1',
                        clearButton: true,
                        validator: (value) =>
                            numberValidation(value, allowNull: true),
                        keyboardType: TextInputType.number,
                        onSave: (key, value) =>
                            data[key] = double.tryParse(value) ?? 1,
                      ),

                      CustomTextField('selling_price_list', 'Price List'.tr(),
                          initialValue: data['selling_price_list'],
                          disableValidation: true,

                          clearButton: true, onPressed: () async {
                        final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => priceListScreen()));
                        if (res != null && res.isNotEmpty) {
                          setState(() {
                            if (data['selling_price_list'] != res['name']) {
                              InheritedForm.of(context).items.clear();
                              InheritedForm.of(context)
                                  .data['selling_price_list'] = res['name'];
                              data['selling_price_list'] = res['name'];
                            }
                            data['price_list_currency'] = res['currency'];
                          });
                          return res['name'];
                        }
                      }),
                      if (data['price_list_currency'] != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(tr('Price List Currency'),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey)),
                            )),
                      if (data['price_list_currency'] != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(data['price_list_currency'],
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            )),
                      if (data['price_list_currency'] != null)
                        Divider(color: Colors.grey, height: 1, thickness: 0.7),

                      CustomTextField('plc_conversion_rate',
                          'Price List Exchange Rate'.tr(),
                          initialValue: '${data['plc_conversion_rate'] ?? ''}',
                          hintText: '1',
                          clearButton: true,
                          disableValidation: true,

                          validator: (value) =>
                              numberValidation(value, allowNull: true),
                          keyboardType: TextInputType.number,
                          onSave: (key, value) =>
                              data[key] = double.tryParse(value) ?? 1),

                      CustomTextField(
                          'set_warehouse', 'Set Source Warehouse'.tr(),
                          initialValue: data['set_warehouse'],
                          disableValidation: true,

                          clearButton: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => warehouseScreen()))),

                      CustomTextField('payment_terms_template',
                          'Payment Terms Template'.tr(),
                          initialValue: data['payment_terms_template'],
                          disableValidation: true,

                          clearButton: true,

                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => paymentTermsScreen()))),
                      CustomTextField('tc_name', 'Terms & Conditions'.tr(),
                          initialValue: data['tc_name'],
                          disableValidation: true,

                          clearButton: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => termsConditionScreen()))),
                      if (_terms != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(_terms!,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            )),
                      if (_terms != null)
                        Divider(color: Colors.grey, height: 1, thickness: 0.7),
                      // CustomTextField(
                      //   'terms',
                      //   'Terms & Conditions Details',
                      //   onSave: (key, value) => data[key] = value.isEmpty ? null : value,
                      //   validator: (value) => null,
                      // ),

                      CustomTextField(
                        'sales_partner',
                        'Sales Partner'.tr(),
                        initialValue: data['sales_partner'],
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => salesPartnerScreen())),
                      ),
                    ],
                  ),
                ),

                ///
                /// group 3
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
                //         validator: (value) => numberValidation(value!.isEmpty ? '0': value),
                //         keyboardType: TextInputType.number,
                //         onSave: (key, value) => data[key] = double.tryParse(value) ?? 0,
                //       ),
                //       CustomTextField(
                //         'discount_amount',
                //         'Additional Discount Amount (Company Currency)',
                //         hintText: '0',
                //         validator: (value) => numberValidation(value!.isEmpty ? '0': value),
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
