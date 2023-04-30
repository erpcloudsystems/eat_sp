import 'package:NextApp/models/list_models/project_list_models/project_list_model.dart';
import 'package:NextApp/new_version/core/extensions/status_converter.dart';

import '../../models/list_models/project_list_models/issue_list_model.dart';
import '../../models/list_models/project_list_models/task_list_model.dart';
import '../../models/list_models/project_list_models/timesheet_list_model.dart';
import '../../new_version/core/resources/strings_manager.dart';
import '../../screen/form/project_forms/issue_form.dart';
import '../../screen/form/project_forms/project_form.dart';
import '../../screen/form/project_forms/task_form.dart';
import '../../screen/form/project_forms/timesheet_form.dart';
import '../../screen/form/stock_forms/item_form.dart';
import '../../screen/form/stock_forms/stock_entry_form.dart';
import '../../screen/page/project_pages/issue_page.dart';
import '../../screen/page/project_pages/project_page.dart';
import '../../screen/page/project_pages/task_page.dart';
import '../../screen/page/project_pages/timesheet_page.dart';
import '../../screen/page/stock_pages/delivery_note_page.dart';
import '../../screen/page/selling_pages/opportunity_page.dart';
import '../../widgets/filter_widgets/project_filters/issue_filter.dart';
import '../../widgets/filter_widgets/project_filters/project_filter.dart';
import '../../widgets/filter_widgets/project_filters/task_filter.dart';
import '../../widgets/filter_widgets/project_filters/timesheet_filter.dart';
import '../../widgets/filter_widgets/selling_filters/Quotation_filter.dart';
import '../../widgets/filter_widgets/selling_filters/address_filter.dart';
import '../../widgets/filter_widgets/selling_filters/cusotmer_filter.dart';
import '../../widgets/filter_widgets/stock_filters/delivery_note_filter.dart';
import '../../widgets/filter_widgets/stock_filters/item_filter.dart';
import '../../widgets/filter_widgets/selling_filters/lead_filter.dart';
import '../../widgets/filter_widgets/selling_filters/opportunity_filter.dart';
import '../../widgets/filter_widgets/selling_filters/payment_entry_filter.dart';
import '../../widgets/filter_widgets/selling_filters/sales_invoice_filter.dart';
import '../../widgets/filter_widgets/selling_filters/sales_order_filter.dart';
import '../../widgets/filter_widgets/stock_filters/stock_entry_filter.dart';
import '../../widgets/inherited_widgets/contact/add_phone.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/list_models/buying_list_models/purchase_order_list_model.dart';
import '../../models/list_models/buying_list_models/supplier_list_model.dart';
import '../../models/list_models/buying_list_models/supplier_quotation_list_model.dart';
import '../../models/list_models/hr_list_model/attendance_request_list_model.dart';
import '../../models/list_models/hr_list_model/employee_advance_list_model.dart';
import '../../models/list_models/hr_list_model/employee_checkin_list_model.dart';
import '../../models/list_models/hr_list_model/employee_list_model.dart';
import '../../models/list_models/hr_list_model/expense_claim_list_model.dart';
import '../../models/list_models/hr_list_model/journal_entry_list_model.dart';
import '../../models/list_models/hr_list_model/leave_application_list_model.dart';
import '../../models/list_models/hr_list_model/loan_application_list_model.dart';
import '../../models/list_models/selling_list_model/address_list_model.dart';
import '../../models/list_models/selling_list_model/contact_list_model.dart';
import '../../models/list_models/selling_list_model/customer_visit_list_model.dart';
import '../../screen/form/buying_forms/purchase_invoce_form.dart';
import '../../screen/form/buying_forms/purchase_order_form.dart';
import '../../screen/form/buying_forms/supplier_form.dart';
import '../../screen/form/buying_forms/supplier_quotation_form.dart';
import '../../screen/form/hr_forms/attendance_request_form.dart';
import '../../screen/form/hr_forms/employee_advance_form.dart';
import '../../screen/form/hr_forms/employee_checkin_form.dart';
import '../../screen/form/hr_forms/employee_form.dart';
import '../../screen/form/hr_forms/expense_claim_form.dart';
import '../../screen/form/account_forms/journal_entry_form.dart';
import '../../screen/form/hr_forms/leave_application_form.dart';
import '../../screen/form/hr_forms/loan_application_form.dart';
import '../../screen/form/selling_forms/address_form.dart';
import '../../screen/form/selling_forms/contact_form.dart';
import '../../screen/form/selling_forms/customer_visit_form.dart';
import '../../screen/form/stock_forms/material_request_form.dart';
import '../../screen/form/stock_forms/purchase_receipt_form.dart';
import '../../screen/page/buying_pages/purchase_invoice_page.dart';
import '../../screen/page/buying_pages/purchase_order_page.dart';
import '../../screen/page/buying_pages/supplier_page.dart';
import '../../screen/page/buying_pages/supplier_quotation_page.dart';
import '../../screen/page/hr_pages/attendance_request_page.dart';
import '../../screen/page/hr_pages/employee_advance_page.dart';
import '../../screen/page/hr_pages/employee_checkin_page.dart';
import '../../screen/page/hr_pages/employee_page.dart';
import '../../screen/page/hr_pages/expense_claim_page.dart';
import '../../screen/page/hr_pages/journal_entry_page.dart';
import '../../screen/page/hr_pages/leave_application_page.dart';
import '../../screen/page/hr_pages/loan_application_page.dart';
import '../../screen/page/selling_pages/address_page.dart';
import '../../screen/page/selling_pages/contact_page.dart';
import '../../screen/page/selling_pages/customer_visit_page.dart';
import '../../screen/page/stock_pages/material_request_page.dart';
import '../../screen/page/stock_pages/purchase_receipt_page.dart';
import '../../widgets/inherited_widgets/add_account_list.dart';
import '../../widgets/inherited_widgets/add_expenses_list.dart';
import '../../widgets/filter_widgets/accounts_filters/journal_entry_filter.dart';
import '../../widgets/filter_widgets/buying_filters/purchase_invoice_filter.dart';
import '../../widgets/filter_widgets/buying_filters/purchase_order_filter.dart';
import '../../widgets/filter_widgets/buying_filters/supplier_filter.dart';
import '../../widgets/filter_widgets/buying_filters/supplier_quotation_filter.dart';
import '../../widgets/filter_widgets/hr_filters/attendance_request_filter.dart';
import '../../widgets/filter_widgets/hr_filters/employee_advance_filter.dart';
import '../../widgets/filter_widgets/hr_filters/employee_checkin_filter.dart';
import '../../widgets/filter_widgets/hr_filters/employee_filter.dart';
import '../../widgets/filter_widgets/hr_filters/expense_claim_filter.dart';
import '../../widgets/filter_widgets/hr_filters/leave_application_filter.dart';
import '../../widgets/filter_widgets/hr_filters/loan_application_filter.dart';
import '../../widgets/filter_widgets/selling_filters/contact_filter.dart';
import '../../widgets/filter_widgets/selling_filters/customer_visit_filter.dart';
import '../../widgets/filter_widgets/stock_filters/material_request_filter.dart';
import '../../widgets/filter_widgets/stock_filters/purchase_receipt_filter.dart';
import '../../widgets/inherited_widgets/item/add_uom_list.dart';
import 'module_provider.dart';
import '../../screen/form/selling_forms/customer_form.dart';
import '../../screen/form/stock_forms/delivery_note_form.dart';
import '../../screen/form/selling_forms/lead_form.dart';
import '../../screen/form/selling_forms/opportunity_form.dart';
import '../../screen/form/selling_forms/payment_entry_form.dart';
import '../../screen/form/selling_forms/quotation_form.dart';
import '../../screen/form/selling_forms/sales_invoice_form.dart';
import '../../screen/form/selling_forms/sales_order_form.dart';
import '../../screen/page/selling_pages/customer_page.dart';
import '../../screen/page/generic_page.dart';
import '../../screen/page/stock_pages/item_page.dart';
import '../../screen/page/selling_pages/lead_page.dart';
import '../../screen/page/selling_pages/payment_entry_page.dart';
import '../../screen/page/selling_pages/quotation_page.dart';
import '../../screen/page/selling_pages/sales_invoice_page.dart';
import '../../screen/page/selling_pages/sales_order_page.dart';
import '../../screen/page/stock_pages/stock_entry_page.dart';
import '../../widgets/item_card.dart';
import '../../widgets/list_card.dart';
import '../../widgets/inherited_widgets/select_items_list.dart';
import '../../core/constants.dart';
import '../../models/list_models/buying_list_models/purchase_invoice_list_model.dart';
import '../../models/list_models/selling_list_model/customer_list_model.dart';
import '../../models/list_models/stock_list_model/delivery_note_model.dart';
import '../../models/list_models/stock_list_model/item_table_model.dart';
import '../../models/list_models/selling_list_model/lead_list_model.dart';
import '../../models/list_models/list_model.dart';
import '../../models/list_models/material_list_model.dart';
import '../../models/list_models/selling_list_model/opportunity_list_model.dart';
import '../../models/list_models/order_list_model.dart';
import '../../models/list_models/selling_list_model/payment_entry_model.dart';
import '../../models/list_models/stock_list_model/purchase_receipt_list_model.dart';
import '../../models/list_models/selling_list_model/quotation_list_model.dart';
import '../../models/list_models/selling_list_model/sales_invoice_list_model.dart';
import '../../models/list_models/stock_list_model/stock_entry_list_model.dart';
import '../../models/page_models/model_functions.dart';
import '../../service/service_constants.dart';
import '../../new_version/core/extensions/date_tine_extension.dart';

