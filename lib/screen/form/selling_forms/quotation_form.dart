import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/modules/new_item/presentation/pages/add_items.dart';
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
import '../../../models/page_models/selling_page_model/quotation_page_model.dart';

const List<String> grandTotalList = ['Grand Total', 'Net Total'];

enum quotationType { customer, lead, none }

class QuotationForm extends StatefulWidget {
  const QuotationForm({Key? key}) : super(key: key);

  @override
  _QuotationFormState createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {
  quotationType _type = quotationType.customer;

  String? _terms;

  Map<String, dynamic> data = {
    "doctype": "Quotation",
    "transaction_date": DateTime.now().toIso8601String(),
    'apply_discount_on': grandTotalList[0],
    'order_type': orderTypeList[0],
    'quotation_to': KQuotationToList[1],
    'conversion_rate': 1,
  };
  Map<String, dynamic> selectedCstData = {
    'quotation_validaty_days': '0',
  };

  //used to clear all fields when change Quotation type(customer or lead)
  void changeType(String newType) {
    data['valid_till'] = null;
    data['quotation_to'] = newType;
    data['party_name'] = null;
    data['customer_name'] = null;
    data['territory'] = null;
    data['customer_group'] = null;
    // data['customer_type'] = null;
    data['customer_address'] = null;
    data['contact_person'] = null;
    data['selling_price_list'] = null;
    data['payment_terms_template'] = null;
    data['currency'] = null;
    data['price_list_currency'] = null;

    if (data['source'] != null) data['source'] = null;
    if (data['campaign'] != null) data['campaign'] = null;

    if (newType == KQuotationToList.last) {
      setState(() => _type = quotationType.customer);
    } else if (newType == KQuotationToList.first) {
      setState(() => _type = quotationType.lead);
    }
  }

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

    data['docstatus'] = 0;
    data['items'] = [];
    data['taxes'] = context.read<UserProvider>().defaultTax;
    // InheritedForm.of(context)
    //     .items
    //     .forEach((element) => data['items'].add(element.toJson));
    for (var element in provider.newItemList) {
      data['items'].add(element);
    }

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Quotation');

    final server = APIService();

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(QUOTATION_POST, {'data': data}),
        context);

    // for loading dialog message
    Navigator.pop(context);

