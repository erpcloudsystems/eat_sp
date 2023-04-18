import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    if (newType == KQuotationToList.last)
      setState(() => _type = quotationType.customer);
    else if (newType == KQuotationToList.first)
      setState(() => _type = quotationType.lead);
  }

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

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Quotation');

    final server = APIService();

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(QUOTATION_POST, {'data': data}),
        context);

    // for loading dialog message
    Navigator.pop(context);

    InheritedForm.of(context).data['selling_price_list'] = null;

    if (provider.isEditing && res == false)
      return;
    //else if (provider.isEditing && res == null) Navigator.pop(context);\
    else if (provider.isEditing) Navigator.pop(context);

    if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['quotation'] != null)
        context.read<ModuleProvider>().pushPage(res['message']['quotation']);
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['quotation'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['quotation']);
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
        data = context.read<ModuleProvider>().updateData;
        _getCustomerData(data['customer_name']).then((value) => setState(() {
              selectedCstData['address_line1'] =
                  formatDescription(data['address_line1']);
              selectedCstData['city'] = data['city'];
              selectedCstData['country'] = data['country'];
            }));

        final items = QuotationPageModel(context, data).items;

        items.forEach((element) => InheritedForm.of(context)
            .items
            .add(ItemSelectModel.fromJson(element)));
        InheritedForm.of(context).data['selling_price_list'] =
            data['selling_price_list'];

        setState(() {});
      });

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;
        print(data.toString());

        data['transaction_date'] = DateTime.now().toIso8601String();
        data['apply_discount_on'] = grandTotalList[0];
        data['order_type'] = orderTypeList[0];
        data['conversion_rate'] = 1;

        //from lead
        if (data['doctype'] == 'Lead') {
          data['customer_name'] = data['lead_name'];
          data['party_name'] = data['name'];
          data['quotation_to'] = KQuotationToList[0];
        }
        // From Opportunity
        if (data['doctype'] == 'Opportunity') {
          data['opportunity'] = data['name'];
          data['customer_name'] = data['party_name'];
          data['party_name'] = data['customer_name'];
        }

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
        print('asdfsf1${data['customer_name']}');

        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //  print('========== Quotation Rebuild ============');
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
              ? Text("Edit Quotation")
              : Text("Create Quotation"),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Group(
                  child: Column(
                    children: [
                      SizedBox(height: 4),
                      CustomDropDown('id', 'Quotation To',
                          items: KQuotationToList,
                          onChanged: changeType,
                          defaultValue:
                              data["quotation_to"] ?? KQuotationToList[1]),
                      Divider(color: Colors.grey, height: 1, thickness: 0.7),
                      CustomTextField(
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
                        CustomTextField(
                          'customer_name',
                          data['quotation_to'] ?? '',
                          initialValue: data['customer_name'],
                          enabled: false,
                        ),
                      Row(children: [
                        Flexible(
                          child: DatePicker(
                            'transaction_date',
                            'Quotation Date',
                            initialValue: data['transaction_date'],
                            onChanged: (value) => setState(
                                () => data['transaction_date'] = value),
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
                        SizedBox(width: 10),
                        Flexible(
                            child: DatePicker(
                          'valid_till',
                          'Valid Till',
                          onChanged: (value) =>
                              setState(() => data['valid_till'] = value),
                          //firstDate: DateTime.parse(data['transaction_date']),
                          disableValidation: true,

                          initialValue: data['valid_till'] ??
                              ((selectedCstData['quotation_validaty_days'] !=
                                      '0')
                                  ? DateTime.now()
                                      .add(
                                        Duration(
                                          days: int.parse(selectedCstData[
                                                  'quotation_validaty_days']
                                              .toString())))
                                      .toIso8601String()
                                  : null),
                        )),
                      ]),
                      if (_type == quotationType.customer)
                        CustomTextField('customer_group', 'Customer Group',
                            initialValue: data['customer_group'],
                            disableValidation: true,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => customerGroupScreen()))),
                      CustomTextField('territory', 'Territory'.tr(),
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['territory'],
                          disableValidation: true,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => territoryScreen()))),
                      if (_type == quotationType.customer)
                        CustomExpandableTile(
                          hideArrow: data['customer_name'] == null,
                          title: CustomTextField(
                              'customer_address', 'Customer Address',
                              initialValue: data['customer_address'],
                              disableValidation: true,
                              clearButton: false,
                              onSave: (key, value) => data[key] = value,
                              liestenToInitialValue:
                                  data['customer_address'] == null,
                              onPressed: () async {
                                if (data['customer_name'] == null)
                                  return showSnackBar(
                                      'Please select a customer to first',
                                      context);
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
                                    title:
                                        Text(selectedCstData['country'] ?? ''),
                                  )
                                ]
                              : null,
                        ),
                      if (_type == quotationType.customer)
                        CustomExpandableTile(
                          hideArrow: data['customer_name'] == null,
                          title: CustomTextField(
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
                                  selectedCstData['mobile_no'] =
                                      res['mobile_no'];
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
                                        (selectedCstData['mobile_no'] ??
                                            'none')),
                                  ),
                                  ListTile(
                                    trailing: Icon(Icons.call),
                                    title: Text('Phone :  ' +
                                        (selectedCstData['phone'] ?? 'none')),
                                  ),
                                  ListTile(
                                    trailing: Icon(Icons.alternate_email),
                                    title: Text('' +
                                        (selectedCstData['email_id'] ??
                                            'none')),
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
                      CustomDropDown('order_type', 'Order Type'.tr(),
                          items: orderTypeList,
                          defaultValue: data['order_type'] ?? orderTypeList[0],
                          onChanged: (value) => data['order_type'] = value),
                      Divider(color: Colors.grey, height: 1, thickness: 0.7),
                      CustomTextField('currency', 'Currency',
                          initialValue: data['currency'],
                          liestenToInitialValue: data['currency'] == null,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => currencyListScreen()))),
                      CustomTextField(
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
                          hintText: '1',
                          clearButton: true,
                          validator: (value) =>
                              numberValidation(value, allowNull: true),
                          keyboardType: TextInputType.number,
                          onSave: (key, value) =>
                              data[key] = double.tryParse(value) ?? 1),
                      CustomTextField('payment_terms_template',
                          'Payment Terms Template'.tr(),
                          initialValue: data['payment_terms_template'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => paymentTermsScreen()))),
                      CustomTextField('tc_name', 'Terms & Conditions'.tr(),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(_terms!,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            )),
                      if (_terms != null)
                        Divider(color: Colors.grey, height: 1, thickness: 0.7),
                    ],
                  ),
                ),

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
