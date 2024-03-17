import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import '../../../new_version/modules/new_item/presentation/pages/add_items.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
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
import '../../../models/page_models/buying_page_model/supplier_quotation_page_model.dart';

const List<String> grandTotalList = ['Grand Total', 'Net Total'];

enum quotationType { supplier, none }

class SupplierQuotationForm extends StatefulWidget {
  const SupplierQuotationForm({Key? key}) : super(key: key);

  @override
  _SupplierQuotationFormState createState() => _SupplierQuotationFormState();
}

class _SupplierQuotationFormState extends State<SupplierQuotationForm> {
  final quotationType _type = quotationType.supplier;

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
    data['taxes'] =
        (provider.isEditing) ? [] : context.read<UserProvider>().defaultTax;
    // InheritedForm.of(context)
    //     .items
    //     .forEach((element) => data['items'].add(element.toJson));
    for (var element in provider.newItemList) {
      data['items'].add(element);
    }

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

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

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['quotation_name'] != null) {
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['quotation_name']);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null &&
        res['message']['supplier_quotation_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['supplier_quotation_name']);
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
    data['default_currency'] = context.read<UserProvider>().defaultCurrency;

    //Editing Mode
    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = provider.updateData;
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
        //New Item
        for (var element in items) {
          provider.setItemToList(element);
        }
        // for (var element in items) {
        //   InheritedForm.of(context)
        //       .items
        //       .add(ItemSelectModel.fromJson(element));
        // }
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
          provider.newItemList.add(element);
        });
        // data['items'].forEach((element) {
        //   InheritedForm.of(context)
        //       .items
        //       .add(ItemSelectModel.fromJson(element));
        // });

        print('asdfsf1$data');
        data['doctype'] = "Supplier Quotation";
        data['transaction_date'] = DateTime.now().toIso8601String();
        data['apply_discount_on'] = grandTotalList[0];

        // From Opportunity
        if (data['doctype'] == 'Opportunity') {
          data['opportunity'] = data['name'];
        }

        _getSupplierData(data['customer_name']).then((value) => setState(() {
              data['currency'] = selectedSupplierData['default_currency'];
              data['price_list_currency'] =
                  selectedSupplierData['default_currency'];
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
  void deactivate() {
    super.deactivate();
    context.read<ModuleProvider>().resetCreationForm();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final provider = context.read<ModuleProvider>();
    InheritedForm.of(context).data['selling_price_list'] = '';
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
                    CustomDropDownFromField(
                        defaultValue: data['supplier'],
                        docType: APIService.SUPPLIER,
                        nameResponse: 'name',
                        title: tr('Supplier'),
                        onChange: (value) {
                          if (_type == quotationType.supplier) {
                            if (value != null) {
                              _getSupplierData(value['name']);

                              setState(() {
                                data['name'] = value['name'];
                                data['supplier'] = value['name'];
                                data['supplier_name'] = value['supplier_name'];
                                data['valid_till'] = DateTime.now()
                                    .add(Duration(days: int.parse('30')))
                                    .toIso8601String(); // selectedSupplierData['credit_days']
                                data['supplier_address'] = selectedSupplierData[
                                    "supplier_primary_address"];

                                data['contact_person'] = selectedSupplierData[
                                    "supplier_primary_contact"];
                                data['contact_display'] = selectedSupplierData[
                                    "supplier_primary_contact"];
                                data['currency'] =
                                    selectedSupplierData['default_currency'];
                              });
                            }
                          } else {
                            showSnackBar('select quotation to first', context);
                          }
                        }),
                    Row(children: [
                      Flexible(
                        child: DatePickerTest(
                          'transaction_date',
                          'Quotation Date',
                          initialValue: data['transaction_date'],
                          onChanged: (value) =>
                              setState(() => data['transaction_date'] = value),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                          child: DatePickerTest(
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
                    CustomExpandableTile(
                      hideArrow: data['supplier'] == null,
                      title: CustomDropDownFromField(
                          defaultValue: data['supplier_address'],
                          docType: APIService.FILTERED_ADDRESS,
                          nameResponse: 'name',
                          title: tr('Supplier Address'),
                          filters: {'cur_nam': data['supplier']},
                          onChange: (value) {
                            if (data['supplier'] == null) {
                              return showSnackBar(
                                  'Please select a supplier to first', context);
                            }
                            setState(() {
                              data['supplier_address'] = value['name'];
                              selectedSupplierData['address_line1'] =
                                  value['address_line1'];
                              selectedSupplierData['city'] = value['city'];
                              selectedSupplierData['country'] =
                                  value['country'];
                            });
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
                      title: CustomDropDownFromField(
                          defaultValue: data['contact_person'],
                          docType: APIService.FILTERED_CONTACT,
                          nameResponse: 'name',
                          title: tr('Contact Person'),
                          isValidate: false,
                          filters: {'cur_nam': data['supplier']},
                          onChange: (value) {
                            if (data['supplier'] == null) {
                              showSnackBar('Please select a supplier', context);
                              return null;
                            }

                            setState(() {
                              data['contact_person'] = value['name'];

                              selectedSupplierData['contact_display'] =
                                  value['contact_person'];
                              selectedSupplierData['mobile_no'] =
                                  value['mobile_no'];
                              selectedSupplierData['phone'] = value['phone'];
                              selectedSupplierData['email_id'] =
                                  value['email_id'];
                            });
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
                    CustomDropDownFromField(
                        defaultValue:
                            data['currency'] ?? userProvider.defaultCurrency,
                        docType: APIService.CURRENCY,
                        nameResponse: 'name',
                        title: tr('Currency'),
                        onChange: (value) {
                          setState(() {
                            data['currency'] = value['name'];
                          });
                        }),
                    CustomTextFieldTest(
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
                    CustomTextFieldTest(
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
                    CustomDropDownFromField(
                        defaultValue: data['buying_price_list'] ??
                            userProvider.defaultBuyingPriceList,
                        docType: APIService.BUYING_PRICE_LIST,
                        nameResponse: 'name',
                        title: 'Price List'.tr(),
                        onChange: (value) {
                          if (value != null && value.isNotEmpty) {
                            setState(() {
                              if (data['buying_price_list'] != value['name']) {
                                provider.newItemList.clear();
                                InheritedForm.of(context)
                                    .data['buying_price_list'] = value['name'];
                                data['buying_price_list'] = value['name'];
                              }
                              data['price_list_currency'] = value['currency'];
                            });
                          }
                        }),
                    CustomDropDownFromField(
                        defaultValue: data['price_list_currency'],
                        docType: APIService.CURRENCY,
                        nameResponse: 'name',
                        title: 'Price List Currency'.tr(),
                        isValidate: false,
                        onChange: (value) {
                          setState(() {
                            data['price_list_currency'] = value['name'];
                          });
                        }),
                    CheckBoxWidget('ignore_pricing_rule', 'Ignore Pricing Rule',
                        initialValue:
                            data['ignore_pricing_rule'] == 1 ? true : false,
                        onChanged: (id, value) =>
                            setState(() => data[id] = value ? 1 : 0)),
                  ],
                ),
              ),
              AddItemsWidget(
                priceList: data['buying_price_list'] ??
                    context.read<UserProvider>().defaultBuyingPriceList,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
