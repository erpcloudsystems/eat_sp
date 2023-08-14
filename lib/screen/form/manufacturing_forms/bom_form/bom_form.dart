import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'group1.dart';
import 'group2.dart';
import 'group3.dart';
import '../../../page/generic_page.dart';
import '../../../../core/constants.dart';
import '../../../../service/service.dart';
import '../../../../widgets/snack_bar.dart';
import '../../../../widgets/dismiss_keyboard.dart';
import '../../../../service/service_constants.dart';
import '../../../../test/custom_page_view_form.dart';
import '../../../../provider/user/user_provider.dart';
import '../../../../widgets/dialog/loading_dialog.dart';
import '../../../../provider/module/module_provider.dart';
import '../../../../new_version/core/resources/strings_manager.dart';
import '../../../../models/page_models/manufacuting_model/bom_page_model.dart';
import '../../../../new_version/modules/new_item/presentation/pages/add_items.dart';

class BomForm extends StatefulWidget {
  const BomForm({Key? key}) : super(key: key);

  @override
  State<BomForm> createState() => _BomFormState();
}

class _BomFormState extends State<BomForm> {
  final server = APIService();
  Map<String, dynamic> data = {
    "doctype": DocTypesName.bom,
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) {
      showSnackBar(KFillRequiredSnackBar, context);
      return;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeAmendingFunction(context, data);

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);
    _formKey.currentState!.save();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Bom');

    // To print the body we send to backend
    for (var k in data.keys) {
      log("➡️ $k: ${data[k]}");
    }

    data['items'] = [];
    data['docstatus'] = 0;
    for (var element in provider.newItemList) {
      data['items'].add(element);
    }

    await handleRequest(
            () async => provider.isEditing
                ? await provider.updatePage(data)
                : await server.postRequest(BOM_POST, {'data': data}),
            context)
        .then((res) {
      Navigator.pop(context);

      if (provider.isEditing && res == false) {
        return;
      } else if (provider.isEditing && res == null) {
        Navigator.pop(context);
      } else if (context.read<ModuleProvider>().isCreateFromPage) {
        if (res != null && res['message']['bom'] != null) {
          context.read<ModuleProvider>().pushPage(res['message']['bom']);
        }
        Navigator.of(context)
            .push(MaterialPageRoute(
              builder: (_) => const GenericPage(),
            ))
            .then((value) => Navigator.pop(context));
      } else if (res != null && res['message']['bom'] != null) {
        provider.pushPage(res['message']['bom']);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const GenericPage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final provider = context.read<ModuleProvider>();

    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        final items = BomPageModel(data).items;
        for (var element in items) {
          provider.setItemToList(element);
        }
        for (var k in data.keys) {
          log("➡️ $k: ${data[k]}");
        }

        if (provider.isAmendingMode) {
          data.remove('amended_to');
          data['docstatus'] = 0;
        }
        setState(() {});
      });
    }

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;
        data['bom'] = data['name'];
        data['doctype'] = DocTypesName.bom;
        data['items'].forEach((element) {
          provider.newItemList.add(element);
        });

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
        data.remove('status');
        data.remove('taxes');
        data.remove('users');
        data.remove('actual_time');

        setState(() {});
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    context.read<ModuleProvider>().resetCreationForm();
    Provider.of<ModuleProvider>(context, listen: false).clearTimeSheet = [];
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
                Group1(data: data),
                Group2(data: data),
                Group3(data: data),
                AddItemsWidget(
                  haveRate: false,
                  priceList:
                      context.read<UserProvider>().defaultSellingPriceList,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
