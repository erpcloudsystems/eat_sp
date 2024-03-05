import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../list/otherLists.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../provider/user/user_provider.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';

class LeadForm extends StatefulWidget {
  const LeadForm({Key? key}) : super(key: key);

  @override
  _LeadFormState createState() => _LeadFormState();
}

class _LeadFormState extends State<LeadForm> {
  Map<String, dynamic> data = {
    "doctype": "Lead",
    "status": "Lead",
    "organization_lead": 0
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) return;

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    showLoadingDialog(context,
        provider.isEditing ? 'Updating ${provider.pageId}' : 'Adding new lead');

    final server = APIService();

    for (var k in data.keys) {
      log("$k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(LEAD_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing) {
      Navigator.pop(context);
    } else if (res != null && res['message']['lead'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['lead']);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GenericPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    final provider = context.read<ModuleProvider>();
    if (!provider.isEditing) {
      data['country'] = context.read<UserProvider>().companyDefaults['country'];
      setState(() {});
    }

    if (provider.isEditing || provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        debugPrint(data.toString());
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
                      'lead_name',
                      tr('Person Name'),
                      initialValue: data['lead_name'],
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) {
                        setState(() {
                          data['lead_name'] = value;
                        });
                      },
                    ),
                    CustomTextFieldTest(
                      'company_name',
                      tr('Company Name'),
                      initialValue: data['company_name'],
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) {
                        setState(() {
                          data['company_name'] = value;
                        });
                      },
                      enabled: true,
                      disableValidation: true,
                    ),
                    CustomTextFieldTest(
                      'industry',
                      tr('Industry'),
                      onSave: (key, value) => data[key] = value,
                      initialValue: data['industry'],
                      disableValidation: true,
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => industryScreen(),
                          ),
                        );
                        data['industry'] = res;
                        return res;
                      },
                    ),
                    CustomTextFieldTest(
                      'market_segment',
                      tr('Market Segment'),
                      initialValue: data['market_segment'],
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) => setState(() {
                        data['market_segment'] = value;
                      }),
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => marketSegmentScreen(),
                          ),
                        );
                        data['market_segment'] = res;
                        return res;
                      },
                    ),
                    CustomTextFieldTest(
                      'territory',
                      tr('Territory'),
                      initialValue: data['territory'],
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) => setState(() {
                        data['territory'] = value;
                      }),
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => territoryScreen(),
                          ),
                        );
                        data['territory'] = res;
                        return res;
                      },
                    ),
                    CustomTextFieldTest(
                      'city',
                      'City',
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) => setState(() {
                        data['city'] = value;
                      }),
                      initialValue: data['city'],
                      disableValidation: true,
                    ),
                    CustomTextFieldTest(
                      'country',
                      tr('Country'),
                      onSave: (key, value) => data[key] = value,
                      initialValue: data['country'],
                      disableValidation: true,
                      onChanged: (value) => setState(() {
                        data['country'] = value;
                      }),
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => countryScreen(),
                          ),
                        );
                        data['country'] = res;
                        return res;
                      },
                    ),
                    CustomTextFieldTest('mobile_no', tr('Mobile No'),
                        initialValue: data['mobile_no'],
                        disableValidation: true,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) => setState(() {
                              data['mobile_no'] = value;
                            }),
                        validator: validateMobile,
                        onSave: (key, value) => data[key] = value),
                    CustomTextFieldTest('email_id', tr('Email Address'),
                        initialValue: data['email_id'],
                        disableValidation: true,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => setState(() {
                              data['email_id'] = value;
                            }),
                        validator: mailValidation,
                        onSave: (key, value) => data[key] = value),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              ///
              /// group 2
              ///
              Group(
                child: Column(
                  children: [
                    CustomDropDown(
                      'status',
                      'Status'.tr(),
                      items: LeadStatusList,
                      defaultValue: data["status"] ?? LeadStatusList[0],
                      onChanged: (value) => setState(() {
                        data['status'] = value;
                      }),
                    ),
                    CustomTextFieldTest('source', 'Source'.tr(),
                        onSave: (key, value) => data[key] = value,
                        initialValue: data['source'],
                        disableValidation: true,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => sourceScreen()))),
                    CustomTextFieldTest('campaign_name', 'Campaign Name'.tr(),
                        initialValue: data['campaign_name'],
                        disableValidation: true,
                        onSave: (key, value) => data[key] = value,
                        onChanged: (value) => data['campaign_name'] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => campaignScreen()))),
                    CustomDropDown('request_type', 'Request Type'.tr(),
                        items: requestTypeList,
                        defaultValue: requestTypeList[0],
                        onChanged: (value) => data['request_type'] = value),
                    const Divider(
                        color: Colors.grey, height: 1, thickness: 0.7),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