class ModuleType {
  final String _genericListService, _title, _pageService;
  //int _listCount = PAGINATION_PAGE_LENGTH;

  final Widget Function(dynamic) _listItem;

  final Widget? _createForm;

  final void Function(Map)? _editPage;

  final ListModel Function(Map<String, dynamic>) _serviceParser;

  final Widget _pageWidget;

  final Widget? _filter;

  // getters

  String get genericListService => _genericListService;

  String get pageService => _pageService;

  String get title => _title;

  Widget Function(dynamic) get listItem => _listItem;

  Widget? get createForm => _createForm;

  Function(Map)? get editPage => _editPage;

  ListModel Function(Map<String, dynamic>) get serviceParser => _serviceParser;

  Widget get pageWidget => _pageWidget;

  Widget? get filterWidget => _filter;

  const ModuleType._({
    required genericListService,
    required title,
    required Widget Function(dynamic) listItem,
    createForm,
    Widget? filter,
    required editPage,
    required ListModel Function(Map<String, dynamic>) serviceParser,
    required pageService,
    required pageWidget,
  })  : this._genericListService = genericListService,
        this._title = title,
        this._listItem = listItem,
        this._createForm = createForm,
        this._editPage = editPage,
        this._serviceParser = serviceParser,
        this._pageService = pageService ?? '',
        this._filter = filter,
        this._pageWidget = pageWidget ?? const SizedBox();

