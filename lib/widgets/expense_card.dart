import '../core/constants.dart';
import '../provider/user/user_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/service.dart';
import 'inherited_widgets/add_expenses_list.dart';
import 'form_widgets.dart';


class ExpenseCard extends StatelessWidget {
  final List<String> names, values;

  final void Function(BuildContext context)? onPressed;

  const ExpenseCard({Key? key, this.names = const ['Expense Date', 'Expense Type', 'Amount','Sanctioned Amount','Cost Center',], required this.values, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
      child: InkWell(
        onTap: onPressed == null ? null : () => onPressed!(context),
        borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
        child: Ink(
          decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS), border: Border.all(width: 1, color: Colors.blueAccent.shade100)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(values[0], textAlign: TextAlign.center),
              ),
              Divider(color: Colors.blueAccent, height: 1),
              Row(
                children: [
                  Flexible(
                      // flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(values[0]),
                            // Divider(color: Colors.grey),
                            for (int i = 1; i < values.length; i++)
                              Column(
                                children: [
                                  _CardExpense(title: names[i - 1], value: values[i]),
                                  if (i != values.length - 1) Divider(color: Colors.grey),
                                ],
                              ),
                          ],
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardExpense extends StatelessWidget {
  final String title, value;
  final _formKey = GlobalKey<FormState>();

   _CardExpense({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Text('$title:  '),

            // CustomTextField('expense_type', 'Expense Claim Type'.tr(),
            //     initialValue: data['expense_type'],
            //     onSave: (key, value) => data[key] = value,
            //     onPressed: () async {
            //       var res = await Navigator.of(context).push(
            //           MaterialPageRoute(
            //               builder: (_) => expenseClaimTypeScreen()));
            //       return res; //TODO Check @RUN
            //     }),
          ],
        ),
      ),
    );
  }
}
