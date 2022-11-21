import 'package:next_app/core/constants.dart';
import 'package:next_app/provider/module/module_provider.dart';
import 'package:next_app/provider/user/user_provider.dart';
import 'package:next_app/screen/list/generic_list_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/service.dart';
import 'list_card.dart';

class PageGroup extends StatelessWidget {
  final Widget child;
  final Color? color;

  const PageGroup({Key? key, required this.child, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
        border: Border.all(color: color ?? Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.fromLTRB(8, 14, 8, 10),
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
            // border: Border.all(color: Colors.transparent),
            ),
        child: child,
      ),
    );
  }
}

class PageCard extends StatelessWidget {
  ///items is a list of maps, each listItem contains map, the map hold this row data
  ///each row may contain 1 or more items
  final List<Map<String, String>> items;
  final List<Widget> header;
  final Color? color;

  ///gives ability to swap default [ListTitle] widget with another custom widget
  ///by adding elements to this list of type [SwapWidget] which gonna ask for coordinates for which
  ///widget you want to exchange, and the swap widget itself
  final List<SwapWidget> swapWidgets;

  //number where status should be, must be bigger then 0

  const PageCard(
      {Key? key,
      required this.items,
      this.header = const [],
      this.swapWidgets = const <SwapWidget>[],
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _columnChildren = [...header];
    List<Widget> _rowChildren = [];
    List<String> _keys;

    //for each row
    for (int i = 0; i < items.length; i++) {
      _rowChildren = [];

      //row keys list
      _keys = items[i].keys.toList();

      //initialize row children
      // for each item in the row
      for (int j = 0; j < _keys.length; j++) {
        _rowChildren
            .add(ListTitle(title: _keys[j], value: items[i][_keys[j]]!));

        //vertical separator between items
        if (j < _keys.length - 1)
          _rowChildren.add(Container(
              width: 1,
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: Colors.grey.shade300));
      }
      // add the initialized row to the column children
      _columnChildren.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _rowChildren));

      //separator if the item is not last item
      // if (i < items.length - 1 ) _columnChildren.add(Divider(color: Colors.grey.shade400, thickness: 1));
      if (i < items.length - 1 && items[i].isNotEmpty)
        _columnChildren.add(Divider(color: Colors.grey.shade300, thickness: 1));
    }

    // //replace the status with status widget to show the status  color
    // if (statusIndex > 0) (_columnChildren[header.length - 2 + (statusIndex * 2)] as Row).children.last = StatusWidget(items[statusIndex - 1]['Status']!);

    if (swapWidgets.isNotEmpty)
      swapWidgets.forEach((element) =>
          (_columnChildren[header.length - 2 + (element.rowNumber * 2)] as Row)
                  .children[element.widgetIndex] =
              ListTitle(
                  title: items[element.rowNumber - 1]
                      .entries
                      .toList()[element.widgetNumber - 1]
                      .key,
                  child: element.widget));

    return PageGroup(color: color, child: Column(children: _columnChildren));
  }
}

class PageExpandableCardItem extends StatefulWidget {
  PageExpandableCardItem({
    Key? key,
    required this.items,
    this.title = '',
    this.width = 250,
    this.hideArrow = false,
    this.titleAlign = TextAlign.left,
  }) : super(key: key);

  final String title;
  final List<Map<String, dynamic>> items;
  final double width;
  final TextAlign titleAlign;
  final bool hideArrow;
  bool isOpened = false;

  @override
  _PageExpandableCardItemState createState() => _PageExpandableCardItemState();
}

