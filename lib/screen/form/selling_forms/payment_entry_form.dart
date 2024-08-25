import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import '../../../widgets/dismiss_keyboard.dart';
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
  const PaymentForm({super.key});

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  Map<String, dynamic> data = {
    "doctype": "Payment Entry",
    'payment_type': paymentType[0],
    'party_type': KPaymentPartyList[0],
    "posting_date": DateTime.now().toIso8601String(),
    "source_exchange_rate": 1,
    "target_exchange_rate": 1,
  };
  String? bankType;
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

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }
    log(data.toString());

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(PAYMENT_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['payment_entry'] != null) {
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['payment_entry']);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['payment_entry'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['payment_entry']);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GenericPage()));
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
    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      data = context.read<ModuleProvider>().updateData;
    }
    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

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
              "outstanding_amount": data["outstanding_amount"],
              "allocated_amount": data["outstanding_amount"],
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
        data.remove('logs');
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
        bool? isGoBack =
            await checkDialog(context, 'Are you sure to go back?'.tr());
        if (isGoBack != null) {
          if (isGoBack) {
            return Future.value(true);
          } else {
            return Future.value(false);
          }
        }
        return Future.value(false);
      },
      child: DismissKeyboard(
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: CustomPageViewForm(
              submit: () => submit(),
              widgetGroup: [
                Group(
                  child: ListView(
                    children: [
                      const SizedBox(height: 4),
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
                                } else {
                                  data['party_type'] = null;
                                }
                              })),
                      CustomDropDown(
                        'party_type',
                        'Party Type'.tr(),
                        items: KPaymentPartyList,
                        defaultValue:
                            data['party_type'] ?? KPaymentPartyList[0],
                        enable: false,
                        onChanged: (value) => setState(() {
                          data['party'] = null;
                          data['party_name'] = null;
                          data['party_type'] = value;
                        }),
                      ),
                      // -----------------
                      if (data['party_type'] == KPaymentPartyList[0] &&
                          data['party_type'] != null)
                        CustomDropDownFromField(
                          defaultValue: data['party'],
                          docType: 'Customer',
                          nameResponse: 'name',
                          keys: const {
                            'subTitle': 'customer_group',
                            'trailing': 'territory',
                          },
                          title: data['party_type'] ?? 'Customer',
                          onChange: (value) {
                            setState(() {
                              data['party'] = value['name'];
                              data['party_name'] = value['customer_name'];
                            });
                          },
                        ),
                      if (data['party_type'] != KPaymentPartyList[0] &&
                          data['party_type'] != null)
                        CustomDropDownFromField(
                            defaultValue: data['party'],
                            docType: 'Supplier',
                            keys: const {
                              'subTitle': 'supplier_group',
                              'trailing': 'country',
                            },
                            nameResponse: 'name',
                            title: data['party_type'] ?? "Supplier",
                            onChange: (value) {
                              setState(() {
                                data['party'] = value['name'];
                                data['party_name'] = value['supplier_name'];
                              });
                            }),
                      if (data['party_name'] != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(data['party_name']!,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            )),
                      if (data['party_name'] != null)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0, left: 2, right: 2),
                          child: Divider(
                              color: Colors.grey, height: 1, thickness: 0.7),
                        ),
                      DatePickerTest('posting_date', 'Date'.tr(),
                          initialValue: data['posting_date'],
                          onChanged: (value) {
                        setState(() {
                          data['posting_date'] = value;
                        });
                      }),

                      /// New mode of payment
                      CustomDropDownFromField(
                          defaultValue: data['mode_of_payment'],
                          docType: 'Mode of Payment',
                          nameResponse: 'name',
                          title: data['payment_type'] == paymentType[2]
                              ? 'Payment From'
                              : 'Mode Of Payment',
                          onChange: (value) {
                            setState(() {
                              bankType = value['type'];
                              data['mode_of_payment'] = value['name'];
                            });
                          }),

                      if (bankType == 'Bank')
                        CustomTextFieldTest(
                          'reference_no',
                          'Reference Number'.tr(),
                          initialValue: data['reference_no'],
                          onChanged: (value) {
                            data['reference_no'] = value;
                          },
                          onSave: (key, value) => data[key] = value,
                          keyboardType: TextInputType.number,
                          disableError: false,
                          validator: (value) => numberValidationToast(
                              value, 'Reference Number'.tr()),
                          disableValidation: true,
                        ),
                      if (data['payment_type'] == paymentType[2])
                        CustomTextFieldTest(
                          'mode_of_payment_2',
                          'Payment To',
                          initialValue: data['mode_of_payment_2'],
                          clearButton: true,
                          onPressed: () async {
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => modeOfPaymentScreen(
                                        data['mode_of_payment'])));
                            if (res != null) {
                              data['mode_of_payment_2'] = res['name'];
                            }
                            return res['name'];
                          },
                        ),
                      CustomTextFieldTest(
                        'paid_amount',
                        'Paid Amount',
                        initialValue: '${data['paid_amount'] ?? ''}',
                        clearButton: true,
                        keyboardType: TextInputType.number,
                        validator: numberValidation,
                        onSave: (key, value) =>
                            data[key] = double.tryParse(value) ?? 0,
                        onChanged: (value) {
                          data['paid_amount'] = double.tryParse(value) ?? 0;
                          data['received_amount'] = double.tryParse(value) ?? 0;
                          if (data.containsKey('references')) {
                            data['references'] = [
                              {
                                "reference_doctype": data['references'][0]
                                    ["reference_doctype"],
                                "reference_name": data['references'][0]
                                    ["reference_name"],
                                "total_amount": data['references'][0]
                                    ["total_amount"],
                                "outstanding_amount": data['references'][0]
                                    ["outstanding_amount"],
                                "allocated_amount": data['paid_amount'],
                              }
                            ];
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
