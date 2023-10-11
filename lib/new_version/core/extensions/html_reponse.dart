extension StringExtensions on String {
  String removeAllHtmlTags() {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return replaceAll(exp, '').split(":").last;
  }

  String parseHtml() {
    final RegExp exp = RegExp(r"'(.+?)'");
    final Iterable<Match> matches = exp.allMatches(this);
    final errorMessage = matches.map((match) => match.group(1)).join('\n');
    return errorMessage;
  }
}
