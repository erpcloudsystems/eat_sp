import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../bloc/stock_warehouse_report/stockreports_bloc.dart';
import '../../data/models/warehouse_filters.dart';
import '../../../../../../../screen/list/otherLists.dart';
import '../../../../../../../models/list_models/stock_list_model/item_table_model.dart';

class ItemFilterButton extends StatelessWidget {
  final String warehouseCode;

  const ItemFilterButton({super.key, required this.warehouseCode});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final ItemSelectModel res = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => itemListScreen(''),
          ),
        );

        /// Reset Stock..
        BlocProvider.of<StockReportsBloc>(context).add(
          ResetWarehouseEvent(),
        );

        /// Filter Warehouse ..
        final warehouseFilters = WarehouseFilters(
          warehouseFilter: warehouseCode,
          itemFilter: res.itemCode,
        );

        /// Get Warehouse data ..
        BlocProvider.of<StockReportsBloc>(context).add(
          GetWarehouseEvent(warehouseFilters: warehouseFilters),
        );
      },
      child: Icon(Icons.search),
    );
  }
}
