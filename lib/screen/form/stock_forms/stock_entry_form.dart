import 'package:next_app/models/list_models/stock_list_model/item_table_model.dart';
import 'package:next_app/models/page_models/stock_page_model/stock_entry_page_model.dart';
import 'package:next_app/service/service.dart';
import 'package:next_app/service/service_constants.dart';
import 'package:next_app/provider/module/module_provider.dart';
import 'package:next_app/screen/list/otherLists.dart';
import 'package:next_app/screen/page/generic_page.dart';
import 'package:next_app/widgets/dialog/loading_dialog.dart';
import 'package:next_app/widgets/form_widgets.dart';
import 'package:next_app/widgets/item_card.dart';
import 'package:next_app/widgets/snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';

const List<String> stockEntryType = ['Material Issue', 'Material Receipt', 'Material Transfer'];

class StockEntryForm extends StatefulWidget {
  const StockEntryForm({Key? key}) : super(key: key);

  @override
  _StockEntryFormState createState() => _StockEntryFormState();
}

class _StockEntryFormState extends State<StockEntryForm> {
  final List<ItemQuantity> _items = [];

  Map<String, dynamic> data = {
    "doctype": "Stock Entry",
    'stock_entry_type': stockEntryType[0],
    "posting_date": DateTime.now().toIso8601String(),
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) return;

    if (_items.isEmpty) {
      showSnackBar('Please add an item at least', context);
      return;
    }
    _formKey.currentState!.save();

    data['items'] = [];
    _items.forEach((element) => data['items'].add(element.toJson));

    showLoadingDialog(context, provider.isEditing ? 'Updating ${provider.pageId}' : 'Creating Stock Entry');

    final server = APIService();

    for (var k in data.keys) print("$k: ${data[k]}");
    final res = await handleRequest(
        () async => provider.isEditing ? await provider.updatePage(data) : await server.postRequest(STOCK_ENTRY_POST, {'data': data}), context);

    Navigator.pop(context);

    if (provider.isEditing)
      Navigator.pop(context);
    else if (res != null && res['message']['stock_entry'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['stock_entry']);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
    }
  }

  @override
  void initState() {
    super.initState();

    if (context.read<ModuleProvider>().isEditing)
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;

        final items = StockEntryPageModel(data).items;

        items.forEach((element) {
          final item = ItemSelectModel.fromJson(element);
          _items.add(ItemQuantity(item, qty: item.qty));
        });

        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? isGoBack = await checkDialog(context, 'Are you sure to go back?');
        if (isGoBack != null){
          if(isGoBack){
            return Future.value(true);
          }else{
            return Future.value(false);
          }
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: (context.read<ModuleProvider>().isEditing) ? Text("Edit Stock Entry") : Text("Create Stock Entry"),
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
                      CustomDropDown('stock_entry_type', 'Stock Entry Type'.tr(),
                          items: stockEntryType,
                          defaultValue: data['stock_entry_type'] ?? stockEntryType[0],
                          onChanged: (value) => setState(() {
                                data['stock_entry_type'] = value;
                                if (value == stockEntryType[1])
                                  data['from_warehouse'] = null;
                                else if (value == stockEntryType[0]) data['to_warehouse'] = null;
                              })),
                      Divider(color: Colors.grey, height: 1, thickness: 0.7),
                      DatePicker('posting_date', 'Date'.tr(),
                          initialValue: data['posting_date'], onChanged: (value) => setState(() => data['posting_date'] = value)),
                      if (data['stock_entry_type'] != stockEntryType[1])
                        CustomTextField('from_warehouse', 'Source Warehouse'.tr(),
                            onSave: (key, value) => data[key] = value,
                            initialValue: data['from_warehouse'],
                            onPressed: () async {
                              final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => warehouseScreen(data['to_warehouse'])));
                              if (res != null) data['from_warehouse'] = res;
                              return res;
                            }),
                      if (data['stock_entry_type'] != stockEntryType[0])
                        CustomTextField('to_warehouse', 'Target Warehouse'.tr(),
                            initialValue: data['to_warehouse'],
                            onSave: (key, value) => data[key] = value,
                            onPressed: () async {
                              final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => warehouseScreen(data['from_warehouse'])));
                              if (res != null) data['to_warehouse'] = res;
                              return res;
                            }),
                      CustomTextField('project', 'Project'.tr(),
                          disableValidation: true,
                          initialValue: data['project'],
                          onSave: (key, value) => data[key] = value.isEmpty ? null : value,
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => projectScreen()))),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                Card(
                  elevation: 1,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            SizedBox(
                              width: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                                onPressed: () async {
                                  final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => itemListScreen('')));
                                  if (res != null && !_items.contains(res)) setState(() => _items.add(ItemQuantity(res, qty: 0)));
                                },
                                child: Icon(Icons.add, size: 25, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.55),
                    child: _items.isEmpty
                        ? Center(child: Text('no items added', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 16)))
                        // this pattern in order to save state of each item in the list
                        : SingleChildScrollView(
          physics: BouncingScrollPhysics(),
                            child: Column(children: [
                              for (int index = 0; index < _items.length; index++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                                            border: Border.all(color: Colors.blue)),
                                        margin: const EdgeInsets.only(bottom: 8.0, left: 16, right: 16),
                                        padding: const EdgeInsets.only(left: 16, right: 16),
                                        child: CustomTextField(
                                          _items[index].itemCode + 'Quantity',
                                          'Quantity',
                                          validator: (value) => numberValidationToast(value, 'Quantity', isInt: true),
                                          keyboardType: TextInputType.number,
                                          disableError: true,
                                          initialValue: _items[index].qty.toString(),
                                          onSave: (_, value) => _items[index].qty = int.parse(value),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 62),
                                        child: Dismissible(
                                          key: Key(_items[index].itemCode),
                                          direction: DismissDirection.endToStart,
                                          onDismissed: (_) => setState(() => _items.removeAt(index)),
                                          background: Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.red),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: const EdgeInsets.all(16),
                                                child: Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: ItemCard(
                                              values: [_items[index].itemName, _items[index].itemCode, _items[index].group, _items[index].stockUom],
                                              imageUrl: _items[index].imageUrl),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(height: 12)
                            ]),
                          ),
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
