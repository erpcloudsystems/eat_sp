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
import '../../../widgets/snack_bar.dart';
import '../../list/generic_list_screen.dart';
import '../../list/otherLists.dart';
import '../../page/generic_page.dart';

class SupplierForm extends StatefulWidget {
  const SupplierForm({Key? key}) : super(key: key);

  @override
  _SupplierFormState createState() => _SupplierFormState();
}

class _SupplierFormState extends State<SupplierForm> {
  Map<String, dynamic> data = {
    "doctype": "Supplier",
    'supplier_type': supplierType[0],
    'disabled': 0,
  };

  final _formKey = GlobalKey<FormState>();

  // any widgets below this condition will not be shown
  bool removeWhenUpdate = true;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) {
      showSnackBar('Fill required fields', context);
      return;
    }
    _formKey.currentState!.save();

    final server = APIService();
    final provider = context.read<ModuleProvider>();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Adding new Supplier');

    for (var k in data.keys) print("➡️ $k: ${data[k]}");
    // return;
    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(SUPPLIER_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if(provider.isEditing && res == false) return;
    else if (provider.isEditing && res == null) Navigator.pop(context);
    else if (res != null && res['message']['name'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['name']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));

      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => GenericListScreen.module()));
    }
  }

  @override
  void initState() {
    super.initState();

    if (!context.read<ModuleProvider>().isEditing) {
      data['country'] = context.read<UserProvider>().companyDefaults['country'];
      data['default_currency'] = context
          .read<UserProvider>()
          .defaultCurrency
          .split('(')[1]
          .split(')')[0];
      setState(() {});
    }


    if (context.read<ModuleProvider>().isEditing)
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        removeWhenUpdate = data.isEmpty;
        setState(() {});
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
      child: Scaffold(
        appBar: AppBar(
          title: (context.read<ModuleProvider>().isEditing)
              ? Text("Edit Supplier")
              : Text("Create Supplier"),
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
                        'supplier_name',
                        tr('Supplier Name'),
                        onSave: (key, value) => data[key] = value,
                        initialValue: data['supplier_name'],
                      ),
                      CustomDropDown('supplier_type', tr('Supplier Type'),
                          items: supplierType,
                          defaultValue:
                              data['supplier_type'] ?? supplierType[0],
                          onChanged: (value) =>
                              setState(() => data['supplier_type'] = value)),
                      Divider(color: Colors.grey, height: 1, thickness: 0.7),
                      CustomTextField('supplier_group', tr('Supplier Group'),
                          initialValue: data['supplier_group'],
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => supplierGroupScreen()))),
                      CustomTextField('tax_id', tr('Tax ID'),
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['tax_id']),
                      //if (removeWhenUpdate)
                      CustomTextField('email_id', tr('Email Address'),
                          initialValue: data['email_id'],
                          keyboardType: TextInputType.emailAddress,
                          validator: mailValidation,
                          onSave: (key, value) => data[key] = value),
                      CustomTextField('mobile_no', tr('Mobile No'),
                          initialValue: data['mobile_no'],

                          keyboardType: TextInputType.phone,
                          validator: validateMobile,
                          onSave: (key, value) => data[key] = value),
                      CustomTextField(
                        'address_line1',
                        tr('Address'),
                        initialValue: data['supplier_primary_address'],
                        onSave: (key, value) => data[key] = value,
                      ),
                        CustomTextField(
                          'city',
                          tr('city'),
                          disableValidation: true,
                          initialValue: data['city'],
                          onSave: (key, value) => data[key] = value,
                        ),
                      //if (removeWhenUpdate)
                      CustomTextField('country', tr('Country'),
                          initialValue: data['country'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => countryScreen()))),
                      if(!removeWhenUpdate)
                      CheckBoxWidget('disabled', 'Disabled'.tr(),
                          initialValue: data['disabled'] == 1,
                          onChanged: (key, value) =>
                          data[key] = value ? 1 : 0),
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
                      CustomTextField('default_currency', 'Currency',
                          initialValue: data['default_currency'],
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => currencyListScreen()))),
                      CustomTextField('default_price_list', 'Price List'.tr(),
                          initialValue: data['default_price_list'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () async {
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => buyingPriceListScreen()));
                            if (res != null) {
                              data['default_price_list'] = res['name'];

                              return res['name'];
                            }
                          }),
                      CustomTextField(
                          'payment_terms', 'Payment Terms Template'.tr(),

                          initialValue: data['payment_terms'],
                          onSave: (key, value) => data[key] = value,
                          onChanged: (value) => data['payment_terms'] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => paymentTermsScreen()))),
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