class _PageExpandableCardItemState extends State<PageExpandableCardItem> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _columnChildren = [];
    List<String> _keys;

    for (int i = 0; i < widget.items.length; i++) {
      _keys = widget.items[i].keys.toList();
      for (int j = 0; j < _keys.length; j++) {
        _columnChildren.add(
            // Row(
            //   children: [
            //     Text(_keys[j],maxLines: 1),
            //     Text(widget.items[i][_keys[j]],maxLines: 2)
            //   ],
            // ),

            ListTile(
                horizontalTitleGap: 2,
                contentPadding: EdgeInsets.zero,
                title: Text(_keys[j], maxLines: 1),
                trailing: SizedBox(
                    width: 200,
                    child: Text(widget.items[i][_keys[j]],
                        textAlign: TextAlign.right,
                        style: TextStyle(overflow: TextOverflow.visible),
                        maxLines: 2))));
      }
    }

    return Container(
      width: widget.width,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          trailing: !widget.hideArrow
              ? AnimatedRotation(
                  turns: widget.isOpened ? .5 : 0,
                  duration: Duration(milliseconds: 400),
                  child: Icon(Icons.expand_more),
                )
              : null,
          onExpansionChanged: (v) {
            setState(() {
              widget.isOpened = !widget.isOpened;
            });
          },
          textColor: Colors.black,
          childrenPadding: EdgeInsets.zero,
          tilePadding: EdgeInsets.zero,
          expandedAlignment: Alignment.centerLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Text(widget.title,
              textAlign: widget.titleAlign,
              style: TextStyle(fontWeight: FontWeight.w600),
              maxLines: 1),
          children: _columnChildren,
        ),
      ),
    );
  }
}

///simple class holds information about which widget we want to exchange, and the swap widget
class SwapWidget {
  final int rowNumber;
  final int widgetIndex;
  final int widgetNumber;
  final Widget widget;

  SwapWidget(this.rowNumber, this.widget, {this.widgetNumber = 1})

      //to get the correct widget index in the row
      // the row contains widgets and between each widget there is a divider widget
      : this.widgetIndex = widgetNumber == 1 ? 0 : (widgetNumber * 2) - 2;
}

class ConnectionCard extends StatelessWidget {
  const ConnectionCard(
      {required this.imageUrl,
      required this.docTypeId,
      required this.count,
      Key? key})
      : super(key: key);

  final String imageUrl, docTypeId, count;

