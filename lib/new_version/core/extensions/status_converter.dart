import 'package:easy_localization/easy_localization.dart';

import '../resources/strings_manager.dart';

extension StatusConverter on int {
  /// We use this extension to convert DocStatus which is Int to String
  /// which the [statusColor] switch understand.
  String convertStatusToString() {
    switch (toString()) {
      case '0':
        return 'Draft';
      case '1':
        return 'Submitted';
      case '2':
        return 'Cancelled';
      default:
        return toString();
    }
  }
}

extension DashBoardStatusTranslator on String {
  /// We use this extension to translate dashboard status which is 
  /// received from the backend
  String translateDashBoardStatus() {
    switch (this) {
      case StringsManager.paid:
        return StringsManager.paid.tr();
      case StringsManager.unpaid:
        return StringsManager.unpaid.tr();
      case StringsManager.returns:
        return StringsManager.returns.tr();
      case StringsManager.overdue:
        return StringsManager.overdue.tr();
      case StringsManager.cancelled:
        return StringsManager.cancelled.tr();
      default:
        return toString();
    }
  }
}
