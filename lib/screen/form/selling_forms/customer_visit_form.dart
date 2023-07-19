import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../test/custom_page_view_form.dart';
import '../../../test/test_text_field.dart';
import '../../list/otherLists.dart';
import '../../../core/constants.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/gps_services.dart';
import '../../../widgets/dismiss_keyboard.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/page_models/model_functions.dart';

class CustomerVisitForm extends StatefulWidget {
  const CustomerVisitForm({Key? key}) : super(key: key);

  @override
  _CustomerVisitFormState createState() => _CustomerVisitFormState();
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
    data['location'] = gpsService.placeman[0].subAdministrativeArea;
    if (data['time'].toString().contains('T')) {
      data['time'] = data['time'].toString().split('T')[1].split('.')[0];
    }

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Adding new Customer Visit');

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(CUSTOMER_VISIT_POST, {'data': data}),
        context);

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
  }

  Future<void> _getCustomerData(String customer) async {
    selectedCstData = Map<String, dynamic>.from(
        await APIService().getPage(CUSTOMER_PAGE, customer))['message'];
    for (var k in selectedCstData.keys) {
      print("➡️ $k: ${selectedCstData[k]}");
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
          print("➡️ $k: ${data[k]}");
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
                      CustomTextFieldTest(
                        'customer',
                        'Customer',
                        initialValue: data['customer'],
                        disableValidation: false,
                        onPressed: () async {
                          String? id;

                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      selectCustomerScreen()));
                          if (res != null) {
                            id = res['name'];
                            await _getCustomerData(res['name']);

                            setState(() {
                              data['customer'] = res['name'];
                              data['customer_name'] = res['customer_name'];
                              data['customer_address'] =
                                  res["customer_primary_address"];
                              data['contact_person'] =
                                  res["customer_primary_contact"];
                            });
                          }

                          return id;
                        },
                      ),
                      CustomExpandableTile(
                        hideArrow: data['customer'] == null,
                        title: CustomTextFieldTest(
                            'customer_address', 'Customer Address',
                            initialValue: data['customer_address'],
                            disableValidation: false,
                            clearButton: false,
                            onSave: (key, value) => data[key] = value,
                            liestenToInitialValue:
                                data['customer_address'] == null,
                            onPressed: () async {
                              if (data['customer'] == null) {
                                return showSnackBar(
                                    'Please select a customer to first',
                                    context);
                              }
                              final res = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => customerAddressScreen(
                                          data['customer'])));
                              setState(() {
                                data['customer_address'] = res['name'];
                                selectedCstData['address_line1'] =
                                    res['address_line1'];
                                selectedCstData['city'] = res['city'];
                                selectedCstData['country'] = res['country'];
                              });
                              return res['name'];
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
                       Row(
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
