import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/resources/strings_manager.dart';
import '../bloc/faq_bloc.dart';

class Tags extends StatefulWidget {
  const Tags({super.key});

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  int _selectedIndex = -1;

  void selectButton(int index) => setState(() => _selectedIndex = index);

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    const List<({String name, String? key})> tagsList = [
      (name: 'all', key: null),
      (name: DocTypesName.buying, key: DocTypesName.buying),
      (name: DocTypesName.accounts, key: DocTypesName.accounts),
      (name: DocTypesName.stock, key: DocTypesName.stock),
      (name: DocTypesName.selling, key: DocTypesName.selling),
    ];
    return GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: DoublesManager.d_5),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: IntManager.i_4,
            mainAxisSpacing: DoublesManager.d_10,
            mainAxisExtent: DoublesManager.d_35,
            crossAxisSpacing: DoublesManager.d_5),
        itemCount: tagsList.length,
        itemBuilder: (context, index) => TagButton(
              tagsList: tagsList,
              index: index,
              isSelected: index == _selectedIndex,
              onPressed: () => selectButton(index),
            ));
  }
}

class TagButton extends StatelessWidget {
  const TagButton({
    super.key,
    required this.tagsList,
    required this.index,
    required this.onPressed,
    required this.isSelected,
  });

  final int index;
  final bool isSelected;
  final List<({String name, String? key})> tagsList;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Color defaultColor = isSelected ? Colors.grey : Colors.grey[350]!;
    return ElevatedButton(
      onPressed: () {
        onPressed();
        BlocProvider.of<FaqBloc>(context)
            .add(GetFagsEvent(tag: tagsList[index].key));
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: defaultColor,
      ),
      child: Text(
        tagsList[index].name,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
