import '../../models/list_models/stock_list_model/item_table_model.dart';
import '../../models/page_models/model_functions.dart';
import '../snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import '../../provider/module/module_provider.dart';
import '../../screen/list/otherLists.dart';
import '../form_widgets.dart';
import '../item_card.dart';
import '../list_card.dart';

class InheritedForm extends InheritedWidget {
  InheritedForm({Key? key, required Widget child, List<ItemSelectModel>? items})
      : this.items = items ?? [],
        super(key: key, child: child);
  final List<ItemSelectModel> items;
  final Map<String, dynamic> data = {};

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static InheritedForm of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedForm>()!;
  }
}

class SelectedItemsList extends StatefulWidget {
  const SelectedItemsList({Key? key}) : super(key: key);

  @override
  State<SelectedItemsList> createState() => _SelectedItemsListState();
}

class _SelectedItemsListState extends State<SelectedItemsList> {
  @override
  void dispose() {
    // _items?.clear();
    super.dispose();
  }

  @override
  void deactivate() {
    InheritedForm.of(context)
        .items
        .clear(); // this to clear items before go new form

    super.deactivate();
  }

  // List? _items;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      // _items = InheritedForm.of(context).items;

      // Adding Mode only
      if ((!context.read<ModuleProvider>().isEditing) &&
          (!context.read<ModuleProvider>().isCreateFromPage)) {
        InheritedForm.of(context).items.clear();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('123E3${InheritedForm.of(context).items}');
    // if (InheritedForm.of(context).items.isNotEmpty)
    //   print('123E3${InheritedForm.of(context).items[0].netRate}');

    return Column(
      children: [
        Card(
          elevation: 1,
          margin: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Items',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        SizedBox(
                          width: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero),
                            onPressed: () async {
                              if (InheritedForm.of(context)
                                          .data['selling_price_list'] ==
                                      null &&
                                  InheritedForm.of(context)
                                          .data['buying_price_list'] ==
                                      null) {
                                showSnackBar(
                                    'Please select a Price List', context);
                                return;
                              }
                              if (InheritedForm.of(context)
                                      .data['selling_price_list'] !=
                                  null) {
                                final ItemSelectModel? res = await Navigator.of(
                                        context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => itemListScreen(
                                            InheritedForm.of(context)
                                                .data['selling_price_list'])));

                                if (res != null &&
                                    !InheritedForm.of(context)
                                        .items
                                        .contains(res)) {
                                  setState(() => InheritedForm.of(context)
                                      .items
                                      .insert(0, res));
                                }
                              }

                              if (InheritedForm.of(context)
                                      .data['buying_price_list'] !=
                                  null) {
                                final ItemSelectModel? res = await Navigator.of(
                                        context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => itemListScreen(
                                            InheritedForm.of(context)
                                                .data['buying_price_list'])));
                                if (res != null &&
                                    !InheritedForm.of(context)
                                        .items
                                        .contains(res)) {
                                  setState(() => InheritedForm.of(context)
                                      .items
                                      .insert(0, res));
                                }
                              }
                            },
                            child:
                                Icon(Icons.add, size: 25, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  _Totals()
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.55),
          child: InheritedForm.of(context).items.isEmpty
              ? Center(
                  child: Text('no items added',
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 16)))
              : ShaderMask(
                  blendMode: BlendMode.dstOut,
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.grey
                      ],
                      stops: [0.0, 0.03, 0.97, 1.0],
                    ).createShader(bounds);
                  },
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: InheritedForm.of(context).items.length,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(8)),
                                      border: Border.all(color: Colors.blue)),
                                  margin: const EdgeInsets.only(
                                      bottom: 8.0, left: 16, right: 16),
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: CustomTextField(
                                                InheritedForm.of(context)
                                                    .items[index]
                                                    .itemCode +
                                                    'Quantity',
                                                'Quantity',
                                                validator: (value) =>
                                                    numberValidationToast(
                                                        value, 'Quantity',
                                                        isInt: true),
                                                keyboardType: TextInputType.number,
                                                disableError: true,
                                                initialValue:
                                                InheritedForm.of(context)
                                                    .items[index]
                                                    .qty ==
                                                    0
                                                    ? null
                                                    : InheritedForm.of(context)
                                                    .items[index]
                                                    .qty
                                                    .toString(),
                                                onChanged: (value) {
                                                  int? _value = int.tryParse(value);
                                                  if (_value != null)
                                                    InheritedForm.of(context)
                                                        .items[index]
                                                        .qty = _value;
                                                  Future.delayed(
                                                      Duration(seconds: 1),
                                                          () => setState(() {}));
                                                },
                                              )),
                                          SizedBox(width: 6),
                                          Expanded(
                                              child: NumberTextField(
                                                InheritedForm.of(context)
                                                    .items[index]
                                                    .itemCode +
                                                    'Rate',
                                                InheritedForm.of(context)
                                                    .items[index]
                                                    .enableEdit
                                                    ? 'Net Rate'
                                                    : 'Rate',
                                                initialValue: !InheritedForm.of(
                                                    context)
                                                    .items[index]
                                                    .enableEdit
                                                    ? InheritedForm.of(context)
                                                    .items[index]
                                                    .netRate
                                                    : (InheritedForm.of(context)
                                                    .items[index]
                                                    .netRate ==
                                                    0
                                                    ? null
                                                    : InheritedForm.of(context)
                                                    .items[index]
                                                    .rate),
                                                onPressed: InheritedForm.of(context)
                                                    .items[index]
                                                    .enableEdit
                                                    ? null
                                                    : () async {},
                                                validator: (value) =>
                                                    numberValidationToast(
                                                        value, 'Rate'),
                                                keyboardType: TextInputType.number,
                                                disableError: true,
                                                onChanged: (value) {
                                                  final item =
                                                  InheritedForm.of(context)
                                                      .items[index];
                                                  double? _value =
                                                  double.tryParse(value);
                                                  if (_value != null) {
                                                    InheritedForm.of(context)
                                                        .items[index]
                                                        .netRate = _value;
                                                    InheritedForm.of(context)
                                                        .items[index]
                                                        .rate = (_value *
                                                        (item.taxPercent /
                                                            100)) +
                                                        _value;
                                                    InheritedForm.of(context)
                                                        .items[index]
                                                        .vat =
                                                        _value *
                                                            item.taxPercent /
                                                            100;
                                                  }
                                                  Future.delayed(
                                                      Duration(seconds: 1),
                                                          () => setState(() {}));
                                                },
                                                //onSave: (_, value) => _items[index].rate = double.parse(value),
                                              )),
                                          SizedBox(width: 6),
                                          Expanded(
                                              child: Column(
                                                children: [
                                                  Text('Total',
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                  SingleChildScrollView(
                                                      physics:
                                                      BouncingScrollPhysics(),
                                                      scrollDirection:
                                                      Axis.horizontal,
                                                      child: Text(
                                                          currency(InheritedForm.of(
                                                              context)
                                                              .items[index]
                                                              .total),
                                                          style: const TextStyle(
                                                              fontSize: 16),
                                                          maxLines: 1)),
                                                ],
                                              )),
                                          SizedBox(width: 6),
                                          Expanded(
                                              child: CustomTextField(
                                                'uom',
                                                'UOM',
                                                disableError: true,
                                                initialValue:
                                                InheritedForm.of(context)
                                                    .items[index]
                                                    .stockUom
                                                    .toString(),
                                                onPressed: () async {
                                                  final res =
                                                  await Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                      builder: (_) =>
                                                          filteredUOMListScreen(InheritedForm.of(context)
                                                              .items[index].itemCode.toString())));

                                              if (res != null) {
                                                log(res.toString());
                                                InheritedForm.of(context)
                                                    .items[index]
                                                    .stockUom = res['uom'];
                                                setState(() {
                                                  InheritedForm.of(context)
                                                      .items[index]
                                                      .rate = res[
                                                          'conversion_factor'] *
                                                      InheritedForm.of(context)
                                                          .items[index]
                                                          .priceListRate;
                                                });
                                              }
                                              return res['uom'];
                                            },
                                          )),
                                        ],
                                      ),
                                      Row(
                                        children: [

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 62),
                                  child: Dismissible(
                                    key: Key(InheritedForm.of(context)
                                        .items[index]
                                        .itemCode),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (_) => setState(() =>
                                        InheritedForm.of(context)
                                            .items
                                            .removeAt(index)),
                                    background: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.red),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Icon(Icons.delete_forever,
                                              color: Colors.white, size: 30),
                                        ),
                                      ),
                                    ),
                                    child: ItemCard(
                                        names: [
                                          'Code',
                                          'Group',
                                          'UoM',
                                          'Tax',
                                          '',
                                        ],
                                        values: [
                                          InheritedForm.of(context)
                                              .items[index]
                                              .itemName,
                                          InheritedForm.of(context)
                                              .items[index]
                                              .itemCode,
                                          InheritedForm.of(context)
                                              .items[index]
                                              .group,
                                          InheritedForm.of(context)
                                              .items[index]
                                              .stockUom,
                                          InheritedForm.of(context)
                                                  .items[index]
                                                  .taxPercent
                                                  .toString() +
                                              '%',
                                        ],
                                        imageUrl: InheritedForm.of(context)
                                            .items[index]
                                            .imageUrl),
                                  ),
                                ),

                              ],
                            ),
                          )),
                ),
        )
      ],
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double vat = 0;
    double total = 0;
    double netTotal = 0;

    InheritedForm.of(context).items.forEach((item) {
      netTotal += item.total;
      vat += (item.total * (item.taxPercent / 100));
      total = netTotal + vat;
    });

    return Row(
      children: [
        ListTitle(title: 'Net Total', value: currency(netTotal)),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            color: Colors.grey,
            height: 50,
            width: 0.5),
        ListTitle(title: 'VAT', value: currency(vat)),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            color: Colors.grey,
            height: 50,
            width: 0.5),
        ListTitle(title: 'Total', value: currency(total)),
      ],
    );
  }
}
