extension StatusConverter on int {
/// We use this extension to convert DocStatus which is Int to String 
/// which the [statusColor] switch understand.
  String convertStatusToString() {
    switch (this.toString()) {
      case '0':
        return 'Draft';
      case '1':
        return 'Submitted';
      case '2':
        return 'Cancelled';
      default:
        return this.toString();
    }
  }
}
