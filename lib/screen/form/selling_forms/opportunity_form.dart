import 'package:next_app/models/list_models/stock_list_model/item_table_model.dart';
import 'package:next_app/models/page_models/selling_page_model/opportunity_page_model.dart';
import 'package:next_app/provider/user/user_provider.dart';
import 'package:next_app/service/service.dart';
import 'package:next_app/service/service_constants.dart';
import 'package:next_app/provider/module/module_provider.dart';
import 'package:next_app/screen/list/otherLists.dart';
import 'package:next_app/widgets/dialog/loading_dialog.dart';
import 'package:next_app/widgets/form_widgets.dart';
import 'package:next_app/widgets/inherited_widgets/select_items_list.dart';
import 'package:next_app/widgets/item_card.dart';
import 'package:next_app/widgets/snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../page/generic_page.dart';
import 'quotation_form.dart';

const List<String> grandTotalList = ['Grand Total', 'Net Total'];

class OpportunityForm extends StatefulWidget {
  const OpportunityForm({Key? key}) : super(key: key);

  @override
  _OpportunityFormState createState() => _OpportunityFormState();
}

class _OpportunityFormState extends State<OpportunityForm> {
  Map<String, dynamic> data = {
    "doctype": "Opportunity",
    "opportunity_from": "Customer",
    "posting_date": DateTime.now().toIso8601String(),
    "transaction_date": DateTime.now().toIso8601String(),
    "with_items": 0,
  };

