import 'dart:developer';

import 'package:NextApp/widgets/new_widgets/test_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import '../../../new_version/modules/new_item/presentation/pages/add_items.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
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
import '../../../models/page_models/selling_page_model/sales_order_model.dart';

const List<String> grandTotalList = ['Grand Total', 'Net Total'];

class SalesOrderForm extends StatefulWidget {
  const SalesOrderForm({super.key});

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

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(SALES_ORDER_POST, {'data': data}),
        context);

    Navigator.pop(context);
    InheritedForm.of(context).data['selling_price_list'] = null;

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['sales_order'] != null) {
        context.read<ModuleProvider>().pushPage(res['message']['sales_order']);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['sales_order'] != null) {
      log(data.toString());
      context.read<ModuleProvider>().pushPage(res['message']['sales_order']);
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
        print('123E4${InheritedForm.of(context).items}');
        if (InheritedForm.of(context).items.isNotEmpty) {
          print('123E4${InheritedForm.of(context).items[0].netRate}');
        }
        data = context.read<ModuleProvider>().updateData;
        print('123E5${InheritedForm.of(context).items}');
        if (InheritedForm.of(context).items.isNotEmpty) {
          print('123E5${InheritedForm.of(context).items[0].netRate}');
        }
        _getCustomerData(data['customer']).then((value) => setState(() {
              selectedCstData['address_line1'] =
                  formatDescription(data['address_line1']);
              selectedCstData['city'] = data['city'];
              selectedCstData['country'] = data['country'];
            }));

        final items = SalesOrderPageModel(context, data).items;

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
        print('123E6${InheritedForm.of(context).items}');
        if (InheritedForm.of(context).items.isNotEmpty) {
          print('123E6${InheritedForm.of(context).items[0].netRate}');
        }

        setState(() {});
      });
    }

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;

        // Because "Customer Visit" doesn't have Items.
        if (data['doctype'] != DocTypesName.customerVisit) {
          InheritedForm.of(context).items.clear();
          // data['items'].forEach((element) {
          //   InheritedForm.of(context)
          //       .items
          //       .add(ItemSelectModel.fromJson(element));
          // });
          data['items'].forEach((element) {
            provider.newItemList.add(element);
          });
        }

        InheritedForm.of(context).data['selling_price_list'] =
            data['selling_price_list'];

        data['posting_date'] = DateTime.now().toIso8601String();
        data['is_return'] = 0;
        data['update_stock'] = 1;
        data['latitude'] = 0.0;
        data['longitude'] = 0.0;
        data['conversion_rate'] = 1;

        // from Quotation
        if (data['doctype'] == 'Quotation') {
          data['prevdoc_docname'] = data['name'];
          data['customer'] = data['party_name'];
          data['customer_name'] = data['party_name'];
        }

        // From Customer Visit:
        if (data['doctype'] == DocTypesName.customerVisit) {
          data['customer_name'] = data['customer'];
          data['customer'] = data['customer'];
          data["transaction_date"] = DateTime.now().toIso8601String();
          data['order_type'] = orderTypeList[0];
          data["update_stock"] = 0;
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
              data['contact_person'] =
                  selectedCstData["customer_primary_contact"];
              data['territory'] = selectedCstData['territory'];
              data['customer_group'] = selectedCstData['customer_group'];
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
                    // New customer list
                    CustomDropDownFromField(
                        defaultValue: data['customer'],
                        docType: 'Customer',
                        nameResponse: 'name',
                        title: 'Customer'.tr(),
                        keys: const {
                          'subTitle': 'customer_group',
                          'trailing': 'territory',
                        },
                        onChange: (value) async {
                          if (value != null) {
                            await _getCustomerData(value['name']);

                            setState(() {
                              data['customer'] = value['name'];
                              data['customer_name'] = value['customer_name'];
                              data['territory'] = value['territory'];
                              data['customer_group'] = value['customer_group'];
                              data['customer_address'] =
                                  value["customer_primary_address"];
                              data['contact_person'] =
                                  value["customer_primary_contact"];
                              data['currency'] = value['default_currency'];
                              data['price_list_currency'] =
                                  value['default_currency'];
                              if (data['selling_price_list'] !=
                                  value['default_price_list']) {
                                data['selling_price_list'] =
                                    value['default_price_list'];
                                InheritedForm.of(context).items.clear();
                                InheritedForm.of(context)
                                        .data['selling_price_list'] =
                                    value['default_price_list'];
                              }
                              data['payment_terms_template'] =
                                  value['payment_terms'];
                              data['sales_partner'] =
                                  value['default_sales_partner'];
                              data['tax_id'] = value['tax_id'];
                            });
                          }
                        }),

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
                    Row(children: [
                      Flexible(
                          child: DatePickerTest(
                        'transaction_date',
                        'Date'.tr(),
                        lastDate:
                            DateTime.tryParse(data['delivery_date'] ?? ''),
                        initialValue: data['transaction_date'] ?? '',
                        onChanged: (value) =>
                            setState(() => data['transaction_date'] = value),
                      )),
                      const SizedBox(width: 10),
                      Flexible(
                          child: DatePickerTest(
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
                    // New customer group
                    CustomDropDownFromField(
                        defaultValue: data['customer_group'],
                        docType: 'Customer Group',
                        nameResponse: 'name',
                        title: 'Customer Group'.tr(),
                        onChange: (value) {
                          setState(() {
                            data['customer_group'] = value['name'];
                          });
                        }),
                    // New territory
                    CustomDropDownFromField(
                        defaultValue: data['territory'],
                        docType: APIService.TERRITORY,
                        nameResponse: 'name',
                        title: 'Territory'.tr(),
                        onChange: (value) {
                          setState(() {
                            data['territory'] = value['name'];
                          });
                        }),
                    // New customer address
                    CustomExpandableTile(
                      hideArrow: data['customer'] == null,
                      title: CustomDropDownFromField(
                          defaultValue: data['customer_address'],
                          docType: APIService.FILTERED_ADDRESS,
                          nameResponse: 'name',
                          title: 'Customer Address'.tr(),
                          filters: {
                            'cur_nam': data['customer'],
                          },
                          onChange: (value) async {
                            if (data['customer'] == null) {
                              return showSnackBar(
                                  'Please select a customer to first', context);
                            }

                            setState(() {
                              data['customer_address'] = value['name'];
                              selectedCstData['address_line1'] =
                                  value['address_line1'];
                              selectedCstData['city'] = value['city'];
                              selectedCstData['country'] = value['country'];
                            });
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

                    // New contact person
                    CustomExpandableTile(
                      hideArrow: data['contact_person'] == null,
                      title: CustomDropDownFromField(
                          defaultValue: data['contact_person'],
                          docType: APIService.FILTERED_CONTACT,
                          nameResponse: 'name',
                          isValidate: false,
                          title: 'Contact Person'.tr(),
                          filters: {
                            'cur_nam': data['customer'],
                          },
                          onChange: (value) {
                            if (data['customer'] == null) {
                              showSnackBar('Please select a customer', context);
                              return null;
                            }
                            setState(() {
                              data['contact_person'] = value['name'];
                              selectedCstData['contact_display'] =
                                  value['contact_display'];
                              selectedCstData['phone'] = value['phone'];
                              selectedCstData['mobile_no'] = value['mobile_no'];
                              selectedCstData['email_id'] = value['email_id'];
                            });
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
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 4),
                    // CustomDropDownFromField(
                    //     defaultValue: data['project'],
                    //     docType: APIService.PROJECT,
                    //     nameResponse: 'name',
                    //     keys: const {
                    //       "subTitle": 'project_name',
                    //       "trailing": 'status',
                    //     },
                    //     title: 'Project'.tr(),
                    //     onChange: (value) {
                    //       setState(() {
                    //         data['project'] = value['name'];
                    //       });
                    //     }),
                    CustomDropDown('order_type', 'Order Type'.tr(),
                        items: orderTypeList,
                        defaultValue: data['order_type'] ?? orderTypeList[0],
                        onChanged: (value) => data['order_type'] = value),
                    const Divider(
                        color: Colors.grey, height: 1, thickness: 0.7),
                    CustomDropDownFromField(
                        defaultValue:
                            data['currency'] ?? userProvider.defaultCurrency,
                        docType: APIService.CURRENCY,
                        enable: false,
                        nameResponse: 'name',
                        title: 'Currency'.tr(),
                        onChange: (value) {
                          setState(() {
                            data['currency'] = value['name'];
                          });
                        }),
                    CustomTextFieldTest(
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
                    CustomDropDownFromField(
                        defaultValue: data['selling_price_list'] ??
                            userProvider.defaultSellingPriceList,
                        docType: APIService.PRICE_LIST,
                        enable: false,
                        nameResponse: 'name',
                        title: 'Price List'.tr(),
                        onChange: (value) {
                          if (value != null && value.isNotEmpty) {
                            setState(() {
                              if (data['selling_price_list'] != value['name']) {
                                provider.newItemList.clear();
                                InheritedForm.of(context)
                                    .data['selling_price_list'] = value['name'];
                                data['selling_price_list'] = value['name'];
                              }
                              data['price_list_currency'] = value['currency'];
                            });
                          }
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
                        disableValidation: true,
                        validator: (value) =>
                            numberValidation(value, allowNull: true),
                        keyboardType: TextInputType.number,
                        onSave: (key, value) =>
                            data[key] = double.tryParse(value) ?? 1),
                    CustomDropDownFromField(
                        defaultValue: data['set_warehouse'],
                        docType: APIService.WAREHOUSE,
                        nameResponse: 'name',
                        title: 'Source Warehouse'.tr(),
                        keys: const {
                          'subTitle': 'warehouse_name',
                          'trailing': 'warehouse_type',
                        },
                        onChange: (value) {
                          setState(() {
                            data['set_warehouse'] = value['name'];
                          });
                        }),
                    CustomDropDownFromField(
                        defaultValue: data['payment_terms_template'],
                        docType: APIService.PAYMENT_TERMS,
                        nameResponse: 'name',
                        title: 'Payment Terms Template'.tr(),
                        onChange: (value) {
                          setState(() {
                            data['payment_terms_template'] = value['name'];
                          });
                        }),
                    CustomDropDownFromField(
                        defaultValue: data['tc_name'],
                        docType: APIService.TERMS_CONDITION,
                        nameResponse: 'name',
                        title: 'Terms & Conditions'.tr(),
                        onChange: (value) {
                          setState(() {
                            data['tc_name'] = value['name'];
                          });
                        }),
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
                    CustomDropDownFromField(
                        defaultValue: data['sales_partner'],
                        docType: APIService.SALES_PARTNER,
                        nameResponse: 'name',
                        title: 'Sales Partner'.tr(),
                        onChange: (value) {
                          setState(() {
                            data['sales_partner'] = value['name'];
                          });
                        }),
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
