import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

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
  };

  LatLng location = LatLng(0.0, 0.0);
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

    if (location == LatLng(0.0, 0.0)) {
      showSnackBar(KEnableGpsSnackBar, context);
      Future.delayed(Duration(seconds: 1), () async {
        location = await gpsService.getCurrentLocation(context);
      });
      return;
    }

    if (InheritedForm.of(context).items.isEmpty) {
      showSnackBar('Please add an item at least', context);
      return;
    }
    _formKey.currentState!.save();

    data['items'] = [];
    data['taxes'] = context.read<UserProvider>().defaultTax;

    InheritedForm.of(context).items.forEach((element) {
      if (data['is_return'] == 1) element.qty = element.qty * -1;
      data['items'].add(element.toJson);
    });

    //DocFromPage Mode from Sales Invoice
    data['items'].forEach((element) {
      element['sales_invoice'] = data['sales_invoice'];
    });

    final server = APIService();

    if (!context.read<ModuleProvider>().isEditing) {
      data['latitude'] = location.latitude;
      data['longitude'] = location.longitude;
      data['location'] = gpsService.placemarks[0].subAdministrativeArea;
    }

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Sales Invoice');

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(SALES_INVOICE_POST, {'data': data}),
        context);

    Navigator.pop(context);

    InheritedForm.of(context).data['selling_price_list'] = null;

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['sales_invoice'] != null)
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['sales_invoice']);
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['sales_invoice'] != null) {
      provider.pushPage(res['message']['sales_invoice']);
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

    //Editing Mode
    if (context.read<ModuleProvider>().isEditing)
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

        // // Because "Customer Visit" doesn't have Items.
        if (data['doctype'] != DocTypesName.customerVisit) {
          InheritedForm.of(context).items.clear();
          data['items'].forEach((element) {
            InheritedForm.of(context)
                .items
                .add(ItemSelectModel.fromJson(element));
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
  Widget build(BuildContext context) {
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
          appBar: AppBar(
            title: (context.read<ModuleProvider>().isEditing)
                ? Text("Edit Sales Invoice")
                : Text("Create Sales Invoice"),
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
                children: [
                  Group(
                    child: Column(
                      children: [
                        SizedBox(height: 4),
                        CustomTextField(
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
                        if (data['customer_name'] != null)
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Text(data['customer_name']!,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                              )),
                        if (data['customer_name'] != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 2, right: 2),
                            child: Divider(
                                color: Colors.grey, height: 1, thickness: 0.7),
                          ),
                        Row(children: [
                          Flexible(
                              child: DatePicker(
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
                          SizedBox(width: 10),
                          Flexible(
                              child: DatePicker(
                            'due_date',
                            'Due Date',
                            onChanged: (value) => Future.delayed(Duration.zero,
                                () => setState(() => data['due_date'] = value)),
                            firstDate:
                                DateTime.parse(data['posting_date'] ?? ''),
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
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                              )),
                        if (data['tax_id'] != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 2, right: 2),
                            child: Divider(
                                color: Colors.grey, height: 1, thickness: 0.7),
                          ),
                        CustomTextField('customer_group', 'Customer Group',
                            onSave: (key, value) => data[key] = value,
                            initialValue: data['customer_group'],
                            disableValidation: true,
                            clearButton: true,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => customerGroupScreen()))),
                        CustomTextField('territory', 'Territory'.tr(),
                            onSave: (key, value) => data[key] = value,
                            initialValue: data['territory'],
                            disableValidation: true,
                            clearButton: true,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => territoryScreen()))),
                        CustomExpandableTile(
                          hideArrow: data['customer'] == null,
                          title: CustomTextField(
                              'customer_address', 'Customer Address',
                              initialValue: data['customer_address'],
                              disableValidation: false,
                              clearButton: false,
                              onSave: (key, value) => data[key] = value,
                              liestenToInitialValue:
                                  data['customer_address'] == null,
                              onPressed: () async {
                                if (data['customer'] == null)
                                  return showSnackBar(
                                      'Please select a customer to first',
                                      context);
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
                        CustomExpandableTile(
                          hideArrow: data['customer'] == null,
                          title: CustomTextField(
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
                      ],
                    ),
                  ),

                  ///
                  /// group 2
                  ///
                  Group(
                    child: Column(
                      children: [
                        SizedBox(height: 4),
                        CheckBoxWidget('is_return', 'Is Return',
                            initialValue: data['is_return'] == 1 ? true : false,
                            onChanged: (id, value) =>
                                setState(() => data[id] = value ? 1 : 0)),
                        CustomTextField('project', 'Project'.tr(),
                            initialValue: data['project'],
                            disableValidation: true,
                            clearButton: true,
                            onSave: (key, value) => data[key] = value,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => projectScreen()))),
                        CustomTextField('cost_center', 'Cost Center',
                            initialValue: data['cost_center'],
                            disableValidation: true,
                            clearButton: true,
                            onSave: (key, value) => data[key] = value,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => costCenterScreen()))),
                        CustomTextField('currency', 'Currency',
                            initialValue: data['currency'],
                            clearButton: true,
                            onSave: (key, value) => data[key] = value,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => currencyListScreen()))),
                        CustomTextField(
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
                        CustomTextField('selling_price_list', 'Price List'.tr(),
                            initialValue: data['selling_price_list'],
                            clearButton: true, onPressed: () async {
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
                          return null;
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
                                child: Text(data['price_list_currency']!,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                              )),
                        if (data['price_list_currency'] != null)
                          Divider(
                              color: Colors.grey, height: 1, thickness: 0.7),
                        CustomTextField('plc_conversion_rate',
                            'Price List Exchange Rate'.tr(),
                            initialValue:
                                '${data['plc_conversion_rate'] ?? ''}',
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
                          CustomTextField(
                              'set_warehouse', 'Source Warehouse'.tr(),
                              initialValue: data['set_warehouse'],
                              disableValidation: true,
                              clearButton: true,
                              onSave: (key, value) => data[key] = value,
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => warehouseScreen()))),
                        CustomTextField('payment_terms_template',
                            'Payment Terms Template'.tr(),
                            initialValue: data['payment_terms_template'],
                            clearButton: true,
                            onSave: (key, value) => data[key] = value,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => paymentTermsScreen()))),
                        CustomTextField('tc_name', 'Terms & Conditions'.tr(),
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
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                              )),
                        if (_terms != null)
                          Divider(
                              color: Colors.grey, height: 1, thickness: 0.7),
                        CustomTextField(
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
                        SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
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
                        SizedBox(height: 8),
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
      ),
    );
  }
}
