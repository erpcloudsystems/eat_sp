import 'dart:async';
import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import '../../../core/constants.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import '../../../service/gps_services.dart';
import '../../../widgets/dismiss_keyboard.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/page_models/model_functions.dart';

class CustomerVisitForm extends StatefulWidget {
  const CustomerVisitForm({Key? key}) : super(key: key);

  @override
  State<CustomerVisitForm> createState() => _CustomerVisitFormState();
}

class _CustomerVisitFormState extends State<CustomerVisitForm> {
  Map<String, dynamic> data = {
    "doctype": "Customer Visit",
    "posting_date": DateTime.now().toIso8601String(),
    "time": DateTime.now().toIso8601String(),
    "latitude": 0.0,
    "longitude": 0.0,
  };
  LatLng location = const LatLng(0.0, 0.0);
  GPSService gpsService = GPSService();

  Map<String, dynamic> selectedCstData = {
    'name': 'noName',
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (location == const LatLng(0.0, 0.0)) {
      showSnackBar(KEnableGpsSnackBar, context);
      Future.delayed(const Duration(seconds: 1), () async {
        location = await gpsService.getCurrentLocation(context);
      });
      return;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeAmendingFunction(context, data);

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    final server = APIService();
    final provider = context.read<ModuleProvider>();

    data['docstatus'] = 0;
    data['latitude'] = location.latitude;
    data['longitude'] = location.longitude;
    data['location'] = gpsService.placeman[0].street;
    if (data['time'].toString().contains('T')) {
      data['time'] = data['time'].toString().split('T')[1].split('.')[0];
    }

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Adding new Customer Visit');

    for (var k in data.keys) {
      log("➡️ $k: ${data[k]}");
    }

    await handleRequest(
            () async => provider.isEditing
                ? await provider.updatePage(data)
                : await server.postRequest(CUSTOMER_VISIT_POST, {'data': data}),
            context)
        .then((res) {
      Navigator.pop(context);

      if (provider.isEditing && res == false) {
        return;
      } else if (provider.isEditing && res == null) {
        Navigator.pop(context);
      } else if (res != null &&
          res['message']['customer_visit_data_name'] != null) {
        context
            .read<ModuleProvider>()
            .pushPage(res['message']['customer_visit_data_name']);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const GenericPage()));
      }
    });
  }

  Future<void> _getCustomerData(String customer) async {
    selectedCstData = Map<String, dynamic>.from(
        await APIService().getPage(CUSTOMER_PAGE, customer))['message'];
    for (var k in selectedCstData.keys) {
      log("➡️ $k: ${selectedCstData[k]}");
    }
  }

  @override
  void initState() {
    final provider = context.read<ModuleProvider>();
    super.initState();

    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = provider.updateData;
        for (var k in data.keys) {
          log("➡️ $k: ${data[k]}");
        }
        data['latitude'] = 0.0;
        data['longitude'] = 0.0;
        data['time'] =
            "${DateTime.now().toIso8601String().split("T")[0]}T" + data['time'];
        _getCustomerData(data['customer']).then((value) => setState(() {
              selectedCstData['address_line1'] =
                  formatDescription(data['address_line1']);
              selectedCstData['city'] = data['city'];
              selectedCstData['country'] = data['country'];
            }));
        setState(() {});
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () async {
      location = await gpsService.getCurrentLocation(context);
    });
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
                      // New customer list
                      CustomDropDownFromField(
                          defaultValue: data['customer'],
                          docType: 'Customer',
                          nameResponse: 'name',
                          title: 'Customer'.tr(),
                          keys: const {
                            'subTitle': 'customer_group',
                            'trailing': 'territory',
                          },
                          onChange: (value) async {
                            if (value != null) {
                              await _getCustomerData(value['name']);

                              setState(() {
                                data['customer'] = value['name'];
                                data['customer_name'] = value['customer_name'];
                                data['customer_address'] =
                                    value["customer_primary_address"];
                                data['contact_person'] =
                                    value["customer_primary_contact"];
                              });
                            }
                          }),
// New customer address
                      CustomExpandableTile(
                        hideArrow: data['customer'] == null,
                        title: CustomDropDownFromField(
                            defaultValue: data['customer_address'],
                            docType: APIService.FILTERED_ADDRESS,
                            nameResponse: 'name',
                            title: 'Customer Address'.tr(),
                            filters: {
                              'cur_nam': data['customer'],
                            },
                            onChange: (value) async {
                              if (data['customer'] == null) {
                                return showSnackBar(
                                    'Please select a customer to first',
                                    context);
                              }

                              setState(() {
                                data['customer_address'] = value['name'];
                                selectedCstData['address_line1'] =
                                    value['address_line1'];
                                selectedCstData['city'] = value['city'];
                                selectedCstData['country'] = value['country'];
                              });
                            }),
                        children: (data['customer_address'] != null)
                            ? <Widget>[
                                ListTile(
                                  trailing: const Icon(Icons.location_on),
                                  title: Text(
                                      selectedCstData['address_line1'] ?? ''),
                                ),
                                ListTile(
                                  trailing: const Icon(Icons.location_city),
                                  title: Text(selectedCstData['city'] ?? ''),
                                ),
                                ListTile(
                                  trailing: const Icon(Icons.flag),
                                  title: Text(selectedCstData['country'] ?? ''),
                                )
                              ]
                            : null,
                      ),

                      Row(children: [
                        Flexible(
                            child: DatePickerTest(
                          'posting_date',
                          'Posting Date'.tr(),
                          enable: false,
                          initialValue: data['posting_date'],
                          onChanged: (value) =>
                              setState(() => data['posting_date'] = value),
                        )),
                        const SizedBox(width: 10),
                        Flexible(
                            child: TimePickerTest(
                          'time',
                          'Time'.tr(),
                          enable: false,
                          initialValue: data['time'],
                          onChanged: (value) {
                            //value on that shap: (10:01:00)
                            setState(() {
                              data['time'] = value;
                            });
                          },
                        ))
                      ]),
                      CustomTextFieldTest(
                        'description',
                        'Description'.tr(),
                        onChanged: (value) => data['description'] = value,
                        onSave: (key, value) => data[key] = value,
                        initialValue: data['description'],
                        disableValidation: true,
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(Icons.warning_amber,
                                color: Colors.amber, size: 22),
                          ),
                          Flexible(
                              child: Text(
                            KLocationNotifySnackBar,
                            textAlign: TextAlign.start,
                          )),
                        ],
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
