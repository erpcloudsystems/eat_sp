import 'package:next_app/core/constants.dart';
import 'package:next_app/provider/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/service.dart';


class ItemCard extends StatelessWidget {
  final List<String> names, values;
  final String imageUrl;
  final void Function(BuildContext context)? onPressed;

  const ItemCard({Key? key, this.names = const ['Code', 'Group', 'UoM'], required this.values, required this.imageUrl, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
      child: InkWell(
        onTap: onPressed == null ? null : () => onPressed!(context),
        borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
        child: Ink(
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS), border: Border.all(width: 1, color: Colors.blueAccent.shade100)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(values[0], textAlign: TextAlign.center),
              ),
              Divider(color: Colors.blueAccent, height: 1),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          context.read<UserProvider>().url + imageUrl,
                          headers: APIService().getHeaders,
                          fit: BoxFit.fitWidth,
                          // width: 45,
                          // height: 45,
                          loadingBuilder: (context, child, progress) {
                            return progress != null ? SizedBox(child: Icon(Icons.image, color: Colors.grey, size: 40)) : child;
                          },
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return SizedBox(child: Icon(Icons.image, color: Colors.grey, size: 40));
                          },
                        ),
                      ),
                    ),
                  ),
                  //Divider(endIndent: BORDER_RADIUS, indent: BORDER_RADIUS, ),
                  Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(values[0]),
                            // Divider(color: Colors.grey),
                            for (int i = 1; i < values.length; i++)
                              Column(
                                children: [
                                  _CardItem(title: names[i - 1], value: values[i]),
                                  if (i != values.length - 1) Divider(color: Colors.grey),
                                ],
                              ),
                          ],
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  final String title, value;

  const _CardItem({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$title:  '),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // textAlign: TextAlign.center,
            // textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }
}