    InheritedForm.of(context).data['selling_price_list'] = null;

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing) {
      Navigator.pop(context);
    }

    if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['quotation'] != null) {
        context.read<ModuleProvider>().pushPage(res['message']['quotation']);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['quotation'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['quotation']);
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
    if (!provider.isEditing) {
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
                  formatDescription(data['address_line1']);
              selectedCstData['city'] = data['city'];
              selectedCstData['country'] = data['country'];
            }));

        final items = QuotationPageModel(context, data).items;

        // for (var element in items) {
        //   InheritedForm.of(context)
        //       .items
        //       .add(ItemSelectModel.fromJson(element));
        // }
        for (var element in items) {
          provider.setItemToList(element);
        }
        InheritedForm.of(context).data['selling_price_list'] =
            data['selling_price_list'];

        setState(() {});
      });
    }

    //DocFromPage Mode
    if (provider.isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = provider.createFromPageData;
        print(data.toString());

        data['transaction_date'] = DateTime.now().toIso8601String();
        data['apply_discount_on'] = grandTotalList[0];
        data['order_type'] = orderTypeList[0];
        data['conversion_rate'] = 1;

        //from lead
        if (data['doctype'] == 'Lead') {
          data['customer_name'] = data['lead_name'];
          data['party_name'] = data['name'];
          data['campaign'] = data['campaign_name'];
          data['quotation_to'] = KQuotationToList[0];
          data['selling_price_list'] =
              context.read<UserProvider>().defaultSellingPriceList;
        }
        // From Opportunity
        if (data['doctype'] == 'Opportunity') {
          data['opportunity'] = data['name'];
          data['customer_name'] = data['party_name'];
          data['party_name'] = data['customer_name'];
          data['quotation_to'] = data['opportunity_from'] == 'Lead'
              ? KQuotationToList[0]
              : KQuotationToList[1];
          // data['selling_price_list'] =
          //     context.read<UserProvider>().defaultSellingPriceList;
        }
        final items = QuotationPageModel(context, data).items;
        //New Item
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

        _getCustomerData(data['customer_name']).then((value) => setState(() {
              data['valid_till'] = DateTime.now()
                  .add(Duration(
                      days: int.parse(
                          (selectedCstData['quotation_validaty_days'] ?? "0")
                              .toString())))
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
              data['payment_terms_template'] = selectedCstData['payment_terms'];
              data['customer_address'] =
                  selectedCstData["customer_primary_address"];
              data['contact_person'] =
                  selectedCstData["customer_primary_contact"];
            }));

        data['doctype'] = "Quotation";
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
        print('${data['customer_name']}');

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
    final provider = context.read<ModuleProvider>();
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
        body: Form(
          key: _formKey,
          child: CustomPageViewForm(
            submit: () => submit(),
            widgetGroup: [
              Group(
                child: ListView(
                  children: [
                    const SizedBox(height: 4),
                    CustomDropDown(
                      'id',
                      'Quotation To',
                      items: KQuotationToList,
                      onChanged: changeType,
                      defaultValue: data["quotation_to"] ?? KQuotationToList[1],
                    ),
                    const Divider(
                        color: Colors.grey, height: 1, thickness: 0.7),
                    CustomTextFieldTest(
                      'party_name',
                      data['quotation_to'] ?? '',
                      initialValue: data['party_name'],
                      onPressed: () async {
                        String? id;
                        if (_type == quotationType.customer) {
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      selectCustomerScreen()));
                          if (res != null) {
                            id = res['name'];

                            await _getCustomerData(res['name']);

                            setState(() {
                              data['valid_till'] = DateTime.now()
                                  .add(Duration(
                                      days: int.parse((selectedCstData[
                                                  'quotation_validaty_days'] ??
                                              "0")
                                          .toString())))
                                  .toIso8601String();
                              data['party_name'] = res['name'];
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
                            });
                          }
                        } else if (_type == quotationType.lead) {
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => selectLeadScreen()));
                          if (res != null) {
                            id = res['name'];
                            //await _getCustomerData(res['name']);
                            setState(() {
                              data['valid_till'] = DateTime.now()
                                  .add(Duration(
                                      days: int.parse(selectedCstData[
                                              'quotation_validaty_days']
                                          .toString())))
                                  .toIso8601String();
                              data['party_name'] = res['name'];
                              data['customer_name'] = res['lead_name'];
                              data['territory'] = res['territory'];
                              data['source'] = res['source'];
                              data['campaign'] = res['campaign_name'];
                            });
                          }
                        } else {
                          showSnackBar('select quotation to first', context);
                        }
                        return id;
                      },
                    ),
                    if (data['customer_name'] != null)
                      CustomTextFieldTest(
                        'customer_name',
                        data['quotation_to'] ?? '',
                        initialValue: data['customer_name'],
                        enabled: false,
                      ),
                    Row(children: [
                      Flexible(
                        child: DatePickerTest(
                          'transaction_date',
                          'Quotation Date',
                          initialValue: data['transaction_date'],
                          onChanged: (value) =>
                              setState(() => data['transaction_date'] = value),
                          lastDate: DateTime.tryParse(data['valid_till'] ??
                              DateTime.now()
                                  .add(Duration(
                                      days: int.parse((selectedCstData[
                                                  'quotation_validaty_days'] ??
                                              "0")
                                          .toString())))
                                  .toIso8601String()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                          child: DatePickerTest(
                        'valid_till',
                        'Valid Till',
                        onChanged: (value) =>
                            setState(() => data['valid_till'] = value),
                        //firstDate: DateTime.parse(data['transaction_date']),
                        disableValidation: true,

                        initialValue: data['valid_till'] ??
                            ((selectedCstData['quotation_validaty_days'] != '0')
                                ? DateTime.now()
                                    .add(Duration(
                                        days: int.parse(selectedCstData[
                                                'quotation_validaty_days']
                                            .toString())))
                                    .toIso8601String()
                                : null),
                      )),
                    ]),
                    if (_type == quotationType.customer)
                      CustomTextFieldTest('customer_group', 'Customer Group',
                          initialValue: data['customer_group'],
                          disableValidation: true,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => customerGroupScreen()))),
                    CustomTextFieldTest('territory', 'Territory'.tr(),
                        onSave: (key, value) => data[key] = value,
                        initialValue: data['territory'],
                        disableValidation: true,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => territoryScreen()))),
                    if (_type == quotationType.customer)
                      CustomExpandableTile(
                        hideArrow: data['customer_name'] == null,
                        title: CustomTextFieldTest(
                            'customer_address', 'Customer Address',
                            initialValue: data['customer_address'],
                            disableValidation: true,
                            clearButton: false,
                            onSave: (key, value) => data[key] = value,
                            liestenToInitialValue:
                                data['customer_address'] == null,
                            onPressed: () async {
                              if (data['customer_name'] == null) {
                                return showSnackBar(
                                    'Please select a customer to first',
                                    context);
                              }
                              final res = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => customerAddressScreen(
                                          data['customer_name'])));
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
                    if (_type == quotationType.customer)
                      CustomExpandableTile(
                        hideArrow: data['customer_name'] == null,
                        title: CustomTextFieldTest(
                            'contact_person', 'Contact Person',
                            initialValue: data['contact_person'],
                            disableValidation: true,
                            clearButton: false,
                            onSave: (key, value) => data[key] = value,
                            onPressed: () async {
                              if (data['customer_name'] == null) {
                                showSnackBar(
                                    'Please select a customer', context);
                                return null;
                              }
                              final res = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => contactScreen(
                                          data['customer_name'])));
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
                                      (selectedCstData['contact_display'] ??
                                          '')),
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
                    if (_type == quotationType.lead)
                      CustomTextField('campaign', 'Campaign',
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['campaign'],
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => campaignScreen()))),
                    if (_type == quotationType.lead)
                      CustomTextField('source', 'Source',
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['source'],
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => sourceScreen()))),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              /// group 2
              Group(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    CustomDropDown('order_type', 'Order Type'.tr(),
                        items: orderTypeList,
                        defaultValue: data['order_type'] ?? orderTypeList[0],
                        onChanged: (value) => data['order_type'] = value),
                    const Divider(
                        color: Colors.grey, height: 1, thickness: 0.7),
                    CustomTextFieldTest('currency', 'Currency',
                        initialValue:
                            data['currency'] ?? userProvider.defaultCurrency,
                        liestenToInitialValue: data['currency'] == null,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => currencyListScreen()))),
                    CustomTextFieldTest(
                      'conversion_rate',
                      'Exchange Rate'.tr(),
                      initialValue: '${data['conversion_rate'] ?? ''}',
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
                        onChanged: (value) => setState(() {
                              data['selling_price_list'] = value;
                            }),
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => priceListScreen()));
                          if (res != null && res.isNotEmpty) {
                            setState(() {
                              if (data['selling_price_list'] != res['name']) {
                                provider.newItemList.clear();
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
                        hintText: '1',
                        clearButton: true,
                        validator: (value) =>
                            numberValidation(value, allowNull: true),
                        keyboardType: TextInputType.number,
                        onSave: (key, value) =>
                            data[key] = double.tryParse(value) ?? 1),
                    CustomTextFieldTest(
                        'payment_terms_template', 'Payment Terms Template'.tr(),
                        initialValue: data['payment_terms_template'],
                        disableValidation: true,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => paymentTermsScreen()))),
                    CustomTextFieldTest('tc_name', 'Terms & Conditions'.tr(),
                        initialValue: data['tc_name'],
                        onSave: (key, value) => data[key] = value,
                        disableValidation: true,
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
                ),
              ),
              AddItemsWidget(
                  priceList: data['selling_price_list'] ??
                      context.read<UserProvider>().defaultSellingPriceList),
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
