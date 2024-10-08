import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/resources/routes.dart';
import '../../data/models/general_ledger_filter.dart';
import '../../../../../../../widgets/form_widgets.dart';
import '../../../../../../core/resources/app_radius.dart';
import '../../../../../../../screen/list/otherLists.dart';
import '../bloc/general_ledger_bloc/general_ledger_bloc.dart';
import '../bloc/general_ledger_bloc/general_ledger_state.dart';

class FilterAccountScreen extends StatelessWidget {
  const FilterAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? accountName;
    String? partyType;
    String? party;
    final reportType = ModalRoute.of(context)!.settings.arguments;
    var formKey = GlobalKey<FormState>();
    String? fromDate;
    String? toDate;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$reportType Filters',
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              /// Warehouse list
              Flexible(
                child: CustomTextField(
                  'account_name',
                  'Account',
                  clearButton: true,
                  onSave: (key, value) => accountName = value,
                  onPressed: () async {
                    final res = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => accountListScreen(),
                      ),
                    );
                    return res['name'];
                  },
                ),
              ),

              /// From date and to date in stock ledger Report
              Flexible(
                child: Row(
                  children: [
                    Flexible(
                      child: DatePicker(
                        'transaction_date',
                        'From Date'.tr(),
                        disableValidation: false,
                        clear: true,
                        onChanged: (value) {
                          fromDate = value;
                          print(fromDate);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: DatePicker('delivery_date', 'To Date',
                          clear: true,
                          disableValidation: false,
                          onChanged: (value) => toDate = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Flexible(
                child: CustomTextField(
                  'party_type',
                  'Party Type',
                  clearButton: true,
                  onClear: () {
                    BlocProvider.of<GeneralLedgerBloc>(context)
                        .add(const ChangePartyTypeEvent(false));
                    partyType = null;
                  },
                  disableValidation: true,
                  onPressed: () async {
                    final res = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => partyTypeListScreen(),
                      ),
                    );
                    BlocProvider.of<GeneralLedgerBloc>(context)
                        .add(const ChangePartyTypeEvent(true));
                    partyType = res;
                    return res;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              Flexible(
                child: BlocBuilder<GeneralLedgerBloc, GeneralLedgerState>(
                  builder: (context, state) {
                    if (state.isPartyType == true) {
                      return CustomTextField(
                        'party',
                        'Party',
                        clearButton: true,
                        disableValidation: true,
                        onClear: () {
                          party = null;
                        },
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => partyListScreen(
                                partyType: partyType,
                              ),
                            ),
                          );
                          party = res['name'];
                          return res['name'];
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),

              /// Apply filter button
              InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    final filters = GeneralLedgerFilters(
                      account: accountName!,
                      fromDate: fromDate!,
                      toDate: toDate!,
                      partyType: partyType != null ? partyType! : null,
                      party: party != null ? party! : null,
                    );
                    Navigator.of(context).pushNamed(
                      Routes.generalLedgerReportScreen,
                      arguments: filters,
                    );
                  }
                },
                child: Container(
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: AppRadius.radius10,
                  ),
                  child: const Center(
                    child: Text(
                      'Apply Filter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
