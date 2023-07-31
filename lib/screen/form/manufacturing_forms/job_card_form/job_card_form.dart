import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'job_card_group1.dart';
import '../../../../core/constants.dart';
import '../../../page/generic_page.dart';
import '../../../../service/service.dart';
import '../../../../widgets/snack_bar.dart';
import '../../../../widgets/dismiss_keyboard.dart';
import '../../../../service/service_constants.dart';
import '../../../../test/custom_page_view_form.dart';
import '../../../../widgets/dialog/loading_dialog.dart';
import '../../../../provider/module/module_provider.dart';
import '../../../../new_version/core/resources/strings_manager.dart';

class JobCardForm extends StatefulWidget {
  const JobCardForm({Key? key}) : super(key: key);

  @override
  State<JobCardForm> createState() => _JobCardFormState();
}

class _JobCardFormState extends State<JobCardForm> {
  final _formKey = GlobalKey<FormState>();
  final server = APIService();
  Map<String, dynamic> data = {
    "doctype": DocTypesName.jobCard,
  };

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

    data['docstatus'] = 0;

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Job Card');

    // To print the body we send to backend
    for (var k in data.keys) {
      log("➡️ $k: ${data[k]}");
    }

    await handleRequest(
            () async => provider.isEditing
                ? await provider.updatePage(data)
                : await server.postRequest(JOB_CARD_POST, {'data': data}),
            context)
        .then((result) {
      Navigator.pop(context);
      if (provider.isEditing && result == false) {
        return;
      } else if (provider.isEditing && result == null) {
        Navigator.pop(context);
      } else if (context.read<ModuleProvider>().isCreateFromPage) {
        if (result != null && result['message']['job_card'] != null) {
          context
              .read<ModuleProvider>()
              .pushPage(result['message']['job_card']);
        }
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const GenericPage()))
            .then((value) => Navigator.pop(context));
      } else if (result != null && result['message']['job_card'] != null) {
        provider.pushPage(result['message']['job_card']);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const GenericPage()));
      }
    });
  }

  @override
  void initState() {
    final provider = context.read<ModuleProvider>();
    super.initState();

    //Editing Mode & Duplicate &  Amending
    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = provider.updateData;
        for (var k in data.keys) {
          log("➡️ $k: ${data[k]}");
        }
        setState(() {});
      });
    }

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;
        data['doctype'] = "job_card";

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
    return WillPopScope(
      onWillPop: () async {
        bool? isGoBack =
            await checkDialog(context, StringsManager.areYouSureToGoBack.tr());
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
                widgetGroup: [JobCardGroup1(data: data)],
              )),
        ),
      ),
    );
  }
}
