import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'faq_item.dart';
import '../bloc/faq_bloc.dart';
import '../../../../core/utils/error_dialog.dart';
import '../../../../core/utils/request_state.dart';
import '../../../../../widgets/custom_loading.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/resources/strings_manager.dart';

class FaqsListScreen extends StatelessWidget {
  const FaqsListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) => BlocConsumer<FaqBloc, FaqState>(
        listenWhen: (previous, current) =>
            current.getFagsState != previous.getFagsState,
        listener: (context, state) {
          if (state.getFagsState == RequestState.error) {
            showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(errorMessage: state.getFagsFailMessage));
          }
        },
        buildWhen: (previous, current) =>
            current.getFagsState != previous.getFagsState,
        builder: (context, state) {
          if (state.getFagsState == RequestState.loading) {
            return const Center(child: CustomLoadingWithImage());
          }
          if (state.getFagsState == RequestState.error) {
            return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 150.h),
                child: const Text(StringsManager.noFaqs));
          }
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(DoublesManager.d_20),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.getFagsData.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: DoublesManager.d_15),
              child: FaqItem(
                faqs: state.getFagsData,
                index: index,
              ),
            ),
          );
        },
      );
}
