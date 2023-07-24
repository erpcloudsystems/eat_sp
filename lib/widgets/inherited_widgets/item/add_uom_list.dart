import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'uom_table_model.dart';
import '../../form_widgets.dart';
import '../../../screen/list/otherLists.dart';
import '../../../provider/module/module_provider.dart';

class InheritedUOMForm extends InheritedWidget {
  InheritedUOMForm({
    Key? key,
    required Widget child,
    List<UOMModel>? uoms,
  })  : uoms = uoms ?? [],
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
  final ScrollController _uomScrollController = ScrollController();

  Map<String, dynamic> initUOM = {
    "uom": null,
    "conversion_factor": 0.0,
  };

  @override
  void initState() {
    final provider = context.read<ModuleProvider>();
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        if (!provider.isEditing && !provider.duplicateMode) {
          InheritedUOMForm.of(context).uoms.clear();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 12),
        ////// Add Phone Row //////
        Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'UOMs',
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
                                const Duration(milliseconds: 50),
                                () => _uomScrollController.animateTo(
                                    _uomScrollController
                                        .position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut));
                          },
                          child: const Icon(Icons.add,
                              size: 25, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
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
          margin: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: InheritedUOMForm.of(context).uoms.isEmpty
                    ? MediaQuery.of(context).size.height * 0.10
                    : MediaQuery.of(context).size.height * 1),
            child: InheritedUOMForm.of(context).uoms.isEmpty
                ? const Center(
                    child: Text('no UOMs added',
                        style: TextStyle(color: Colors.grey, fontSize: 16)))
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
                        stops: [0.0, 0.05, 0.97, 1.0],
                      ).createShader(bounds);
                    },
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
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
                                        child: const Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Icon(Icons.delete_forever,
                                                color: Colors.white, size: 30),
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            bottom: Radius.circular(8),
                                            top: Radius.circular(8),
                                          ),
                                          border: Border.all(
                                              color: Colors.transparent),
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
                                                const SizedBox(
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
                                                      onChanged: (value) =>
                                                          setState(() {
                                                            
                                                            initUOM['uom'] =
                                                                value;
                                                            InheritedUOMForm.of(
                                                                    context)
                                                                .uoms[index]
                                                                .uom = value;
                                                          }),
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
                                                const SizedBox(
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
                                                        setState(() {
                                                      initUOM['conversion_factor'] =
                                                          double.parse(value);
                                                      InheritedUOMForm.of(
                                                                  context)
                                                              .uoms[index]
                                                              .conversionFactor =
                                                          double.parse(value);
                                                    }),
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
                                                const SizedBox(
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
