import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import '../../../new_version/modules/new_item/presentation/pages/add_items.dart';
import '../../../provider/user/user_provider.dart';
import '../../../test/custom_page_view_form.dart';
import '../../../test/test_text_field.dart';
import '../../../core/constants.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/inherited_widgets/select_items_list.dart';
import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../models/page_models/stock_page_model/material_request_page_model.dart';

const List<String> purposeType = [
  'Purchase',
  'Material Transfer',
  'Material Issue',
  'Manufacture',
  'Customer Provided',
];

class MaterialRequestForm extends StatefulWidget {
  const MaterialRequestForm({Key? key}) : super(key: key);

  @override
  _MaterialRequestFormState createState() => _MaterialRequestFormState();
}

class _MaterialRequestFormState extends State<MaterialRequestForm> {
  final List<ItemQuantity> _items = [];

  Map<String, dynamic> data = {
    "doctype": "Material Request",
    'material_request_type': purposeType[0],
    "transaction_date": DateTime.now().toIso8601String(),
  };
  double totalAmount = 0;

  Map<String, dynamic> selectedCstData = {
    'name': 'noName',
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

    data['items'] = [];

    // for (var element in _items) {
    //   data['items'].add(element.toJson);
    // }
    for (var element in provider.newItemList) {
      data['items'].add(element);
    }

    final server = APIService();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Material Request');

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(MATERIAL_REQUEST_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['material_request_name'] != null) {
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['material_request_name']);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['material_request_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['material_request_name']);
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

    //Editing Mode
    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = provider.updateData;

        final items = MaterialRequestPageModel(context, data).items;
        //New Item
        for (var element in items) {
          provider.setItemToList(element);
        }

        for (var element in items) {
          final item = ItemSelectModel.fromJson(element);
          _items.add(ItemQuantity(item, qty: item.qty));
        }

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
        InheritedForm.of(context).items.clear();

        // data['items'].forEach((element) {
        //   InheritedForm.of(context)
        //       .items
        //       .add(ItemSelectModel.fromJson(element));
        // });
        data['items'].forEach((element) {
          provider.newItemList.add(element);
        });

        data['doctype'] = "Material Request";
        data['material_request_type'] = purposeType[0];

        data['transaction_date'] = DateTime.now().toIso8601String();

        // from Sales Order
        data['sales_order'] = data['name'];

        _getCustomerData(data['customer_name'])
            .then((value) => setState(() {}));

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
  void deactivate() {
    super.deactivate();
    context.read<ModuleProvider>().resetCreationForm();
  }

  @override
  Widget build(BuildContext context) {
    InheritedForm.of(context).data['selling_price_list'] = '';
    for (var item in _items) {
      totalAmount += item.total;
    }
    return WillPopScope(
      onWillPop: () async {
        bool? isGoBack =
            await checkDialog(context, 'Are you sure to go back?'.tr());
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
                    CustomDropDown('material_request_type', 'Purpose'.tr(),
                        items: purposeType,
                        defaultValue:
                            data['material_request_type'] ?? purposeType[0],
                        onChanged: (value) => setState(() {
                              data['material_request_type'] = value;
                              data['set_from_warehouse'] = null;
                              data['set_warehouse'] = null;
                            })),
                    const Divider(
                        color: Colors.grey, height: 1, thickness: 0.7),
                    if (data['material_request_type'] == purposeType[4])
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
                            });
                          }
                        },
                      ),
                    Row(children: [
                      Flexible(
                          child: DatePickerTest(
                        'transaction_date',
                        'Transaction Date'.tr(),
                        initialValue: data['transaction_date'],
                        onChanged: (value) =>
                            setState(() => data['transaction_date'] = value),
                      )),
                      const SizedBox(width: 10),
                      Flexible(
                          child: DatePickerTest(
                        'schedule_date',
                        'Required By Date'.tr(),
                        onChanged: (value) =>
                            setState(() => data['schedule_date'] = value),
                        initialValue: data['schedule_date'],
                        disableValidation: false,
                      )),
                    ]),
                    if (data['material_request_type'] == purposeType[1])
                      CustomDropDownFromField(
                          defaultValue: data['set_from_warehouse'],
                          docType: APIService.WAREHOUSE,
                          nameResponse: 'name',
                          title: 'Source Warehouse'.tr(),
                          keys: const {
                            'subTitle': 'warehouse_name',
                            'trailing': 'warehouse_type',
                          },
                          onChange: (value) {
                            if (data['set_warehouse'] == value['name']) {
                              showSnackBar('Already selected!', context);
                            } else {
                              setState(() {
                                data['set_from_warehouse'] = value['name'];
                              });
                            }
                          }),
                    CustomDropDownFromField(
                        defaultValue: data['set_warehouse'],
                        docType: APIService.WAREHOUSE,
                        nameResponse: 'name',
                        title: 'Target Warehouse'.tr(),
                        keys: const {
                          'subTitle': 'warehouse_name',
                          'trailing': 'warehouse_type',
                        },
                        onChange: (value) {
                          if (data['set_from_warehouse'] == value['name']) {
                            showSnackBar('Already selected!', context);
                          } else {
                            setState(() {
                              data['set_warehouse'] = value['name'];
                            });
                          }
                        }),
                    const SizedBox(height: 8),
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
