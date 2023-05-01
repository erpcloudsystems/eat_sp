import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
import '../../../widgets/inherited_widgets/select_items_list.dart';
import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../models/page_models/stock_page_model/delivery_note_page_model.dart';

const List<String> grandTotalList = ['Grand Total', 'Net Total'];

class DeliveryNoteForm extends StatefulWidget {
  const DeliveryNoteForm({Key? key}) : super(key: key);

  @override
  _DeliveryNoteFormState createState() => _DeliveryNoteFormState();
}

class _DeliveryNoteFormState extends State<DeliveryNoteForm> {
  String? _terms;

  Map<String, dynamic> data = {
    "doctype": "Delivery Note",
    "posting_date": DateTime.now().toIso8601String(),
    'order_type': orderTypeList[0],
    "update_stock": 0,
  };
  Map<String, dynamic> selectedCstData = {'name': 'noName', 'credit_days': 0};

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ModuleProvider>();
    if (InheritedForm.of(context).items.isEmpty) {
      showSnackBar('Please add an item at least', context);
      return;
    }


    Provider.of<ModuleProvider>(context, listen: false)
        .initializeAmendingFunction(context, data);
    _formKey.currentState!.save();

    data['items'] = [];
    data['taxes'] = context.read<UserProvider>().defaultTax;

    InheritedForm.of(context).items.forEach((element) {
      if (data['is_return'] == 1) element.qty = element.qty * -1;
      data['items'].add(element.toJson);
    });

    //DocFromPage Mode from Sales Order
    data['items'].forEach((element) {
      element['against_sales_order'] = data['against_sales_order'];
    });

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Delivery Note');

    final server = APIService();

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(DELIVERY_NOTE_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null) Navigator.pop(context);

    if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['delivery_note'] != null)
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['delivery_note']);
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['delivery_note'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['delivery_note']);
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

    final provider = context.read<ModuleProvider>();
    //Adding Mode
    if (!provider.isEditing && !provider.isAmendingMode ) {
      data['tc_name'] =
          context.read<UserProvider>().companyDefaults['default_selling_terms'];
      setState(() {});
    }
    //Editing Mode
    if (provider.isEditing || provider.isAmendingMode)
      Future.delayed(Duration.zero, () {
        data = provider.updateData;
        _getCustomerData(data['customer_name']).then((value) => setState(() {
              selectedCstData['address_line1'] =
                  formatDescription(data['address_display']);
              selectedCstData['city'] = data['city'];
              selectedCstData['country'] = data['country'];

              selectedCstData['contact_display'] = data['contact_display'];
              selectedCstData['phone'] = data['phone'];
              selectedCstData['mobile_no'] = data['mobile_no'];
              selectedCstData['email_id'] = data['email_id'];
            }));

        final items = DeliveryNotePageModel(context, data).items;

        items.forEach((element) => InheritedForm.of(context)
            .items
            .add(ItemSelectModel.fromJson(element)));
        InheritedForm.of(context).data['selling_price_list'] =
            data['selling_price_list'];

        if (provider.isAmendingMode) {
          data.remove('amended_to');
          data['docstatus'] = 0;
        }

        setState(() {});
      });

    //DocFromPage Mode
    if (provider.isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = provider.createFromPageData;

        InheritedForm.of(context).items.clear();
        data['items'].forEach((element) {
          if (!InheritedForm.of(context).items.contains(element)) {
            InheritedForm.of(context)
                .items
                .add(ItemSelectModel.fromJson(element));
          }
        });
        InheritedForm.of(context).data['selling_price_list'] =
            data['selling_price_list'];

        data['posting_date'] = DateTime.now().toIso8601String();
        data['order_type'] = orderTypeList[0];
        data['update_stock'] = 0;
        data['conversion_rate'] = 1;

        // from Sales Order
        if (data['doctype'] == 'Sales Order') {
          data['customer_name'] = data['customer_name'];
          data['against_sales_order'] = data['name'];
        }

        // from Delivery Note
        if (data['doctype'] == 'Delivery Note') {
          data['delivery_mote'] = data['name'];
          data['is_return'] = 1;
        }

        _getCustomerData(data['customer_name']).then((value) => setState(() {
              data['currency'] = selectedCstData['default_currency'];
              data['price_list_currency'] = selectedCstData['default_currency'];
              data['customer_address'] =
                  selectedCstData["customer_primary_address"];
              data['contact_person'] =
                  selectedCstData["customer_primary_contact"];
            }));

        data['doctype'] = "Delivery Note";

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
        setState(() {});
      });
    }
  }

   // Here we stop the "Amending mode" to clear the data for the next creation.
  @override
  void deactivate() {
    final provider = context.read<ModuleProvider>();
    if (provider.isAmendingMode) provider.amendDoc = false;
    super.deactivate();
  }
  
  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          title: (context.read<ModuleProvider>().isEditing)
              ? Text("Edit Delivery Note")
              : Text("Create Delivery Note"),
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
                      DatePicker('posting_date', 'Date'.tr(),
                          initialValue: data['posting_date'],
                          onChanged: (value) =>
                              setState(() => data['posting_date'] = value)),
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
                      CustomTextField('customer_group', 'Customer Group'.tr(),
                          initialValue: data['customer_group'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => customerGroupScreen()))),
                      CustomTextField('territory', 'Territory'.tr(),
                          onSave: (key, value) => data[key] = value,
                          disableValidation: true,
                          initialValue: data['territory'],
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => territoryScreen()))),
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
                                print('88889r${data['items']['net_rate']}');
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

                      CheckBoxWidget('is_return', 'Is Return',
                          initialValue: data['is_return'] == 1 ? true : false,
                          onChanged: (id, value) =>
                              setState(() => data[id] = value ? 1 : 0)),

                      CustomTextField('project', 'Project'.tr(),
                          disableValidation: true,
                          initialValue: data['project'],
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
                        initialValue: '${data['conversion_rate'] ?? ''}',
                        disableValidation: true,
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
                          onPressed: () async {
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
                          disableValidation: true,
                          hintText: '1',
                          clearButton: true,
                          validator: (value) =>
                              numberValidation(value, allowNull: true),
                          keyboardType: TextInputType.number,
                          onSave: (key, value) =>
                              data[key] = double.tryParse(value) ?? 1),

                      CustomTextField('set_warehouse', 'Source Warehouse'.tr(),
                          initialValue: data['set_warehouse'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => warehouseScreen()))),
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
