import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../test/custom_page_view_form.dart';
import '../../../test/test_text_field.dart';
import '../../list/otherLists.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../service/gps_services.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../provider/user/user_provider.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';

class CustomerForm extends StatefulWidget {
  const CustomerForm({Key? key}) : super(key: key);

  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  Map<String, dynamic> data = {
    "doctype": "Customer",
    'customer_type': customerType[0],
    'credit_limits': [<String, dynamic>{}],
    "latitude": 0.0,
    "longitude": 0.0,
  };

  LatLng location = const LatLng(0.0, 0.0);
  GPSService gpsService = GPSService();

  final _formKey = GlobalKey<FormState>();

  // any widgets below this condition will not be shown
  bool removeWhenUpdate = true;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (location == const LatLng(0.0, 0.0)) {
      showSnackBar('Enable Location Permission for this action', context);
      Future.delayed(const Duration(seconds: 1), () async {
        location = await gpsService.getCurrentLocation(context);
      });
      return;
    }
    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    final server = APIService();
    final provider = context.read<ModuleProvider>();

    if (!context.read<ModuleProvider>().isEditing) {
      data['latitude'] = location.latitude;
      data['longitude'] = location.longitude;
      data['location'] = gpsService.placemarks[0].subAdministrativeArea;
    }
    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Adding new customer');

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(CUSTOMER_POST, {'data': data}),
        context);

    // for loading dialog message
    Navigator.pop(context);

    if (provider.isEditing) Navigator.pop(context);

    if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['customer'] != null) {
        context.read<ModuleProvider>().pushPage(res['message']['customer']);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['customer'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['customer']);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GenericPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    final provider = context.read<ModuleProvider>();
    //Adding Mode
    if (!provider.isEditing) {
      data['default_currency'] = context.read<UserProvider>().defaultCurrency;
      data['country'] = context.read<UserProvider>().companyDefaults['country'];
      setState(() {});
    }
//Editing Mode
    if (provider.isEditing || provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        removeWhenUpdate = data.isEmpty;
        data['latitude'] = 0.0;
        data['longitude'] = 0.0;

        setState(() {});
      });
    }
    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;
        for (var k in data.keys) {
          print("➡️ $k: ${data[k]}");
        }
        data['credit_limits'] = [{}];
        data['customer_type'] = customerType[0];
        data['customer_name'] = data['lead_name'];
        data['latitude'] = 0.0;
        data['longitude'] = 0.0;

        //from lead
        if (data['doctype'] == 'Lead') {
          data['lead_name'] = data['name'];
        }
        // From Opportunity
        if (data['doctype'] == 'Opportunity') {
          data['opportunity_name'] = data['name'];
          data['customer_name'] = data['party_name'];
        }

        // from user defaults
        data['default_currency'] = context.read<UserProvider>().defaultCurrency;
        data['country'] =
            context.read<UserProvider>().companyDefaults['country'];

        data['doctype'] = "Customer";
        data.remove('print_formats');
        data.remove('conn');
        data.remove('comments');
        data.remove('attachments');
        data.remove('docstatus');
        data.remove('name');
        data.remove('_pageData');
        data.remove('_pageId');
        data.remove('_availablePdfFormat');
        data.remove('_currentModule');

        setState(() {});
      });
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    location = await gpsService.getCurrentLocation(context);
  }

  @override
  void deactivate() {
    super.deactivate();
    context.read<ModuleProvider>().resetCreationForm();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
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
                      'customer_name',
                      tr('Customer Name'),
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) {
                        setState(() {
                          data['customer_name'] = value;
                        });
                      },
                      initialValue: data['customer_name'],
                    ),
                    CustomDropDown('customer_type', tr('Customer Type'),
                        items: customerType,
                        defaultValue: data['customer_type'] ?? customerType[0],
                        onChanged: (value) =>
                            setState(() => data['customer_type'] = value)),
                    const Divider(
                        color: Colors.grey, height: 1, thickness: 0.7),
                    CustomTextFieldTest(
                      'customer_group',
                      tr('Customer Group'),
                      initialValue: data['customer_group'],
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) {
                        setState(() {
                          data['customer_group'] = value;
                        });
                      },
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => customerGroupScreen(),
                          ),
                        );
                        data['customer_group'] = res;
                        return res;
                      },
                    ),
                    CustomTextFieldTest(
                      'territory',
                      tr('Territory'),
                      initialValue: data['territory'],
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) {
                        setState(() {
                          data['territory'] = value;
                        });
                      },
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
                      'market_segment',
                      tr('Market Segment'),
                      initialValue: data['market_segment'],
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) {
                        setState(() {
                          data['market_segment'] = value;
                        });
                      },
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
                      'industry',
                      tr('Industry'),
                      initialValue: data['industry'],
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) {
                        setState(() {
                          data['industry'] = value;
                        });
                      },
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => industryScreen()));
                        data['industry'] = res;
                        return res;
                      },
                    ),
                    CustomTextFieldTest(
                      'tax_id',
                      tr('Tax ID'),
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) {
                        setState(() {
                          data['tax_id'] = value;
                        });
                      },
                      initialValue: data['tax_id'],
                      disableValidation: true,
                    ),

                    if (!removeWhenUpdate)
                      CheckBoxWidget('disabled', 'Disabled'.tr(),
                          initialValue: data['disabled'] == 1,
                          onChanged: (key, value) => data[key] = value ? 1 : 0),
                    if (removeWhenUpdate)
                      CustomTextFieldTest('email_id', tr('Email Address'),
                          initialValue: data['email_id'],
                          disableValidation: true,
                          keyboardType: TextInputType.emailAddress,
                          validator: mailValidation,
                          onChanged: (value) {
                            setState(() {
                              data['email_id'] = value;
                            });
                          },
                          onSave: (key, value) => data[key] = value),
                    if (removeWhenUpdate)
                      CustomTextFieldTest('mobile_no', tr('Mobile No'),
                          initialValue: data['mobile_no'],
                          disableValidation: true,
                          keyboardType: TextInputType.phone,
                          validator: validateMobile,
                          onChanged: (value) {
                            setState(() {
                              data['mobile_no'] = value;
                            });
                          },
                          onSave: (key, value) => data[key] = value),
                    if (removeWhenUpdate)
                      CustomTextFieldTest(
                        'address_line1',
                        tr('Address'),
                        onSave: (key, value) => data[key] = value,
                        initialValue: data['address_line1'],
                        onChanged: (value) {
                          setState(() {
                            data['address_line1'] = value;
                          });
                        },
                        disableValidation: true,
                      ),
                    if (removeWhenUpdate)
                      CustomTextFieldTest('city', 'City',
                          onSave: (key, value) => data[key] = value,
                          disableValidation: true,
                          onChanged: (value) {
                            setState(() {
                              data['city'] = value;
                            });
                          },
                          initialValue: data['city']),
                    if (removeWhenUpdate)
                      CustomTextFieldTest('country', tr('Country'),
                          initialValue: data['country'],
                          onSave: (key, value) {
                            data[key] = value;
                          },
                          onChanged: (value) {
                            setState(() {
                              data['country'] = value;
                            });
                          },
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => countryScreen()))),
                    // if (data['lead_name']!=null)
                    // CustomTextField('lead_name', tr('From Lead'),
                    //     initialValue: data['lead_name'],
                    //     onSave: (key, value) => data[key] = value),

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
                    CustomTextFieldTest(
                      'default_currency',
                      'Currency',
                      initialValue: data['default_currency'] ??
                          userProvider.defaultCurrency,
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) {
                        setState(() {
                          data['default_currency'] = value;
                        });
                      },
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => currencyListScreen())),
                    ),
                    CustomTextFieldTest('default_price_list', 'Price List'.tr(),
                        initialValue: data['default_price_list'] ??
                            userProvider.defaultSellingPriceList,
                        disableValidation: true,
                        onSave: (key, value) => data[key] = value,
                        onChanged: (value) {
                          setState(() {
                            data['default_price_list'] = value;
                          });
                        },
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => priceListScreen()));
                          if (res != null) {
                            data['default_price_list'] = res['name'];
                            return res['name'];
                          }
                          return res['name'];
                        }),
                    CustomTextFieldTest(
                        'default_sales_partner', 'Sales Partner',
                        initialValue: data['default_sales_partner'],
                        onSave: (key, value) => data[key] = value,
                        disableValidation: true,
                        onChanged: (value) {
                          setState(() {
                            data['default_sales_partner'] = value;
                          });
                        },
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => salesPartnerScreen()))),
                    CustomTextFieldTest(
                        'payment_terms', 'Payment Terms Template'.tr(),
                        initialValue: data['payment_terms'],
                        disableValidation: true,
                        onSave: (key, value) => data[key] = value,
                        onChanged: (value) => data['payment_terms'] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => paymentTermsScreen()))),
                  ],
                ),
              ),

              ///
              /// Group 3
              ///

              Group(
                child: Column(
                  children: [
                    CustomTextFieldTest('credit_limit', 'Credit Limit'.tr(),
                        initialValue:
                            (data['credit_limits']?[0]['credit_limit'] ?? '')
                                .toString(),
                        disableValidation: true,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            data['credit_limit'] = value;
                          });
                        },
                        onSave: (key, value) =>
                            data['credit_limits']?[0][key] = value),
                    // disappeared in edit as this data not in Cst Page
                    CheckBoxWidget('bypass_credit_limit_check',
                        'Bypass Credit Limit Check at Sales Order'.tr(),
                        initialValue: data['credit_limits']?[0]
                                ['bypass_credit_limit_check'] ==
                            1,
                        onChanged: (key, value) =>
                            data['credit_limits']?[0][key] = value ? 1 : 0),
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
