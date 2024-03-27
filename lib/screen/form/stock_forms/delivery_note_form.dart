import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import '../../../new_version/modules/new_item/presentation/pages/add_items.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
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
                        isValidate: false,
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
                  children: [
                    const SizedBox(height: 4),
                    CheckBoxWidget('is_return', 'Is Return',
                        initialValue: data['is_return'] == 1 ? true : false,
                        onChanged: (id, value) =>
                            setState(() => data[id] = value ? 1 : 0)),
                    CustomDropDownFromField(
                        defaultValue: data['project'],
                        docType: APIService.PROJECT,
                        nameResponse: 'name',
                        isValidate: false,
                        keys: const {
                          "subTitle": 'project_name',
                          "trailing": 'status',
                        },
                        title: 'Project'.tr(),
                        onChange: (value) {
                          setState(() {
                            data['project'] = value['name'];
                          });
                        }),
                    CustomDropDownFromField(
                        defaultValue:
                            data['currency'] ?? userProvider.defaultCurrency,
                        docType: APIService.CURRENCY,
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
                    CustomDropDownFromField(
                        defaultValue: data['selling_price_list'] ??
                            userProvider.defaultSellingPriceList,
                        docType: APIService.PRICE_LIST,
                        nameResponse: 'name',
                        title: 'Price List'.tr(),
                        onChange: (value) {
                          if (value != null && value.isNotEmpty) {
                            setState(() {
                              if (data['selling_price_list'] != value['name']) {
                                InheritedForm.of(context).items.clear();
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
                        disableValidation: true,
                        hintText: '1',
                        clearButton: true,
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
                        isValidate: false,
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
            ],
          ),
        ),
      ),
    );
  }
}
