import 'package:NextApp/core/constants.dart';
import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:NextApp/new_version/modules/new_item/data/models/item_model.dart';
import 'package:NextApp/provider/module/module_provider.dart';
import 'package:NextApp/widgets/snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:provider/provider.dart';
import '../../../../../provider/user/user_provider.dart';
import '../../../../../service/service.dart';
import '../../../../../widgets/new_widgets/test_text_field.dart';

// ignore: must_be_immutable
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
  int? QTY = 1;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ModuleProvider>(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // More rounded corners
        side: const BorderSide(color: Colors.grey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 100,
                    width: 120,
                    child: Image.network(
                      context.read<UserProvider>().url + widget.imageUrl,
                      headers: APIService().getHeaders,
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, progress) {
                        return progress != null
                            ? const Icon(Icons.image,
                                color: Colors.grey, size: 40)
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
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.itemName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Rate: '.tr(),
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              (newRate ?? widget.priceListRate).toString(),
                              //widget.rate.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Gutter.small(),
                  Flexible(
                    child: CustomTextFieldTest(
                      'qty',
                      'QTY'.tr(),
                      keyboardType: TextInputType.number,
                      disableError: true,
                      onSave: (_, value) {
                        if (int.tryParse(value) == null ||
                            int.tryParse(value)! < 0) {
                          return;
                        }
                        QTY = int.tryParse(value);
                      },
                      onChanged: (value) {
                        if (int.tryParse(value) == null ||
                            int.tryParse(value)! < 0) {
                          return;
                        }
                        QTY = int.tryParse(value);
                      },
                    ),
                  ),
                  const Gutter.extraLarge(),

                  ///UOM List
                  // const Flexible(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       // Text(
                  //       //   'UOM'.tr(),
                  //       //   overflow: TextOverflow.ellipsis,
                  //       //   style: const TextStyle(
                  //       //     fontSize: 16,
                  //       //   ),
                  //       // ),
                  //       // SizedBox(
                  //       //   height: 40,
                  //       //   child: InkWell(
                  //       //     onTap: () {
                  //       //       showDialog(
                  //       //         context: context,
                  //       //         builder: (ctx) => AlertDialog(
                  //       //           insetPadding: EdgeInsets.only(
                  //       //             bottom: MediaQuery.of(context).size.height *
                  //       //                 0.1,
                  //       //           ),
                  //       //           content: SizedBox(
                  //       //             width: 20,
                  //       //             child: ListView.builder(
                  //       //               shrinkWrap: true,
                  //       //               itemCount: widget.uomList.length,
                  //       //               itemBuilder: (context, index) {
                  //       //                 return InkWell(
                  //       //                   onTap: () async {
                  //       //                     setState(() {
                  //       //                       UOM = widget.uomList[index].uom;

                  //       //                       newRate = widget.uomList[index]
                  //       //                               .conversionFactor *
                  //       //                           widget.priceListRate;
                  //       //                     });

                  //       //                     Navigator.pop(context);
                  //       //                   },
                  //       //                   child: Container(
                  //       //                     margin: const EdgeInsets.all(5),
                  //       //                     decoration: BoxDecoration(
                  //       //                       borderRadius:
                  //       //                           BorderRadius.circular(12),
                  //       //                       border: Border.all(
                  //       //                         color: APPBAR_COLOR,
                  //       //                       ),
                  //       //                     ),
                  //       //                     child: Center(
                  //       //                       child: Text(
                  //       //                         widget.uomList[index].uom,
                  //       //                         style: const TextStyle(
                  //       //                           fontSize: 18,
                  //       //                           color: Colors.black,
                  //       //                         ),
                  //       //                       ),
                  //       //                     ),
                  //       //                   ),
                  //       //                 );
                  //       //               },
                  //       //             ),
                  //       //           ),
                  //       //         ),
                  //       //       );
                  //       //     },
                  //       //     child: Container(
                  //       //       decoration: BoxDecoration(
                  //       //           borderRadius: BorderRadius.circular(12),
                  //       //           border: Border.all(
                  //       //             color: APPBAR_COLOR,
                  //       //           )),
                  //       //       child: Center(
                  //       //         child: Text(
                  //       //           UOM ?? widget.uom,
                  //       //           style: const TextStyle(
                  //       //               color: Colors.black,
                  //       //               fontSize: 16,
                  //       //               fontWeight: FontWeight.bold),
                  //       //         ),
                  //       //       ),
                  //       //     ),
                  //       //   ),
                  //       // ),
                  //     ],
                  //   ),
                  // ),

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
      ),
    );
  }
}
