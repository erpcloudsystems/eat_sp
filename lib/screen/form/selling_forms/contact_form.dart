import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import '../../../test/custom_page_view_form.dart';
import '../../../test/test_text_field.dart';
import '../../list/otherLists.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/dismiss_keyboard.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/inherited_widgets/contact/add_phone.dart';
import '../../../widgets/inherited_widgets/contact/email_table_model.dart';
import '../../../widgets/inherited_widgets/contact/phone_table_model.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  Map<String, dynamic> data = {
    "doctype": "Contact",
    "posting_date": DateTime.now().toIso8601String(),
    "is_primary_contact": 0,
    "links": [
      {
        //"link_doctype": 'Customer',
        "link_name": '',
      }
    ],
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (data['links']?[0]['link_doctype'] == null) {
      showSnackBar('Link Document Type is Mandatory', context);
      return;
    }
    if (data['links']?[0]['link_name'] == null) {
      showSnackBar('Link Name is Mandatory', context);
      return;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);
    _formKey.currentState!.save();

    final server = APIService();
    final provider = context.read<ModuleProvider>();

    // print('111dsjk${InheritedContactForm.of(context).emails}');
    data['email_ids'] = [];
    data['phone_nos'] = [];
    InheritedContactForm.of(context).phones.forEach((element) {
      data['phone_nos'].add(element.toJson);
    });
    InheritedContactForm.of(context).emails.forEach((element) {
      data['email_ids'].add(element.toJson);
    });

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Adding new Contact');

    for (var k in data.keys) {
      print("➡️ \"$k\": \"${data[k]}\"");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(CONTACT_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (res != null && res['message']['contact_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['contact_data_name']);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GenericPage()));
    }
  }

  @override
  void initState() {
    super.initState();

    final provider = context.read<ModuleProvider>();

    if (provider.isEditing || provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        for (var k in data.keys) {
          print("➡️ $k: ${data[k]}");
        }

        // data['links'] = data['reference'].asMap();

        data['email_ids'].forEach((element) => InheritedContactForm.of(context)
            .emails
            .add(EmailModel.fromJson(element)));
        data['phone_nos'].forEach((element) => InheritedContactForm.of(context)
            .phones
            .add(PhoneModel.fromJson(element)));

        setState(() {});
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    InheritedContactForm.of(context).emails.clear();
    InheritedContactForm.of(context).phones.clear();
    context.read<ModuleProvider>().resetCreationForm();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? isGoBack = await checkDialog(context, 'Are you sure to go back?');
        if (isGoBack != null) {
          if (isGoBack) {
            InheritedContactForm.of(context).data.clear();
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
                      CustomTextFieldTest(
                        'first_name',
                        'First Name'.tr(),
                        initialValue: data['first_name'],
                        onChanged: (value) => data['first_name'] = value,
                        onSave: (key, value) => data[key] = value,
                        clearButton: true,
                        onClear: () {
                          setState(() {
                            data['first_name'] = '';
                          });
                        },
                      ),
                      // New user list
                      CustomDropDownFromField(
                          defaultValue: data['user'],
                          docType: 'User',
                          nameResponse: 'name',
                          keys: const {
                            'subTitle': 'full_name',
                            'trailing': '',
                          },
                          title: 'User Id'.tr(),
                          onChange: (value) {
                            setState(() {
                              data['user'] = value['name'];
                            });
                          }),
                      // CustomTextFieldTest(
                      //   'user',
                      //   'User Id'.tr(),
                      //   initialValue: data['user'],
                      //   onChanged: (value) => data['user'] = value,
                      //   onSave: (key, value) => data[key] = value,
                      //   disableValidation: true,
                      //   clearButton: true,
                      //   onClear: () {
                      //     setState(() {
                      //       data['user'] = '';
                      //     });
                      //   },
                      // ),
                    ],
                  ),
                ),
                const SelectedPhonesList(),
                Group(
                  child: ListView(
                    children: [
                      CustomDropDown('link_doctype', 'Link Document Type'.tr(),
                          items: linkDocumentTypeList,
                          defaultValue: data['links']?[0]['link_doctype'],
                          onChanged: (value) => setState(() {
                                data['links']?[0]['link_name'] = '';
                                data['links']?[0]['link_doctype'] = value;
                              })),
                      Divider(
                          color: Colors.grey.shade300,
                          height: 1,
                          thickness: 0.9),
                      if (data['links']?[0]['link_doctype'] ==
                          linkDocumentTypeList[0])
                        CustomTextFieldTest(
                          'link_name',
                          'Link Name'.tr(),
                          initialValue: data['links']?[0]['link_name'],
                          onPressed: () async {
                            String? id;

                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        selectCustomerScreen()));
                            if (res != null) {
                              id = res['name'];
                              setState(() {
                                data['links']?[0]['link_name'] = res['name'];
                              });
                            }

                            return id;
                          },
                        ),
                      if (data['links']?[0]['link_doctype'] ==
                          linkDocumentTypeList[1])
                        CustomTextFieldTest(
                          'link_name',
                          'Link Name',
                          initialValue: data['links']?[0]['link_name'],
                          onPressed: () async {
                            String? id;
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        selectSupplierScreen()));
                            if (res != null) {
                              id = res['name'];

                              setState(() {
                                data['links']?[0]['link_name'] = res['name'];
                              });
                            }
                            return id;
                          },
                        ),
                      CheckBoxWidget(
                        'is_primary_address',
                        'Is Primary',
                        initialValue:
                            data['is_primary_address'] == 1 ? true : false,
                        onChanged: (id, value) => setState(
                          () => data[id] = value ? 1 : 0,
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
    );
  }
}
