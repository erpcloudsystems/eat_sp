import 'dart:async';

import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../models/page_models/model_functions.dart';
import 'email_table_model.dart';
import 'phone_table_model.dart';
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
import '../../ondismiss_tutorial.dart';

class InheritedContactForm extends InheritedWidget {
  InheritedContactForm({
    Key? key,
    required Widget child,
    List<PhoneModel>? phones,
    List<EmailModel>? emails,
  })  : this.phones = phones ?? [],
        this.emails = emails ?? [],
        super(key: key, child: child);

  final List<PhoneModel> phones;
  final List<EmailModel> emails;
  final Map<String, dynamic> data = {};

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static InheritedContactForm of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedContactForm>()!;
  }
}

class SelectedPhonesList extends StatefulWidget {
  const SelectedPhonesList({Key? key}) : super(key: key);

  @override
  State<SelectedPhonesList> createState() => _SelectedPhonesListState();
}

class _SelectedPhonesListState extends State<SelectedPhonesList> {
  ScrollController _EmailScrollController = ScrollController();
  ScrollController _phoneScrollController = ScrollController();

  int rowNo = 0;
  bool isSlid = false;

  Map<String, dynamic> initPhone = {
    "phone": null,
    "is_primary_phone": 0,
    "is_primary_mobile_no": 0,
  };
  Map<String, dynamic> initEmail = {
    "email_id": null,
    "is_primary": 0,
  };
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        if (!context.read<ModuleProvider>().isEditing) {
          InheritedContactForm.of(context).phones.clear();
          InheritedContactForm.of(context).emails.clear();
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
    return ListView(
      children: [
        const SizedBox(height: 12),
        ////// Add Email Row //////
        Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(
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
                        const Text('Email IDs',
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

                                // InheritedPhoneForm.of(context).emails.insert(
                                //     0, EmailModel.fromJson(initPhone));
                                InheritedContactForm.of(context)
                                    .emails
                                    .add(EmailModel.fromJson(initEmail));
                              });

                              Timer(
                                  const Duration(milliseconds: 50),
                                  () => _EmailScrollController.animateTo(
                                      _EmailScrollController
                                          .position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut));

                              //Dismiss Tutorial for user
                              if (InheritedContactForm.of(context)
                                      .emails
                                      .length <
                                  2)
                                Timer(
                                    const Duration(milliseconds: 2500),
                                    () => setState(() {
                                          isSlid = true;
                                          Timer(
                                              const Duration(
                                                  milliseconds: 1000),
                                              () => setState(() {
                                                    isSlid = false;
                                                  }));
                                        }));
                              rowNo++;
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
        ),
        const SizedBox(height: 8),
        (InheritedContactForm.of(context).emails.isNotEmpty)
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 30,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () async {
                          setState(() {
                            InheritedContactForm.of(context).emails.clear();
                          });
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
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
                maxHeight: InheritedContactForm.of(context).emails.isEmpty
                    ? MediaQuery.of(context).size.height * 0.10
                    : MediaQuery.of(context).size.height * 0.24),
            child: InheritedContactForm.of(context).emails.isEmpty
                ? const Center(
                    child: Text('no emails added',
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
                        controller: _EmailScrollController,
                        // reverse: true,
                        itemCount:
                            InheritedContactForm.of(context).emails.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 8),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Dismissible(
                                      key: Key(InheritedContactForm.of(context)
                                          .emails[index]
                                          .id
                                          .toString()),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (_) {
                                        setState(() {
                                          InheritedContactForm.of(context)
                                              .emails
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
                                      child: DissmissTutorial(
                                        isSlid: isSlid,
                                        height: 120,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              bottom: Radius.circular(8),
                                              top: Radius.circular(8),
                                            ),
                                            // border: Border.all(
                                            //     color: Colors.grey),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
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
                                                      'email_id',
                                                      tr('Email'),
                                                      initialValue:
                                                          InheritedContactForm
                                                                  .of(context)
                                                              .emails[index]
                                                              .emailId,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      validator: mailValidation,
                                                      onSave: (key, value) =>
                                                          InheritedContactForm
                                                                  .of(context)
                                                              .emails[index]
                                                              .emailId = value,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          InheritedContactForm
                                                                  .of(context)
                                                              .emails[index]
                                                              .emailId = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                      flex: 1,
                                                      child: Text(
                                                          'Row# ${index + 1}')),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: CheckBoxWidget(
                                                      'is_primary_phone',
                                                      'Is Primary Email'.tr(),
                                                      fontSize: 11,
                                                      initialValue:
                                                          InheritedContactForm.of(
                                                                          context)
                                                                      .emails[
                                                                          index]
                                                                      .isPrimary ==
                                                                  1
                                                              ? true
                                                              : false,
                                                      onChanged: (id, value) =>
                                                          setState(() =>
                                                              InheritedContactForm.of(
                                                                          context)
                                                                      .emails[index]
                                                                      .isPrimary =
                                                                  value
                                                                      ? 1
                                                                      : 0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Divider(
                                  //   color: Colors.black54,
                                  //   height: 2,
                                  //   thickness: 1,
                                  //   indent: 15,
                                  //   endIndent: 15,
                                  // ),
                                ],
                              ),
                            )),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        ////// Add Phone Row //////
        Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(
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
                        const Text('Contact Numbers',
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

                                // InheritedPhoneForm.of(context).phones.insert(
                                //     0, PhoneModel.fromJson(initPhone));
                                InheritedContactForm.of(context)
                                    .phones
                                    .add(PhoneModel.fromJson(initPhone));
                              });

                              Timer(
                                  const Duration(milliseconds: 50),
                                  () => _phoneScrollController.animateTo(
                                      _phoneScrollController
                                          .position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut));

                              //Dismiss Tutorial for user
                              if (InheritedContactForm.of(context)
                                      .emails
                                      .length <
                                  2) {
                                Timer(
                                    const Duration(milliseconds: 2500),
                                    () => setState(() {
                                          isSlid = true;
                                          Timer(
                                              const Duration(
                                                  milliseconds: 1000),
                                              () => setState(() {
                                                    isSlid = false;
                                                  }));
                                        }));
                              }
                              rowNo++;
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
        ),
        const SizedBox(height: 8),
        (InheritedContactForm.of(context).phones.isNotEmpty)
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 30,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () async {
                          setState(() {
                            InheritedContactForm.of(context).phones.clear();
                          });
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
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
                maxHeight: InheritedContactForm.of(context).phones.isEmpty
                    ? MediaQuery.of(context).size.height * 0.10
                    : MediaQuery.of(context).size.height * 0.24),
            child: InheritedContactForm.of(context).phones.isEmpty
                ? const Center(
                    child: Text('no phones added',
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
                        controller: _phoneScrollController,
                        // reverse: true,
                        itemCount:
                            InheritedContactForm.of(context).phones.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 8),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Dismissible(
                                      key: Key(InheritedContactForm.of(context)
                                          .phones[index]
                                          .id
                                          .toString()),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (_) {
                                        setState(() {
                                          InheritedContactForm.of(context)
                                              .phones
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
                                      child: DissmissTutorial(
                                        isSlid: isSlid,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.20,
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
                                                color: Colors.grey
                                                    .withOpacity(0.2),
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
                                                      'phone', tr('Phone'),
                                                      initialValue:
                                                          InheritedContactForm
                                                                  .of(context)
                                                              .phones[index]
                                                              .phone,
                                                      keyboardType:
                                                          TextInputType.phone,
                                                      // validator: validateMobile,
                                                      onSave: (key, value) =>
                                                          InheritedContactForm
                                                                  .of(context)
                                                              .phones[index]
                                                              .phone = value,
                                                              onChanged: (value) {
                                                        setState(() {
                                                          InheritedContactForm
                                                                  .of(context)
                                                              .phones[index]
                                                              .phone = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                      flex: 1,
                                                      child: Text(
                                                          'Row# ${index + 1}')),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: CheckBoxWidget(
                                                      'is_primary_phone',
                                                      'Is Primary Phone'.tr(),
                                                      fontSize: 11,
                                                      initialValue:
                                                          InheritedContactForm.of(
                                                                          context)
                                                                      .phones[
                                                                          index]
                                                                      .isPrimaryPhone ==
                                                                  1
                                                              ? true
                                                              : false,
                                                      onChanged: (id, value) => setState(
                                                          () => InheritedContactForm
                                                                      .of(context)
                                                                  .phones[index]
                                                                  .isPrimaryPhone =
                                                              value ? 1 : 0),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                    child: CheckBoxWidget(
                                                      'is_primary_mobile_no',
                                                      'Is Primary Mobile'.tr(),
                                                      fontSize: 11,
                                                      initialValue:
                                                          InheritedContactForm.of(
                                                                          context)
                                                                      .phones[
                                                                          index]
                                                                      .isPrimaryMobile ==
                                                                  1
                                                              ? true
                                                              : false,
                                                      onChanged: (id, value) => setState(
                                                          () => InheritedContactForm
                                                                      .of(context)
                                                                  .phones[index]
                                                                  .isPrimaryMobile =
                                                              value ? 1 : 0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Divider(
                                  //   color: Colors.black54,
                                  //   height: 2,
                                  //   thickness: 1,
                                  //   indent: 15,
                                  //   endIndent: 15,
                                  // ),
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
