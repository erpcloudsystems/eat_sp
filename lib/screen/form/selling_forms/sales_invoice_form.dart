import 'package:NextApp/models/list_models/selling_list_model/customer_list_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
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
import '../../../new_version/modules/new_item/presentation/pages/add_items.dart';
import '../../../models/page_models/selling_page_model/sales_invoice_page_model.dart';

const List<String> grandTotalList = ['Grand Total', 'Net Total'];

class SalesInvoiceForm extends StatefulWidget {
  const SalesInvoiceForm({super.key});

  @override
  State<SalesInvoiceForm> createState() => _SalesInvoiceFormState();
}

class _SalesInvoiceFormState extends State<SalesInvoiceForm> {
  Map<String, dynamic> data = {
    "doctype": "Sales Invoice",
    "posting_date": DateTime.now().toIso8601String(),
    "is_return": 0,
    "update_stock": 1,
    "conversion_rate": 1,
    "latitude": 0.0,
    "longitude": 0.0,
    'additional_discount_percentage': 0.0,
    'discount_amount': 0.0,
    'tax_type': taxType[0],
    'posting_time': DateTime.now().toString(),
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

    // Here we handle return and credit note case, besides add new items to the data.
    for (var element in provider.newItemList) {
      if (data['is_return'] == 1 && element['qty'] > 0) {
        element['qty'] = element['qty'] * -1;
        if (element['stock_qty'] != null) {
          element['stock_qty'] = element['stock_qty'] * -1;
        }
      }
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
      if (gpsService.placeman.isNotEmpty) {
        data['location'] = gpsService.placeman[0].subAdministrativeArea;
      }
    }

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Sales Invoice');

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    await handleRequest(
            () async => provider.isEditing
                ? await provider.updatePage(data)
                : await server.postRequest(SALES_INVOICE_POST, {'data': data}),
            context)
        .then((res) {
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
    });
  }

  Future<void> _getCustomerData(String customer) async {
    selectedCstData = Map<String, dynamic>.from(
        await APIService().getPage(CUSTOMER_PAGE, customer))['message'];
  }

  @override
  void initState() {
    super.initState();

    final provider = context.read<ModuleProvider>();
    final userProvider = context.read<UserProvider>();

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

        // Because "Customer Visit" doesn't have Items.
        if (data['doctype'] != DocTypesName.customerVisit) {
          InheritedForm.of(context).items.clear();
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

    // Default Warehouse
    if (userProvider.sellingWarehouse != null) {
      Future.delayed(Duration.zero, () {
        data['set_warehouse'] = userProvider.sellingWarehouse;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () async {
      location = await gpsService.getCurrentLocation(context);
      setState(() {});
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
    return DismissKeyboard(
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: CustomDropDownFromField(
                              defaultValue: data['customer'],
                              docType: 'Customer',
                              nameResponse: 'name',
                              title: 'Customer'.tr(),
                              keys: const {
                                'subTitle': 'customer_group',
                                'trailing': 'customer_name_in_arabic',
                                'thirdKey': 'customer_name',
                              },
                              onChange: (value) async {
                                if (value != null) {
                                  await _getCustomerData(value['name']);

                                  setState(() {
                                    data['due_date'] = DateTime.now()
                                        .add(Duration(
                                            days: int.parse(
                                                selectedCstData['credit_days']
                                                    .toString())))
                                        .toIso8601String();
                                    data['customer'] = value['name'];
                                    data['customer_name'] =
                                        value['customer_name'];
                                    data['territory'] = value['territory'];
                                    data['customer_group'] =
                                        value['customer_group'];
                                    data['customer_address'] =
                                        value["customer_primary_address"];
                                    data['contact_person'] =
                                        value["customer_primary_contact"];
                                    data['currency'] =
                                        value['default_currency'];
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
                        ),
                        // CustomerScannerIconButton(
                        //   onCustomerFetched: (customerModel) async {
                        //     fetchCustomerData(customerModel);
                        //   },
                        // ),
                      ],
                    ),

                    Row(children: [
                      Flexible(
                          child: DatePickerTest(
                        'posting_date',
                        'Date'.tr(),
                        initialValue: data['posting_date'] ?? 'none',
                        enable: false,
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
                        child: TimePicker(
                          'from',
                          'From Time',
                          enable: false,
                          initialValue: data['posting_time'],
                          onChanged: (value) {},
                        ),
                      ),
                    ]),
                    // New customer address
                    CustomExpandableTile(
                      hideArrow: data['customer'] == null,
                      title: CustomDropDownFromField(
                          defaultValue: data['customer_address'],
                          docType: APIService.FILTERED_ADDRESS,
                          nameResponse: 'name',
                          anotherTitle: 'custom_code',
                          title: 'Customer Address'.tr(),
                          isValidate: false,
                          keys: const {'subTitle': 'address_title'},
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

                    SizedBox(
                      height: 500.h,
                      child: AddItemsWidget(
                        allowSales: 1,
                        priceList: data['selling_price_list'] ??
                            context
                                .read<UserProvider>()
                                .defaultSellingPriceList,
                        warehouse: data['set_warehouse'],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fetchCustomerData(CustomerItemModel customerModel) async {
    await _getCustomerData(customerModel.id);
    setState(() {
      data['due_date'] = DateTime.now()
          .add(Duration(
              days: int.parse(selectedCstData['credit_days'].toString())))
          .toIso8601String();
      data['customer'] = customerModel.id;
      data['customer_name'] = customerModel.name;
      data['territory'] = customerModel.territory;
      data['customer_group'] = customerModel.customerGroup;
      data['customer_address'] = customerModel.addressName;
      data['currency'] = customerModel.currency;
      data['price_list_currency'] = customerModel.currency;

      InheritedForm.of(context).items.clear();
    });
  }
}
