import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

const double KLeftColumnWidth = 125.0;
const double KColumnWidth = 110.0;
const double KRowHeight = 52;

class TableScreen extends StatefulWidget {
  final String title;
  final List<MapEntry<String, String>> columnsName;
  final List<Map> table;

  const TableScreen({
    required this.title,
    required this.columnsName,
    required this.table,
    Key? key,
  }) : super(key: key);

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  bool isAscending = true;

  String sortKey = '';
  List<Map> table = [];

  @override
  void initState() {
    table = widget.table;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        child: HorizontalDataTable(
          leftHandSideColumnWidth: KLeftColumnWidth,
          // to make the table takes full width always
          rightHandSideColumnWidth:
              (widget.columnsName.length - 1) * KColumnWidth <=
                      MediaQuery.of(context).size.width - KLeftColumnWidth
                  ? MediaQuery.of(context).size.width - KLeftColumnWidth - 0.1
                  : (widget.columnsName.length - 1) * KColumnWidth,
          isFixedHeader: true,
          headerWidgets: _getTitleWidget(),
          leftSideItemBuilder: _generateFirstColumnRow,
          rightSideItemBuilder: _generateRightHandSideColumnRow,
          itemCount: table.length,
          rowSeparatorWidget:
              const Divider(color: Colors.black54, height: 1.0, thickness: 0.0),
          leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
          rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
          verticalScrollbarStyle: const ScrollbarStyle(
            isAlwaysShown: true,
            thickness: 4.0,
            radius: Radius.circular(5.0),
          ),
          horizontalScrollbarStyle: const ScrollbarStyle(
            isAlwaysShown: true,
            thickness: 4.0,
            radius: Radius.circular(5.0),
          ),
        ),
        height: MediaQuery.of(context).size.height,
      ),
    );
  }

  void _sortTable() {
    table.sort((m1, m2) {
      var r = m1[sortKey].compareTo(m2[sortKey]);
      if (r != 0) return r;
      return m1[sortKey].compareTo(m2[sortKey]);
    });
    if (!isAscending) table = table.reversed.toList();
    setState(() {});
  }

  List<Widget> _getTitleWidget() {
    return widget.columnsName
        .map((title) => TextButton(
              style: TextButton.styleFrom(
                padding: title.key == widget.columnsName[0].key
                    ? const EdgeInsets.only(left: 12)
                    : EdgeInsets.zero,
              ),
              child: _getTitleItemWidget(
                  title.value +
                      (sortKey == title.key ? (isAscending ? ' ↓' : ' ↑') : ''),
                  title.key == widget.columnsName[0].key
                      ? KLeftColumnWidth
                      : KColumnWidth,
                  title.key == widget.columnsName[0].key
                      ? Alignment.centerLeft
                      : null),
              onPressed: () {
                sortKey = title.key;
                isAscending = !isAscending;
                _sortTable();
              },
            ))
        .toList();
  }

  Widget _getTitleItemWidget(String label, double width,
      [AlignmentGeometry? alignment]) {
    return Container(
      child: Text(label,
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center),
      width: width,
      height: 56,
      alignment: alignment ?? Alignment.center,
    );
  }

  ///left side item builder
  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: RichText(
          text: TextSpan(
              text: table[index].values.first.toString(),
              style: GoogleFonts.cairo(color: Colors.black))),
      width: KLeftColumnWidth,
      constraints: BoxConstraints(
          minHeight: KRowHeight,
          maxWidth: KLeftColumnWidth,
          minWidth: KLeftColumnWidth),
      // height: KRowHeight,
      padding: EdgeInsets.fromLTRB(12, 4, 4, 4),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    // this part simulates how this widget is presented on the screen
    // to measure the text height

    // 14 for emulator , 15.3 for real device
    TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: table[index].values.first.toString(),
            style: GoogleFonts.cairo()),
        //better to pass this from master widget if ltr and rtl both supported
        // maxLines: widget.maxLines,
        textDirection: TextDirection.ltr);

    textPainter.layout(maxWidth: KLeftColumnWidth - 16);

    // +8 for vertical padding in the left column
    final double textHeight = textPainter.size.height + 8;

    // generates row widgets
    final List<Widget> children = [];
    // starts from 1 to avoid first item
    for (int i = 1; i < widget.columnsName.length; i++)
      children.add(
        Container(
          child: Text(table[index].values.toList()[i].toString(),
              textAlign: TextAlign.center),
          width: KColumnWidth,
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          alignment: Alignment.center,
        ),
      );

    return SizedBox(
      height: textHeight <= KRowHeight ? KRowHeight : textHeight,
      child: Row(children: children),
    );
  }
}
