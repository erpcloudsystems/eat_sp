import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../widgets/form_widgets.dart';

// ignore: must_be_immutable
class FromDataToDateWidget extends StatelessWidget {
  FromDataToDateWidget({
    super.key,
    this.fromData,
    this.toDate,
  });
  String? fromData;
  String? toDate;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          Flexible(
            child: DatePicker(
              'transaction_date',
              'From Date'.tr(),
              disableValidation: false,
              clear: true,
              onChanged: (value) {
                fromData = value;
                print(fromData);
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: DatePicker(
              'delivery_date',
              'To Date',
              clear: true,
              disableValidation: false,
              onChanged: (value) {
                toDate = value;
                print(toDate);
              },
            ),
          ),
        ],
      ),
    );
  }
}
