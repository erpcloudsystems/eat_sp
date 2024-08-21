import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../bloc/generalreports_bloc.dart';
import '../../../../../../core/resources/routes.dart';
import '../../../../../../core/utils/error_dialog.dart';
import '../../../../../../core/utils/request_state.dart';
import '../../../../../../core/resources/app_values.dart';
import '../../../../../../../screen/list/otherLists.dart';
import '../../../../../../../widgets/custom_loading.dart';
import '../../../../../../core/resources/strings_manager.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String moduleName =
        ModalRoute.of(context)!.settings.arguments as String;

    BlocProvider.of<GeneralReportsBloc>(context)
        .add(GetAllReportsEvent(moduleName: moduleName));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringsManager.selectReport.tr(),
        ),
      ),
      body: BlocConsumer<GeneralReportsBloc, GeneralReportsState>(
        listenWhen: (previous, current) =>
            previous.getReportsState != current.getReportsState,
        listener: (context, state) {
          if (state.getReportsState == RequestState.error) {
            showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(errorMessage: state.getReportsMessage));
          }
        },
        buildWhen: (previous, current) =>
            previous.getReportsState != current.getReportsState,
        builder: (context, state) {
          if (state.getReportsState == RequestState.loading) {
            return const CustomLoadingWithImage();
          }
          if (state.getReportsState == RequestState.success) {
            return ListView.builder(
              itemCount: state.getReportData.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(DoublesManager.d_8),
                child: SingleValueTile(
                  state.getReportData[index].reportName.tr(),
                  onTap: (context) {
                    if (state.getReportData[index].reportName ==
                        'General Ledger') {
                      Navigator.of(context).pushNamed(
                        Routes.accountReportFilterScreen,
                        arguments: state.getReportData[index].reportName,
                      );
                    } else if (state.getReportData[index].reportName ==
                        StringsManager.accountsReceivable.tr()) {
                      Navigator.of(context).pushNamed(
                        Routes.accountReceivableReportFilterScreen,
                        arguments: state.getReportData[index].reportName,
                      );
                    } else {
                      Navigator.of(context).pushNamed(
                        Routes.reportFilterScreen,
                        arguments: state.getReportData[index].reportName,
                      );
                    }
                  },
                ),
              ),
            );
          }
          return const Center(
            child: Text(
              'No Data',
            ),
          );
        },
      ),
    );
  }
}
