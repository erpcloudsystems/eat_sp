import 'dart:async';

import '../../models/list_models/stock_list_model/item_table_model.dart';
import '../../models/page_models/model_functions.dart';
import '../snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/list_models/hr_list_model/expense_table_model.dart';
import '../../provider/module/module_provider.dart';
import '../../screen/list/otherLists.dart';
import '../../service/service.dart';
import '../expense_card.dart';
import '../form_widgets.dart';
import '../item_card.dart';
import '../list_card.dart';
import '../ondismiss_tutorial.dart';

class InheritedExpenseForm extends InheritedWidget {
  InheritedExpenseForm(
      {Key? key, required Widget child, List<ExpenseModel>? expense})
      : this.expense = expense ?? [],
        super(key: key, child: child);

  final List<ExpenseModel> expense;
  final Map<String, dynamic> data = {};
  Map<String, dynamic> taxData = {};

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static InheritedExpenseForm of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedExpenseForm>()!;
  }
}

class SelectedExpensesList extends StatefulWidget {
  const SelectedExpensesList({Key? key}) : super(key: key);

  @override
  State<SelectedExpensesList> createState() => _SelectedExpensesListState();
}

class _SelectedExpensesListState extends State<SelectedExpensesList> {
  ScrollController _scrollController = ScrollController();
  int rowNo = 0;
  bool isSlid = false;

