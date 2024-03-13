import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../test/custom_page_view_form.dart';
import '../../../test/test_text_field.dart';
import '../../page/generic_page.dart';
import '../../../core/constants.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/inherited_widgets/add_account_list.dart';
import '../../../models/list_models/accounts_list_models/account_table_model.dart';

class JournalEntryForm extends StatefulWidget {
  const JournalEntryForm({Key? key}) : super(key: key);

  @override
  _JournalEntryFormState createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  Map<String, dynamic> data = {
    "doctype": "Journal Entry",
    "posting_date": DateTime.now().toIso8601String(),
    "voucher_type": "Journal Entry",
    "cheque_date": DateTime.now().toIso8601String(),
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) {
      showSnackBar(KFillRequiredSnackBar, context);
      return;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeAmendingFunction(context, data);

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    final server = APIService();
    final provider = context.read<ModuleProvider>();

    data['accounts'] = [];
    InheritedAccountForm.of(context).account.forEach((element) {
      data['accounts'].add(element.toJson);
    });

    // data['accounts'][0].remove('bank_account');

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Adding new Journal Entry');

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(JOURNAL_ENTRY_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (res != null &&
        res['message']['ejournal_entry_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['ejournal_entry_data_name']);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GenericPage()));
    }
  }

  // Future<void> _getEmployeeData(String employee) async {
  //   selectedEmployeeData = Map<String, dynamic>.from(
  //       await APIService().getPage(EMPLOYEE_PAGE, employee))['message'];

  //   data['pending_amount'] = Map<String, dynamic>.from(
  //       await APIService().genericGet(GET_PENDING_AMOUNT, {
  //         "employee": selectedEmployeeData['name'],
  //         "posting_date": data['posting_date'].toString().split(".")[0],
  //       }))['message'];
  // }

  @override
  void initState() {
    final provider = context.read<ModuleProvider>();
    super.initState();

    if (context.read<ModuleProvider>().isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        for (var k in data.keys) {
          print("➡️ $k: ${data[k]}");
        }

        data['accounts'].forEach((element) => InheritedAccountForm.of(context)
            .account
            .add(AccountModel.fromJson(element)));

        if (provider.isAmendingMode) {
          data.remove('amended_to');
          data['docstatus'] = 0;
        }
        setState(() {});
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    log('${InheritedAccountForm.of(context).data}');
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
            InheritedAccountForm.of(context).data.clear();
            return Future.value(true);
          } else {
            return Future.value(false);
          }
        }
        return Future.value(false);
      },
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
                    CustomDropDown('voucher_type', 'Entry Type'.tr(),
                        items: journalEntryTypeStatus,
                        defaultValue:
                            data['voucher_type'] ?? journalEntryTypeStatus[0],
                        onChanged: (value) => setState(() {
                              data['voucher_type'] = value;
                            })),
                    Row(children: [
                      Flexible(
                          child: DatePickerTest(
                        'posting_date',
                        'Posting Date'.tr(),
                        initialValue: data['posting_date'],
                        onChanged: (value) =>
                            setState(() => data['posting_date'] = value),
                      )),
                      const SizedBox(width: 10),
                    ]),
                  ],
                ),
              ),
              Group(
                child: ListView(
                  children: [
                    CustomTextFieldTest(
                      'cheque_no',
                      'Reference Number'.tr(),
                      initialValue: data['cheque_no'],
                      onChanged: (value) => data['cheque_no'] = value,
                      onSave: (key, value) => data[key] = value,
                      keyboardType: TextInputType.number,
                      disableError: true,
                      validator: (value) =>
                          numberValidationToast(value, 'Reference Number'.tr()),
                      disableValidation: true,
                    ),
                    Row(children: [
                      Flexible(
                          child: DatePickerTest(
                        'cheque_date',
                        'Reference Date'.tr(),
                        initialValue: data['cheque_date'],
                        onChanged: (value) =>
                            setState(() => data['cheque_date'] = value),
                      )),
                    ]),
                    CustomTextFieldTest(
                      'user_remark',
                      'User Remark'.tr(),
                      initialValue: data['user_remark'],
                      onChanged: (value) => data['user_remark'] = value,
                      onSave: (key, value) => data[key] = value,
                      disableValidation: true,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 13),
                child: SelectedAccountsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
