import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import '../../list/otherLists.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/gps_services.dart';
import '../../../widgets/dismiss_keyboard.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({Key? key}) : super(key: key);

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  Map<String, dynamic> data = {
    "doctype": "Address",
    // "posting_date": DateTime.now().toIso8601String(),
    "is_primary_address": 0,
    "address_type": 'Billing',
    "links": [
      {
        // 'link_name': null,
        // 'link_doctype': null,
      }
    ],
    "latitude": 0.0,
    "longitude": 0.0,
  };

  LatLng location = const LatLng(0.0, 0.0);
  GPSService gpsService = GPSService();

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (data['link_doctype'] == null) {
      showSnackBar('Link Document Type is Mandatory', context);
      return;
    }
    if (data['link_name'] == null) {
      showSnackBar('Link Name is Mandatory', context);
      return;
    }

    if (location == const LatLng(0.0, 0.0)) {
      showSnackBar(KEnableGpsSnackBar, context);
      Future.delayed(const Duration(seconds: 1), () async {
        location = await gpsService.getCurrentLocation(context);
      });
      return;
    }

    if (!context.read<ModuleProvider>().isEditing) {
      data['latitude'] = location.latitude;
      data['longitude'] = location.longitude;
      data['location'] = gpsService.placeman[0].subAdministrativeArea;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    final server = APIService();
    final provider = context.read<ModuleProvider>();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Adding new Address');

    // data['link_name'] = data['links'][0]['link_name'];
    // data['link_doctype'] = data['links'][0]['link_doctype'];

    data.remove('reference');
    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(ADDRESS_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (res != null && res['message']['address_name'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['address_name']);
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
        data = provider.updateData;
        for (var k in data.keys) {
          print("➡️ $k: ${data[k]}");
        }

        data['latitude'] = 0.0;
        data['longitude'] = 0.0;

        if (data['reference'] != null) {
          data['reference'][0]['link_doctype'] =
              data['reference'][0]['link_doctype'];
          data['reference'][0]['link_name'] = data['reference'][0]['link_name'];
          data['link_doctype'] = data['reference'][0]['link_doctype'];
          data['link_name'] = data['reference'][0]['link_name'];
        }

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
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      CustomTextFieldTest(
                        'address_title',
                        'Address Title',
                        initialValue: data['address_title'],
                        disableValidation: true,
                        onChanged: (value) => data['address_title'] = value,
                        onSave: (key, value) => data[key] = value,
                      ),
                      // CustomDropDown('address_type', ' Address Type'.tr(),
                      //     items: addressTypeList,
                      //     defaultValue: addressTypeList[0],
                      //     onChanged: (value) => data['address_type'] = value),
                      //Divider(color: Colors.grey, height: 1, thickness: 0.9),
                      CustomTextFieldTest(
                        'address_line1',
                        'Address Line 1'.tr(),
                        initialValue: data['address_line1'],
                        onChanged: (value) => data['address_line1'] = value,
                        onSave: (key, value) => data[key] = value,
                      ),
                      CustomTextFieldTest(
                        'city',
                        'City/Town'.tr(),
                        initialValue: data['city'],
                        onChanged: (value) => data['city'] = value,
                        onSave: (key, value) => data[key] = value,
                      ),

                      CustomTextFieldTest(
                        'country',
                        'Country'.tr(),
                        initialValue: data['country'],
                        disableValidation: false,
                        onSave: (key, value) => data[key] = value,
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
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Group(
                    child: ListView(
                  children: [
                    const SizedBox(height: 8),
                    CustomDropDown(
                      'link_doctype',
                      'Link Document Type',
                      items: linkDocumentTypeList,
                      defaultValue:
                          data['link_doctype'] ?? linkDocumentTypeList[0],
                      onChanged: (value) => setState(() {
                        data['link_name'] = null;
                        data['link_doctype'] = value;
                      }),
                    ),
                    Divider(
                        color: Colors.grey.shade300, height: 1, thickness: 0.9),
                    if (data['link_doctype'] == linkDocumentTypeList[0])
                      CustomTextFieldTest(
                        'link_name',
                        'Link Name'.tr(),
                        initialValue: data['link_name'],
                        onPressed: () async {
                          String? id;

                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      selectCustomerScreen()));
                          if (res != null) {
                            id = res['name'];
                            setState(() {
                              data['link_name'] = res['name'];
                            });
                          }

                          return id;
                        },
                      ),
                    if (data['link_doctype'] == linkDocumentTypeList[1])
                      CustomTextFieldTest(
                        'link_name',
                        'Link Name',
                        initialValue: data['link_name'],
                        onPressed: () async {
                          String? id;
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      selectSupplierScreen()));
                          if (res != null) {
                            id = res['name'];

                            setState(() {
                              data['link_name'] = res['name'];
                            });
                          }
                          return id;
                        },
                      ),
                    CheckBoxWidget('is_primary_address', 'Is Primary',
                        initialValue:
                            data['is_primary_address'] == 1 ? true : false,
                        onChanged: (id, value) =>
                            setState(() => data[id] = value ? 1 : 0)),
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
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
