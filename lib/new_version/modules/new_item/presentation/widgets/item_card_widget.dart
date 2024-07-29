import 'package:NextApp/core/constants.dart';
import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:NextApp/new_version/modules/new_item/data/models/item_model.dart';
import 'package:NextApp/provider/module/module_provider.dart';
import 'package:NextApp/widgets/snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../provider/user/user_provider.dart';
import '../../../../../service/service.dart';
import '../../../../../widgets/new_widgets/test_text_field.dart';

class ItemCardWidget extends StatefulWidget {
  ItemCardWidget({
    super.key,
    required this.itemName,
    required this.rate,
    required this.uom,
    required this.imageUrl,
    required this.itemCode,
    required this.uomList,
    required this.itemGroup,
    required this.priceListRate,
    this.itemTaxTemplate,
    this.taxPercent,
  });
  final String itemName, imageUrl, itemCode, itemGroup;
  final String? itemTaxTemplate;

  final double? taxPercent;
  final double rate, priceListRate;
  String uom;
  final List<UomModel> uomList;

  @override
  State<ItemCardWidget> createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {
  final formKey = GlobalKey<FormState>();
  double? newRate;
  String? UOM;
  int QTY = 1;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ModuleProvider>(context);
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            offset: Offset(
              6.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              widget.itemName,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: Image.network(
                    context.read<UserProvider>().url + widget.imageUrl,
                    headers: APIService().getHeaders,
                    fit: BoxFit.fill,
                    height: 100,
                    width: 120,
                    loadingBuilder: (context, child, progress) {
                      return progress != null
                          ? const SizedBox(
                              child: Icon(Icons.image,
                                  color: Colors.grey, size: 40))
                          : child;
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return const SizedBox(
                        child: Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 80,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Rate: '.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          (newRate ?? widget.priceListRate).toStringAsFixed(2),
                          //widget.rate.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Group: '.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.itemGroup,
                          //widget.rate.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: CustomTextFieldTest(
                    'qty',
                    'QTY'.tr(),
                    initialValue: QTY.toString(),
                    keyboardType: TextInputType.number,
                    disableError: true,
                    onSave: (_, value) => QTY = int.parse(value),
                    onChanged: (value) {
                      QTY = int.parse(value);
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),

                ///UOM List
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UOM'.tr(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                insetPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.1,
                                ),
                                content: SizedBox(
                                  height: widget.uomList.length > 2 ? 120 : 100,
                                  width: 20,
                                  child: ListView.builder(
                                    itemCount: widget.uomList.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          setState(() {
                                            UOM = widget.uomList[index].uom;

                                            newRate = widget.uomList[index]
                                                    .conversionFactor *
                                                widget.priceListRate;
                                          });

                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: APPBAR_COLOR,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              widget.uomList[index].uom,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: APPBAR_COLOR,
                                )),
                            child: Center(
                              child: Text(
                                UOM ?? widget.uom,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            provider.setItemToList({
                              "item_code": widget.itemCode,
                              "item_name": widget.itemName,
                              "item_group": widget.itemGroup,
                              "image": widget.imageUrl,
                              "qty": QTY,
                              "uom": UOM ?? widget.uom,
                              "rate": newRate ?? widget.priceListRate,
                              if (provider.currentModule.title ==
                                  DocTypesName.salesInvoice)
                                'item_tax_template': widget.itemTaxTemplate,
                              if (provider.currentModule.title ==
                                  DocTypesName.salesInvoice)
                                'tax_percent': widget.taxPercent,
                            });
                            showSnackBar(
                              '${"This Item added".tr()}\n${widget.itemName}',
                              context,
                              color: Colors.green,
                            );
                          }
                        },
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: APPBAR_COLOR,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
