import 'package:flutter/cupertino.dart';

import '../../screen/form/buying_forms/purchase_invoce_form.dart';
import '../../screen/form/buying_forms/purchase_order_form.dart';
import '../../screen/form/buying_forms/supplier_quotation_form.dart';
import '../../screen/form/selling_forms/customer_form.dart';
import '../../screen/form/selling_forms/opportunity_form.dart';
import '../../screen/form/selling_forms/payment_entry_form.dart';
import '../../screen/form/selling_forms/quotation_form.dart';
import '../../screen/form/selling_forms/sales_invoice_form.dart';
import '../../screen/form/selling_forms/sales_order_form.dart';
import '../../screen/form/stock_forms/delivery_note_form.dart';
import '../../screen/form/stock_forms/material_request_form.dart';
import '../../screen/form/stock_forms/purchase_receipt_form.dart';
import '../inherited_widgets/select_items_list.dart';

//Selling
//Lead
Map<String, Widget> fromLead = {
  'Customer': CustomerForm(),
  'Opportunity': OpportunityForm(),
  'Quotation': InheritedForm(child: QuotationForm()),
};
//Opportunity
Map<String, Widget> fromOpportunity = {
  'Supplier Quotation': InheritedForm(child: SupplierQuotationForm()),
  'Quotation': InheritedForm(child: QuotationForm()),
};
Map<String, Widget> fromOpportunity2 = {
  'Customer': CustomerForm(),
  'Supplier Quotation': InheritedForm(child: SupplierQuotationForm()),
  'Quotation': InheritedForm(child: QuotationForm()),
};

//Sales Order
Map<String, Widget> fromSalesOrder = {
  'Delivery Note': InheritedForm(child: DeliveryNoteForm()),
  'Sales Invoice': InheritedForm(child: SalesInvoiceForm()),
  'Material Request': InheritedForm(child: MaterialRequestForm()),
  'Purchase Order': InheritedForm(child: PurchaseOrderForm()),
  'Payment Entry': PaymentForm(),
};
//Quotation
Map<String, Widget> fromQuotation = {
  'Sales Order': InheritedForm(child: SalesOrderForm()),
};

//Sales Invoice
Map<String, Widget> fromSalesInvoice = {
  'Payment Entry': PaymentForm(),
  'Credit Note': InheritedForm(child: SalesInvoiceForm()),
};
Map<String, Widget> fromSalesInvoice2 = {
  'Credit Note': InheritedForm(child: SalesInvoiceForm()),
};

//Purchase Invoice
Map<String, Widget> fromPurchaseInvoice = {
  'Purchase Receipt': InheritedForm(child: PurchaseReceiptForm()),
  'Payment Entry': PaymentForm(),
  'Debit Note': InheritedForm(child: PurchaseInvoiceForm()),
};

//Delivery Note
Map<String, Widget> fromDeliveryNote = {
  'Sales Return': InheritedForm(child: DeliveryNoteForm()),
  'Sales Invoice': InheritedForm(child: SalesInvoiceForm()),
};
