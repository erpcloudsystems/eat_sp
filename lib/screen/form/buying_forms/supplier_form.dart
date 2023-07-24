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
import '../../../service/service_constants.dart';
import '../../../provider/user/user_provider.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';

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
      showSnackBar(KFillRequiredSnackBar, context);
      return;
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
            : 'Adding new Supplier');

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }
    // return;
    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(SUPPLIER_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (res != null && res['message']['name'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['name']);
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
      data['default_currency'] = context.read<UserProvider>().defaultCurrency;
      setState(() {});
    }

    if (provider.isEditing || provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        removeWhenUpdate = data.isEmpty;
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
                      'supplier_name',
                      tr('Supplier Name'),
                      initialValue: data['supplier_name'],
                      disableValidation: false,
                      clearButton: true,
                      onChanged: (value) {
                        setState(() {
                          data['supplier_name'] = value;
                        });
                      },
                      onSave: (key, value) => data[key] = value,
                    ),
                    CustomDropDown(
                      'supplier_type',
                      tr('Supplier Type'),
                      items: supplierType,
                      defaultValue: data['supplier_type'] ?? supplierType[0],
                      onChanged: (value) => setState(
                        () => data['supplier_type'] = value,
                      ),
                    ),
                    const Divider(
                        color: Colors.grey, height: 1, thickness: 0.7),
                    CustomTextFieldTest(
                      'supplier_group',
                      tr('Supplier Group'),
                      initialValue: data['supplier_group'],
                      onSave: (key, value) => data[key] = value,
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => supplierGroupScreen(),
                          ),
                        );
                        data['supplier_group'] = res;

                        return res;
                      },
                    ),
                    CustomTextFieldTest(
                      'tax_id',
                      tr('Tax ID'),
                      initialValue: data['tax_id'],
                      clearButton: true,
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) {
                        setState(() {
                          data['tax_id'] = value;
                        });
                      },
                      disableValidation: true,
                    ),
                    //if (removeWhenUpdate)
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
                    CustomTextFieldTest(
                      'mobile_no',
                      tr('Mobile No'),
                      initialValue: data['mobile_no'],
                      disableValidation: true,
                      keyboardType: TextInputType.phone,
                      validator: validateMobile,
                      onChanged: (value) {
                        setState(() {
                          data['mobile_no'] = value;
                        });
                      },
                      onSave: (key, value) => data[key] = value,
                    ),
                    CustomTextFieldTest(
                      'address_line1',
                      tr('Address'),
                      initialValue: data['supplier_primary_address'],
                      disableValidation: true,
                      onChanged: (value) {
                        setState(() {
                          data['supplier_primary_address'] = value;
                        });
                      },
                      onSave: (key, value) => data[key] = value,
                    ),
                    CustomTextFieldTest(
                      'city',
                      tr('city'),
                      disableValidation: true,
                      initialValue: data['city'],
                      onChanged: (value) {
                        setState(() {
                          data['city'] = value;
                        });
                      },
                      onSave: (key, value) => data[key] = value,
                    ),
                    //if (removeWhenUpdate)
                    CustomTextFieldTest('country', tr('Country'),
                        initialValue: data['country'],
                        disableValidation: true,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => countryScreen()))),
                    if (!removeWhenUpdate)
                      CheckBoxWidget('disabled', 'Disabled'.tr(),
                          initialValue: data['disabled'] == 1,
                          onChanged: (key, value) => data[key] = value ? 1 : 0),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              ///
              /// group 2
              ///
              Group(
                child: ListView(
                  children: [
                    CustomTextFieldTest('default_currency', 'Currency',
                        initialValue: data['default_currency'],
                        disableValidation: true,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => currencyListScreen()))),
                    CustomTextFieldTest('default_price_list', 'Price List'.tr(),
                        initialValue: data['default_price_list'] ?? userProvider.defaultBuyingPriceList,
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
                          return null;
                        }),
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
            ],
          ),
        ),
      ),
    );
  }
}
