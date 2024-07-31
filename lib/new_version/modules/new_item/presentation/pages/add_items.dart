import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'item_list_screen.dart';
import '../widgets/total_widget.dart';
import '../../../../../widgets/item_card.dart';
import '../../../../../widgets/form_widgets.dart';
import '../../../../../provider/module/module_provider.dart';

class AddItemsWidget extends StatefulWidget {
  const AddItemsWidget({
    super.key,
    this.haveRate = true,
    required this.priceList,
  });
  final bool haveRate;
  final String priceList;

  @override
  State<AddItemsWidget> createState() => _AddItemsWidgetState();
}

class _AddItemsWidgetState extends State<AddItemsWidget> {
  double total = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ModuleProvider>(
        builder: (context, provider, child) {
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(top: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Items',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ItemListScreen(
                                      priceList: widget.priceList,
                                    );
                                  },
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.add,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.haveRate)
                    Totals(
                      items: provider.newItemList,
                    ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.69,
                    ),
                    child: provider.newItemList.isEmpty
                        ? const Center(
                            child: Text(
                              'no items added',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ShaderMask(
                            blendMode: BlendMode.dstOut,
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
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
                              physics: const BouncingScrollPhysics(),
                              itemCount: provider.newItemList.length,
                              itemBuilder: (context, index) {
                                total = double.parse(provider.newItemList[index]
                                        ['amount']
                                    .toString());
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    bottom: Radius.circular(8)),
                                            border:
                                                Border.all(color: Colors.blue)),
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
                                                  'qty',
                                                  'Quantity',
                                                  validator: (value) =>
                                                      numberValidationToast(
                                                          value, 'Quantity',
                                                          isInt: true,
                                                          isReturn: true),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  disableError: true,
                                                  initialValue: (provider
                                                          .newItemList[index]
                                                              ['qty']
                                                          .toInt())
                                                      .toString(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      provider.newItemList[
                                                              index]['qty'] =
                                                          int.parse(value);

                                                      provider.newItemList[
                                                          index]['amount'] = int
                                                              .parse(value) *
                                                          provider.newItemList[
                                                              index]['rate'];
                                                    });
                                                  },
                                                )),
                                                const SizedBox(width: 6),
                                                if (widget.haveRate)
                                                  Expanded(
                                                      child: CustomTextField(
                                                    'rate',
                                                    'Rate',
                                                    validator: (value) =>
                                                        numberValidationToast(
                                                      value,
                                                      'Quantity',
                                                      isInt: false,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    enabled: false,
                                                    disableError: true,
                                                    initialValue:
                                                        (provider.newItemList[
                                                                index]['rate'])
                                                            .toString(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        provider.newItemList[
                                                                index]['rate'] =
                                                            int.parse(value);

                                                        provider.newItemList[
                                                                index]
                                                            ['amount'] = int
                                                                .parse(value) *
                                                            provider.newItemList[
                                                                index]['qty'];
                                                      });
                                                    },
                                                  )),
                                                const SizedBox(width: 6),
                                                if (widget.haveRate)
                                                  Expanded(
                                                    child: CustomTextField(
                                                      'amount',
                                                      'Total',
                                                      enabled: false,
                                                      initialValue: provider
                                                          .newItemList[index]
                                                              ['amount']
                                                          .toString(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          provider.newItemList[
                                                                      index]
                                                                  ['amount'] =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                    child: CustomTextField(
                                                  'uom',
                                                  'UOM',
                                                  disableError: true,
                                                  enabled: false,
                                                  initialValue: provider
                                                          .newItemList[index]
                                                      ['uom'],
                                                )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 62),
                                        child: Dismissible(
                                          key: Key(provider.newItemList[index]
                                              ['item_code']),
                                          direction:
                                              DismissDirection.endToStart,
                                          onDismissed: (_) => setState(() =>
                                              provider.newItemList
                                                  .removeAt(index)),
                                          background: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.red),
                                            child: const Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: EdgeInsets.all(16),
                                                child: Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.white,
                                                    size: 30),
                                              ),
                                            ),
                                          ),
                                          child: ItemCard(
                                            names: const [
                                              'Code',
                                              'Group',
                                              'UoM',
                                              '',
                                            ],
                                            values: [
                                              provider.newItemList[index]
                                                  ['item_name'],
                                              provider.newItemList[index]
                                                  ['item_code'],
                                              provider.newItemList[index]
                                                      ['item_group'] ??
                                                  'none',
                                              provider.newItemList[index]
                                                  ['uom'],
                                            ],
                                            imageUrl:
                                                provider.newItemList[index]
                                                        ['image'] ??
                                                    '',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
