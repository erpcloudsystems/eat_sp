import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../list/otherLists.dart';
import '../../page/generic_page.dart';
import '../../../core/constants.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/inherited_widgets/item/add_uom_list.dart';
import '../../../widgets/inherited_widgets/item/uom_table_model.dart';

const List<String> grandTotalList = ['Grand Total', 'Net Total'];

class ItemForm extends StatefulWidget {
  const ItemForm({Key? key}) : super(key: key);

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  Map<String, dynamic> data = {
    "doctype": "Item",
    "posting_date": DateTime.now().toIso8601String(),
    "disabled": 0,
    "is_stock_item": 1,
    "include_item_in_manufacturing": 1,
    "is_fixed_asset": 0,
    "is_sales_item": 1,
    "is_purchase_item": 1,
  };

  bool _addedImage = false;
  File? _pickedImage;
  String? _imageUrl;

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) {
      showSnackBar(KFillRequiredSnackBar, context);
      return;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Item');

    final server = APIService();

    for (var k in data.keys) print("➡️ \"$k\": \"${data[k]}\"");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(ITEM_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (res != null && res['message']['item'] != null) {
      provider.pushPage(res['message']['item']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
    }
  }

  @override
  void initState() {
    super.initState();

    final provider = context.read<ModuleProvider>();
    if (provider.isEditing || provider.duplicateMode)
      Future.delayed(Duration.zero, () {
        data = provider.updateData;
        for (var k in data.keys) print("➡️ \"$k\": \"${data[k]}\"");

        data['uoms'].forEach((element) =>
            InheritedUOMForm.of(context).uoms.add(UOMModel.fromJson(element)));

        setState(() {});
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
      child: Scaffold(
        appBar: AppBar(
          title: (context.read<ModuleProvider>().isEditing)
              ? Text("Edit Item")
              : Text("Create Item"),
          actions: [
            Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: IconButton(
                  onPressed: submit,
                  icon: Icon(
                    Icons.check,
                    color: FORM_SUBMIT_BTN_COLOR,
                  ),
                ))
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Group(
                  child: Column(
                    children: [
                      SizedBox(height: 4),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: CustomTextField(
                                'item_code',
                                'Item Code'.tr(),
                                initialValue: data['item_code'],
                                clearButton: true,
                                disableValidation: false,
                                onChanged: (value) => data['item_code'] = value,
                                onSave: (key, value) => data[key] = value,
                              ),
                            ),
                            SizedBox(width: 10),
                            if (context.read<ModuleProvider>().isEditing)
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  GestureDetector(
                                      child: SizedBox(
                                        width: 130,
                                        height: 130,
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          margin: const EdgeInsets.only(
                                              top: 0, bottom: 5),
                                          child: _addedImage == false
                                              ? const Icon(Icons.add_a_photo,
                                                  size: 70, color: Colors.grey)
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.file(
                                                    _pickedImage!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      onTap: _addedImage == true
                                          ? null
                                          : () async {
                                              var res = await context
                                                  .read<ModuleProvider>()
                                                  .uploadImage(context);
                                              if (res != null &&
                                                  res['imageUrl'] != null &&
                                                  res['imageFile'] != null) {
                                                _imageUrl = res['imageUrl'];
                                                _pickedImage = res['imageFile'];
                                                _addedImage = true;
                                                data['image'] = _imageUrl;
                                                setState(() {});
                                              }
                                            }),
                                  _addedImage == false
                                      ? Container()
                                      : Positioned.fill(
                                          top: -8,
                                          right: -8,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                                onPressed: () {
                                                  _imageUrl = null;
                                                  _pickedImage = null;
                                                  _addedImage = false;
                                                  setState(() {});
                                                },
                                                icon: Icon(
                                                  Icons.cancel_outlined,
                                                  color: Colors.black45,
                                                  size: 29,
                                                )),
                                          ),
                                        ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      CustomTextField(
                        'item_name',
                        'Item Name'.tr(),
                        initialValue: data['item_name'],
                        clearButton: true,
                        disableValidation: true,
                        onChanged: (value) => data['item_name'] = value,
                        onSave: (key, value) => data[key] = value,
                      ),
                      CheckBoxWidget('disabled', 'Disabled',
                          initialValue: data['disabled'] == 1 ? true : false,
                          onChanged: (id, value) =>
                              setState(() => data[id] = value ? 1 : 0)),
                      CustomTextField('item_group', 'Item Group',
                          disableValidation: false,
                          initialValue: data['item_group'] ?? '',
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => itemGroupScreen()))),
                      CustomTextField('brand', 'Brand',
                          disableValidation: true,
                          initialValue: data['brand'] ?? '',
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => brandListScreen()))),
                      CustomTextField('stock_uom', 'Default UOM',
                          disableValidation: false,
                          initialValue: data['stock_uom'] ?? '',
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => uomListScreen()))),
                      CustomTextField(
                        'description',
                        'Description'.tr(),
                        initialValue: data['description'],
                        clearButton: true,
                        disableValidation: true,
                        onChanged: (value) => data['description'] = value,
                        onSave: (key, value) => data[key] = value,
                      ),
                      CheckBoxWidget('is_stock_item', 'Maintain Stock',
                          initialValue:
                              data['is_stock_item'] == 1 ? true : false,
                          onChanged: (id, value) =>
                              setState(() => data[id] = value ? 1 : 0)),
                      CheckBoxWidget('include_item_in_manufacturing',
                          'Include In Maunfacturing',
                          initialValue:
                              data['include_item_in_manufacturing'] == 1
                                  ? true
                                  : false,
                          onChanged: (id, value) =>
                              setState(() => data[id] = value ? 1 : 0)),
                      CheckBoxWidget('is_fixed_asset', 'Is Fixed Asset',
                          initialValue:
                              data['is_fixed_asset'] == 1 ? true : false,
                          onChanged: (id, value) =>
                              setState(() => data[id] = value ? 1 : 0)),
                      if (data['is_fixed_asset'] == 1)
                        CustomTextField(
                          'asset_category',
                          'Asset Category',
                          disableValidation: false,
                          initialValue: data['asset_category'] ?? '',
                          onSave: (key, value) => data[key] = value,
                          onPressed: () async {
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => assetCategoryListScreen()));
                            return res['asset_category_name'];
                          },
                        ),
                      CheckBoxWidget('is_sales_item', 'Is Sales Item',
                          initialValue:
                              data['is_sales_item'] == 1 ? true : false,
                          onChanged: (id, value) =>
                              setState(() => data[id] = value ? 1 : 0)),
                      CustomTextField('sales_uom', 'Sales UOM',
                          disableValidation: true,
                          initialValue: data['sales_uom'] ?? '',
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => uomListScreen()))),
                      CheckBoxWidget('is_purchase_item', 'Is Purchase Item',
                          initialValue:
                              data['is_purchase_item'] == 1 ? true : false,
                          onChanged: (id, value) =>
                              setState(() => data[id] = value ? 1 : 0)),
                      CustomTextField('purchase_uom', 'Purchase UOM',
                          disableValidation: true,
                          initialValue: data['purchase_uom'] ?? '',
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => uomListScreen()))),
                      SizedBox(height: 22),
                    ],
                  ),
                ),
                SelectedUOMsList(),
                SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
