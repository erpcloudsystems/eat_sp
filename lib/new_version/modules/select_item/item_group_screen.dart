import 'package:flutter/material.dart';

class ItemGroupScreen extends StatelessWidget {
  const ItemGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Select Item Group',
          ),
        ),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Item group',
              ),
            );
          },
        ));
  }
}