  Map<String, dynamic> selectedCstData = {
  };
  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) return;

    if (_items.isEmpty && data['with_items'] == 1) {
      showSnackBar('Please add an item at least', context);
      return;
    }
    _formKey.currentState!.save();

    data['items'] = [];
    if (data['with_items'] == 1)
      _items.forEach((element) => data['items'].add(element.toJson));

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Opportunity');

    final server = APIService();

    // for (var k in data.keys) print("$k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(OPPORTUNITY_POST, {'data': data}),
        context);

    // for loading dialog message
    Navigator.pop(context);

    if (provider.isEditing) Navigator.pop(context);

    if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['opportunity'] != null)
        context.read<ModuleProvider>().pushPage(res['message']['opportunity']);
      Navigator.of(context)
          .push(MaterialPageRoute(
        builder: (_) => GenericPage(),
      ))
          .then((value) => Navigator.pop(context));
    }
    else if (res != null && res['message']['opportunity'] != null) {
      context.read<ModuleProvider>().pushPage(res['message']['opportunity']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
    }
  }

  quotationType _type = quotationType.customer;

  void changeType(String newType) {
    data['opportunity_from'] = newType;
    data['party_name'] = null;
    data['customer_name'] = null;
    data['territory'] = null;
    data['customer_group'] = null;
    data['customer_address'] = null;
    data['contact_person'] = null;

    data['source'] = null;
    data['campaign'] = null;

    if (newType == KQuotationToList.last)
      setState(() => _type = quotationType.customer);
    else if (newType == KQuotationToList.first)
      setState(() => _type = quotationType.lead);
  }

  final _controller = ScrollController();
  final List<ItemQuantity> _items = [];

  Future<void> _getCustomerData(String customer) async {
    selectedCstData = Map<String, dynamic>.from(
        await APIService().getPage(CUSTOMER_PAGE, customer))['message'];
  }

  @override
  void initState() {
    super.initState();

    //Editing Mode
    if (context.read<ModuleProvider>().isEditing){
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;

        final items = OpportunityPageModel(context, data).items;

        items.forEach((element) {
          final item = ItemSelectModel.fromJson(element);
          _items.add(ItemQuantity(item, qty: item.qty));
        });
        setState(() {});
      });
    }


    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;


        data['doctype']= "Opportunity";
        data['opportunity_from']= "Customer";
        data['posting_date']= DateTime.now().toIso8601String();
        data['transaction_date']= DateTime.now().toIso8601String();
        data['with_items']= 0;

        data['customer_name'] = data['lead_name'];
        data['party_name'] = data['lead_name'];
        data['lead_name'] = data['name'];
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
        data.remove('organization_lead');

        _getCustomerData(data['customer_name']).then((value) => setState(() {

          data['valid_till'] = DateTime.now()
              .add(Duration(
              days: int.parse((selectedCstData[
              'quotation_validaty_days']??"0").toString())))
              .toIso8601String();



          data['currency'] = selectedCstData['default_currency'] ;
          data['price_list_currency'] = selectedCstData['default_currency'] ;
          data['payment_terms_template'] = selectedCstData['payment_terms'] ;
          data['customer_address'] = selectedCstData["customer_primary_address"];
          data['contact_person'] = selectedCstData["customer_primary_contact"];


        }));

        setState(() {});
      });
    }
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
              ? Text("Edit Opportunity")
              : Text("Create Opportunity"),
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
          controller: _controller,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Group(
                  child: Column(
                    children: [
                      SizedBox(height: 4),
                      CustomDropDown('id', 'Opportunity From'.tr(),
                          items: KQuotationToList,
                          onChanged: changeType,
                          defaultValue:
                              data["opportunity_from"] ?? KQuotationToList[1]),
                      Divider(color: Colors.grey, height: 1, thickness: 0.7),
                      CustomTextField(
                        'party_name',
                        'Customer',
                        initialValue: data['party_name'],
                        onPressed: () async {
                          String? id;

                          if (_type == quotationType.customer) {
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        selectCustomerScreen()));
                            if (res != null) {
                              id = res['name'];
                              setState(() {
                                data['party_name'] = res['name'];
                                data['customer_name'] = res['customer_name'];
                                data['territory'] = res['territory'];
                                data['customer_group'] = res['customer_group'];
                                data['customer_address'] =
                                    res["customer_primary_address"];
                                data['contact_person'] =
                                    res["customer_primary_contact"];
                              });
                            }
                          } else if (_type == quotationType.lead) {
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => selectLeadScreen()));
                            if (res != null) {
                              id = res['name'];
                              setState(() {
                                data['party_name'] = res['name'];
                                data['customer_name'] = res['lead_name'];
                                data['territory'] = res['territory'];
                                data['source'] = res['source'];
                                data['campaign'] = res['campaign_name'];
                              });
                            }
                          } else {
                            showSnackBar('select quotation to first', context);
                          }
                          return id;
                        },
                      ),
                      if (data['customer_name'] != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(data['customer_name']!,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            )),
                      if (data['customer_name'] != null)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 2, right: 2),
                          child: Divider(
                              color: Colors.grey, height: 1, thickness: 0.7),
                        ),
                      DatePicker('transaction_date', 'Date'.tr(),
                          initialValue: data['transaction_date'],
                          onChanged: (value) =>
                              setState(() => data['transaction_date'] = value)),
                      if (_type == quotationType.customer)
                        CustomTextField('customer_group', 'Customer Group',
                            initialValue: data['customer_group'],
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => customerGroupScreen()))),
                      CustomTextField('territory', 'Territory'.tr(),
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['territory'],
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => territoryScreen()))),
                      if (_type == quotationType.customer)
                        CustomTextField('customer_address', 'Customer Address',
                            initialValue: data['customer_address'],
                            onSave: (key, value) => data[key] = value,
                            liestenToInitialValue:
                                data['customer_address'] == null,
                            onPressed: () async {
                              if (data['party_name'] == null)
                                return showSnackBar(
                                    'Please select a customer to first',
                                    context);

                              final res = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => customerAddressScreen(
                                          data['party_name'])));
                              data['customer_address'] = res;
                              return res;
                            }),
                      if (_type == quotationType.customer)
                        CustomTextField('contact_person', 'Contact Person',
                            initialValue: data['contact_person'],
                            disableValidation: true,
                            onSave: (key, value) => data[key] = value,
                            onPressed: () async {
                              if (data['customer_name'] == null) {
                                showSnackBar(
                                    'Please select a customer', context);
                                return null;
                              }
                              final res = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          contactScreen(data['party_name'])));
                              return res;
                            }),
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
                      SizedBox(height: 4),
                      if (_type == quotationType.lead)
                        CustomTextField('campaign', 'Campaign',
                            onSave: (key, value) => data[key] = value,
                            initialValue: data['campaign'],
                            disableValidation: true,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => campaignScreen()))),
                      if (_type == quotationType.lead)
                        CustomTextField('source', 'Source',
                            onSave: (key, value) => data[key] = value,
                            initialValue: data['source'],
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => sourceScreen()))),
                      CustomTextField('opportunity_type', 'Opportunity Type',
                          initialValue: data['opportunity_type'],
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => opportunityTypeScreen()))),
                      //TODO: convert to User list screen
                      CustomTextField('contact_by', 'Next Contact By'.tr(),
                          initialValue: data['contact_by'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => userListScreen()))),
                      DatePicker('contact_date', tr('Next Contact Date'),
                          initialValue: data['contact_date'],
                          disableValidation: true,
                          onChanged: (value) =>
                              setState(() => data['contact_date'] = value)),
                      CustomTextField('to_discuss', 'To Discuss'.tr(),
                          initialValue: data['to_discuss'],
                          onSave: (key, value) => data[key] = value),
                      CheckBoxWidget('with_items', 'With Items'.tr(),
                          initialValue: data['with_items'] == 1 ? true : false,
                          onChanged: (id, value) {
                        setState(() => data[id] = value ? 1 : 0);
                        if (value)
                          Future.delayed(Duration(milliseconds: 100))
                              .then((value) => _controller.animateTo(
                                    _controller.position.pixels + 200,
                                    curve: Curves.easeOut,
                                    duration: const Duration(milliseconds: 500),
                                  ));
                      }),
                    ],
                  ),
                ),

                SizedBox(height: 8),
                Container(
                    // duration: Duration(seconds: 2),
                    height: data['with_items'] == 1 ? null : 0,
                    child: Column(
                      children: [
                        Card(
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Items',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(
                                      width: 40,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero),
                                        onPressed: () async {
                                          final res =
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          itemListScreen('')));
                                          if (res != null &&
                                              !_items.contains(res))
                                            setState(() => _items.add(
                                                ItemQuantity(res, qty: 0)));
                                        },
                                        child: Icon(Icons.add,
                                            size: 25, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.55),
                            child: _items.isEmpty
                                ? Center(
                                    child: Text('no items added',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 16)))
                                : ListView.builder(
                                physics: BouncingScrollPhysics(),

                                    padding: const EdgeInsets.only(bottom: 12),
                                    itemCount: _items.length,
                                    itemBuilder: (context, index) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            bottom:
                                                                Radius.circular(
                                                                    8)),
                                                    border: Border.all(
                                                        color: Colors.blue)),
                                                margin: const EdgeInsets.only(
                                                    bottom: 8.0,
                                                    left: 16,
                                                    right: 16),
                                                padding: const EdgeInsets.only(
                                                    left: 16, right: 16),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: CustomTextField(
                                                      _items[index].itemCode +
                                                          'Quantity',
                                                      'Quantity',
                                                      initialValue:
                                                          _items[index].qty == 0
                                                              ? null
                                                              : _items[index]
                                                                  .qty
                                                                  .toString(),
                                                      validator: (value) =>
                                                          numberValidationToast(
                                                              value, 'Quantity',
                                                              isInt: true),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      disableError: true,
                                                      onSave: (_, value) =>
                                                          _items[index].qty =
                                                              int.parse(value),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 62),
                                                child: Dismissible(
                                                  key: Key(
                                                      _items[index].itemCode),
                                                  direction: DismissDirection
                                                      .endToStart,
                                                  onDismissed: (_) => setState(
                                                      () => _items
                                                          .removeAt(index)),
                                                  background: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: Colors.red),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: Icon(
                                                          Icons.delete_forever,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  child: ItemCard(
                                                      names: const [
                                                        'Code',
                                                        'Group',
                                                        'UoM'
                                                      ],
                                                      values: [
                                                        _items[index].itemName,
                                                        _items[index].itemCode,
                                                        _items[index].group,
                                                        _items[index].stockUom
                                                      ],
                                                      imageUrl: _items[index]
                                                          .imageUrl),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                          ),
                        )
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
