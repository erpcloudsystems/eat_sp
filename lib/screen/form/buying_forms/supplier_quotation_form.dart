import 'package:next_app/models/page_models/selling_page_model/quotation_page_model.dart';
import 'package:next_app/service/service.dart';
import 'package:next_app/service/service_constants.dart';
import 'package:next_app/provider/module/module_provider.dart';
import 'package:next_app/provider/user/user_provider.dart';
import 'package:next_app/screen/list/otherLists.dart';
import 'package:next_app/screen/page/generic_page.dart';
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
import '../../../models/page_models/buying_page_model/supplier_quotation_page_model.dart';
import '../../../models/page_models/model_functions.dart';

const List<String> grandTotalList = ['Grand Total', 'Net Total'];

enum quotationType { supplier, none }

class SupplierQuotationForm extends StatefulWidget {
  const SupplierQuotationForm({Key? key}) : super(key: key);

  @override
  _SupplierQuotationFormState createState() => _SupplierQuotationFormState();
}

class _SupplierQuotationFormState extends State<SupplierQuotationForm> {
  quotationType _type = quotationType.supplier;

  String? _terms;

  Map<String, dynamic> data = {
    "doctype": "Supplier Quotation",
    "transaction_date": DateTime.now().toIso8601String(),
    'apply_discount_on': grandTotalList[0],
  };