  @override
  Widget build(BuildContext context) {
    void pushConnectionRoute() {
      final moduleProvider =
          Provider.of<ModuleProvider>(context, listen: false);

      if (moduleProvider.isSecondModule) {
        // change current module and use connection
        moduleProvider.pushConnection(docTypeId);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => WillPopScope(
                    child: GenericListScreen.module(),
                    onWillPop: () async {
                      // return to first route module and remove connection
                      moduleProvider.removeConnection();
                      return true;
                    },
                  ),
              settings: RouteSettings(name: CONNECTION_ROUTE)),
          (route) => route.settings.name == null,
        );
      } else {
        // change current module and use connection
        moduleProvider.pushConnection(docTypeId);
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (_) => WillPopScope(
                      child: GenericListScreen.module(),
                      onWillPop: () async {
                        // return to first route module and remove connection
                        moduleProvider.removeConnection();
                        return true;
                      },
                    ),
                settings: RouteSettings(name: CONNECTION_ROUTE)))
            .then((value) {});
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
          border: Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: pushConnectionRoute,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: Colors.white,
            onPrimary: Colors.blueAccent.shade100,
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
                side: BorderSide(color: Colors.transparent, width: 0.8)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Image.network(
                    imageUrl,
                    headers: APIService().getHeaders,
                    width: 45,
                    height: 45,
                    loadingBuilder: (context, child, progress) {
                      return progress != null
                          ? SizedBox(
                              width: 45,
                              height: 45,
                              child: Icon(Icons.image, color: Colors.grey))
                          : child;
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return SizedBox(
                          width: 45,
                          height: 45,
                          child: Icon(Icons.image, color: Colors.grey));
                    },
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Center(
                      child: Text(docTypeId,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black)))),
              Expanded(
                  child: Center(
                      child:
                          Text(count, style: const TextStyle(fontSize: 15)))),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemCard3 extends StatelessWidget {
  final String id;
  final String status;
  final List<MapEntry<String, String>> values;
  final VoidCallback? onPressed;

  const ItemCard3(
      {Key? key,
      required this.id,
      this.status = '',
      required this.values,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> secondRow = [];
    for (int i = 3; i < values.length; i++) {
      secondRow.add(ListTitle(title: values[i].key, value: values[i].value));
      if (i < values.length - 1)
        secondRow.add(Container(
          width: 1,
          color: Colors.grey.shade400,
          height: 42,
        ));
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
        border: Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
          child: InkWell(
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
            onTap: onPressed,
            child: Ink(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
                  border: Border.all(color: Colors.transparent, width: 1.2)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Center(
                                  child: Text('Row #$id',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1))),
                          Container(
                              width: 1,
                              color: Colors.grey.shade400,
                              height: 42),
                          ListTitle(
                            title: values[0].key,
                            value: values[0].value,
                            flex: 3,
                          ),
                        ],
                      ),
                    ),

                    Divider(thickness: 1, color: Colors.grey.shade400),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ListTitle(title: values[1].key, value: values[1].value),
                        Container(
                            width: 1, color: Colors.grey.shade400, height: 42),
                        ListTitle(title: values[2].key, value: values[2].value),
                      ],
                    ),
                    Divider(thickness: 1, color: Colors.grey.shade400),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: secondRow,
                    ),
                    // Divider(thickness: 1, color: Colors.grey.shade300,height: 10),
                    // SizedBox(height: 25,child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600),),),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemWithImageCard extends StatelessWidget {
  final String id, itemName;
  final String imageUrl;
  final List<MapEntry<String, String>> names;
  final VoidCallback? onPressed;

  const ItemWithImageCard(
      {Key? key,
      required this.id,
      required this.itemName,
      required this.imageUrl,
      required this.names,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> secondRow = [];
    int _start = names.length > 5 ? 3 : 2;
    for (int i = _start; i < names.length; i++) {
      secondRow.add(ListTitle(
          title: names[i].key,
          child: Text(names[i].value,
              maxLines: 1, overflow: TextOverflow.ellipsis)));
      if (i < names.length - 1)
        secondRow.add(Container(
          width: 1,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.symmetric(vertical: 25),
        ));
    }
    return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
          child: Ink(
            height: 226,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
                border:
                    Border.all(width: 1, color: Colors.blueAccent.shade100)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                          flex: 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 0, top: 6),
                                  child: Text('Row #$id',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1)),
                              AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.network(
                                    context.read<UserProvider>().url + imageUrl,
                                    headers: APIService().getHeaders,
                                    // width: 45,
                                    // height: 45,
                                    loadingBuilder: (context, child, progress) {
                                      return progress != null
                                          ? SizedBox(
                                              child: Icon(Icons.image,
                                                  color: Colors.grey, size: 40))
                                          : child;
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return SizedBox(
                                          child: Icon(Icons.image,
                                              color: Colors.grey, size: 40));
                                    },
                                  )),
                            ],
                          )),
                      Container(
                          width: 1,
                          color: Colors.grey.shade400,
                          margin: const EdgeInsets.symmetric(vertical: 8)),
                      Flexible(
                          flex: 8,
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  ListTitle(
                                      title: names[0].key,
                                      child: Text(names[0].value,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis)),
                                  Container(
                                      width: 1,
                                      color: Colors.grey.shade400,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 25)),
                                  ListTitle(
                                      title: names[1].key,
                                      child: Text(names[1].value,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis)),
                                  if (_start > 2)
                                    Container(
                                        width: 1,
                                        color: Colors.grey.shade400,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 25)),
                                  if (_start > 2)
                                    ListTitle(
                                        title: names[2].key,
                                        child: Text(names[2].value,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis))
                                ],
                              ),
                              Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 1,
                                  endIndent: 20,
                                  indent: 20),
                              Row(children: secondRow),
                            ],
                          ))
                    ],
                  ),
                ),
                Divider(
                    color: Colors.grey.shade400,
                    thickness: 1,
                    endIndent: 20,
                    indent: 20),
                Row(children: [
                  ListTitle(
                      title: tr('Item Name'),
                      child: Text(itemName,
                          maxLines: 1, overflow: TextOverflow.ellipsis))
                ]),
              ],
            ),
          ),
        ));
  }
}
