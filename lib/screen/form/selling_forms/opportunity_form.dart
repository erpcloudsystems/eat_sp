import 'package:NextApp/provider/user/user_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/modules/new_item/presentation/pages/add_items.dart';
import '../../../test/custom_page_view_form.dart';
import '../../../test/test_text_field.dart';
import 'quotation_form.dart';
import '../../list/otherLists.dart';
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
                    CustomTextFieldTest(
                      'party_name',
                      data['opportunity_from'].toString().tr(),
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
                            setState(() {
                              data['party_name'] = res['name'];
                              data['customer_name'] = res['customer_name'];
                              data['territory'] = res['territory'];
                              data['customer_group'] = res['customer_group'];
                              data['customer_address'] =
                                  res["customer_primary_address"];
                              data['contact_person'] =
                                  res["customer_primary_contact"];
                              data['contact_mobile'] = res['mobile_no'];
                            });
                          }
                        } else if (_type == quotationType.lead) {
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => selectLeadScreen()));
                          if (res != null) {
                            id = res['name'];
                            setState(() {
                              data['party_name'] = res['name'];
                              data['customer_name'] = res['lead_name'];
                              data['territory'] = res['territory'];
                              data['source'] = res['source'];
                              data['campaign'] = res['campaign_name'];
                              data['contact_mobile'] = res['mobile_no'];
                              data['contact_email'] = res['email_id'];
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
                      CustomTextFieldTest(
                          'customer_group', 'Customer Group'.tr(),
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
                      CustomTextFieldTest(
                          'customer_address', 'Customer Address'.tr(),
                          initialValue: data['customer_address'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onChanged: (value) {
                            setState(() {
                              data['customer_address'] = value;
                            });
                          },
                          // liestenToInitialValue:
                          //     data['customer_address'] == null,
                          onPressed: () async {
                            if (data['party_name'] == null) {
                              return showSnackBar(
                                  'Please select a customer to first', context);
                            }

                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => customerAddressScreen(
                                        data['party_name'])));
                            print(res);
                            print('------------------------------------');
                            data['customer_address'] = res['name'];
                            return res['name'];
                          }),
                    if (_type == quotationType.customer)
                      CustomTextFieldTest(
                          'contact_person', 'Contact Person'.tr(),
                          initialValue: data['contact_person'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () async {
                            if (data['customer_name'] == null) {
                              showSnackBar('Please select a customer', context);
                              return null;
                            }
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        contactScreen(data['party_name'])));
                            return res;
                          }),
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
                      CustomTextFieldTest('campaign', 'Campaign'.tr(),
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['campaign'],
                          disableValidation: true,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => campaignScreen()))),
                    if (_type == quotationType.lead)
                      CustomTextFieldTest('source', 'Source',
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['source'],
                          disableValidation: true,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => sourceScreen()))),
                    CustomTextFieldTest('opportunity_type', 'Opportunity Type',
                        initialValue: data['opportunity_type'],
                        disableValidation: true,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => opportunityTypeScreen()))),
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
                priceList: data['selling_price_list'] ?? context.read<UserProvider>().defaultSellingPriceList,
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 8.0, vertical: 13),
              //   child: ListView(
              //     children: [
              //       Card(
              //         elevation: 1,
              //         margin: EdgeInsets.zero,
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12)),
              //         child: Container(
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 8.0, vertical: 8),
              //             child: Column(
              //               children: [
              //                 Padding(
              //                   padding:
              //                       const EdgeInsets.symmetric(horizontal: 16),
              //                   child: Row(
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceBetween,
              //                     children: [
              //                       const Text(
              //                         'Items',
              //                         style: TextStyle(
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w600,
              //                         ),
              //                       ),
              //                       SizedBox(
              //                         width: 40,
              //                         child: ElevatedButton(
              //                           style: ElevatedButton.styleFrom(
              //                               padding: EdgeInsets.zero),
              //                           onPressed: () async {
              //                             final res =
              //                                 await Navigator.of(context).push(
              //                                     MaterialPageRoute(
              //                                         builder: (_) =>
              //                                             itemListScreen('')));
              //                             if (res != null &&
              //                                 !_items.contains(res)) {
              //                               setState(() =>
              //                                   _items.add(ItemQuantity(res)));
              //                             }
              //                           },
              //                           child: const Icon(Icons.add,
              //                               size: 25, color: Colors.white),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 const Divider(),
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.end,
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: [
              //                     ListTitle(
              //                       title: 'Total',
              //                       value: totalAmount.toString(),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //         child: ConstrainedBox(
              //           constraints: BoxConstraints(
              //               maxHeight:
              //                   MediaQuery.of(context).size.height * 0.55),
              //           child: _items.isEmpty
              //               ? const Center(
              //                   child: Text('no items added',
              //                       style: TextStyle(
              //                           color: Colors.grey,
              //                           fontStyle: FontStyle.italic,
              //                           fontSize: 16)))
              //               : ListView.builder(
              //                   physics: const BouncingScrollPhysics(),
              //                   padding: const EdgeInsets.only(bottom: 12),
              //                   itemCount: _items.length,
              //                   itemBuilder: (context, index) => Padding(
              //                         padding: const EdgeInsets.symmetric(
              //                             horizontal: 8.0),
              //                         child: Stack(
              //                           alignment: Alignment.bottomCenter,
              //                           children: [
              //                             Container(
              //                               decoration: BoxDecoration(
              //                                   color: Colors.white,
              //                                   borderRadius:
              //                                       const BorderRadius.vertical(
              //                                           bottom:
              //                                               Radius.circular(8)),
              //                                   border: Border.all(
              //                                       color: Colors.blue)),
              //                               margin: const EdgeInsets.only(
              //                                   bottom: 8.0,
              //                                   left: 16,
              //                                   right: 16),
              //                               padding: const EdgeInsets.only(
              //                                   left: 16, right: 16),
              //                               child: Row(
              //                                 children: [
              //                                   Expanded(
              //                                       child: CustomTextField(
              //                                     '${_items[index].itemCode}Quantity',
              //                                     'Quantity',
              //                                     initialValue:
              //                                         _items[index].qty == 0
              //                                             ? null
              //                                             : _items[index]
              //                                                 .qty
              //                                                 .toString(),
              //                                     validator: (value) =>
              //                                         numberValidationToast(
              //                                             value, 'Quantity',
              //                                             isInt: true),
              //                                     keyboardType:
              //                                         TextInputType.number,
              //                                     disableError: true,
              //                                     onSave: (_, value) =>
              //                                         _items[index].qty =
              //                                             int.parse(value),
              //                                     onChanged: (value) {
              //                                       _items[index].qty =
              //                                           int.parse(value);
              //                                       _items[index].total =
              //                                           _items[index].qty *
              //                                               _items[index].rate;
              //                                       Future.delayed(
              //                                           const Duration(
              //                                               seconds: 1),
              //                                           () => setState(() {}));
              //                                     },
              //                                   )),
              //                                   const SizedBox(width: 12),
              //                                   Expanded(
              //                                       child: CustomTextField(
              //                                     'rate',
              //                                     'Rate',
              //                                     initialValue:
              //                                         _items[index].rate == 0.0
              //                                             ? null
              //                                             : _items[index]
              //                                                 .rate
              //                                                 .toString(),
              //                                     keyboardType:
              //                                         TextInputType.number,
              //                                     disableError: true,
              //                                     onSave: (_, value) =>
              //                                         _items[index].rate =
              //                                             double.parse(value),
              //                                     onChanged: (value) {
              //                                       _items[index].rate =
              //                                           double.parse(value);
              //                                       _items[index].total =
              //                                           _items[index].qty *
              //                                               _items[index].rate;
              //                                       Future.delayed(
              //                                           const Duration(
              //                                               seconds: 1),
              //                                           () => setState(() {}));
              //                                     },
              //                                   )),
              //                                   const SizedBox(width: 12),
              //                                   Expanded(
              //                                       child: CustomTextField(
              //                                     'amount',
              //                                     'Amount',
              //                                     initialValue: (_items[index]
              //                                                 .qty *
              //                                             _items[index].rate)
              //                                         .toString(),
              //                                     enabled: false,
              //                                     disableError: true,
              //                                   )),
              //                                   const SizedBox(width: 12),
              //                                 ],
              //                               ),
              //                             ),
              //                             Padding(
              //                               padding: const EdgeInsets.only(
              //                                   bottom: 62),
              //                               child: Dismissible(
              //                                 key: Key(_items[index].itemCode),
              //                                 direction:
              //                                     DismissDirection.endToStart,
              //                                 onDismissed: (_) => setState(
              //                                     () => _items.removeAt(index)),
              //                                 background: Container(
              //                                   decoration: BoxDecoration(
              //                                       borderRadius:
              //                                           BorderRadius.circular(
              //                                               12),
              //                                       color: Colors.red),
              //                                   child: const Align(
              //                                     alignment:
              //                                         Alignment.centerRight,
              //                                     child: Padding(
              //                                       padding: EdgeInsets.all(16),
              //                                       child: Icon(
              //                                         Icons.delete_forever,
              //                                         color: Colors.white,
              //                                         size: 30,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ),
              //                                 child: ItemCard(
              //                                     names: const [
              //                                       'Code',
              //                                       'Group',
              //                                       'UoM'
              //                                     ],
              //                                     values: [
              //                                       _items[index].itemName,
              //                                       _items[index].itemCode,
              //                                       _items[index].group,
              //                                       _items[index].stockUom
              //                                     ],
              //                                     imageUrl:
              //                                         _items[index].imageUrl),
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       )),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
