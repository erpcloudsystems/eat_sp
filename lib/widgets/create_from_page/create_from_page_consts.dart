import 'package:NextApp/screen/form/project_forms/issue_form.dart';
import 'package:NextApp/screen/form/project_forms/task_form.dart';
import 'package:NextApp/screen/form/project_forms/timesheet_form.dart';
import 'package:NextApp/screen/form/stock_forms/stock_entry_form.dart';
import 'package:flutter/cupertino.dart';

import '../inherited_widgets/select_items_list.dart';
import '../../screen/form/selling_forms/customer_form.dart';
import '../../screen/form/selling_forms/quotation_form.dart';
import '../../screen/form/selling_forms/opportunity_form.dart';
import '../../screen/form/selling_forms/sales_order_form.dart';
import '../../screen/form/stock_forms/delivery_note_form.dart';
import '../../new_version/core/resources/strings_manager.dart';
import '../../screen/form/selling_forms/payment_entry_form.dart';
import '../../screen/form/buying_forms/purchase_order_form.dart';
import '../../screen/form/selling_forms/sales_invoice_form.dart';
import '../../screen/form/stock_forms/purchase_receipt_form.dart';
import '../../screen/form/stock_forms/material_request_form.dart';
import '../../screen/form/buying_forms/purchase_invoce_form.dart';
import '../../screen/form/buying_forms/supplier_quotation_form.dart';

//Selling
//Lead
Map<String, Widget> fromLead = {
  'Customer': const CustomerForm(),
  'Opportunity': InheritedForm(child: const OpportunityForm()),
  'Quotation': InheritedForm(child: const QuotationForm()),
};
//Opportunity
Map<String, Widget> fromOpportunity = {
  'Supplier Quotation': InheritedForm(child: const SupplierQuotationForm()),
  'Quotation': InheritedForm(child: const QuotationForm()),
};
Map<String, Widget> fromOpportunity2 = {
  'Customer': const CustomerForm(),
  'Supplier Quotation': InheritedForm(child: const SupplierQuotationForm()),
  'Quotation': InheritedForm(child: const QuotationForm()),
};

//Sales Order
Map<String, Widget> fromSalesOrder = {
  'Delivery Note': InheritedForm(child: const DeliveryNoteForm()),
  'Sales Invoice': InheritedForm(child: const SalesInvoiceForm()),
  'Material Request': InheritedForm(child: const MaterialRequestForm()),
  'Purchase Order': InheritedForm(child: const PurchaseOrderForm()),
  'Payment Entry': const PaymentForm(),
};

//Quotation
Map<String, Widget> fromQuotation = {
  'Sales Order': InheritedForm(child: const SalesOrderForm()),
};

//Sales Invoice
Map<String, Widget> fromSalesInvoice = {
  'Payment Entry': const PaymentForm(),
  'Return / Credit Note': InheritedForm(child: const SalesInvoiceForm()),
};
Map<String, Widget> fromSalesInvoice2 = {
  'Return / Credit Note': InheritedForm(child: const SalesInvoiceForm()),
};

//Delivery Note
Map<String, Widget> fromDeliveryNote = {
  'Sales Return': InheritedForm(child: const DeliveryNoteForm()),
  'Sales Invoice': InheritedForm(child: const SalesInvoiceForm()),
};

// Customer Visit:
Map<String, Widget> fromCustomerVisit = {
  DocTypesName.salesInvoice: InheritedForm(child: const SalesInvoiceForm()),
  DocTypesName.salesOrder: InheritedForm(child: const SalesOrderForm()),
  DocTypesName.paymentEntry: const PaymentForm(),
};

// Project:
Map<String, Widget> fromProject = {
  DocTypesName.task: const TaskForm(),
  DocTypesName.timesheet: InheritedForm(child: const TimesheetForm()),
  DocTypesName.issue: InheritedForm(child: const IssueForm()),
};
// Issue
Map<String, Widget> fromIssue = {
  DocTypesName.task: const TaskForm(),
};

// Buying Modules:

// Purchase Order:
Map<String, Widget> fromPurchaseOrder = {
  DocTypesName.purchaseReceipt:
      InheritedForm(child: const PurchaseReceiptForm()),
  DocTypesName.purchaseInvoice:
      InheritedForm(child: const PurchaseInvoiceForm()),
  DocTypesName.paymentEntry: InheritedForm(child: const PaymentForm()),
};

// Purchase Invoice:
Map<String, Widget> fromPurchaseInvoice = {
  'Purchase Receipt': InheritedForm(child: const PurchaseReceiptForm()),
  'Debit Note': InheritedForm(child: const PurchaseInvoiceForm()),
  'Payment Entry': const PaymentForm(),
};

//Supplier Quotation
Map<String, Widget> formSupplierQuotation = {
  'Purchase Order': InheritedForm(child: const PurchaseOrderForm()),
};

///Stock :
//Material Request
Map<String, Widget> formMaterialRequestToPurchaseOrder = {
  DocTypesName.purchaseOrder: InheritedForm(child: const PurchaseOrderForm()),
};
Map<String, Widget> formMaterialRequestStockEntry = {
  DocTypesName.stockEntry: InheritedForm(child: const StockEntryForm()),
};
