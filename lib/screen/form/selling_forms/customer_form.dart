import 'package:next_app/provider/user/user_provider.dart';
import 'package:next_app/screen/other/user_profile.dart';
import 'package:next_app/service/service.dart';
import 'package:next_app/service/service_constants.dart';
import 'package:next_app/provider/module/module_provider.dart';
import 'package:next_app/widgets/dialog/loading_dialog.dart';
import 'package:next_app/widgets/form_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../service/gps_services.dart';
import '../../../widgets/snack_bar.dart';
import '../../list/otherLists.dart';
import '../../page/generic_page.dart';

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

  LatLng location = LatLng(0.0, 0.0);
  GPSService gpsService = GPSService();


  final _formKey = GlobalKey<FormState>();

  // any widgets below this condition will not be shown
  bool removeWhenUpdate = true;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if(location == LatLng(0.0, 0.0)

    ) {
      showSnackBar(
          'Enable Location Permission for this action',
          context)  ;
      Future.delayed(Duration(seconds: 1), () async{

        location = await gpsService.getCurrentLocation(context);

      });
      return;
    }

    _formKey.currentState!.save();

    final server = APIService();
    final provider = context.read<ModuleProvider>();

    if (!context.read<ModuleProvider>().isEditing){
      data['latitude'] = location.latitude;
      data['longitude'] = location.longitude;
      data['location'] = gpsService.placemarks[0].subAdministrativeArea;

    }
    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Adding new customer');

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(CUSTOMER_POST, {'data': data}),
        context);

    // for loading dialog message
    Navigator.pop(context);

    if (provider.isEditing) Navigator.pop(context);

    if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['customer'] != null)
        context.read<ModuleProvider>().pushPage(res['message']['customer']);
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['customer'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['customer']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
    }
  }

  @override
  void initState() {
    super.initState();

    //Adding Mode
    if (!context.read<ModuleProvider>().isEditing) {
      data['default_currency'] = context
          .read<UserProvider>()
          .defaultCurrency
          .split('(')[1]
          .split(')')[0];
      data['country'] = context.read<UserProvider>().companyDefaults['country'];
      setState(() {});
    }
//Editing Mode
    if (context.read<ModuleProvider>().isEditing){
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
        for (var k in data.keys) print("➡️ $k: ${data[k]}");
        data['credit_limits'] = [{}];
        data['customer_type'] =  customerType[0];
        data['customer_name'] = data['lead_name'];
        data['latitude'] = 0.0;
        data['longitude'] = 0.0;


        //from lead
        if(data['doctype']=='Lead'){
          data['lead_name'] = data['name'];
        }
        // From Opportunity
        if(data['doctype']=='Opportunity'){
          data['opportunity_name'] = data['name'];
          data['customer_name'] = data['party_name'];
        }


        // from user defaults
        data['default_currency'] = context
            .read<UserProvider>()
            .defaultCurrency
            .split('(')[1]
            .split(')')[0];
        data['country'] =
            context.read<UserProvider>().companyDefaults['country'];


        data['doctype']= "Customer";
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
        appBar: AppBar(
          title: (context.read<ModuleProvider>().isEditing)
              ? Text("Edit Customer")
              : Text("Create Customer"),
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
                        'customer_name',
                        tr('Customer Name'),
                        onSave: (key, value) => data[key] = value,
                        initialValue: data['customer_name'],
                      ),
                      CustomDropDown('customer_type', tr('Customer Type'),
                          items: customerType,
                          defaultValue:
                              data['customer_type'] ?? customerType[0],
                          onChanged: (value) =>
                              setState(() => data['customer_type'] = value)),
                      Divider(color: Colors.grey, height: 1, thickness: 0.7),
                      CustomTextField('customer_group', tr('Customer Group'),
                          initialValue: data['customer_group'],
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => customerGroupScreen()))),
                      CustomTextField('territory', tr('Territory'),
                          initialValue: data['territory'],
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => territoryScreen()))),
                      CustomTextField('market_segment', tr('Market Segment'),
                          initialValue: data['market_segment'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => marketSegmentScreen()))),
                      CustomTextField('industry', tr('Industry'),
                          initialValue: data['industry'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => industryScreen()))),
                      CustomTextField('tax_id', tr('Tax ID'),
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['tax_id'],
                        disableValidation: true,

                      ),

                      if (!removeWhenUpdate)
                        CheckBoxWidget('disabled', 'Disabled'.tr(),
                            initialValue: data['disabled'] == 1,
                            onChanged: (key, value) =>
                                data[key] = value ? 1 : 0),
                      if (removeWhenUpdate)
                        CustomTextField('email_id', tr('Email Address'),
                            initialValue: data['email_id'],
                            disableValidation: true,

                            keyboardType: TextInputType.emailAddress,
                            validator: mailValidation,
                            onSave: (key, value) => data[key] = value),
                      if (removeWhenUpdate)
                        CustomTextField('mobile_no', tr('Mobile No'),
                            initialValue: data['mobile_no'],
                            disableValidation: true,

                            keyboardType: TextInputType.phone,
                            validator: validateMobile,
                            onSave: (key, value) => data[key] = value),
                      if (removeWhenUpdate)
                        CustomTextField('address_line1', tr('Address'),
                            onSave: (key, value) => data[key] = value,
                            initialValue: data['address_line1'],
                          disableValidation: true,
                        ),
                      if (removeWhenUpdate)
                        CustomTextField('city', 'City',
                            onSave: (key, value) => data[key] = value,
                            disableValidation: true,

                            initialValue: data['city']),
                      if (removeWhenUpdate)
                        CustomTextField('country', tr('Country'),
                            initialValue: data['country'],
                            onSave: (key, value) {
                              data[key] = value;
                            },
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => countryScreen()))),
                      // if (data['lead_name']!=null)
                      // CustomTextField('lead_name', tr('From Lead'),
                      //     initialValue: data['lead_name'],
                      //     onSave: (key, value) => data[key] = value),

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
                      CustomTextField(
                        'default_currency',
                        'Currency',
                        initialValue: data['default_currency'],
                        disableValidation: true,

                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => currencyListScreen())),
                      ),
                      CustomTextField('default_price_list', 'Price List'.tr(),
                          initialValue: data['default_price_list'],
                          disableValidation: true,

                          onSave: (key, value) => data[key] = value,
                          onPressed: () async {
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => priceListScreen()));
                            if (res != null) {
                              data['default_price_list'] = res['name'];
                              return res['name'];
                            }
                          }),
                      CustomTextField('default_sales_partner', 'Sales Partner',
                          initialValue: data['default_sales_partner'],
                          onSave: (key, value) => data[key] = value,
                          disableValidation: true,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => salesPartnerScreen()))),
                      CustomTextField(
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
                      CustomTextField('credit_limit', 'Credit Limit'.tr(),
                          initialValue: (data['credit_limits']?[0]
                                  ['credit_limit']??'')
                              .toString(),
                          disableValidation: true,
                          keyboardType: TextInputType.number,
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
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
