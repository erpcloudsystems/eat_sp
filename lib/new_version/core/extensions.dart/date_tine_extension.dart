import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatDate() {
    return DateFormat('dd-MM-yyyy').format(this);
  }

  String formatDateYMD() {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}
