import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/resources/routes.dart';
import '../../../../../../../../widgets/form_widgets.dart';
import '../../../../../../../core/resources/app_values.dart';
import '../../../../../../../../screen/list/otherLists.dart';
import '../../../../../../../core/resources/app_radius.dart';
import '../../../data/models/accounts_receivable_filters.dart';
import '../../../../../../../core/resources/strings_manager.dart';

class AccountsReceivableFilterScreen extends StatefulWidget {
  const AccountsReceivableFilterScreen({Key? key}) : super(key: key);

  @override
  State<AccountsReceivableFilterScreen> createState() =>
      _AccountsReceivableFilterScreenState();
}

class _AccountsReceivableFilterScreenState
    extends State<AccountsReceivableFilterScreen> {
  final formKey = GlobalKey<FormState>();
  String? salesPerson, customerName, toDate;
  double? customerCode;
  @override
  Widget build(BuildContext context) {
    final reportType = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$reportType Filters',
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              //___________________________Sales Person____________________________
              Flexible(
                  child: CustomTextField(
                      'sales_person_name', StringsManager.salesPerson.tr(),
                      clearButton: true,
                      disableValidation: true,
                      initialValue: salesPerson,
                      onSave: (key, value) => salesPerson = value,
                      onChanged: (value) => salesPerson = value,
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => salesPersonScreen()),
                        );
                        salesPerson = res['name'];
                        return res['name'];
                      })),
              //___________________________ Customer Name _________________________________
              const SizedBox(height: DoublesManager.d_10),
              Flexible(
                  child: CustomTextField(
                      'customer_name',StringsManager.customer.tr(),
                      clearButton: true,
                      disableValidation: true,
                      onSave: (key, value) => customerName = value,
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => selectCustomerScreen(),
                          ),
                        );
                        customerName = res['customer_name'];
                        return res['customer_name'];
                      })),
              //___________________________ Customer Code _________________________________
              const SizedBox(height: DoublesManager.d_10),
              Flexible(
                  child: NumberTextField(
                'customer_code',
                StringsManager.customerCode.tr(),
                disableError: true,
                clearValue: true,
                onSave: (key, value) => customerCode = double.tryParse(value),
                onChanged: (value) => customerCode = double.tryParse(value),
                validator: (value) =>
                    numberValidation(value, allowNull: true, isInt: true),
                keyboardType: TextInputType.number,
              )),
              //___________________________From date and to date ____________________________

              Flexible(
                child: DatePicker('to_date', StringsManager.toDate.tr(),
                    clear: true,
                    disableValidation: true,
                    onChanged: (value) => toDate = value),
              ),
              const SizedBox(height: DoublesManager.d_10),
              //______________________________ Button ______________________________________
              InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    final filters = AccountReceivableFilters(
                      salesPersonName: salesPerson,
                      customerCode: customerCode,
                      customerName: customerName,
                      toDate: toDate,
                    );
                    Navigator.of(context).pushNamed(
                      Routes.accountReceivableReportScreen,
                      arguments: filters,
                    );
                  }
                },
                child: Container(
                  width: 150.w,
                  decoration: BoxDecoration(
                      color: Colors.blue, borderRadius: AppRadius.radius10),
                  child: Center(
                    child: Text(
                      StringsManager.applyFilters.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
