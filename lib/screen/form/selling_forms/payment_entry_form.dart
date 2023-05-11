import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../list/otherLists.dart';
import '../../page/generic_page.dart';
import '../../../core/constants.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../new_version/core/resources/strings_manager.dart';

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
    "source_exchange_rate": 1,
    "target_exchange_rate": 1,
  };

  Map<String, dynamic> selectedCstData = {
    'name': 'noName',
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) {
      showSnackBar(KFillRequiredSnackBar, context);
      return;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeAmendingFunction(context, data);

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    data['docstatus'] = 0;

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Payment');

    final server = APIService();

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(PAYMENT_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['payment_entry'] != null)
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['payment_entry']);
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['payment_entry'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['payment_entry']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
    }
  }

  // Future<void> _getCustomerData(String customer) async {
  //   selectedCstData = Map<String, dynamic>.from(
  //       await APIService().getPage(CUSTOMER_PAGE, customer))['message'];
  // }

  @override
  void initState() {
    super.initState();
    final provider = context.read<ModuleProvider>();

    //Editing Mode & Amending Mode & Duplicate Mode
    if (provider.isEditing || provider.isAmendingMode || provider.duplicateMode)
      data = context.read<ModuleProvider>().updateData;
    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    if (provider.isAmendingMode) {
      data['source_exchange_rate'] = 1;
      data['target_exchange_rate'] = 1;

      data.remove('paid_from_account_balance');
      data.remove('paid_from_account_currency');
      data.remove('paid_to_account_balance');
      data.remove('mode_of_payment_2');
      data.remove('set_posting_time');
      data.remove('reference_no');
      data.remove('amended_to');
      data.remove('paid_from');
      data.remove('paid_to');
      data.remove('docstatus');
      data.remove('status');
    }
    setState(() {});

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;

        data['payment_type'] = paymentType[0];
        data['party_type'] = KPaymentPartyList[0];
        data['posting_date'] = DateTime.now().toIso8601String();
        data['reference_date'] = "posting_date";

        // from Sales Order
        if (data['doctype'] == 'Sales Order') {
          data['sales_order'] = data['name'];
          data['party_name'] = data['customer_name'];
          data['party'] = data['customer'];
          data['source_exchange_rate'] = data['conversion_rate'];
          data['target_exchange_rate'] = data['conversion_rate'];
          data['paid_amount'] = data['grand_total'];
          data['references'] = [
            {
              "reference_doctype": "Sales Order",
              "reference_name": data["sales_order"],
              "total_amount": data["grand_total"],
              "outstanding_amount": data["grand_total"],
              "allocated_amount": data["grand_total"],
            }
          ];
        }

        // from Sales Invoice
        if (data['doctype'] == 'Sales Invoice') {
          data['sales_invoice'] = data['name'];
          data['party_name'] = data['customer_name'];
          data['party'] = data['customer'];
          data['source_exchange_rate'] = data['conversion_rate'];
          data['target_exchange_rate'] = data['conversion_rate'];
          data['paid_amount'] = data['grand_total'];
          data['references'] = [
            {
              "reference_doctype": "Sales Invoice",
              "reference_name": data["sales_invoice"],
              "total_amount": data["grand_total"],
              "outstanding_amount": data["grand_total"],
              "allocated_amount": data["grand_total"],
            }
          ];
        }

        // from Purchase Invoice
        if (data['doctype'] == 'Purchase Invoice') {
          data['purchase_invoice'] = data['name'];
          data['party_name'] = data['supplier_name'];
          data['party'] = data['supplier'];
          data['source_exchange_rate'] = data['conversion_rate'];
          data['target_exchange_rate'] = data['conversion_rate'];
          data['paid_amount'] = data['grand_total'];
          data['references'] = [
            {
              "reference_doctype": "Purchase Invoice",
              "reference_name": data["purchase_invoice"],
              "total_amount": data["grand_total"],
              "outstanding_amount": data["grand_total"],
              "allocated_amount": data["grand_total"],
            }
          ];
          data['payment_type'] = paymentType[1];
          data['party_type'] = KPaymentPartyList[1];
        }
        // from Purchase Order
        if (data['doctype'] == 'Purchase Order') {
          data['purchase_order'] = data['name'];
          data['party_name'] = data['supplier_name'];
          data['party'] = data['supplier'];
          data['source_exchange_rate'] = data['conversion_rate'];
          data['target_exchange_rate'] = data['conversion_rate'];
          data['paid_amount'] = data['grand_total'];
          data['references'] = [
            {
              "reference_doctype": "Purchase Order",
              "reference_name": data["purchase_order"],
              "total_amount": data["grand_total"],
              "outstanding_amount": data["grand_total"],
              "allocated_amount": data["grand_total"],
            }
          ];
          data['payment_type'] = paymentType[1];
          data['party_type'] = KPaymentPartyList[1];
        }
        // From Customer Visit
        if (data['doctype'] == DocTypesName.customerVisit) {
          data['customer_visit'] = data['name'];
          data['party_name'] = data['customer'];
          data['party'] = data['customer'];
          data['source_exchange_rate'] = data['conversion_rate'];
          data['target_exchange_rate'] = data['conversion_rate'];
          data['references'] = [
            {
              "reference_doctype": DocTypesName.customerVisit,
              "reference_name": data["customer_visit"],
            }
          ];
        }

        data['doctype'] = "Payment Entry";

        data.remove('print_formats');
        data.remove('conn');
        data.remove('comments');
        data.remove('attachments');
        data.remove('docstatus');
        data.remove('name');
        data.remove('_pageData');
        data.remove('_pageId');
        data.remove('_availablePdfFormat');
        data.remove('_currentModule');
        data.remove('status');
        data.remove('taxes'); //from sales order

        setState(() {});
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    context.read<ModuleProvider>().resetCreationForm();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? isGoBack = await checkDialog(context, 'Are you sure to go back?');
        if (isGoBack != null) {
          if (isGoBack) {
            return Future.value(true);
          } else {
            return Future.value(false);
          }
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: (context.read<ModuleProvider>().isEditing)
              ? Text("Edit Payment")
              : Text("Create Payment"),
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
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Group(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 4),
                  CustomDropDown('payment_type', 'Payment Type'.tr(),
                      items: paymentType,
                      defaultValue: data['payment_type'] ?? paymentType[0],
                      onChanged: (value) => setState(() {
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
                  CustomDropDown(
                    'party_type',
                    'Party Type'.tr(),
                    items: KPaymentPartyList,
                    defaultValue: data['party_type'] ?? KPaymentPartyList[0],
                    enable: false,
                    onChanged: (value) => setState(() {
                      data['party'] = null;
                      data['party_name'] = null;
                      data['party_type'] = value;
                    }),
                  ),

                  // Divider(color: Colors.grey, height: 1, thickness: 0.7),
                  // if (data['party_type'] != null)
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                  //     child: Row(
                  //       children: [
                  //         Text(
                  //           tr('Party') + ': ' + data['party_type'],
                  //           textAlign: TextAlign.start,
                  //           style: TextStyle(
                  //               fontSize: 16, color: Colors.grey.shade700),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // if (data['party_type'] != null)
                  //   Divider(color: Colors.grey, height: 1, thickness: 0.7),
                  if (data['party_type'] != null)
                    CustomTextField(
                      'party',
                      data['party_type'],
                      initialValue: data['party'],
                      onPressed: () async {
                        String? id;

                        if (data['party_type'] == KPaymentPartyList[0]) {
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      selectCustomerScreen()));
                          if (res != null) {
                            id = res['name'];
                            setState(() {
                              data['party'] = res['name'];
                              data['party_name'] = res['customer_name'];
                            });
                          }
                        } else {
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => supplierListScreen()));
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
                          child: Text(data['party_name']!,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                        )),
                  if (data['party_name'] != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, left: 2, right: 2),
                      child: Divider(
                          color: Colors.grey, height: 1, thickness: 0.7),
                    ),
                  Flexible(
                      child: DatePicker('posting_date', 'Date'.tr(),
                          initialValue: data['posting_date'],
                          onChanged: (value) =>
                              setState(() => data['posting_date'] = value))),
                  CustomTextField(
                    'mode_of_payment',
                    data['payment_type'] == paymentType[2]
                        ? 'Payment From'
                        : 'Mode Of Payment',
                    initialValue: data['mode_of_payment'],
                    clearButton: true,
                    onPressed: () async {
                      final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => modeOfPaymentScreen(
                                  data['mode_of_payment_2'])));
                      if (res != null) data['mode_of_payment'] = res;
                      return res;
                    },
                  ),
                  if (data['payment_type'] == paymentType[2])
                    CustomTextField(
                      'mode_of_payment_2',
                      'Payment To',
                      initialValue: data['mode_of_payment_2'],
                      clearButton: true,
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => modeOfPaymentScreen(
                                    data['mode_of_payment'])));
                        if (res != null) data['mode_of_payment_2'] = res;
                        return res;
                      },
                    ),
                  CustomTextField(
                    'paid_amount',
                    'Paid Amount',
                    initialValue: '${data['paid_amount'] ?? ''}',
                    clearButton: true,
                    keyboardType: TextInputType.number,
                    validator: numberValidation,
                    onSave: (key, value) =>
                        data[key] = double.tryParse(value) ?? 0,
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
