import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../models/page_models/model_functions.dart';
import '../../../models/page_models/stock_page_model/stock_entry_page_model.dart';
import '../../../service/service.dart';
import '../../../service/service_constants.dart';
import '../../../provider/module/module_provider.dart';
import '../../list/otherLists.dart';
import '../../page/generic_page.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/inherited_widgets/select_items_list.dart';
import '../../../widgets/item_card.dart';
import '../../../widgets/list_card.dart';
import '../../../widgets/snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';

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


    // if (InheritedForm.of(context).items.isEmpty) {
    //   showSnackBar('Please add an item at least', context);
    //   return;
    // }
    _formKey.currentState!.save();

    data['items'] = [];
    InheritedForm.of(context).items.forEach((element) {
      if (data['is_return'] == 1) element.qty = element.qty * -1;
      data['items'].add(element.toJson);
    });

    //DocFromPage Mode from Sales Order
    data['items'].forEach((element) {
      element['sales_order'] = data['sales_order'];
    });

    final server = APIService();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Material Request');


    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(MATERIAL_REQUEST_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)  return;
    else if (provider.isEditing && res == null)  Navigator.pop(context);

    else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['material_request_name'] != null)
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['material_request_name']);
      Navigator.of(context)
          .push(MaterialPageRoute(
        builder: (_) => GenericPage(),
      ))
          .then((value) => Navigator.pop(context));
    }
    else if (res != null && res['message']['material_request_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['material_request_name']);
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

        final items = MaterialRequestPageModel(context, data).items;

        items.forEach((element) {
          final item = ItemSelectModel.fromJson(element);
          _items.add(ItemQuantity(item, qty: item.qty));
        });

        setState(() {});
      });
    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;
        InheritedForm.of(context).items.clear();

        data['items'].forEach((element) {
          InheritedForm.of(context)
              .items
              .add(ItemSelectModel.fromJson(element));
        });

         data['doctype']= "Material Request";
        data['material_request_type']= purposeType[0];
        data['transaction_date']= DateTime.now().toIso8601String();

        // from Sales Order
        data['sales_order'] = data['name'];

        _getCustomerData(data['customer_name']).then((value) => setState(() {

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
        print('sdfsdfsd${data['items']}');
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    InheritedForm.of(context)
        .data['selling_price_list']='';
    _items.forEach((item) {
      totalAmount += item.total;
    });
    return WillPopScope(
      onWillPop: () async {
        bool? isGoBack = await checkDialog(context, 'Are you sure to go back?'.tr());
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
              ? Text("Edit Material Request")
              : Text("Create Material Request"),
          actions: [
            Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: IconButton(
                  onPressed: submit,
                  icon: Icon(Icons.check, color: FORM_SUBMIT_BTN_COLOR),
                ))
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Group(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 4),
                      CustomDropDown('material_request_type', 'Purpose'.tr(),
                          items: purposeType,
                          defaultValue:
                              data['material_request_type'] ?? purposeType[0],
                          onChanged: (value) => setState(() {
                                data['material_request_type'] = value;
                                   data['set_from_warehouse'] = null;
                                  data['set_warehouse'] = null;
                              })),
                      Divider(color: Colors.grey, height: 1, thickness: 0.7),
                      if (data['material_request_type'] == purposeType[4])
                        CustomTextField(
                          'customer',
                          'Customer',
                          initialValue: data['customer'],

                          onPressed: () async {
                            String? id;
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        selectCustomerScreen()));
                            if (res != null) {
                              id = res['name'];
                              //await _getCustomerData(res['name']);
                              setState(() {
                                data['customer'] = res['name'];
                                // data['customer_name'] = res['customer_name'];
                                // data['territory'] = res['territory'];
                                // data['customer_group'] = res['customer_group'];
                                // data['customer_address'] =
                                //     res["customer_primary_address"];
                                // data['contact_person'] =
                                //     res["customer_primary_contact"];
                                // data['currency'] = res['default_currency'];
                                // data['price_list_currency'] =
                                //     res['default_currency'];
                                //
                              });
                            }

                            return id;
                          },
                        ),
                      Row(children: [
                        Flexible(
                            child: DatePicker(
                          'transaction_date',
                          'Transaction Date'.tr(),
                          initialValue: data['transaction_date'],
                          onChanged: (value) =>
                              setState(() => data['transaction_date'] = value),
                        )),
                        SizedBox(width: 10),
                        Flexible(
                            child: DatePicker(
                          'schedule_date',
                          'Required By Date'.tr(),
                          onChanged: (value) =>
                              setState(() => data['schedule_date'] = value),
                          initialValue: data['schedule_date'],
                              disableValidation: true,
                        )),
                      ]),
                      if (data['material_request_type'] == purposeType[1])
                        CustomTextField('set_from_warehouse', 'Source Warehouse'.tr(),
                            initialValue: data['set_from_warehouse'],
                            liestenToInitialValue: true,
                            onSave: (key, value) => data[key] = value,
                            onPressed: () async {
                              final res = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          warehouseScreen(data['set_warehouse'])));
                              if (res != null) data['set_from_warehouse'] = res;
                              return res;
                            }),
                      CustomTextField('set_warehouse', 'Target Warehouse'.tr(),
                          initialValue: data['set_warehouse'],
                          liestenToInitialValue: true,
                          disableValidation: true,

                          onSave: (key, value) => data[key] = value,
                          onPressed: () async {
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => warehouseScreen(
                                        data['set_from_warehouse'])));
                            if (res != null) data['set_warehouse'] = res;
                            return res;
                          }),
                      SizedBox(height: 8),

                    ],
                  ),
                ),
                      //SelectedItemsList(),
                Container(
                    child: Column(
                      children: [
                        Card(
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8),
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Items',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)),
                                        SizedBox(
                                          width: 40,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.zero),
                                            onPressed: () async {
                                              final res =
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          itemListScreen('')));
                                              if (res != null &&
                                                  !_items.contains(res))
                                                setState(() =>
                                                    _items.add(ItemQuantity(res)));
                                            },
                                            child: Icon(Icons.add,
                                                size: 25, color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTitle(title: 'Total', value: currency(totalAmount)),
                                    ],
                                  ),


                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight:
                                MediaQuery.of(context).size.height * 0.55),
                            child: _items.isEmpty
                                ? Center(
                                child: Text('no items added',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16)))
                                : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(bottom: 12),
                                itemCount: _items.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.vertical(
                                                bottom:
                                                Radius.circular(8)),
                                            border: Border.all(
                                                color: Colors.blue)),
                                        margin: const EdgeInsets.only(
                                            bottom: 8.0,
                                            left: 16,
                                            right: 16),
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: CustomTextField(
                                                  _items[index].itemCode +
                                                      'Quantity',
                                                  'Quantity',
                                                  initialValue:
                                                  _items[index].qty == 0
                                                      ? null
                                                      : _items[index]
                                                      .qty
                                                      .toString(),
                                                  validator: (value) =>
                                                      numberValidationToast(
                                                          value, 'Quantity',
                                                          isInt: true),
                                                  keyboardType:
                                                  TextInputType.number,
                                                  disableError: true,
                                                  onSave: (_, value) =>
                                                  _items[index].qty =
                                                      int.parse(value),
                                                  onChanged: (value) {
                                                    _items[index].qty =
                                                        int.parse(value);
                                                    _items[index].total = _items[index]
                                                        .qty *
                                                        _items[index].rate;                                                        Future.delayed(
                                                        Duration(seconds: 1),
                                                            () => setState(() {}));
                                                  },
                                                )),
                                            SizedBox(width: 12),
                                            Expanded(
                                                child: CustomTextField(
                                                  'rate',
                                                  'Rate',
                                                  initialValue:
                                                  _items[index].rate == 0.0
                                                      ? null
                                                      : _items[index]
                                                      .rate
                                                      .toString(),

                                                  keyboardType:
                                                  TextInputType.number,
                                                  disableError: true,
                                                  onSave: (_, value) =>
                                                  _items[index].rate =
                                                      double.parse(value),
                                                  onChanged: (value) {
                                                    _items[index].rate =
                                                        double.parse(value);
                                                    _items[index].total = _items[index]
                                                        .qty *
                                                        _items[index].rate;                                                    Future.delayed(
                                                        Duration(seconds: 1),
                                                            () => setState(() {}));
                                                  },
                                                )),
                                            SizedBox(width: 12),
                                            Expanded(
                                                child: CustomTextField(
                                                  'amount',
                                                  'Amount',
                                                  initialValue: (_items[index]
                                                      .qty *
                                                      _items[index].rate)
                                                      .toString(),
                                                  enabled: false,
                                                  disableError: true,
                                                )),
                                            SizedBox(width: 12),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 62),
                                        child: Dismissible(
                                          key: Key(_items[index].itemCode),
                                          direction:
                                          DismissDirection.endToStart,
                                          onDismissed: (_) => setState(
                                                  () => _items.removeAt(index)),
                                          background: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    12),
                                                color: Colors.red),
                                            child: Align(
                                              alignment:
                                              Alignment.centerRight,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(
                                                    16),
                                                child: Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: ItemCard(
                                              names: const [
                                                'Code',
                                                'Group',
                                                'UoM'
                                              ],
                                              values: [
                                                _items[index].itemName,
                                                _items[index].itemCode,
                                                _items[index].group,
                                                _items[index].stockUom
                                              ],
                                              imageUrl:
                                              _items[index].imageUrl),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        )
                      ],
                    )),




              ],
            ),
          ),
        ),
      ),
    );
  }
}
