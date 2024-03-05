import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/modules/new_item/presentation/pages/add_items.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import '../../list/otherLists.dart';
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
    data['taxes'] = context.read<UserProvider>().defaultTax;

    // InheritedForm.of(context).items.forEach((element) {
    //   if (data['is_return'] == 1) element.qty = element.qty * -1;
    //   data['items'].add(element.toJson);
    // });
    for (var element in provider.newItemList) {
      data['items'].add(element);
    }

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

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(DELIVERY_NOTE_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    }

    if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['delivery_note'] != null) {
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['delivery_note']);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['delivery_note'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['delivery_note']);
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
    //Adding Mode
    if (!provider.isEditing &&
        !provider.isAmendingMode &&
        !provider.duplicateMode) {
      data['tc_name'] =
          context.read<UserProvider>().companyDefaults['default_selling_terms'];
      setState(() {});
    }
    //Editing Mode
    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
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
        for (var element in items) {
          provider.setItemToList(element);
        }
        // for (var element in items) {
        //   InheritedForm.of(context)
        //       .items
        //       .add(ItemSelectModel.fromJson(element));
        // }
        InheritedForm.of(context).data['selling_price_list'] =
            data['selling_price_list'];

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

        // InheritedForm.of(context).items.clear();
        // data['items'].forEach((element) {
        //   if (!InheritedForm.of(context).items.contains(element)) {
        //     InheritedForm.of(context)
        //         .items
        //         .add(ItemSelectModel.fromJson(element));
        //   }
        // });
        data['items'].forEach((element) {
          provider.newItemList.add(element);
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
                      'customer',
                      'Customer',
                      initialValue: data['customer'],
                      onPressed: () async {
                        String? id;

                        final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => selectCustomerScreen()));
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
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Text(data['customer_name']!,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black)),
                          )),
                    if (data['customer_name'] != null)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 2, right: 2),
                        child: Divider(
                            color: Colors.grey, height: 1, thickness: 0.7),
                      ),
                    DatePickerTest('posting_date', 'Date'.tr(),
                        initialValue: data['posting_date'],
                        onChanged: (value) =>
                            setState(() => data['posting_date'] = value)),
                    if (data['tax_id'] != null)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Text(data['tax_id']!,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black)),
                          )),
                    if (data['tax_id'] != null)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 2, right: 2),
                        child: Divider(
                            color: Colors.grey, height: 1, thickness: 0.7),
                      ),
                    CustomTextFieldTest('customer_group', 'Customer Group'.tr(),
                        initialValue: data['customer_group'],
                        disableValidation: true,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => customerGroupScreen()))),
                    CustomTextFieldTest('territory', 'Territory'.tr(),
                        onSave: (key, value) => data[key] = value,
                        disableValidation: true,
                        initialValue: data['territory'],
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => territoryScreen()))),
                    CustomExpandableTile(
                      hideArrow: data['customer'] == null,
                      title: CustomTextFieldTest(
                          'customer_address', 'Customer Address',
                          initialValue: data['customer_address'],
                          disableValidation: true,
                          clearButton: false,
                          onSave: (key, value) => data[key] = value,
                          liestenToInitialValue:
                              data['customer_address'] == null,
                          onPressed: () async {
                            if (data['customer'] == null) {
                              return showSnackBar(
                                  'Please select a customer to first', context);
                            }
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
                                trailing: const Icon(Icons.location_on),
                                title: Text(
                                    selectedCstData['address_line1'] ?? ''),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.location_city),
                                title: Text(selectedCstData['city'] ?? ''),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.flag),
                                title: Text(selectedCstData['country'] ?? ''),
                              )
                            ]
                          : null,
                    ),
                    CustomExpandableTile(
                      hideArrow: data['customer'] == null,
                      title: CustomTextFieldTest(
                          'contact_person', 'Contact Person',
                          initialValue: data['contact_person'],
                          disableValidation: true,
                          clearButton: false,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () async {
                            if (data['customer'] == null) {
                              showSnackBar('Please select a customer', context);
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
                                trailing: const Icon(Icons.person),
                                title: Text('' +
                                    (selectedCstData['contact_display'] ?? '')),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.phone_iphone),
                                title: Text('Mobile :  ' +
                                    (selectedCstData['mobile_no'] ?? 'none')),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.call),
                                title: Text('Phone :  ' +
                                    (selectedCstData['phone'] ?? 'none')),
                              ),
                              ListTile(
                                trailing: const Icon(Icons.alternate_email),
                                title: Text('' +
                                    (selectedCstData['email_id'] ?? 'none')),
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
                    const SizedBox(height: 4),

                    CheckBoxWidget('is_return', 'Is Return',
                        initialValue: data['is_return'] == 1 ? true : false,
                        onChanged: (id, value) =>
                            setState(() => data[id] = value ? 1 : 0)),

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

                    CustomTextFieldTest('selling_price_list', 'Price List'.tr(),
                        initialValue: data['selling_price_list'] ??
                            userProvider.defaultSellingPriceList,
                        onPressed: () async {
                      final res = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => priceListScreen()));
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
                      return null;
                    }),
                    if (data['price_list_currency'] != null)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Text(tr('Price List Currency'),
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.grey)),
                          )),
                    if (data['price_list_currency'] != null)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Text(data['price_list_currency'],
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black)),
                          )),
                    if (data['price_list_currency'] != null)
                      const Divider(
                          color: Colors.grey, height: 1, thickness: 0.7),

                    CustomTextFieldTest(
                        'plc_conversion_rate', 'Price List Exchange Rate'.tr(),
                        initialValue: '${data['plc_conversion_rate'] ?? ''}',
                        disableValidation: true,
                        hintText: '1',
                        clearButton: true,
                        validator: (value) =>
                            numberValidation(value, allowNull: true),
                        keyboardType: TextInputType.number,
                        onSave: (key, value) =>
                            data[key] = double.tryParse(value) ?? 1),

                    CustomTextFieldTest(
                        'set_warehouse', 'Source Warehouse'.tr(),
                        initialValue: data['set_warehouse'],
                        disableValidation: false,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => warehouseScreen()))),
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
                    // CustomTextField(
                    //   'terms',
                    //   'Terms & Conditions Details',
                    //   onSave: (key, value) => data[key] = value.isEmpty ? null : value,
                    //   validator: (value) => null,
                    // ),

                    CustomTextFieldTest(
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
              AddItemsWidget(
                priceList: data['selling_price_list'] ??
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
