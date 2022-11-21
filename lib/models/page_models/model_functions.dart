import 'package:easy_localization/easy_localization.dart';

String formatDescription(String? text) {
  if (text == null) return tr('none');
  if (text.contains('<div class=\"ql-editor read-mode\">')){
    text = text.replaceAll('<div class=\"ql-editor read-mode\">', '');
    text = text.replaceAll('</div>', '');
  }
  text = text.replaceAll('<br>', '\n');
  text = text.replaceAll('<br>', '\n');
  text = text.replaceAll('<p>', '');
  text = text.replaceAll("</p>", '\n');
  text = text.splitMapJoin('\n', onMatch: (match) {
    if (match.end < text!.length) {
      if (text.substring(match.end, match.end + 1) == "\n") return '';
    }
    if (match.end == text.length) return '';
    return '\n';
  });

  if (text.contains('<p>')) {
    int start = text.indexOf('<p>');
    int end = text.indexOf('</p');
    return text.substring(start + 3, end);
  }
  return text;
}

//to reverse the date
String reverse(String? date) => date == null ? tr('none') : date.split('-').reversed.join('-');

String currency(double? value) {
  if (value == null) return tr('none');

  final oCcy = new NumberFormat("#,##0.00", "en_US");
  return oCcy.format(value);
}

String percent(double? value){
  if(value == null) return tr('none');
  return '$value%';
}