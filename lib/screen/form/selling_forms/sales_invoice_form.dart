import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../new_version/modules/new_item/presentation/pages/add_items.dart';
import '../../../test/custom_page_view_form.dart';
import '../../../test/test_text_field.dart';
import '../../list/otherLists.dart';
import '../../page/generic_page.dart';
import '../../../core/constants.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../service/gps_services.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/dismiss_keyboard.dart';
import '../../../service/service_constants.dart';
import '../../../provider/user/user_provider.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/page_models/model_functions.dart';
import '../../../new_version/core/resources/strings_manager.dart';
import '../../../widgets/inherited_widgets/select_items_list.dart';
import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../models/page_models/selling_page_model/sales_invoice_page_model.dart';

const List<String> grandTotalList = ['Grand Total', 'Net Total'];

class SalesInvoiceForm extends StatefulWidget {
  const SalesInvoiceForm({Key? key}) : super(key: key);

  @override
  _SalesInvoiceFormState createState() => _SalesInvoiceFormState();
}

class _SalesInvoiceFormState extends State<SalesInvoiceForm> {
  String? _terms;

  Map<String, dynamic> data = {
    "doctype": "Sales Invoice",
    "posting_date": DateTime.now().toIso8601String(),
    "is_return": 0,
    "update_stock": 1,
    "conversion_rate": 1,
    "latitude": 0.0,
    "longitude": 0.0,
    // "apply_discount_on": "Net Total",
    'additional_discount_percentage': 0.0,
    'discount_amount': 0.0,
  };

  LatLng location = const LatLng(0.0, 0.0);
  GPSService gpsService = GPSService();

  Map<String, dynamic> selectedCstData = {
    'name': 'noName',
    'credit_days': 0,
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) {
      showSnackBar(KFillRequiredSnackBar, context);
      return;
    }

    if (location == const LatLng(0.0, 0.0)) {
      showSnackBar(KEnableGpsSnackBar, context);
      Future.delayed(const Duration(seconds: 1), () async {
        location = await gpsService.getCurrentLocation(context);
      });
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

    for (var element in provider.newItemList) {
      if (data['is_return'] == 1) element['qty'] = element['qty'] * -1;
      data['items'].add(element);
    }

    //DocFromPage Mode from Sales Invoice
    data['items'].forEach((element) {
      element['sales_invoice'] = data['sales_invoice'];
    });

    final server = APIService();

    if (!context.read<ModuleProvider>().isEditing) {
      data['latitude'] = location.latitude;
      data['longitude'] = location.longitude;
      data['location'] = gpsService.placeman[0].subAdministrativeArea;
    }

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Sales Invoice');

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(SALES_INVOICE_POST, {'data': data}),
        context);

    Navigator.pop(context);

