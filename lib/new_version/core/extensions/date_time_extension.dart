import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatDate() {
    return DateFormat('dd-MM-yyyy').format(this);
  }

  String formatDateYMD() {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}

extension FormattedDateTimeFromString on String {
  /// We Use this to convert the coming Date time to a new more readable formate.
  String formateToReadableDateTime() {
    final DateTime convertedToDateTime = DateTime.parse(this);
    final String convertedToHumanReadable =
        DateFormat('dd.MMMM.yyyy hh:mm aaa').format(convertedToDateTime);

    return convertedToHumanReadable;
  }

  String formateToReadableDate() {
    final DateTime convertedToDateTime = DateTime.parse(this);
    final String convertedToHumanReadable =
        DateFormat('yyy-MM-dd').format(convertedToDateTime);

    return convertedToHumanReadable;
  }
}
