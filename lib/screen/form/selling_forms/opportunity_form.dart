import 'package:NextApp/provider/user/user_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import '../../../new_version/modules/new_item/presentation/pages/add_items.dart';
import '../../../test/custom_page_view_form.dart';
import '../../../test/test_text_field.dart';
import 'quotation_form.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/inherited_widgets/select_items_list.dart';
import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../models/page_models/selling_page_model/opportunity_page_model.dart';

const List<String> grandTotalList = ['Grand Total', 'Net Total'];

class OpportunityForm extends StatefulWidget {
  const OpportunityForm({Key? key}) : super(key: key);

  @override
  _OpportunityFormState createState() => _OpportunityFormState();
}

class _OpportunityFormState extends State<OpportunityForm> {
  Map<String, dynamic> data = {
    "doctype": "Opportunity",
    "opportunity_from": "Customer",
    "posting_date": DateTime.now().toIso8601String(),
    "transaction_date": DateTime.now().toIso8601String(),
  };
  double totalAmount = 0;
  Map<String, dynamic> selectedCstData = {};
  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) return;

    if (provider.newItemList.isEmpty && data['with_items'] == 1) {
      showSnackBar('Please add an item at least', context);
      return;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    data['items'] = [];
    // for (var element in _items) {
    //   data['items'].add(element.toJson);
    // }
    for (var element in provider.newItemList) {
      data['items'].add(element);
    }

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Opportunity');

    final server = APIService();

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(OPPORTUNITY_POST, {'data': data}),
        context);

    // for loading dialog message
    Navigator.pop(context);

    if (provider.isEditing) Navigator.pop(context);

    if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['opportunity'] != null) {
        context.read<ModuleProvider>().pushPage(res['message']['opportunity']);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['opportunity'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['opportunity']);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GenericPage()));
    }
  }

  quotationType _type = quotationType.customer;

  void changeType(String newType) {
    data['opportunity_from'] = newType;
    data['party_name'] = null;
    data['customer_name'] = null;
    data['territory'] = null;
    data['customer_group'] = null;
    data['customer_address'] = null;
    data['contact_person'] = null;

    data['source'] = null;
    data['campaign'] = null;

    if (newType == KQuotationToList.last) {
      setState(() => _type = quotationType.customer);
    } else if (newType == KQuotationToList.first) {
      setState(() => _type = quotationType.lead);
    }
  }

  final List<ItemQuantity> _items = [];

  Future<void> _getCustomerData(String customer) async {
    selectedCstData = Map<String, dynamic>.from(
        await APIService().getPage(CUSTOMER_PAGE, customer))['message'];
  }

  @override
  void initState() {
    super.initState();

    final provider = context.read<ModuleProvider>();
    //Editing Mode
    if (provider.isEditing || provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        final items = OpportunityPageModel(context, data).items;
        //New Item
        for (var element in items) {
          provider.setItemToList(element);
        }

        for (var element in items) {
          final item = ItemSelectModel.fromJson(element);
          _items.add(
              ItemQuantity(item, qty: item.qty, rate: item.netRate.toDouble()));
        }
        setState(() {});
      });
    }

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;

        data['doctype'] = "Opportunity";
        data['posting_date'] = DateTime.now().toIso8601String();
        data['transaction_date'] = DateTime.now().toIso8601String();

        data['customer_name'] = data['lead_name'];
        data['party_name'] = data['name'];
        data['opportunity_from'] = "Lead"; //data['name'];

        _getCustomerData(data['customer_name']).then((value) => setState(() {
              data['currency'] = selectedCstData['default_currency'];
              data['price_list_currency'] = selectedCstData['default_currency'];
              data['payment_terms_template'] = selectedCstData['payment_terms'];
              data['customer_address'] =
                  selectedCstData["customer_primary_address"];
              data['contact_person'] =
                  selectedCstData["customer_primary_contact"];
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    InheritedForm.of(context).data['selling_price_list'] = '';
  }

  @override
  void deactivate() {
    super.deactivate();
    context.read<ModuleProvider>().resetCreationForm();
  }

  @override
  Widget build(BuildContext context) {
    for (var item in _items) {
      totalAmount += item.total;
    }
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
                    CustomDropDown('id', 'Opportunity From'.tr(),
                        items: KQuotationToList,
                        onChanged: changeType,
                        defaultValue:
                            data["opportunity_from"] ?? KQuotationToList[1]),
                    const Divider(
                        color: Colors.grey, height: 1, thickness: 0.7),
                    // New customer list
                    if (_type == quotationType.customer)
                      CustomDropDownFromField(
                          defaultValue: data['party_name'],
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
                                data['party_name'] = value['name'];
                                data['customer_name'] = value['customer_name'];
                                data['territory'] = value['territory'];
                                data['customer_group'] =
                                    value['customer_group'];
                                data['customer_address'] =
                                    value["customer_primary_address"];
                                data['contact_person'] =
                                    value["customer_primary_contact"];
                                data['contact_mobile'] = value['mobile_no'];
                              });
                            } else {
                              showSnackBar(
                                  'select quotation to first', context);
                            }
                          }),
                    // New lead list
                    if (_type == quotationType.lead)
                      CustomDropDownFromField(
                          defaultValue: data['party_name'],
                          docType: 'Lead',
                          nameResponse: 'name',
                          title: 'Lead'.tr(),
                          keys: const {
                            'subTitle': 'lead_name',
                            'trailing': 'territory',
                          },
                          onChange: (value) async {
                            if (value != null) {
                              setState(() {
                                data['party_name'] = value['name'];
                                data['customer_name'] = value['lead_name'];
                                data['territory'] = value['territory'];
                                data['source'] = value['source'];
                                data['campaign'] = value['campaign_name'];
                                data['contact_mobile'] = value['mobile_no'];
                                data['contact_email'] = value['email_id'];
                              });
                            } else {
                              showSnackBar(
                                  'select quotation to first', context);
                            }
                          }),

                    if (data['customer_name'] != null)
                      CustomTextFieldTest(
                        'customer_name',
                        data['opportunity_from'] ?? '',
                        initialValue: data['customer_name'],
                        disableValidation: true,
                        enabled: false,
                      ),
                    DatePickerTest('transaction_date', 'Date'.tr(),
                        initialValue: data['transaction_date'],
                        onChanged: (value) =>
                            setState(() => data['transaction_date'] = value)),
                    if (_type == quotationType.customer)

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
                    if (_type == quotationType.customer)
                      // New customer address
                      CustomExpandableTile(
                        hideArrow: data['customer_address'] == null,
                        title: CustomDropDownFromField(
                            defaultValue: data['customer_address'],
                            docType: APIService.FILTERED_ADDRESS,
                            nameResponse: 'name',
                            title: 'Customer Address'.tr(),
                            filters: {
                              'cur_nam': data['party_name'],
                            },
                            onChange: (value) async {
                              if (data['party_name'] == null) {
                                return showSnackBar(
                                    'Please select a customer to first',
                                    context);
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

                    if (_type == quotationType.customer)
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
                              'cur_nam': data['party_name'],
                            },
                            onChange: (value) {
                              if (data['party_name'] == null) {
                                showSnackBar(
                                    'Please select a customer', context);
                                return null;
                              }
                              setState(() {
                                data['contact_person'] = value['name'];
                                selectedCstData['contact_display'] =
                                    value['contact_display'];
                                selectedCstData['phone'] = value['phone'];
                                selectedCstData['mobile_no'] =
                                    value['mobile_no'];
                                selectedCstData['email_id'] = value['email_id'];
                              });
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

                    const SizedBox(height: 8),
                  ],
                ),
              ),

              ///
              /// group 2
              ///
              Group(
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    if (_type == quotationType.lead)
                      CustomDropDownFromField(
                          defaultValue: data['campaign'],
                          docType: APIService.CAMPAIGN,
                          nameResponse: 'name',
                          title: 'Campaign'.tr(),
                          onChange: (value) {
                            setState(() {
                              data['campaign'] = value['name'];
                            });
                          }),
                    if (_type == quotationType.lead)
                      CustomDropDownFromField(
                          defaultValue: data['source'],
                          docType: APIService.SOURCE,
                          nameResponse: 'name',
                          title: 'Source'.tr(),
                          onChange: (value) {
                            setState(() {
                              data['source'] = value['name'];
                            });
                          }),
                    CustomDropDownFromField(
                        defaultValue: data['opportunity_type'],
                        docType: APIService.OPPORTUNITY_TYPE,
                        nameResponse: 'name',
                        title: 'Opportunity Type'.tr(),
                        onChange: (value) {
                          setState(() {
                            data['opportunity_type'] = value['name'];
                          });
                        }),
                    if (_type == quotationType.lead)
                      CustomTextFieldTest('to_discuss', 'To Discuss'.tr(),
                          initialValue: data['to_discuss'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value),
                  ],
                ),
              ),

              AddItemsWidget(
                haveRate: false,
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
