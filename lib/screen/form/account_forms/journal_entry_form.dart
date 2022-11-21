import 'package:next_app/models/page_models/model_functions.dart';
import 'package:next_app/service/service.dart';
import 'package:next_app/service/service_constants.dart';
import 'package:next_app/provider/module/module_provider.dart';
import 'package:next_app/widgets/dialog/loading_dialog.dart';
import 'package:next_app/widgets/form_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../models/list_models/accounts_list_models/account_table_model.dart';
import '../../../widgets/inherited_widgets/add_account_list.dart';
import '../../../widgets/inherited_widgets/add_expenses_list.dart';
import '../../list/otherLists.dart';
import '../../page/generic_page.dart';

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

  // Map<String, dynamic> selectedEmployeeData = {
  //   'name': 'noName',
  // };
  //
  final _formKey = GlobalKey<FormState>();

  // any widgets below this condition will not be shown
  //bool removeWhenUpdate = true;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final server = APIService();
    final provider = context.read<ModuleProvider>();


    data['accounts']=[];
    InheritedAccountForm.of(context).account.forEach((element) {
      data['accounts'].add(element.toJson);
    });

    data['accounts'][0].remove('bank_account');



    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Adding new Journal Entry');

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(JOURNAL_ENTRY_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (res != null &&
        res['message']['ejournal_entry_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['ejournal_entry_data_name']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
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
    super.initState();

    if (context.read<ModuleProvider>().isEditing)
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        for (var k in data.keys) print("➡️ $k: ${data[k]}");


        data['accounts'].forEach((element) => InheritedAccountForm.of(context)
            .account
            .add(AccountModel.fromJson(element)));


        setState(() {});
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('7788888787 ${InheritedAccountForm.of(context).data}');

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
        appBar: AppBar(
          title: (context.read<ModuleProvider>().isEditing)
              ? Text("Edit Journal Entry".tr())
              : Text("Create Journal Entry ".tr()),
          actions: [
            Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: IconButton(
                  onPressed: submit,
                  icon: Icon(Icons.check, color: FORM_SUBMIT_BTN_COLOR),
                ))
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Group(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 4),
                      CustomDropDown('voucher_type', 'Entry Type'.tr(),
                          items: journalEntryTypeStatus,
                          defaultValue:
                              data['voucher_type'] ?? journalEntryTypeStatus[0],
                          onChanged: (value) => setState(() {
                                data['voucher_type'] = value;
                              })),
                      Row(children: [
                        Flexible(
                            child: DatePicker(
                          'posting_date',
                          'Posting Date'.tr(),
                          initialValue: data['posting_date'],
                          onChanged: (value) =>
                              setState(() => data['posting_date'] = value),
                        )),
                        SizedBox(width: 10),
                      ]),
                    ],
                  ),
                ),
                Group(child: Column(children: [
                  CustomTextField(
                    'cheque_no',
                    'Reference Number'.tr(),
                    initialValue: data['cheque_no'],
                    onChanged: (value)  =>
                    data['cheque_no'] = value,
                    onSave: (key, value) => data[key] = value,
                    keyboardType: TextInputType.number,
                    disableError: true,
                    validator: (value) =>
                        numberValidationToast(value, 'Reference Number'.tr()),
                    disableValidation: true,
                  ),
                  Row(children: [
                    Flexible(
                        child: DatePicker(
                          'cheque_date',
                          'Reference Date'.tr(),
                          initialValue: data['cheque_date'],
                          onChanged: (value) =>
                              setState(() => data['cheque_date'] = value),
                        )),
                  ]),
                  CustomTextField(
                    'user_remark',
                    'User Remark'.tr(),
                    initialValue: data['user_remark'],
                    onChanged: (value)  =>
                    data['user_remark'] = value,
                    onSave: (key, value) => data[key] = value,
                    disableValidation: true,

                  ),
                ],),),

                SelectedAccountsList(),
                SizedBox(height:8),

              ],
            ),
          ),
        ),
      ),
    );
  }
}