  Map<String, dynamic> initExpense = {
    "expense_date": DateTime.now().toIso8601String(),
    "expense_type": "",
    "amount": null,
    "sanctioned_amount": null,
    "description": "",
    "cost_center": "",
  };
  @override
  void initState() {

    if (!context.read<ModuleProvider>().isEditing) // Not Editing
      Future.delayed(Duration.zero).then((value) {
        InheritedExpenseForm.of(context).expense.clear();
        InheritedExpenseForm.of(context).taxData.clear();
        setState(() {});


    });
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    initExpense['cost_center'] = Map<String, dynamic>.from(await APIService()
        .genericGet('method/ecs_mobile.general.general_service?doctype=' +
            APIService.COMPANY))['message'][0]['round_off_cost_center'];

    InheritedExpenseForm.of(context).taxData['cost_center'] =
        Map<String, dynamic>.from(await APIService().genericGet(
            'method/ecs_mobile.general.general_service?doctype=' +
                APIService.COMPANY))['message'][0]['round_off_cost_center'];
    print('asdas${InheritedExpenseForm.of(context).taxData['cost_center']}');
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
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
            border: Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 0.5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Column(
                  children: [
                    _Totals(),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Expenses',
                              style: TextStyle(
                                color: Colors.black87,
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(
                            width: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero),
                              onPressed: () async {
                                setState(() {
                                  InheritedExpenseForm.of(context)
                                      .expense
                                      .add(ExpenseModel.fromJson(initExpense));
                                });

                                Timer(
                                    Duration(milliseconds: 50),
                                    () => _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeInOut));

                                //Dismiss Tutorial for user
                                if (InheritedExpenseForm.of(context)
                                    .expense.length < 2)
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
                              child: Icon(Icons.add,
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
        ),
        SizedBox(height: 8),
        (InheritedExpenseForm.of(context).expense.isNotEmpty)
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
                      InheritedExpenseForm.of(context).expense.clear();
                      InheritedExpenseForm.of(context).taxData.clear();
                    });
                  },
                  child: Text('Clear All',style: TextStyle(color: Colors.black87),),
                ),
              ),
            ],
          ),
        )
            : Container(),
        (InheritedExpenseForm.of(context).expense.isNotEmpty)
            ? Group(
                color: Colors.transparent,
                child: Column(
                  children: [
                    CustomTextField(
                      'rate',
                      'Tax Rate % '.tr(),
                      removeUnderLine: true,
                      initialValue:InheritedExpenseForm.of(context).taxData['rate'],
                      keyboardType: TextInputType.number,
                      disableError: true,
                      onChanged: (value) {
                        setState(() {
                          InheritedExpenseForm.of(context).taxData['rate'] =
                              value;
                        });
                      },
                      onSave: (key, value) {
                        InheritedExpenseForm.of(context).taxData['key'] =
                            value;
                      },
                      validator: (value) =>
                          numberValidationToast(value, 'Rate'.tr()),
                    ),
                  ],
                ),
              )
            : Container(),

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
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          padding: EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: InheritedExpenseForm.of(context).expense.isEmpty
                    ? MediaQuery.of(context).size.height * 0.10
                    : MediaQuery.of(context).size.height * 0.41),
            child: InheritedExpenseForm.of(context).expense.isEmpty
                ? Center(
                    child: Text('no expenses added',
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
                        controller: _scrollController,
                        //reverse: true,
                        itemCount:
                            InheritedExpenseForm.of(context).expense.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 8),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0),
                                    child: Dismissible(
                                      key: Key(InheritedExpenseForm.of(context)
                                          .expense[index]
                                          .id
                                          .toString()),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (_) {
                                        setState(() {
                                          InheritedExpenseForm.of(context)
                                              .expense
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
                                        height: 220,
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
                                                children: [
                                                  Flexible(
                                                    child: DatePicker(
                                                      'expense_date',
                                                      'Expense Date'.tr(),
                                                      initialValue:
                                                          InheritedExpenseForm
                                                                  .of(context)
                                                              .expense[index]
                                                              .expenseDate,
                                                      onChanged: (value) =>
                                                          setState(() {
                                                        InheritedExpenseForm.of(
                                                                    context)
                                                                .expense[index]
                                                                .expenseDate =
                                                            value;
                                                      }),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Flexible(
                                                    child: CustomTextField(
                                                        'expense_type',
                                                        'Expense Claim Type'
                                                            .tr(),
                                                        initialValue:
                                                            InheritedExpenseForm
                                                                    .of(context)
                                                                .expense[index]
                                                                .expenseClaimType,
                                                        onSave: (key, value) =>
                                                            InheritedExpenseForm
                                                                    .of(context)
                                                                .expense[index]
                                                                .expenseClaimType = value,
                                                        onPressed: () async {
                                                          var res = await Navigator
                                                                  .of(context)
                                                              .push(MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      expenseClaimTypeScreen()));

                                                          setState(() {
                                                            InheritedExpenseForm
                                                                    .of(context)
                                                                .expense[index]
                                                                .expenseClaimType = res;
                                                          });

                                                          return res;
                                                        }),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: CustomTextField(
                                                      'amount',
                                                      'Amount '.tr(),
                                                      initialValue: (InheritedExpenseForm
                                                                      .of(
                                                                          context)
                                                                  .expense[
                                                                      index]
                                                                  .amount !=
                                                              0.0)
                                                          ? InheritedExpenseForm
                                                                  .of(context)
                                                              .expense[index]
                                                              .amount
                                                              .toString()
                                                          : null,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      disableError: true,
                                                      onChanged: (value) {
                                                        InheritedExpenseForm.of(
                                                                    context)
                                                                .expense[index]
                                                                .amount =
                                                            double.tryParse(
                                                                value)!;

                                                        InheritedExpenseForm.of(
                                                                    context)
                                                                .expense[index]
                                                                .sanctionedAmount =
                                                            double.tryParse(
                                                                value)!;
                                                      },
                                                      onSubmit: (value) =>
                                                          setState(() {}),
                                                      onSave: (key, value) =>
                                                          InheritedExpenseForm.of(
                                                                      context)
                                                                  .expense[index]
                                                                  .amount =
                                                              double.tryParse(
                                                                  value)!,
                                                      validator: (value) =>
                                                          numberValidationToast(
                                                              value, 'Amount'),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Flexible(
                                                    child: CustomTextField(
                                                      'sanctioned_amount',
                                                      'Sanctioned Amount'.tr(),
                                                      initialValue:
                                                          (InheritedExpenseForm
                                                                      .of(
                                                                          context)
                                                                  .expense[
                                                                      index]
                                                                  .sanctionedAmount)
                                                              .toString(),
                                                      enabled: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: CustomTextField(
                                                      'description',
                                                      'Description'.tr(),
                                                      initialValue:
                                                          InheritedExpenseForm
                                                                  .of(context)
                                                              .expense[index]
                                                              .description,
                                                      onChanged: (value) {
                                                        InheritedExpenseForm.of(
                                                                    context)
                                                                .expense[index]
                                                                .description =
                                                            value;
                                                      },
                                                      disableValidation: true,

                                                      onSave: (key, value) =>
                                                          InheritedExpenseForm.of(
                                                                      context)
                                                                  .expense[index]
                                                                  .description =
                                                              value,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Flexible(
                                                    child: CustomTextField(
                                                        'cost_center',
                                                        'Cost Center'.tr(),
                                                        initialValue:
                                                            InheritedExpenseForm
                                                                    .of(context)
                                                                .expense[index]
                                                                .costCenter,
                                                        onSave: (key, value) =>
                                                            InheritedExpenseForm
                                                                    .of(context)
                                                                .expense[index]
                                                                .costCenter = value,
                                                        onPressed: () async {
                                                          var res = await Navigator
                                                                  .of(context)
                                                              .push(MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      companyListScreen()));
                                                          setState(() {
                                                            InheritedExpenseForm.of(
                                                                        context)
                                                                    .expense[index]
                                                                    .costCenter =
                                                                res['round_off_cost_center'];

                                                            InheritedExpenseForm.of(
                                                                            context)
                                                                        .taxData[
                                                                    'cost_center'] =
                                                                res['round_off_cost_center'];
                                                          });
                                                          return res[
                                                              'round_off_cost_center'];
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
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
    double totalSanctionedAmount = 0;
    double grandTotal = 0;
    double totalTaxesAndCharges = 0;
    double totalClaimedAmount = 0;

    //double taxAmount = 0;

    InheritedExpenseForm.of(context).expense.forEach((expense) {
      totalSanctionedAmount += expense.amount;
      totalTaxesAndCharges = (totalSanctionedAmount *
          ((double.tryParse((InheritedExpenseForm.of(context)
                      .taxData['rate']
                      .toString())) ??
                  0.0) /
              100));
      grandTotal = totalSanctionedAmount + totalTaxesAndCharges;
      totalClaimedAmount = totalSanctionedAmount;

      InheritedExpenseForm.of(context).taxData['tax_amount'] =
          totalTaxesAndCharges;
      InheritedExpenseForm.of(context).taxData['total'] = grandTotal;
    });

    return Column(
      children: [
        Row(
          children: [
            ListTitle(
                title: 'Total Sanctioned Amount',
                value: currency(totalSanctionedAmount)),

            ListTitle(title: 'Grand Total', value: currency(grandTotal)),
          ],
        ),
        Row(
          children: [
            ListTitle(
                title: 'Total Taxes and Charges',
                value: currency(totalTaxesAndCharges)),

            ListTitle(
                title: 'Total Claimed Amount',
                value: currency(totalClaimedAmount)),
          ],
        ),
      ],
    );
  }
}
