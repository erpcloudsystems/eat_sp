import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  LatLng location = LatLng(0.0, 0.0);
  GPSService gpsService = GPSService();

  Map<String, dynamic> selectedCstData = {
    'name': 'noName',
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (location == LatLng(0.0, 0.0)) {
      showSnackBar(KEnableGpsSnackBar, context);
      Future.delayed(Duration(seconds: 1), () async {
        location = await gpsService.getCurrentLocation(context);
      });
      return;
    }

    _formKey.currentState!.save();

    final server = APIService();
    final provider = context.read<ModuleProvider>();

    data['docstatus'] = 0;
    data['latitude'] = location.latitude;
    data['longitude'] = location.longitude;
    data['location'] = gpsService.placemarks[0].subAdministrativeArea;
    if (data['time'].toString().contains('T')) {
      data['time'] = data['time'].toString().split('T')[1].split('.')[0];
    }

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Adding new Customer Visit');

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(CUSTOMER_VISIT_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (res != null &&
        res['message']['customer_visit_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['customer_visit_data_name']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
    }
  }

  Future<void> _getCustomerData(String customer) async {
    selectedCstData = Map<String, dynamic>.from(
        await APIService().getPage(CUSTOMER_PAGE, customer))['message'];
    for (var k in selectedCstData.keys) print("➡️ $k: ${selectedCstData[k]}");
  }

  @override
  void initState() {
    super.initState();

    if (context.read<ModuleProvider>().isEditing)
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        for (var k in data.keys) print("➡️ $k: ${data[k]}");
        data['latitude'] = 0.0;
        data['longitude'] = 0.0;
        data['time'] =
            DateTime.now().toIso8601String().split("T")[0] + "T" + data['time'];
        _getCustomerData(data['customer']).then((value) => setState(() {
              selectedCstData['address_line1'] =
                  formatDescription(data['address_line1']);
              selectedCstData['city'] = data['city'];
              selectedCstData['country'] = data['country'];
            }));

        setState(() {});
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () async {
      location = await gpsService.getCurrentLocation(context);
    });
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
          appBar: AppBar(
            title: (context.read<ModuleProvider>().isEditing)
                ? Text("Edit Customer Visit".tr())
                : Text("Create Customer Visit".tr()),
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
                          'customer',
                          'Customer',
                          initialValue: data['customer'],
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
                          title: CustomTextField(
                              'customer_address', 'Customer Address',
                              initialValue: data['customer_address'],
                              disableValidation: false,
                              clearButton: false,
                              onSave: (key, value) => data[key] = value,
                              liestenToInitialValue:
                                  data['customer_address'] == null,
                              onPressed: () async {
                                if (data['customer'] == null)
                                  return showSnackBar(
                                      'Please select a customer to first',
                                      context);
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
                                    trailing: Icon(Icons.location_on),
                                    title: Text(
                                        selectedCstData['address_line1'] ?? ''),
                                  ),
                                  ListTile(
                                    trailing: Icon(Icons.location_city),
                                    title: Text(selectedCstData['city'] ?? ''),
                                  ),
                                  ListTile(
                                    trailing: Icon(Icons.flag),
                                    title:
                                        Text(selectedCstData['country'] ?? ''),
                                  )
                                ]
                              : null,
                        ),
                        Row(children: [
                          Flexible(
                              child: DatePicker(
                            'posting_date',
                            'Posting Date'.tr(),
                            enable: false,
                            initialValue: data['posting_date'],
                            onChanged: (value) =>
                                setState(() => data['posting_date'] = value),
                          )),
                          SizedBox(width: 10),
                          Flexible(
                              child: TimePicker(
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
                        CustomTextField(
                          'description',
                          'Description'.tr(),
                          onChanged: (value) => data['description'] = value,
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['description'],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
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
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
