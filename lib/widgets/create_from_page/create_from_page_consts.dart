import 'package:next_app/screen/form/selling_forms/customer_form.dart';
import 'package:next_app/screen/form/selling_forms/opportunity_form.dart';
import 'package:next_app/screen/form/selling_forms/quotation_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:next_app/widgets/inherited_widgets/select_items_list.dart';



//Selling
//Lead
 Map<String,Widget> fromLead=
{
  'Customer':CustomerForm(),
  'Opportunity':OpportunityForm(),
  'Quotation':InheritedForm(child: QuotationForm()),
};
//Opportunity
 Map<String,Widget> fromOpportunity=
{
  'Customer':CustomerForm(),
  'Quotation':QuotationForm(),
};