  /// check if it's first time to push a page_models or not
  static bool isFirstRoute(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;

    return routeName == null;
  }

  /// calculate total vat on the item
  static double _calculateVat(String taxTemplate, double price) {
    final tax =
        double.tryParse(taxTemplate.substring(0, taxTemplate.length - 1));
    if (tax == null) return 0;
    return price * (tax / 100 * price);
  }

  /// converts '14%' to 14.0
  static double _taxPercent(String tax) {
    return double.tryParse(tax.substring(0, tax.length - 1)) ?? 0;
  }

  static void _onListCardPressed(BuildContext context, String pageId) {
    context.read<ModuleProvider>().pushPage(pageId);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GenericPage(),
      settings:
          isFirstRoute(context) ? null : RouteSettings(name: CONNECTION_ROUTE),
    ));
  }

  // Selling
  static final lead = ModuleType._(
    genericListService: 'Lead',
    title: 'Lead',
    listItem: (item) {
      item as LeadItemModel;
      return ListCard(
        id: item.id,
        title: item.name,
        status: item.status,
        names: [
          'Company'.tr(),
          'Territory'.tr(),
          'Source'.tr(),
          'Segment'.tr()
        ],
        values: [
          item.companyName,
          item.territory,
          item.source,
          item.marketSegment
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: LeadForm(),
    serviceParser: (data) => LeadListModel.fromJson(data),
    pageService: LEAD_PAGE,
    pageWidget: LeadPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Quotation"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();

      // return InheritedForm(child: QuotationForm(), items: items);
    },
    filter: LeadFilter(),
  );

  static final opportunity = ModuleType._(
      genericListService: 'Opportunity',
      title: 'Opportunity',
      listItem: (item) {
        item as OpportunityItemModel;
        return ListCard(
          id: item.id,
          title: item.customerName,
          status: item.status,
          names: [
            'Opportunity'.tr(),
            'Date'.tr(),
            'Type'.tr(),
            'Sales Stage'.tr()
          ],
          values: [
            item.opportunityFrom,
            '${item.transactionDate.day}/${item.transactionDate.month}/${item.transactionDate.year}',
            item.opportunityType,
            item.salesStage
          ],
          onPressed: (context) => _onListCardPressed(context, item.id),
        );
      },
      createForm: InheritedForm(child: OpportunityForm()),
      serviceParser: (data) => OpportunityListModel.fromJson(data),
      editPage: (pageData) {
        pageData["doctype"] = ["Quotation"];
        var items;
        items = List<Map<String, dynamic>>.from(pageData['items']);
        items = items.map((e) {
          e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
          e['tax_percent'] = _taxPercent(e['item_tax_template']);
          return ItemSelectModel.fromJson(e);
        }).toList();

        // return InheritedForm(child: QuotationForm(), items: items);
      },
      filter: OpportunityFilter(),
      pageService: OPPORTUNITY_PAGE,
      pageWidget: OpportunityPage());

  static final customer = ModuleType._(
    genericListService: 'Customer',
    title: 'Customer',
    listItem: (item) {
      item as CustomerItemModel;
      return ListCard(
        id: item.id,
        title: item.name,
        status: item.status,
        names: [
          'Group'.tr(),
          'Type'.tr(),
          'Currency'.tr(),
          'Territory'.tr(),
          'Mobile'.tr()
        ],
        values: [
          item.customerGroup,
          item.customerType,
          item.currency,
          item.territory,
          item.mobile
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: CustomerForm(),
    serviceParser: (data) => CustomerListModel.fromJson(data),
    pageService: CUSTOMER_PAGE,
    pageWidget: CustomerPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Customer"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();
    },
    filter: CustomerFilter(),
  );

  static final quotation = ModuleType._(
      genericListService: 'Quotation',
      title: 'Quotation',
      listItem: (item) {
        item as QuotationItemModel;
        return ListCard(
            id: item.id,
            title: item.customerName,
            status: item.status,
            names: [
              'Quotation To'.tr(),
              'Date'.tr(),
              'Total'.tr() + ' (${item.currency})'
            ],
            onPressed: (context) => _onListCardPressed(context, item.id),
            values: [
              item.quotationTo,
              formatDate(item.transactionDate),
              currency(item.grandTotal)
            ]);
      },
      createForm: InheritedForm(child: QuotationForm()),
      serviceParser: (data) => QuotationListModel.fromJson(data),
      pageService: QUOTATION_PAGE,
      pageWidget: QuotationPage(),
      editPage: (pageData) {
        pageData["doctype"] = ["Quotation"];
        var items;
        items = List<Map<String, dynamic>>.from(pageData['items']);
        items = items.map((e) {
          e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
          e['tax_percent'] = _taxPercent(e['item_tax_template']);
          return ItemSelectModel.fromJson(e);
        }).toList();
      },
      filter: QuotationFilter());

  static final salesOrder = ModuleType._(
    genericListService: 'Sales Order',
    title: 'Sales Order',
    listItem: (item) {
      item as OrderItemModel;
      return ListCard(
        title: item.customerName,
        status: item.status,
        id: item.id,
        names: ['Address', 'Date'.tr(), 'Total' + ' (${item.currency})'],
        values: [
          item.customerAddress,
          formatDate(item.transactionDate),
          currency(item.grandTotal).toString()
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: InheritedForm(child: SalesOrderForm()),
    serviceParser: (data) => OrderListModel.fromJson(data),
    pageService: SALES_ORDER_PAGE,
    pageWidget: SalesOrderPage(),
    filter: new SalesOrderFilter(),
    editPage: (pageData) {
      pageData["doctype"] = ["Quotation"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();
    },
  );

  static final salesInvoice = ModuleType._(
    genericListService: 'Sales Invoice',
    title: 'Sales Invoice',
    listItem: (item) {
      item as SalesInvoiceItemModel;
      return ListCard(
        id: item.id,
        title: item.customerName,
        status: item.status,
        names: [
          'Address'.tr(),
          'Posting Date'.tr(),
          'Total'.tr() + ' (${item.currency})'
        ],
        values: [
          item.customerAddress,
          '${item.postingDate.day}/${item.postingDate.month}/${item.postingDate.year}',
          currency(item.grandTotal).toString()
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: InheritedForm(child: SalesInvoiceForm()),
    serviceParser: (data) => SalesInvoiceListModel.fromJson(data),
    pageService: SALES_INVOICE_PAGE,
    pageWidget: SalesInvoicePage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Quotation"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();
    },
    filter: SalesInvoiceFilter(),
  );

  static final paymentEntry = ModuleType._(
    genericListService: 'Payment Entry',
    title: 'Payment Entry',
    listItem: (item) {
      item as PaymentEntryItem;
      return ListCard(
        title: item.partyName,
        id: item.id,
        status: item.status,
        names: [
          'Payment Type'.tr(),
          'Mode Of Payment'.tr(),
          'Date'.tr(),
          'Amount '.tr() + '(${item.currency})'
        ],
        values: [
          item.paymentType,
          item.modeOfPayment,
          formatDate(item.postingDate),
          currency(item.paidAmount)
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: PaymentForm(),
    serviceParser: (data) => PaymentEntryModel.fromJson(data),
    pageService: PAYMENT_ENTRY_PAGE,
    pageWidget: PaymentEntryPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Quotation"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();

      // return InheritedForm(child: QuotationForm(), items: items);
    },
    filter: PaymentEntryFilter(),
  );

  static final customerVisit = ModuleType._(
    genericListService: 'Customer Visit',
    title: 'Customer Visit',
    listItem: (item) {
      item as CustomerVisitItemModel;
      return ListCard(
        id: item.id,
        title: item.customer,
        status: item.status.convertStatusToString(),
        names: [
          'Customer Address'.tr(),
          'Posting Date'.tr(),
          'Time'.tr(),
        ],
        values: [
          item.customerAddress,
          '${item.postingDate.day}/${item.postingDate.month}/${item.postingDate.year}',
          item.time,
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: CustomerVisitForm(),
    serviceParser: (data) => CustomerVisitListModel.fromJson(data),
    pageService: CUSTOMER_VISIT_PAGE,
    pageWidget: CustomerVisitPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Quotation"];
    },
    filter: CustomerVisitFilter(),
  );

  static final address = ModuleType._(
    genericListService: 'Address',
    title: 'Address',
    listItem: (item) {
      item as AddressItemModel;
      return ListCard(
        id: item.id,
        title: item.addressTitle,
        status: item.status,
        names: [
          'Address Type'.tr(),
          'Address Line1'.tr(),
          'city'.tr(),
          'Country'.tr(),
          'Link Doctype'.tr(),
          'Link Name'.tr(),
        ],
        values: [
          item.addressType,
          item.addressLine1,
          item.city,
          item.country,
          item.linkDocType,
          item.linkName,
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: AddressForm(),
    serviceParser: (data) => AddressListModel.fromJson(data),
    pageService: ADDRESS_PAGE,
    pageWidget: AddressPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Address"];
    },
    filter: AddressFilter(),
  );

  static final contact = ModuleType._(
    genericListService: 'Contact',
    title: 'Contact',
    listItem: (item) {
      item as ContactItemModel;
      return ListCard(
        id: item.id,
        title: item.firstName,
        status: item.status,
        names: [
          'User'.tr(),
          'Mobile No'.tr(),
          'Phone'.tr(),
          'Email ID'.tr(),
          'Link Doctype'.tr(),
          'Link Name'.tr(),
        ],
        values: [
          item.user,
          item.mobileNo,
          item.emailId,
          item.emailId,
          item.linkDoctype,
          item.linkName,
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: InheritedContactForm(child: ContactForm()),
    serviceParser: (data) => ContactListModel.fromJson(data),
    pageService: CONTACT_PAGE,
    pageWidget: ContactPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Contact"];
    },
    filter: ContactFilter(),
  );

  // Stock
  static final item = ModuleType._(
    genericListService: 'Item',
    title: 'Item',
    listItem: (item) {
      item as ItemModel;
      return ItemCard(
        imageUrl: item.imageUrl,
        values: [item.itemName, item.itemCode, item.group, item.stockUom],
        onPressed: (context) => _onListCardPressed(context, item.itemCode),
      );
    },
    createForm: InheritedUOMForm(child: ItemForm()),
    editPage: (pageData) {
      pageData["doctype"] = ["Item"];
    },
    serviceParser: (data) => ItemTableModel.fromJson(data),
    pageService: ITEM_PAGE,
    pageWidget: ItemPage(),
    filter: ItemFilter(),
  );

  static final stockEntry = ModuleType._(
    genericListService: 'Stock Entry',
    title: 'Stock Entry',
    listItem: (item) {
      item as StockEntryItemModel;
      return ListCard(
        id: item.id,
        title: item.stockEntryType,
        names: ['From Warehouse'.tr(), 'To Warehouse'.tr(), 'Date'.tr()],
        status: mapStatus(item.docStatus),
        values: [
          item.fromWarehouse,
          item.toWarehouse,
          formatDate(item.postingDate)
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: StockEntryForm(),
    serviceParser: (data) => StockEntryListModel.fromJson(data),
    pageService: STOCK_ENTRY_PAGE,
    pageWidget: StockEntryPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Stock Entry"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();

      // return InheritedForm(child: QuotationForm(), items: items);
    },
    filter: StockEntryFilter(),
  );

  static final deliveryNote = ModuleType._(
    genericListService: 'Delivery Note',
    title: 'Delivery Note',
    listItem: (item) {
      item as DeliveryNoteItemModel;
      return ListCard(
        id: item.id,
        title: item.customer,
        status: item.status,
        names: [
          'Territory'.tr(),
          'Date'.tr(),
          'Warehouse'.tr(),
          'Currency'.tr()
        ],
        values: [
          item.territory,
          formatDate(item.postingDate),
          item.setWarehouse,
          item.currency
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: InheritedForm(child: DeliveryNoteForm()),
    serviceParser: (data) => DeliveryNoteModel.fromJson(data),
    pageService: DELIVERY_NOTE_PAGE,
    pageWidget: DeliveryNotePage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Delivery Note"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();

      // return InheritedForm(child: QuotationForm(), items: items);
    },
    filter: DeliveryNoteFilter(),
  );

  static final purchaseReceipt = ModuleType._(
    genericListService: 'Purchase Receipt',
    title: 'Purchase Receipt',
    listItem: (item) {
      item as PurchaseReceiptItemModel;
      return ListCard(
        id: item.id,
        title: item.supplier,
        names: [
          'Warehouse'.tr(),
          'Date'.tr(),
        ],
        values: [
          item.setWarehouse,
          formatDate(item.postingDate),
        ],
        status: item.status,
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: InheritedForm(child: PurchaseReceiptForm()),
    serviceParser: (data) => PurchaseReceiptListModel.fromJson(data),
    pageService: PURCHASE_RECEIPT_PAGE,
    pageWidget: PurchaseReceiptPage(),
    editPage: (pageData) {
      //TODO Check @Run
      pageData["doctype"] = ["Purchase Receipt"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        print(
            '☠️ inModule_type editPage: $e !!! check this vat_value: ${e['vat_value']} & tax_percent :${e['tax_percent']}');
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();
    },
    filter: PurchaseReceiptFilter(),
  );

  static final materialRequest = ModuleType._(
    genericListService: 'Material Request',
    title: 'Material Request',
    listItem: (item) {
      item as MaterialItemModel;
      return ListCard(
        id: item.id,
        title: item.setWarehouse,
        status: item.status,
        names: ['Request Type', 'Date'.tr()],
        values: [item.requestType, formatDate(item.transactionDate)],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: InheritedForm(child: MaterialRequestForm()),
    serviceParser: (data) => MaterialListModel.fromJson(data),
    pageService: MATERIAL_REQUEST_PAGE,
    pageWidget: MaterialRequestPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Stock Entry"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();

      // return InheritedForm(child: QuotationForm(), items: items);
    },
    filter: MaterialRequestFilter(),
  );

  //Buying
  static final supplier = ModuleType._(
    genericListService: 'Supplier',
    title: 'Supplier',
    listItem: (item) {
      item as SupplierItemModel;
      return ListCard(
        id: item.id,
        title: item.name,
        status: item.status,
        names: [
          'Group'.tr(),
          'Type'.tr(),
          'Currency'.tr(),
          'Country'.tr(),
          'Mobile'.tr()
        ],
        values: [
          item.supplierGroup,
          item.supplierType,
          item.currency,
          item.country,
          item.mobile
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: SupplierForm(),
    serviceParser: (data) => SupplierListModel.fromJson(data),
    pageService: SUPPLIER_PAGE,
    pageWidget: SupplierPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Supplier"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();

      // return InheritedForm(child: QuotationForm(), items: items);
    },
    filter: SupplierFilter(),
  );

  static final supplierQuotation = ModuleType._(
    genericListService: 'Supplier Quotation',
    title: 'Supplier Quotation',
    listItem: (item) {
      item as SupplierQuotationItemModel;
      return ListCard(
        id: item.id,
        title: item.name,
        status: item.status,
        names: [
          'Transaction Date'.tr(),
          'Valid Till'.tr(),
          'Total'.tr() + ' (${item.currency})',
        ],
        values: [
          item.transactionDate,
          item.validTill,
          currency(item.grandTotal).toString() + ' (${item.currency})'
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: InheritedForm(child: SupplierQuotationForm()),
    serviceParser: (data) => SupplierQuotationListModel.fromJson(data),
    pageService: SUPPLIER_QUOTATION_PAGE,
    pageWidget: SupplierQuotationPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Supplier Quotation"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();
    },
    filter: SupplierQuotationFilter(),
  );

  static final purchaseInvoice = ModuleType._(
    genericListService: 'Purchase Invoice',
    title: 'Purchase Invoice',
    listItem: (item) {
      item as PurchaseInvoiceItemModel;
      return ListCard(
        id: item.id,
        title: item.name,
        status: item.status,
        names: [
          'Posting Date'.tr(),
          'Total'.tr() + ' (${item.currency})',
        ],
        values: [
          '${item.postingDate.day}/${item.postingDate.month}/${item.postingDate.year}',
          currency(item.grandTotal).toString()
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: InheritedForm(child: PurchaseInvoiceForm()),
    serviceParser: (data) => PurchaseInvoiceListModel.fromJson(data),
    pageService: PURCHASE_INVOICE_PAGE,
    pageWidget: PurchaseInvoicePage(),
    editPage: (pageData) {
      //TODO Check @Run
      pageData["doctype"] = ["Purchase Invoice"];
      var items;
      items =
          List<Map<String, dynamic>>.from(pageData['purchase_invoice_item']);
      //items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        //TODO check Later
        print(
            '☠️ inModule_type editPage: $e !!! check this vat_value: ${e['vat_value']} & tax_percent :${e['tax_percent']}');
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();

      // return InheritedForm(child: QuotationForm(), items: items);
    },
    filter: PurchaseInvoiceFilter(),
  );

  static final purchaseOrder = ModuleType._(
    genericListService: 'Purchase Order',
    title: 'Purchase Order',
    listItem: (item) {
      item as PurchaseOrderItemModel;
      return ListCard(
        id: item.id,
        title: item.name,
        status: item.status,
        names: [
          'Transaction Date'.tr(),
          'Warehouse'.tr(),
          'Total'.tr() + ' (${item.currency})'
        ],
        values: [
          '${item.transactionDate.day}/${item.transactionDate.month}/${item.transactionDate.year}',
          item.setWarehouse,
          currency(item.grandTotal).toString()
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: InheritedForm(child: PurchaseOrderForm()),
    serviceParser: (data) => PurchaseOrderListModel.fromJson(data),
    pageService: PURCHASE_ORDER_PAGE,
    pageWidget: PurchaseOrderPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Purchase Order"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['purchase_order_items']);
      items = items.map((e) {
        print(
            '☠️ inModule_type editPage: $e !!! check this vat_value: ${e['vat_value']} & tax_percent :${e['tax_percent']}');
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();
    },
    filter: PurchaseOrderFilter(), //TODO (waiting for backend)
  );

  // HR

  static final employee = ModuleType._(
    genericListService: 'Employee',
    title: 'Employee',
    listItem: (item) {
      item as EmployeeItemModel;
      return ListCard(
        id: item.id,
        title: item.name,
        status: item.status,
        names: [
          'branch'.tr(),
          'Designation'.tr(),
          'Attendance Device Id'.tr(),
          'Department'.tr(),
        ],
        values: [
          item.branch,
          item.designation,
          item.attendanceDeviceId,
          item.department,
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: EmployeeForm(),
    serviceParser: (data) => EmployeeListModel.fromJson(data),
    pageService: EMPLOYEE_PAGE,
    pageWidget: EmployeePage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Employee"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();

      // return InheritedForm(child: QuotationForm(), items: items);
    },
    filter: EmployeeFilter(),
  );

  static final leaveApplication = ModuleType._(
    genericListService: 'Leave Application',
    title: 'Leave Application',
    listItem: (item) {
      item as LeaveApplicationItemModel;
      return ListCard(
        id: item.id,
        title: item.name,
        status: item.status,
        names: [
          'Department'.tr(),
          'From Date'.tr(),
          'To Date'.tr(),
          'Total Leave Days'.tr(),
          'Leave Type'.tr(),
        ],
        values: [
          item.department,
          '${item.fromDate.day}/${item.fromDate.month}/${item.fromDate.year}',
          '${item.toDate.day}/${item.toDate.month}/${item.toDate.year}',
          item.totalLeaveDays.toString(),
          item.leaveType,
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: InheritedForm(child: LeaveApplicationForm()),
    serviceParser: (data) => LeaveApplicationListModel.fromJson(data),
    pageService: LEAVE_APPLICATION_PAGE,
    pageWidget: LeaveApplicationPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Leave Application"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();

      // return InheritedForm(child: QuotationForm(), items: items);
    },
    filter: LeaveApplicationFilter(),
  );

  static final employeeCheckin = ModuleType._(
    genericListService: 'Employee Checkin',
    title: 'Employee Checkin',
    listItem: (item) {
      item as EmployeeCheckinItemModel;
      return ListCard(
        id: item.id,
        title: item.name,
        status: item.status,
        names: [
          'Employee Id'.tr(),
          'Log Type'.tr(),
          'Time'.tr(),
          'Shift'.tr(),
          'Device Id'.tr(),
        ],
        values: [
          item.employee,
          item.logType,
          '${item.time.hour}:${item.time.minute}}',
          item.shift,
          item.deviceId.toString(),
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: InheritedForm(child: EmployeeCheckinFrom()),
    serviceParser: (data) => EmployeeCheckinListModel.fromJson(data),
    pageService: EMPLOYEE_CHECKIN_PAGE,
    pageWidget: EmployeeCheckinPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Employee Checkin"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();

      // return InheritedForm(child: QuotationForm(), items: items);
    },
    filter: EmployeeCheckinFilter(),
  );

  static final attendanceRequest = ModuleType._(
    genericListService: 'Attendance Request',
    title: 'Attendance Request',
    listItem: (item) {
      item as AttendanceRequestItemModel;
      return ListCard(
        id: item.id,
        title: item.name,
        status: item.docStatus,
        names: [
          'Employee Id'.tr(),
          'From Date'.tr(),
          'To Date'.tr(),
          'Reason'.tr(),
          'Department'.tr(),
        ],
        values: [
          item.employee,
          '${item.fromDate.day}/${item.fromDate.month}/${item.fromDate.year}',
          '${item.toDate.day}/${item.toDate.month}/${item.toDate.year}',
          item.reason,
          item.department,
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: InheritedForm(child: AttendanceRequestForm()),
    serviceParser: (data) => AttendanceRequestListModel.fromJson(data),
    pageService: ATTENDANCE_REQUEST_PAGE,
    pageWidget: AttendanceRequestPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Attendance Request"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();
    },
    filter: AttendanceRequestFilter(),
  );

  static final employeeAdvance = ModuleType._(
    genericListService: 'Employee Advance',
    title: 'Employee Advance',
    listItem: (item) {
      item as EmployeeAdvanceItemModel;
      return ListCard(
        id: item.id,
        title: item.name,
        status: item.status,
        names: [
          'Employee'.tr(),
          'Posting Date'.tr(),
          'Purpose'.tr(),
          'Department'.tr(),
        ],
        values: [
          item.employee,
          '${item.postingDate.day}/${item.postingDate.month}/${item.postingDate.year}',
          item.purpose,
          item.department,
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: EmployeeAdvanceForm(),
    serviceParser: (data) => EmployeeAdvanceListModel.fromJson(data),
    pageService: EMPLOYEE_ADVANCE_PAGE,
    pageWidget: EmployeeAdvancePage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Employee Advance"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();
    },
    filter: EmployeeAdvanceFilter(),
  );

  static final expenseClaim = ModuleType._(
    genericListService: 'Expense Claim',
    title: 'Expense Claim',
    listItem: (item) {
      item as ExpenseClaimItemModel;
      return ListCard(
        id: item.id,
        title: item.name,
        status: item.status,
        names: [
          'Employee'.tr(),
          'Posting Date'.tr(),
          'Grand Total'.tr(),
          'Department'.tr(),
        ],
        values: [
          item.employee,
          '${item.postingDate.day}/${item.postingDate.month}/${item.postingDate.year}',
          item.grandTotal.toString(),
          item.department,
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: InheritedExpenseForm(child: ExpenseClaimForm()),
    serviceParser: (data) => ExpenseClaimListModel.fromJson(data),
    pageService: EXPENSE_CLAIM_PAGE,
    pageWidget: ExpenseClaimPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Expense Claim"];
      var items;
      items = List<Map<String, dynamic>>.from(pageData['items']);
      items = items.map((e) {
        e['vat_value'] = _calculateVat(e['item_tax_template'], e['net_rate']);
        e['tax_percent'] = _taxPercent(e['item_tax_template']);
        return ItemSelectModel.fromJson(e);
      }).toList();
    },
    filter: ExpenseClaimFilter(),
  );

  static final loanApplication = ModuleType._(
    genericListService: 'Loan Application',
    title: 'Loan Application',
    listItem: (item) {
      item as LoanApplicationItemModel;
      return ListCard(
        id: item.id,
        title: item.applicantName,
        status: item.status,
        names: [
          'Applicant Type'.tr(),
          'Posting Date'.tr(),
          'Applicant'.tr(),
          'Loan Type'.tr(),
          'Loan Amount'.tr(),
        ],
        values: [
          item.applicantType,
          '${item.postingDate.day}/${item.postingDate.month}/${item.postingDate.year}',
          item.applicant,
          item.loanType,
          item.loanAmount.toString(),
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: LoanApplicationForm(),
    serviceParser: (data) => LoanApplicationListModel.fromJson(data),
    pageService: LOAN_APPLICATION_PAGE,
    pageWidget: LoanApplicationPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Loan Application"];
    },
    filter: LoanApplicationFilter(),
  );

  static final journalEntry = ModuleType._(
    genericListService: 'Journal Entry',
    title: 'Journal Entry',
    listItem: (item) {
      item as JournalEntryItemModel;
      return ListCard(
        id: item.id,
        title: item.voucherType,
        //status: item,
        names: [
          'Total'.tr(),
          'Posting Date'.tr(),
          'Mode Of Payment'.tr(),
          'Cheque No'.tr(),
          'Cheque Date'.tr(),
        ],
        values: [
          item.totalDebit.toString(),
          '${item.postingDate.day}/${item.postingDate.month}/${item.postingDate.year}',
          item.modeOfPayment,
          item.chequeNo,
          '${item.chequeDate.day}/${item.chequeDate.month}/${item.chequeDate.year}',
        ],
        onPressed: (context) => _onListCardPressed(context, item.id),
      );
    },
    createForm: InheritedAccountForm(child: JournalEntryForm()),
    serviceParser: (data) => JournalEntryListModel.fromJson(data),
    pageService: JOURNAL_ENTRY_PAGE,
    pageWidget: JournalEntryPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Journal Entry"];
    },
    filter: JournalEntryFilter(),
  );

  ///__________________________________________New version modules____________________________________

  ///__________________________________________Project module____________________________________
  static final task = ModuleType._(
    genericListService: 'Task',
    title: DocTypesName.task,
    listItem: (item) {
      item as TaskItemModel;
      return ListCard(
        id: item.name!,
        status: item.status!,
        names: [
          'Subject',
          'Priority',
          'Project',
          'Expected End Date',
        ],
        values: [
          item.subject!,
          item.priority!,
          item.project!,
          item.expectedEndDate.formatDate(),
        ],
        onPressed: (context) => _onListCardPressed(
          context,
          item.name!,
        ),
      );
    },
    serviceParser: (data) => TaskListModel.fromJson(data),
    createForm: TaskForm(),
    pageService: TASK_PAGE,
    pageWidget: TaskPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Task"];
    },
    filter: TaskFilterScreen(),
  );

  /// Timesheet
  static final timesheet = ModuleType._(
    genericListService: 'Timesheet',
    title: DocTypesName.timesheet,
    listItem: (item) {
      item as TimesheetModel;
      return ListCard(
        id: item.name!,
        status: item.status!,
        names: [
          'Customer',
          'Exchange Rate',
          'Parent Project',
          'Start Date',
          'End Date',
        ],
        values: [
          item.customer!,
          item.exchangeRate.toString(),
          item.parentProject!,
          item.startDate!.formatDate(),
          item.endDate!.formatDate(),
        ],
        onPressed: (context) => _onListCardPressed(
          context,
          item.name!,
        ),
      );
    },
    serviceParser: (data) => TimesheetListModel.fromJson(data),
    createForm: TimesheetForm(),
    pageService: TIMESHEET_PAGE,
    pageWidget: TimesheetPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Timesheet"];
    },
    filter: TimesheetFilterScreen(),
  );

  /// Project
  static final project = ModuleType._(
    genericListService: 'Project',
    title: DocTypesName.project,
    listItem: (item) {
      item as ProjectItemModel;
      return ListCard(
        id: item.name!,
        status: item.status!,
        names: [
          'Project',
          'Priority',
          'Percent Complete',
          'Start Date',
          'End Date',
        ],
        values: [
          item.projectName!,
          item.priority!,
          item.percentComplete.toString(),
          item.expectedStartDate!.formatDate(),
          item.expectedEndDate!.formatDate(),
        ],
        onPressed: (context) => _onListCardPressed(
          context,
          item.name!,
        ),
      );
    },
    serviceParser: (data) => ProjectListModel.fromJson(data),
    createForm: ProjectForm(),
    pageService: PROJECT_PAGE,
    pageWidget: ProjectPage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Project"];
    },
    filter: ProjectFilterScreen(),
  );

  /// Issue
  static final issue = ModuleType._(
    genericListService: 'Issue',
    title: DocTypesName.issue,
    listItem: (item) {
      item as IssueItemModel;
      return ListCard(
        id: item.name!,
        status: item.status!,
        names: [
          'Subject',
          'Priority',
          'Opening Date',
        ],
        values: [
          item.subject ?? 'none',
          item.priority ?? 'none',
          item.openingDate ?? 'none',
        ],
        onPressed: (context) => _onListCardPressed(
          context,
          item.name!,
        ),
      );
    },
    serviceParser: (data) => IssueListModel.fromJson(data),
    createForm: IssueForm(),
    pageService: ISSUE_PAGE,
    pageWidget: IssuePage(),
    editPage: (pageData) {
      pageData["doctype"] = ["Issue"];
    },
    filter: IssueFilterScreen(),
  );
}