    InheritedForm.of(context).data['selling_price_list'] = null;

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['sales_invoice'] != null) {
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['sales_invoice']);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['sales_invoice'] != null) {
      provider.pushPage(res['message']['sales_invoice']);
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

    //Editing Mode and Amending Mode
    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        _getCustomerData(data['customer_name']).then((value) => setState(() {
              selectedCstData['address_line1'] =
                  formatDescription(data['address_line1']);
              selectedCstData['city'] = data['city'];
              selectedCstData['country'] = data['country'];
              selectedCstData['contact_display'] = data['contact_display'];
              selectedCstData['phone'] = data['phone'];
              selectedCstData['mobile_no'] = data['mobile_no'];
              selectedCstData['email_id'] = data['email_id'];
            }));

        data['latitude'] = 0.0;
        data['longitude'] = 0.0;

        final items = SalesInvoicePageModel(context, data).items;
        //New Item
        for (var element in items) {
          provider.setItemToList(element);
        }
        for (var element in items) {
          InheritedForm.of(context)
              .items
              .add(ItemSelectModel.fromJson(element));
        }

        InheritedForm.of(context).data['selling_price_list'] =
            data['selling_price_list'];

        setState(() {});
      });
    }

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;

        // // Because "Customer Visit" doesn't have Items.
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

        // from Sales Order
        if (data['doctype'] == 'Sales Order') {
          data['sales_order'] = data['name'];
          data['project'] = data['project'];
        }

        // from Sales Invoice
        if (data['doctype'] == 'Sales Invoice') {
          data['return_against'] = data['name'];
          data['is_return'] = 1;
        }

        // From Customer Visit:
        if (data['doctype'] == DocTypesName.customerVisit) {
          data['customer_name'] = data['customer'];
          data['customer_visit'] = data['name'];
        }

        _getCustomerData(data['customer_name']).then((_) => setState(() {
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
              data['territory'] = selectedCstData['territory'];
              data['customer_group'] = selectedCstData['customer_group'];
            }));

        data['doctype'] = "Sales Invoice";
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
        print('${data['items']}');
        setState(() {});
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () async {
      location = await gpsService.getCurrentLocation(context);
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    context.read<ModuleProvider>().resetCreationForm();
  }

  bool disableAmount = false;
  String discountValue = 'Percentage';
  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final provider = context.read<ModuleProvider>();
    return WillPopScope(
      onWillPop: () async {
        bool? isGoBack =
            await checkDialog(context, 'Are you sure to go back?'.tr());
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
      child: DismissKeyboard(
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
                        clearButton: true,
                        onPressed: () async {
                          String? id;

                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      selectCustomerScreen()));
                          if (res != null) {
                            id = res['name'];
                            await _getCustomerData(res['name']);

                            setState(() {
                              data['due_date'] = DateTime.now()
                                  .add(Duration(
                                      days: int.parse(
                                          selectedCstData['credit_days']
                                              .toString())))
                                  .toIso8601String();
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
                      const SizedBox(height: 4),
                      if (data['customer_name'] != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(data['customer_name']!,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            )),
                      const SizedBox(height: 4),
                      if (data['customer_name'] != null)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0, left: 2, right: 2),
                          child: Divider(
                              color: Colors.grey, height: 1, thickness: 0.7),
                        ),
                      Row(children: [
                        Flexible(
                            child: DatePickerTest(
                          'posting_date',
                          'Date'.tr(),
                          initialValue: data['posting_date'] ?? 'none',
                          onChanged: (value) =>
                              setState(() => data['posting_date'] = value),
                          lastDate: DateTime.tryParse(data['due_date'] ??
                              DateTime.now()
                                  .add(Duration(
                                      days: int.parse(
                                          selectedCstData['credit_days']
                                              .toString())))
                                  .toIso8601String()),
                        )),
                        const SizedBox(width: 10),
                        Flexible(
                            child: DatePickerTest(
                          'due_date',
                          'Due Date',
                          onChanged: (value) => Future.delayed(Duration.zero,
                              () => setState(() => data['due_date'] = value)),
                          firstDate: DateTime.parse(data['posting_date'] ?? ''),
                          initialValue: data['due_date'] ??
                              ((selectedCstData['name'].toString() !=
                                          'noName' &&
                                      selectedCstData['credit_days']
                                              .toString() !=
                                          'null')
                                  ? DateTime.now()
                                      .add(Duration(
                                          days: int.parse(
                                              (selectedCstData['credit_days']
                                                  .toString()))))
                                      .toIso8601String()
                                  : null),
                        )),
                      ]),
                      if (data['tax_id'] != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
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
                      CustomTextFieldTest('customer_group', 'Customer Group',
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['customer_group'],
                          disableValidation: true,
                          clearButton: true,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => customerGroupScreen()))),
                      CustomTextFieldTest('territory', 'Territory'.tr(),
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['territory'],
                          disableValidation: true,
                          clearButton: true,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => territoryScreen()))),
                      CustomExpandableTile(
                        hideArrow: data['customer'] == null,
                        title: CustomTextFieldTest(
                            'customer_address', 'Customer Address',
                            initialValue: data['customer_address'],
                            disableValidation: false,
                            clearButton: false,
                            onSave: (key, value) => data[key] = value,
                            liestenToInitialValue:
                                data['customer_address'] == null,
                            onPressed: () async {
                              if (data['customer'] == null) {
                                return showSnackBar(
                                    'Please select a customer to first',
                                    context);
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
                        'cost_center',
                        'Cost Center',
                        initialValue: data['cost_center'],
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => costCenterScreen(),
                          ),
                        ),
                      ),
                      CustomTextFieldTest('currency', 'Currency',
                          initialValue:
                              data['currency'] ?? userProvider.defaultCurrency,
                          clearButton: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => currencyListScreen()))),
                      CustomTextFieldTest(
                        'conversion_rate',
                        'Exchange Rate'.tr(),
                        clearButton: true,
                        initialValue: '${data['conversion_rate'] ?? ''}',
                        disableValidation: true,
                        hintText: '1',
                        validator: (value) =>
                            numberValidation(value, allowNull: true),
                        keyboardType: TextInputType.number,
                        onSave: (key, value) =>
                            data[key] = double.tryParse(value) ?? 1,
                      ),
                      CustomTextFieldTest(
                          'selling_price_list', 'Price List'.tr(),
                          initialValue: data['selling_price_list'] ??
                              userProvider.defaultSellingPriceList,
                          clearButton: true, onPressed: () async {
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(tr('Price List Currency'),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.grey)),
                            )),
                      if (data['price_list_currency'] != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(data['price_list_currency']!,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            )),
                      if (data['price_list_currency'] != null)
                        const Divider(
                            color: Colors.grey, height: 1, thickness: 0.7),
                      CustomTextFieldTest('plc_conversion_rate',
                          'Price List Exchange Rate'.tr(),
                          initialValue: '${data['plc_conversion_rate'] ?? ''}',
                          disableValidation: true,
                          clearButton: true,
                          hintText: '1',
                          validator: (value) =>
                              numberValidation(value, allowNull: true),
                          keyboardType: TextInputType.number,
                          onSave: (key, value) =>
                              data[key] = double.tryParse(value) ?? 1),
                      CheckBoxWidget('update_stock', 'Update Stock',
                          initialValue:
                              data['update_stock'] == 1 ? true : false,
                          onChanged: (id, value) =>
                              setState(() => data[id] = value ? 1 : 0)),
                      if (data['update_stock'] == 1)
                        CustomTextFieldTest(
                            'set_warehouse', 'Source Warehouse'.tr(),
                            initialValue: data['set_warehouse'],
                            disableValidation: true,
                            clearButton: true,
                            onSave: (key, value) => data[key] = value,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => warehouseScreen()))),
                      CustomTextFieldTest('payment_terms_template',
                          'Payment Terms Template'.tr(),
                          initialValue: data['payment_terms_template'],
                          clearButton: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => paymentTermsScreen()))),
                      CustomTextFieldTest('tc_name', 'Terms & Conditions'.tr(),
                          initialValue: data['tc_name'],
                          disableValidation: true,
                          clearButton: true,
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
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            )),
                      if (_terms != null)
                        const Divider(
                            color: Colors.grey, height: 1, thickness: 0.7),
                      CustomTextFieldTest(
                        'sales_partner',
                        'Sales Partner'.tr(),
                        disableValidation: true,
                        clearButton: true,
                        initialValue: data['sales_partner'],
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => salesPartnerScreen())),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(Icons.warning_amber,
                                color: Colors.amber, size: 22),
                          ),
                          Flexible(
                              child: Text(
                            KLocationNotifySnackBar,
                            textAlign: TextAlign.start,
                          )),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                AddItemsWidget(
                  priceList: data['selling_price_list'] ??
                      context.read<UserProvider>().defaultSellingPriceList,
                ),

                Group(
                  child: Column(
                    children: [
                      CustomDropDownTest(
                        'amount',
                        'Additional Discount'.tr(),
                        fontSize: 16,
                        items: additionalDiscountList,
                        defaultValue: discountValue,
                        onChanged: (value) => setState(() {
                          discountValue = value;
                          if (value == 'Percentage') {
                            data['additional_discount_percentage'] = 0.0;
                            data['discount_amount'] = 0.0;
                          } else {
                            data['additional_discount_percentage'] = 0.0;
                            data['discount_amount'] = 0.0;
                          }
                        }),
                      ),
                      if (discountValue == 'Percentage')
                        CustomTextFieldTest('additional_discount_percentage',
                            'Additional Discount Percentage'.tr(),
                            initialValue: data['additional_discount_percentage']
                                .toString(),
                            disableValidation: true,
                            clearButton: true,
                            onSave: (id, value) =>
                                data[id] = double.parse(value),
                            onChanged: (value) =>
                                data['additional_discount_percentage'] = value),
                      if (discountValue == 'Amount')
                        CustomTextFieldTest(
                          'discount_amount',
                          'Additional Discount Amount'.tr(),
                          initialValue: data['discount_amount'].toString(),
                          disableValidation: true,
                          clearButton: true,
                          onChanged: (value) {
                            data['discount_amount'] = double.parse(value);
                          },
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
