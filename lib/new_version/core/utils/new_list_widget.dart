import 'package:NextApp/new_version/modules/new_item/presentation/widgets/new_search_widget.dart';
import 'package:NextApp/provider/new_controller/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewListWidget extends StatefulWidget {
  const NewListWidget({
    super.key,
    required this.docType,
    required this.onPressed,
    required this.nameResponse,
  });
  final String docType;
  final Function(Map<String, dynamic>) onPressed;
  final String nameResponse;

  @override
  State<NewListWidget> createState() => _NewListWidgetState();
}

class _NewListWidgetState extends State<NewListWidget> {
  List getList = [];
  bool isLoading = false;
  Future<void> handelCall({String? search}) async {
    setState(() {
      isLoading = true;
      getList = [];
    });
    final provider = Provider.of<HomeProvider>(context, listen: false);

    getList = await provider
        .generalGetList(docType: widget.docType, search: search)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      handelCall();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NewSearchWidget(
          searchFunction: (value) {
            handelCall(search: value);
          },
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        SizedBox(
          height: 250,
          width: 500,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: getList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  widget.onPressed(getList[index]);
                  Navigator.pop(context);
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      getList[index]['name'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
