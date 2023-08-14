import 'package:NextApp/core/cloud_system_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../provider/module/module_provider.dart';
import '../../../../../screen/page/generic_page.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.status,
    required this.image,
    required this.docType,
    required this.name,
    this.type,
  }) : super(key: key);
  final String docType;
  final String title;
  final String subTitle;
  final String status;
  final String image;
  final String name;
  final String? type;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ModuleProvider>();
    return InkWell(
      onTap: () {
        provider.setModule = docType;
        provider.pushPage(name);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black54),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Image(
              image: AssetImage(
                image,
              ),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          subtitle: Text(subTitle),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 85,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: statusColor(status),
                ),
                child: Center(
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (type != null)
                Flexible(
                  child: Text(
                    type!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