  Map<String, dynamic> selectedSupplierData = {
    'quotation_validaty_days': '0',
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
    _formKey.currentState!.save();

    data['items'] = [];
    data['taxes'] =
        (provider.isEditing) ? [] : context.read<UserProvider>().defaultTax;
    InheritedForm.of(context)
        .items
        .forEach((element) => data['items'].add(element.toJson));

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Quotation');

    final server = APIService();

    data['total_qty'] = null;
    data['total'] = null;
    data['base_total'] = null;
    data['net_total'] = null;
    data['base_net_total'] = null;
    data['total_taxes_and_charges '] = null;
    data['base_total_taxes_and_charges'] = null;
    data['additional_discount_percentage'] = null;
    data['discount_amount'] = null;
    data['base_discount_amount'] = null;
    data['in_words'] = null;
    data['base_grand_total'] = null;
    data['set_posting_time'] = null;

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(SUPPLIER_QUOTATION_POST, {'data': data}),
        context);
    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['quotation_name'] != null)
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['quotation_name']);
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['quotation_name'] != null) {
      context.read<ModuleProvider>().pushPage(
          res['message']['quotation_name']);
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
    if (context.read<ModuleProvider>().isEditing){
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        _getSupplierData(data['supplier']).then((value) => setState(() {
          selectedSupplierData['address_line1'] =
              formatDescription(data['address_line1']);

          selectedSupplierData['city'] = data['city'];
          selectedSupplierData['country'] = data['country'];

          selectedSupplierData['contact_display'] =
              formatDescription(data['contact_display']);
          selectedSupplierData['mobile_no'] = data['mobile_no'];
          selectedSupplierData['phone'] = data['phone'];
          selectedSupplierData['email_id'] = data['email_id'];
        }));

        //print('➡️ This is existing data: $data');
        final items = SupplierQuotationPageModel(context, data).items;

        items.forEach((element) => InheritedForm.of(context)
            .items
            .add(ItemSelectModel.fromJson(element)));
        InheritedForm.of(context).data['buying_price_list'] =
        data['buying_price_list'];

        setState(() {});
      });
    }

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;

        InheritedForm.of(context).items.clear;

        data['items'].forEach((element) {
          InheritedForm.of(context)
              .items
              .add(ItemSelectModel.fromJson(element));
        });

        print('asdfsf1${data}');
        data['doctype'] = "Supplier Quotation";
        data['transaction_date'] = DateTime.now().toIso8601String();
        data['apply_discount_on'] = grandTotalList[0];


        // From Opportunity
        if(data['doctype']=='Opportunity'){
          data['opportunity'] = data['name'];
        }

        _getSupplierData(data['customer_name']).then((value) => setState(() {
          data['currency'] = selectedSupplierData['default_currency'];
          data['price_list_currency'] = selectedSupplierData['default_currency'];

        }));

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
  Widget build(BuildContext context) {
    InheritedForm.of(context)
        .data['selling_price_list']='';
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
              ? Text("Edit Supplier Quotation")
              : Text("Create Supplier Quotation"),
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
                      CustomTextField(
                        'supplier',
                        'Supplier',
                        initialValue: data['supplier'],
                        onPressed: () async {
                          String? id;
                          if (_type == quotationType.supplier) {
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        selectSupplierScreen())); //todo check @run

                            if (res != null) {
                              id = res['name'];
                              _getSupplierData(res['name']);
                              // selectedSupplierData = Map<String, dynamic>.from(
                              //     await APIService().getPage(
                              //         SUPPLIER_PAGE, res['name']))['message'];
                              setState(() {
                                data['name'] = res['name'];
                                data['supplier'] = res['name'];
                                data['supplier_name'] = res['supplier_name'];
                                data['valid_till'] = DateTime.now()
                                    .add(Duration(days: int.parse('30')))
                                    .toIso8601String(); // selectedSupplierData['credit_days']
                                data['supplier_address'] = selectedSupplierData[
                                    "supplier_primary_address"];
                                // data['contact_mobile'] =
                                //     selectedSupplierData["mobile_no"];
                                // data['contact_email'] =
                                //     selectedSupplierData["email_id"];
                                data['contact_person'] = selectedSupplierData[
                                    "supplier_primary_contact"];
                                data['contact_display'] = selectedSupplierData[
                                    "supplier_primary_contact"];
                                data['currency'] =
                                    selectedSupplierData['default_currency'];
                                if (data['buying_price_list'] !=
                                    res['default_price_list']) {
                                  data['buying_price_list'] =
                                      res['default_price_list'];
                                  InheritedForm.of(context).items.clear();
                                  InheritedForm.of(context)
                                          .data['buying_price_list'] =
                                      res['default_price_list'];
                                }
                              });
                            }
                          } else {
                            showSnackBar('select quotation to first', context);
                          }
                          return id;
                        },
                      ),
                      Row(children: [
                        Flexible(
                          child: DatePicker(
                            'transaction_date',
                            'Quotation Date',
                            initialValue: data['transaction_date'],
                            onChanged: (value) => setState(
                                () => data['transaction_date'] = value),
                          ),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                            child: DatePicker(
                          'valid_till',
                          'Valid Till',
                          onChanged: (value) =>
                              setState(() => data['valid_till'] = value),
                          initialValue: data['valid_till'] ??
                              DateTime.now()
                                  .add(Duration(days: int.parse('30')))
                                  .toIso8601String(),
                        )),
                      ]),
                      // CustomTextField(
                      //   'quotation_number',
                      //   'Quotation No',
                      //   onSave: (key, value) => data[key] = value,
                      //   initialValue: data['quotation_number'] ,
                      //   clearButton: false,
                      //   disableValidation: false,
                      //   validator: (value) =>
                      //       numberValidation(value, allowNull: true),
                      //   keyboardType: TextInputType.number,
                      // ),

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
                                if (selectedSupplierData['address_line1'] !=
                                    null)
                                  ListTile(
                                    trailing: Icon(Icons.location_on),
                                    title: Text(
                                        selectedSupplierData['address_line1'] ??
                                            ''),
                                  ),
                                if (selectedSupplierData['city'] != null)
                                  ListTile(
                                    trailing: Icon(Icons.location_city),
                                    title: Text(
                                        selectedSupplierData['city'] ?? ''),
                                  ),
                                if (selectedSupplierData['country'] != null)
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
                                        res['contact_person'];
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
                                  title: Text('Phone :  ' +
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

                      CustomTextField('currency', 'Currency',
                          initialValue: data['currency'],
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => currencyListScreen()))),
                      CustomTextField(
                        'conversion_rate',
                        'Exchange Rate'.tr(),
                        initialValue: '${data['conversion_rate'] ?? '1'}',
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
                        initialValue: '${data['conversion_rate'] ?? '1'}',
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
                          disableValidation: true, onPressed: () async {
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
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => currencyListScreen()))),
                      CheckBoxWidget(
                          'ignore_pricing_rule', 'Ignore Pricing Rule',
                          initialValue:
                              data['ignore_pricing_rule'] == 1 ? true : false,
                          onChanged: (id, value) =>
                              setState(() => data[id] = value ? 1 : 0)),
                    ],
                  ),
                ),

                // ///
                // /// group 3
                // ///
                // Group(
                //   child: Column(
                //     children: [
                //       CustomDropDown('apply_discount_on', 'Apply Additional Discount On',
                //           items: grandTotalList, defaultValue: grandTotalList[0], onChanged: (value) => data['apply_discount_on'] = value),
                //       Divider(color: Colors.grey, height: 1, thickness: 0.7),
                //       CustomTextField(
                //         'additional_discount_percentage',
                //         'Additional Discount Percentage',
                //         keyboardType: TextInputType.number,
                //         onSave: (key, value) => data[key] = double.tryParse(value) ?? 0,
                //       ),
                //       CustomTextField(
                //         'discount_amount',
                //         'Additional Discount Amount (Company Currency)',
                //         keyboardType: TextInputType.number,
                //         onSave: (key, value) => data[key] = double.tryParse(value) ?? 0,
                //       ),
                //     ],
                //   ),
                // ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: Text('Net Total', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: Text('VAT', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: Text('Total', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
