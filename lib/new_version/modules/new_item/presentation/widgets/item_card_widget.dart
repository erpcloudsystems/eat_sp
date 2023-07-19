import 'package:NextApp/core/constants.dart';
import 'package:NextApp/new_version/modules/new_item/data/models/item_model.dart';
import 'package:NextApp/provider/module/module_provider.dart';
import 'package:NextApp/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/user/user_provider.dart';
import '../../../../../service/service.dart';
import '../../../../../test/test_text_field.dart';

class ItemCardWidget extends StatefulWidget {
  ItemCardWidget({
    Key? key,
    required this.itemName,
    required this.rate,
    required this.uom,
    this.qty = 1,
    required this.imageUrl,
    required this.itemCode,
    required this.uomList,
  }) : super(key: key);
  final String itemName, imageUrl, itemCode;
  int qty;
  final double rate;
  String uom;
  final List<UomModel> uomList;

  @override
  State<ItemCardWidget> createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: Text(
              widget.itemName,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          Flexible(
            child: Image.network(
              context.read<UserProvider>().url + widget.imageUrl,
              headers: APIService().getHeaders,
              fit: BoxFit.fill,
              height: 100,
              width: 140,
              loadingBuilder: (context, child, progress) {
                return progress != null
                    ? const SizedBox(
                        child: Icon(Icons.image, color: Colors.grey, size: 40))
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Flexible(
                child: Text(
                  'Rate: ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  widget.rate.toStringAsFixed(2),
                  //widget.rate.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                child: CustomTextFieldTest(
                  'qty',
                  'QTY',
                  initialValue: widget.qty.toString(),
                  keyboardType: TextInputType.number,
                  disableError: true,
                  onSave: (_, value) => widget.qty = int.parse(value),
                  onChanged: (value) {
                    widget.qty = int.parse(value);
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
                    const Text(
                      'Uom',
                      style: TextStyle(
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
                                height: widget.uomList.length > 2 ? 100 : 80,
                                width: 20,
                                child: ListView.builder(
                                  itemCount: widget.uomList.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () async {
                                        setState(() {
                                          widget.uom =
                                              widget.uomList[index].uom;
                                        });

                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.black,
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.uomList[index].uom,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
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
                              widget.uom,
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
            ],
          ),
          InkWell(
            onTap: () {
              provider.setItemToList({
                "item_code": widget.itemCode,
                "item_name": widget.itemName,
                "qty": widget.qty,
                "uom": widget.uom,
                "rate": widget.rate,
              });
              showSnackBar(
                'Item ${widget.itemName} Added',
                context,
                color: Colors.green,
              );
            },
            child: Container(
              height: 35,
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
          )
        ],
      ),
    );
  }
}
