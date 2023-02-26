import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../models/page_models/model_functions.dart';
import '../../models/list_models/accounts_list_models/account_table_model.dart';
import '../../provider/module/module_provider.dart';
import '../../screen/list/otherLists.dart';
import '../../service/service.dart';
import '../ondismiss_tutorial.dart';
import '../form_widgets.dart';
import '../list_card.dart';

class InheritedAccountForm extends InheritedWidget {
  InheritedAccountForm(
      {Key? key, required Widget child, List<AccountModel>? account})
      : this.account = account ?? [],
        super(key: key, child: child);

  final List<AccountModel> account;
  final Map<String, dynamic> data = {};

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static InheritedAccountForm of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedAccountForm>()!;
  }
}

class SelectedAccountsList extends StatefulWidget {
  const SelectedAccountsList({Key? key}) : super(key: key);

  @override
  State<SelectedAccountsList> createState() => _SelectedAccountsListState();
}

class _SelectedAccountsListState extends State<SelectedAccountsList> {
  ScrollController _scrollController = ScrollController();
  int rowNo = 0;
  bool isSlid = false;

  Map<String, dynamic> initAccount = {
    "account": null,
    "account_type": null,
    "balance": '0.0',
    "bank_account": null,
    "party_type": null,
    "party": null,
    "debit_in_account_currency": 0.0,
    "credit_in_account_currency": 0.0,
  };
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        if (!context.read<ModuleProvider>().isEditing) {
          InheritedAccountForm.of(context).account.clear();
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
                  _Totals(),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Accounts',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        SizedBox(
                          width: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero),
                            onPressed: () async {
                              setState(() {
                                // InheritedAccountForm.of(context).account.insert(
                                //     0, AccountModel.fromJson(initAccount));
                                InheritedAccountForm.of(context)
                                    .account
                                    .add(AccountModel.fromJson(initAccount));
                              });

                              Timer(
                                  Duration(milliseconds: 50),
                                  () => _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeInOut));
                              //Dismiss Tutorial for user
                              if (InheritedAccountForm.of(context)
                                      .account
                                      .length <
                                  2)
                                Timer(
                                    Duration(milliseconds: 2500),
                                    () => setState(() {
                                          isSlid = true;
                                          Timer(
                                              Duration(milliseconds: 1000),
                                              () => setState(() {
                                                    isSlid = false;
                                                  }));
                                        }));
                              rowNo++;
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
        (InheritedAccountForm.of(context).account.isNotEmpty)
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
                            InheritedAccountForm.of(context).account.clear();
                          });
                        },
                        child: Text(
                          'Clear All',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
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
                maxHeight: InheritedAccountForm.of(context).account.isEmpty
                    ? MediaQuery.of(context).size.height * 0.10
                    : MediaQuery.of(context).size.height * 0.50),
            child: InheritedAccountForm.of(context).account.isEmpty
                ? Center(
                    child: Text('no accounts added',
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
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        controller: _scrollController,
                        // reverse: true,
                        itemCount:
                            InheritedAccountForm.of(context).account.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 8),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Dismissible(
                                      key: Key(InheritedAccountForm.of(context)
                                          .account[index]
                                          .id
                                          .toString()),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (_) {
                                        setState(() {
                                          InheritedAccountForm.of(context)
                                              .account
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
                                      child: DissmissTutorial(
                                        isSlid: isSlid,
                                        height: 155,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(
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
                                              Text('Row# ${index + 1}'),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: CustomTextField(
                                                        'account',
                                                        'Account'.tr(),
                                                        initialValue:
                                                            InheritedAccountForm
                                                                    .of(context)
                                                                .account[index]
                                                                .account,
                                                        onSave: (key, value) =>
                                                            InheritedAccountForm
                                                                    .of(context)
                                                                .account[index]
                                                                .account = value,
                                                        onPressed: () async {
                                                          InheritedAccountForm
                                                                  .of(context)
                                                              .account[index]
                                                              .accountType = '';
                                                          InheritedAccountForm
                                                                  .of(context)
                                                              .account[index]
                                                              .partyType = '';

                                                          var res = await Navigator
                                                                  .of(context)
                                                              .push(MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      accountListScreen()));
                                                          setState(() {});

                                                          InheritedAccountForm.of(
                                                                      context)
                                                                  .account[index]
                                                                  .account =
                                                              res['name'];

                                                          InheritedAccountForm
                                                                  .of(context)
                                                              .account[index]
                                                              .balance = Map<
                                                                      String,
                                                                      dynamic>.from(
                                                                  await APIService()
                                                                      .genericGet(
                                                                          'method/erpnext.accounts.utils.get_balance_on?account=' +
                                                                              res['name']))['message']
                                                              .toString();

                                                          InheritedAccountForm
                                                                  .of(context)
                                                              .account[index]
                                                              .accountType = Map<
                                                                  String,
                                                                  dynamic>.from(
                                                              await APIService().genericGet(
                                                                  'method/ecs_mobile.general.general_service?doctype=Account&filter2=' +
                                                                      InheritedAccountForm.of(context)
                                                                          .account[index]
                                                                          .account))['message'][0]['account_type'];

                                                          if (InheritedAccountForm
                                                                      .of(
                                                                          context)
                                                                  .account[
                                                                      index]
                                                                  .accountType ==
                                                              "Receivable") {
                                                            InheritedAccountForm.of(
                                                                        context)
                                                                    .account[index]
                                                                    .partyType =
                                                                journalEntryTypePartyType1[
                                                                    0];
                                                          } else if (InheritedAccountForm
                                                                      .of(
                                                                          context)
                                                                  .account[
                                                                      index]
                                                                  .accountType ==
                                                              "Payable") {
                                                            InheritedAccountForm.of(
                                                                        context)
                                                                    .account[index]
                                                                    .partyType =
                                                                journalEntryTypePartyType2[
                                                                    0];
                                                          } else {
                                                            InheritedAccountForm
                                                                    .of(context)
                                                                .account[index]
                                                                .partyType = '';
                                                          }

                                                          setState(() {});
                                                          return res['name'];
                                                        }),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                    child: CustomTextField(
                                                      'bank_account',
                                                      'Bank Account'.tr(),
                                                      initialValue:
                                                          InheritedAccountForm
                                                                  .of(context)
                                                              .account[index]
                                                              .bankAccount,
                                                      onSave: (key, value) =>
                                                          InheritedAccountForm.of(
                                                                      context)
                                                                  .account[index]
                                                                  .bankAccount =
                                                              value,
                                                      onPressed: () async {
                                                        var res = await Navigator
                                                                .of(context)
                                                            .push(MaterialPageRoute(
                                                                builder: (_) =>
                                                                    bankAccountScreen()));
                                                        setState(() {
                                                          InheritedAccountForm
                                                                  .of(context)
                                                              .account[index]
                                                              .bankAccount = res;
                                                        });
                                                        return res;
                                                      },
                                                      disableValidation: true,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  if (InheritedAccountForm.of(
                                                              context)
                                                          .account[index]
                                                          .accountType ==
                                                      "Receivable")
                                                    Flexible(
                                                      child: CustomDropDown(
                                                          'party_type',
                                                          'Party Type'.tr(),
                                                          items:
                                                              journalEntryTypePartyType1,
                                                          defaultValue:
                                                              InheritedAccountForm
                                                                      .of(
                                                                          context)
                                                                  .account[
                                                                      index]
                                                                  .partyType,
                                                          onChanged: (value) =>
                                                              setState(() {
                                                                InheritedAccountForm.of(
                                                                        context)
                                                                    .account[
                                                                        index]
                                                                    .partyType = value;
                                                              })),
                                                    ),
                                                  if (InheritedAccountForm.of(
                                                              context)
                                                          .account[index]
                                                          .accountType ==
                                                      "Payable")
                                                    Flexible(
                                                      child: CustomDropDown(
                                                          'party_type',
                                                          'Party Type'.tr(),
                                                          items:
                                                              journalEntryTypePartyType2,
                                                          defaultValue:
                                                              InheritedAccountForm
                                                                      .of(
                                                                          context)
                                                                  .account[
                                                                      index]
                                                                  .partyType,
                                                          onChanged: (value) =>
                                                              setState(() {
                                                                InheritedAccountForm.of(
                                                                        context)
                                                                    .account[
                                                                        index]
                                                                    .partyType = value;
                                                              })),
                                                    ),
                                                ],
                                              ),
                                              if (InheritedAccountForm.of(
                                                              context)
                                                          .account[index]
                                                          .accountType ==
                                                      "Receivable" ||
                                                  InheritedAccountForm.of(
                                                              context)
                                                          .account[index]
                                                          .accountType ==
                                                      "Payable")
                                                CustomTextField(
                                                  'party',
                                                  InheritedAccountForm.of(
                                                          context)
                                                      .account[index]
                                                      .partyType,
                                                  initialValue:
                                                      InheritedAccountForm.of(
                                                              context)
                                                          .account[index]
                                                          .party,
                                                  onPressed: () async {
                                                    String? id;

                                                    if (InheritedAccountForm.of(
                                                                context)
                                                            .account[index]
                                                            .partyType ==
                                                        journalEntryTypePartyType1[
                                                            0]) {
                                                      final res = await Navigator
                                                              .of(context)
                                                          .push(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  selectCustomerScreen()));
                                                      if (res != null) {
                                                        id = res['name'];
                                                        setState(() {
                                                          InheritedAccountForm.of(
                                                                      context)
                                                                  .account[index]
                                                                  .party =
                                                              res['name'];
                                                        });
                                                      }
                                                    } else if (InheritedAccountForm
                                                                .of(context)
                                                            .account[index]
                                                            .partyType ==
                                                        journalEntryTypePartyType2[
                                                            0]) {
                                                      final res = await Navigator
                                                              .of(context)
                                                          .push(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  supplierListScreen()));
                                                      if (res != null) {
                                                        id = res['name'];
                                                        setState(() {
                                                          InheritedAccountForm.of(
                                                                      context)
                                                                  .account[index]
                                                                  .party =
                                                              res['name'];
                                                        });
                                                      }
                                                    } else if (InheritedAccountForm
                                                                .of(context)
                                                            .account[index]
                                                            .partyType ==
                                                        journalEntryTypePartyType2[
                                                            1]) {
                                                      final res = await Navigator
                                                              .of(context)
                                                          .push(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  selectEmployeeScreen()));
                                                      if (res != null) {
                                                        id = res['name'];
                                                        setState(() {
                                                          InheritedAccountForm.of(
                                                                      context)
                                                                  .account[index]
                                                                  .party =
                                                              res['name'];
                                                        });
                                                      }
                                                    }

                                                    return id;
                                                  },
                                                ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: CustomTextField(
                                                      'balance',
                                                      'Balance'.tr(),
                                                      initialValue:
                                                          (InheritedAccountForm
                                                                      .of(
                                                                          context)
                                                                  .account[
                                                                      index]
                                                                  .balance)
                                                              .toString(),
                                                      enabled: false,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                    child: CustomTextField(
                                                      'debit_in_account_currency',
                                                      'Debit'.tr(),
                                                      initialValue: (InheritedAccountForm
                                                                      .of(
                                                                          context)
                                                                  .account[
                                                                      index]
                                                                  .debitInAccountCurrency ==
                                                              0.0)
                                                          ? ""
                                                          : InheritedAccountForm
                                                                  .of(context)
                                                              .account[index]
                                                              .debitInAccountCurrency
                                                              .toString(),
                                                      onChanged: (value) =>
                                                          InheritedAccountForm.of(
                                                                      context)
                                                                  .account[index]
                                                                  .debitInAccountCurrency =
                                                              double.tryParse(
                                                                  value)!,
                                                      onSubmit: (value) =>
                                                          setState(() {}),
                                                      onSave: (key, value) =>
                                                          InheritedAccountForm.of(
                                                                      context)
                                                                  .account[index]
                                                                  .debitInAccountCurrency =
                                                              double.tryParse(
                                                                  value)!,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      disableError: true,
                                                      validator: (value) =>
                                                          numberValidationToast(
                                                              value,
                                                              'Credit'.tr()),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                    child: CustomTextField(
                                                      'credit_in_account_currency',
                                                      'Credit'.tr(),
                                                      initialValue: (InheritedAccountForm
                                                                      .of(
                                                                          context)
                                                                  .account[
                                                                      index]
                                                                  .creditInAccountCurrency ==
                                                              0.0)
                                                          ? ""
                                                          : InheritedAccountForm
                                                                  .of(context)
                                                              .account[index]
                                                              .creditInAccountCurrency
                                                              .toString(),
                                                      onChanged: (value) =>
                                                          InheritedAccountForm.of(
                                                                      context)
                                                                  .account[index]
                                                                  .creditInAccountCurrency =
                                                              double.tryParse(
                                                                  value)!,
                                                      onSubmit: (value) =>
                                                          setState(() {}),
                                                      onSave: (key, value) =>
                                                          InheritedAccountForm.of(
                                                                      context)
                                                                  .account[index]
                                                                  .creditInAccountCurrency =
                                                              double.tryParse(
                                                                  value)!,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      disableError: true,
                                                      validator: (value) =>
                                                          numberValidationToast(
                                                              value,
                                                              'Credit'.tr()),
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

class _Totals extends StatelessWidget {
  const _Totals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalDebit = 0;
    double totalCredit = 0;
    double totalTaxesAndCharges = 0;
    double totalClaimedAmount = 0;

    InheritedAccountForm.of(context).account.forEach((account) {
      totalDebit += account.debitInAccountCurrency;
      totalCredit += account.creditInAccountCurrency;
      InheritedAccountForm.of(context).data['total_debit'] = totalDebit;
      InheritedAccountForm.of(context).data['total_credit'] = totalCredit;
    });

    return Column(
      children: [
        Row(
          children: [
            ListTitle(title: 'Total Debit', value: currency(totalDebit)),
            ListTitle(title: 'Total Credit', value: currency(totalCredit)),
          ],
        ),
      ],
    );
  }
}
