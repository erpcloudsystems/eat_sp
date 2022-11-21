import 'package:next_app/service/service.dart';
import 'package:next_app/service/service_constants.dart';
import 'package:next_app/provider/module/module_provider.dart';
import 'package:next_app/screen/list/otherLists.dart';
import 'package:next_app/widgets/dialog/loading_dialog.dart';
import 'package:next_app/widgets/form_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../page/generic_page.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({Key? key}) : super(key: key);

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  Map<String, dynamic> data = {
    "doctype": "Payment Entry",
    'payment_type': paymentType[0],
    'party_type': KPaymentPartyList[0],
    "posting_date": DateTime.now().toIso8601String(),
    "reference_date": "posting_date",
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    showLoadingDialog(context, provider.isEditing ? 'Updating ${provider.pageId}' : 'Creating Your Payment');

    final server = APIService();

    //  for (var k in data.keys) print("$k: ${data[k]}");

    final res = await handleRequest(
            () async =>
        provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(PAYMENT_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing)
      Navigator.pop(context);
    else if (res != null && res['message']['payment_entry'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['payment_entry']);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
    }
  }

  @override
  void initState() {
    super.initState();

    if (context
        .read<ModuleProvider>()
        .isEditing) data = context
        .read<ModuleProvider>()
        .updateData;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? isGoBack = await checkDialog(context, 'Are you sure to go back?');
        if (isGoBack != null){
          if(isGoBack){
            return Future.value(true);
          }else{
            return Future.value(false);
          }
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: (context.read<ModuleProvider>().isEditing) ? Text("Edit Payment") : Text("Create Payment"),
          actions: [
            Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: IconButton(
                  onPressed: submit,
                  icon: Icon(
                    Icons.check,
                    color: FORM_SUBMIT_BTN_COLOR,
                  ),
                ))
          ],
        ),
        body: Form(
          key: _formKey,
          child: Group(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 4),
                CustomDropDown('payment_type', 'Payment Type'.tr(),
                    items: paymentType,
                    defaultValue: data['payment_type'] ?? paymentType[0],
                    onChanged: (value) =>
                        setState(() {
                          data['party'] = null;
                          data['party_name'] = null;
                          data['payment_type'] = value;
                          if (value == paymentType[0]) {
                            data['party_type'] = KPaymentPartyList[0];
                            data['mode_of_payment_2'] = null;
                          } else if (value == paymentType[1]) {
                            data['party_type'] = KPaymentPartyList[1];
                            data['mode_of_payment_2'] = null;
                          } else
                            data['party_type'] = null;
                        })),
                Divider(color: Colors.grey, height: 1, thickness: 0.7),
                if (data['party_type'] != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Text(
                          tr('Party') + ': ' + data['party_type'],
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                if (data['party_type'] != null) Divider(color: Colors.grey, height: 1, thickness: 0.7),
                if (data['party_type'] != null)
                  CustomTextField(
                    'party',
                    data['party_type'],
                    initialValue: data['party'],
                    onPressed: () async {
                      String? id;

                      if (data['party_type'] == KPaymentPartyList[0]) {
                        final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => selectCustomerScreen()));
                        if (res != null) {
                          id = res['name'];
                          setState(() {
                            data['party'] = res['name'];
                            data['party_name'] = res['customer_name'];
                          });
                        }
                      } else {
                        final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => supplierListScreen()));
                        if (res != null) {
                          id = res['name'];
                          setState(() {
                            data['party'] = res['name'];
                            data['party_name'] = res['supplier_name'];
                          });
                        }
                      }
                      return id;
                    },
                  ),
                if (data['party_name'] != null)
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(data['party_name']!, style: TextStyle(fontSize: 16, color: Colors.black)),
                      )),
                if (data['party_name'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 2, right: 2),
                    child: Divider(color: Colors.grey, height: 1, thickness: 0.7),
                  ),
                Flexible(
                    child: DatePicker('posting_date', 'Date'.tr(),
                        initialValue: data['posting_date'], onChanged: (value) => setState(() => data['posting_date'] = value))),
                CustomTextField(
                  'mode_of_payment',
                  data['payment_type'] == paymentType[2] ? 'Payment From' : 'Mode Of Payment',
                  initialValue: data['mode_of_payment'],
                  onPressed: () async {
                    final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => modeOfPaymentScreen(data['mode_of_payment_2'])));
                    if (res != null) data['mode_of_payment'] = res;
                    return res;
                  },
                ),
                if (data['payment_type'] == paymentType[2])
                  CustomTextField(
                    'mode_of_payment_2',
                    'Payment To',
                    initialValue: data['mode_of_payment_2'],
                    onPressed: () async {
                      final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => modeOfPaymentScreen(data['mode_of_payment'])));
                      if (res != null) data['mode_of_payment_2'] = res;
                      return res;
                    },
                  ),
                CustomTextField(
                  'paid_amount',
                  'Paid Amount',
                  initialValue: '${data['paid_amount'] ?? ''}',
                  keyboardType: TextInputType.number,
                  validator: numberValidation,
                  onSave: (key, value) => data[key] = double.tryParse(value) ?? 0,
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
