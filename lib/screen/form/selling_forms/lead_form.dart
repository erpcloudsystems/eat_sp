import 'package:next_app/service/service.dart';
import 'package:next_app/service/service_constants.dart';
import 'package:next_app/provider/module/module_provider.dart';
import 'package:next_app/widgets/dialog/loading_dialog.dart';
import 'package:next_app/widgets/form_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../provider/user/user_provider.dart';
import '../../list/otherLists.dart';
import '../../page/generic_page.dart';

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

    _formKey.currentState!.save();

    showLoadingDialog(context,
        provider.isEditing ? 'Updating ${provider.pageId}' : 'Adding new lead');

    final server = APIService();

    for (var k in data.keys) print("$k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(LEAD_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing)
      Navigator.pop(context);
    else if (res != null && res['message']['lead'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['lead']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
    }
  }

  @override
  void initState() {
    super.initState();

    if(!context.read<ModuleProvider>().isEditing){
      data['country'] = context.read<UserProvider>().companyDefaults['country'];
      setState(() {
      });
    }

    if (context.read<ModuleProvider>().isEditing)
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        debugPrint(data.toString());
        setState(() {

        });
      });
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
          title: (context.read<ModuleProvider>().isEditing) ? Text("Edit Lead") : Text("Create Lead"),
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
                      CustomTextField(
                        'lead_name',
                        tr('Person Name'),
                        initialValue: data['lead_name'],
                        onSave: (key, value) => data[key] = value,
                      ),
                      // CheckBoxWidget(
                      //     'organization_lead', tr('Lead Is A Company'),
                      //     initialValue: (int.parse(
                      //             '${data['organization_lead'] ?? '0'}') ==
                      //         1),
                      //     onChanged: (key, value) =>
                      //         setState(() => data[key] = value ? 1 : 0)),
                      CustomTextField(
                        'company_name',
                        tr('Company Name'),
                        initialValue: data['company_name'],
                        onSave: (key, value) => data[key] = value,
                        enabled: true,
                        disableValidation: true,
                      ),
                      CustomTextField('industry', tr('Industry'),
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['industry'],
                          disableValidation: true,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => industryScreen()))),
                      CustomTextField('market_segment', tr('Market Segment'),
                          initialValue: data['market_segment'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => marketSegmentScreen()))),
                      CustomTextField('territory', tr('Territory'),
                          initialValue: data['territory'],
                          disableValidation: true,

                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => territoryScreen()))),
                      CustomTextField(
                        'address_title',
                        tr('Address Title'),
                        onSave: (key, value) => data[key] = value,
                        initialValue: data['address_title'],
                        disableValidation: true,

                        onChanged: (value) => data['address_title'] = value,
                      ),
                      CustomTextField(
                        'address_line1',
                        tr('Address'),
                        onSave: (key, value) => data[key] = value,
                        initialValue: data['address_line1'],
                        disableValidation: true,

                      ),
                      CustomTextField(
                        'city',
                        'City',
                        onSave: (key, value) => data[key] = value,
                        initialValue: data['city'],
                        disableValidation: true,

                      ),
                      CustomTextField('country', tr('Country'),
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['country'],
                          disableValidation: true,

                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => countryScreen()))),
                      CustomTextField('mobile_no', tr('Mobile No'),
                          initialValue: data['mobile_no'],
                          disableValidation: true,

                          keyboardType: TextInputType.phone,
                          validator: validateMobile,
                          onSave: (key, value) => data[key] = value),
                      CustomTextField('email_id', tr('Email Address'),
                          initialValue: data['email_id'],
                          disableValidation: true,

                          keyboardType: TextInputType.emailAddress,
                          validator: mailValidation,
                          onSave: (key, value) => data[key] = value),
                      SizedBox(height: 8),
                    ],
                  ),
                ),

                ///
                /// group 2
                ///
                Group(
                  child: Column(
                    children: [
                      CustomDropDown('status', 'Status'.tr(), items: LeadStatusList,
                          defaultValue: data["status"] ?? LeadStatusList[0],
                        onChanged: (value) =>
                            setState(() {
                              data['status'] = value;
                            }),
                      ),
                      CustomTextField('source', 'Source'.tr(),
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['source'],

                          disableValidation: true,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => sourceScreen()))),
                      CustomTextField('campaign_name', 'Campaign Name'.tr(),
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
                      Divider(color: Colors.grey, height: 1, thickness: 0.7),
                      // Deleted By Ziad testing ↓↓↓↓↓↓↓↓↓↓
                      // CustomTextField('contact_by', 'Next Contact By'.tr(),
                      //     initialValue: data['contact_by'],
                      //     disableValidation: true,
                      //     onSave: (key, value) => data[key] = value,
                      //     onPressed: () => Navigator.of(context).push(
                      //         MaterialPageRoute(
                      //             builder: (_) => userListScreen()))),
                      // DatePicker('contact_date', tr('Next Contact Date'),
                      //     initialValue: data['contact_date'],
                      //     disableValidation: true,
                      //     onChanged: (value) =>
                      //         setState(() => data['contact_date'] = value)),
                      // ConstrainedBox(
                      //     constraints: BoxConstraints(maxHeight: 250),
                      //     child: CustomTextField('notes', 'Notes'.tr(),
                      //         disableValidation: true,
                      //         maxLines: null,
                      //         initialValue: data['notes'],
                      //         onChanged: (value) => data['notes'] = value)),
                      // Deleted By Ziad testing ↑↑↑↑↑↑↑↑↑↑↑↑↑
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
