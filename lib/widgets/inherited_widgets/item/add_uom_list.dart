import 'dart:async';

import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../models/page_models/model_functions.dart';
import '../contact/email_table_model.dart';
import '../contact/phone_table_model.dart';
import 'uom_table_model.dart';
import '../../snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../models/list_models/hr_list_model/expense_table_model.dart';
import '../../../provider/module/module_provider.dart';
import '../../../screen/list/otherLists.dart';
import '../../../service/service.dart';
import '../../form_widgets.dart';
import '../../item_card.dart';
import '../../list_card.dart';

class InheritedUOMForm extends InheritedWidget {
  InheritedUOMForm({
    Key? key,
    required Widget child,
    List<UOMModel>? uoms,
  })  : this.uoms = uoms ?? [],
        super(key: key, child: child);

  final List<UOMModel> uoms;
  final Map<String, dynamic> data = {};

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static InheritedUOMForm of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedUOMForm>()!;
  }
}

class SelectedUOMsList extends StatefulWidget {
  const SelectedUOMsList({Key? key}) : super(key: key);

  @override
  State<SelectedUOMsList> createState() => _SelectedUOMsListState();
}

class _SelectedUOMsListState extends State<SelectedUOMsList> {
  ScrollController _uomScrollController = ScrollController();

  Map<String, dynamic> initUOM = {
    "uom": null,
    "conversion_factor": 0.0,
  };

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        if (!context.read<ModuleProvider>().isEditing) {
          InheritedUOMForm.of(context).uoms.clear();
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    print('dispose called');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
        ////// Add Phone Row //////
        Card(
          elevation: 1,
          margin: EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
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
                        Text('UOMs',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        SizedBox(
                          width: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero),
                            onPressed: () async {
                              setState(() {
                                FocusScope.of(context).unfocus();

                                // InheritedUOMForm.of(context).uoms.insert(
                                //     0, UOMModel.fromJson(initPhone));
                                InheritedUOMForm.of(context)
                                    .uoms
                                    .add(UOMModel.fromJson(initUOM));
                              });
                              // Timer(Duration(milliseconds: 200), () => _uomScrollController.jumpTo(_uomScrollController.position.maxScrollExtent));

                              Timer(
                                  Duration(milliseconds: 50),
                                  () => _uomScrollController.animateTo(
                                      _uomScrollController
                                          .position.maxScrollExtent,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeInOut));
                            },
                            child:
                                Icon(Icons.add, size: 25, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 8,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: InheritedUOMForm.of(context).uoms.isEmpty
                    ? MediaQuery.of(context).size.height * 0.10
                    : MediaQuery.of(context).size.height * 0.24),
            child: InheritedUOMForm.of(context).uoms.isEmpty
                ? Center(
                    child: Text('no UOMs added',
                        style: TextStyle(color: Colors.grey, fontSize: 16)))
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
                        stops: [0.0, 0.05, 0.97, 1.0],
                      ).createShader(bounds);
                    },
                    child: ListView.builder(physics: BouncingScrollPhysics(),
                        controller: _uomScrollController,
                        // reverse: true,
                        itemCount: InheritedUOMForm.of(context).uoms.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 8),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Dismissible(
                                      key: Key(InheritedUOMForm.of(context)
                                          .uoms[index]
                                          .id
                                          .toString()),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (_) {
                                        setState(() {
                                          InheritedUOMForm.of(context)
                                              .uoms
                                              .removeAt(index);
                                        });
                                      },
                                      background: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.redAccent),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Icon(Icons.delete_forever,
                                                color: Colors.white, size: 30),
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(8),
                                            top: Radius.circular(8),
                                          ),
                                          border:
                                              Border.all(color: Colors.transparent),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              blurRadius: 4,
                                              spreadRadius: 1,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                        margin: const EdgeInsets.only(
                                            top: 0,
                                            bottom: 0.0,
                                            left: 12,
                                            right: 12),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Flexible(
                                                  flex: 3,
                                                  child: CustomTextField(
                                                      'uom', 'UOM',
                                                      disableValidation: false,
                                                      initialValue:
                                                          InheritedUOMForm.of(
                                                                  context)
                                                              .uoms[index]
                                                              .uom,
                                                      onSave: (key, value) =>
                                                          InheritedUOMForm.of(
                                                                  context)
                                                              .uoms[index]
                                                              .uom = value,
                                                      onPressed: () async {
                                                        var res = await Navigator
                                                                .of(context)
                                                            .push(MaterialPageRoute(
                                                                builder: (_) =>
                                                                    uomListScreen()));

                                                        setState(() {
                                                          InheritedUOMForm.of(
                                                                  context)
                                                              .uoms[index]
                                                              .uom = res;
                                                        });
                                                        print(
                                                            '88799695 ${InheritedUOMForm.of(context).uoms[index].uom}');

                                                        return res;
                                                      }),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  flex: 2,
                                                  child: CustomTextField(
                                                    'conversion_factor',
                                                    'Conversion Factor'.tr(),
                                                    initialValue:
                                                        InheritedUOMForm.of(
                                                                context)
                                                            .uoms[index]
                                                            .conversionFactor
                                                            .toString(),
                                                    onChanged: (value) =>
                                                        InheritedUOMForm.of(
                                                                    context)
                                                                .uoms[index]
                                                                .conversionFactor =
                                                            double.parse(value),
                                                    onSave: (key, value) =>
                                                        InheritedUOMForm.of(
                                                                    context)
                                                                .uoms[index]
                                                                .conversionFactor =
                                                            double.parse(value),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    disableError: true,
                                                    validator: (value) =>
                                                        numberValidationToast(
                                                            value,
                                                            'Conversion Factor'
                                                                .tr()),
                                                    disableValidation: true,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  ),
          ),
        ),
      ],
    );
  }
}
